package com.example.logem

import io.flutter.embedding.android.FlutterActivity


import android.content.Intent
import android.util.Log
import android.content.IntentFilter
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.icu.text.SimpleDateFormat
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.Stack
//import java.util.Date



class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.logem/grab"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            
            if(call.method == "getLatestLog") {
                val logg = getLogs()
                result.success(logg)
              }
              else if(call.method == "svelogs") {
                val str=call.argument<String>("log");
                val ahs=svelogs(str.toString())
                result.success(ahs)
              }
              else{
                result.notImplemented()
            }

        }

    }

    
    private fun svelogs(slog:String): String{
        try{

            val file = File("/storage/emulated/0/"+"logs.txt")
            if(!file.exists())
            file.createNewFile()

            file.writeText(slog)
        }
        catch(e: Exception){

        }
        return "";
    }
   

        private fun getLogs(): String {
                        
            try {
                var process = Runtime.getRuntime().exec("logcat -t 1")
                var bufferedReader = process.inputStream.bufferedReader()
                var grab =  Stack<String>();
                bufferedReader.useLines { lines ->
                    lines.forEach {
                        
                        grab.push(it)
                        
                    }
                    
                        return grab.peek()+"\n"
                }
            } catch (e: Exception) {
                return "ERROR \n \n \n \n \n \n \n \n "
            }
           
           
        }
        
}
