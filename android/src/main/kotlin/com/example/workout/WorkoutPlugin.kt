package com.example.workout

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.hardware.SensorManager.SENSOR_DELAY_FASTEST
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.getSystemService
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** WorkoutPlugin */
class WorkoutPlugin : FlutterPlugin, MethodCallHandler, SensorEventListener {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var sensorManager: SensorManager

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "workout")
        channel.setMethodCallHandler(this)

        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "start") {
            val error = start(call.arguments)
            if (error.isEmpty()) {
                result.success("Sensors started")
            } else {
                result.error(error, null, null)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun start(arguments: Any): String {
        try {
            val argumentList = arguments as List<String>
            argumentList.forEach {
                if (it == "heartRate") {
                    startHeartRate()
                }
            }
        } catch (e: Error) {
            return e.localizedMessage ?: "Error starting sensors"
        }

        return ""
    }

    private fun startHeartRate() {
        sensorManager = getSystemService(context, SensorManager::class.java) as SensorManager
        val hrSensor = sensorManager.getDefaultSensor(Sensor.TYPE_HEART_RATE)
        sensorManager.registerListener(this, hrSensor, SensorManager.SENSOR_DELAY_NORMAL)


        sensorManager.registerListener(this, hrSensor, SENSOR_DELAY_FASTEST);
    }

    private fun stopHeartRate() {
        sensorManager.unregisterListener(this)
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null) return;
        channel.invokeMethod("dataReceived", listOf(event.sensor?.name
                ?: "Unknown", event.values[0].toString()))
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
}
