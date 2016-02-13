Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSsA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:48:00 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id BA54113A6A
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:48:00 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 09/17] alsa_stream: Auto-detect the alsa capture device based on the v4ldev
Date: Sat, 13 Feb 2016 19:47:30 +0100
Message-Id: <1455389258-13470-9-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Based on the xawtv3 code to do the same. This is useful to make tvtime
work in a more plug and play fashion.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/mixer.c      | 41 ++++++++++++++++++++++++++++++++++++-----
 src/mixer.h      |  2 +-
 src/tvtime.c     |  2 +-
 src/tvtimeconf.c |  6 ++++--
 src/videoinput.c |  8 +++++++-
 src/videoinput.h |  5 +++++
 6 files changed, 54 insertions(+), 10 deletions(-)

diff --git a/src/mixer.c b/src/mixer.c
index 06e61a2..5356d2b 100644
--- a/src/mixer.c
+++ b/src/mixer.c
@@ -20,7 +20,9 @@
  */
 
 #include <stdio.h>
+#include <string.h>
 #include "alsa_stream.h"
+#include "get_media_devices.h"
 #include "mixer.h"
 #include "tvtimeconf.h"
 
@@ -109,18 +111,49 @@ struct mixer *mixer = &null_mixer;
 
 /* Config settings */
 config_t *mixer_cfg;
+const char *mixer_capdev;
 
 /**
  * Sets the mixer device and channel.
  * Try each access method until one succeeds.
  */
-void mixer_init( config_t *cfg )
+void mixer_init( config_t *cfg, const char *v4ldev )
 {
     const char *devname;
     int i;
 
     mixer_cfg = cfg;
     devname = config_get_mixer_device( mixer_cfg );
+    mixer_capdev = config_get_alsa_inputdev( mixer_cfg );
+
+#ifdef __linux__ /* Because this depends on get_media_devices.c */
+    if( !strcmp( mixer_capdev, "auto" ) ) {
+        const char *p;
+        void *md;
+
+        md = discover_media_devices();
+        if( !md ) {
+            fprintf( stderr, "Mixer: cannot enumerate video devices\n" );
+            return;
+        }
+
+        p = strrchr( v4ldev, '/' );
+        if (p)
+            p++;
+        else
+            p = v4ldev;
+
+        p = get_associated_device( md, NULL, MEDIA_SND_CAP, p, MEDIA_V4L_VIDEO );
+        if( p ) {
+            mixer_capdev = strdup( p );
+            fprintf( stderr, "Alsa devices: cap: %s (%s), out: %s\n",
+                     mixer_capdev, v4ldev,
+                     config_get_alsa_outputdev( mixer_cfg ) );
+        }
+
+        free_media_devices(md);
+    }
+#endif
 
     for (i = 0; i < sizeof(mixers)/sizeof(mixers[0]); i++) {
         mixer = mixers[i];
@@ -153,9 +186,7 @@ void mixer_mute( int mute )
     } else {
         mixer->mute( 0 );
         alsa_thread_startup( config_get_alsa_outputdev( mixer_cfg ),
-                             config_get_alsa_inputdev( mixer_cfg ),
-                             config_get_alsa_latency( mixer_cfg ),
-                             stderr,
-                             config_get_verbose( mixer_cfg ) );
+                             mixer_capdev, config_get_alsa_latency( mixer_cfg ),
+                             stderr, config_get_verbose( mixer_cfg ) );
     }
 }
diff --git a/src/mixer.h b/src/mixer.h
index 9b5365a..f51f481 100644
--- a/src/mixer.h
+++ b/src/mixer.h
@@ -32,7 +32,7 @@ extern "C" {
  * Sets the mixer device and channel.
  * All interfaces are scanned until one succeeds.
  */
-void mixer_init( config_t *cfg );
+void mixer_init( config_t *cfg, const char *v4ldev );
 void mixer_exit( void );
 void mixer_mute( int mute );
 
diff --git a/src/tvtime.c b/src/tvtime.c
index afc8940..1cc1681 100644
--- a/src/tvtime.c
+++ b/src/tvtime.c
@@ -1417,7 +1417,7 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
     secondlastframe = lastframe = blueframe;
 
     /* Init the mixer (and alsa digital loopback) */
-    mixer_init( ct );
+    mixer_init( ct, videoinput_get_v4ldev( vidin ) );
 
     /* Setup OSD stuff. */
     pixel_aspect = ( (double) width ) /
diff --git a/src/tvtimeconf.c b/src/tvtimeconf.c
index ee80d02..7f8fed5 100644
--- a/src/tvtimeconf.c
+++ b/src/tvtimeconf.c
@@ -53,8 +53,10 @@
 
 #ifdef __linux__ /* This depends on sysfs, so it is linux only */
 #define DEFAULT_VIDEO_DEV "auto"
+#define DEFAULT_ALSA_INPUT "auto"
 #else
 #define DEFAULT_VIDEO_DEV "/dev/video0"
+#define DEFAULT_ALSA_INPUT "hw:1,0"
 #endif
 
 struct config_s
@@ -721,7 +723,7 @@ static void print_config_usage( char **argv )
               "                                 video, radio, monitor\n"), stderr );
     lfputs( _("  -p, --alsainputdev=DEV     Specifies an ALSA device to read input on\n"
               "                                 Examples:\n"
-              "                                          hw:1,0\n"
+              "                                          " DEFAULT_ALSA_INPUT "\n"
               "                                          disabled\n"), stderr );
     lfputs( _("  -P, --alsaoutputdev=DEV    Specifies an ALSA device to write output to\n"
               "                                 Examples:\n"
@@ -827,7 +829,7 @@ config_t *config_new( void )
     ct->config_filename = 0;
     ct->doc = 0;
 
-    ct->alsa_inputdev = strdup( "hw:1,0" );
+    ct->alsa_inputdev = strdup( DEFAULT_ALSA_INPUT );
     ct->alsa_outputdev = strdup( "default" );
     ct->alsa_latency = 50;
 
diff --git a/src/videoinput.c b/src/videoinput.c
index 698d4b5..f9418df 100644
--- a/src/videoinput.c
+++ b/src/videoinput.c
@@ -143,6 +143,7 @@ struct videoinput_s
 {
     int verbose;
     int grab_fd;
+    char v4ldev[ PATH_MAX ];
     char drivername[ 64 ];
     char shortdriver[ 64 ];
 
@@ -361,6 +362,7 @@ int videoinput_open_v4l_device( videoinput_t *vidin, const char *path,
                  caps_v4l2.version, caps_v4l2.capabilities );
     }
     vidin->isv4l2 = 1;
+    snprintf( vidin->v4ldev, sizeof( vidin->v4ldev ), "%s", path );
     snprintf( vidin->drivername, sizeof( vidin->drivername ), "%s [%s/%s/%u]",
               caps_v4l2.driver, caps_v4l2.card,
               caps_v4l2.bus_info, caps_v4l2.version );
@@ -1128,6 +1130,11 @@ const char *videoinput_get_input_name( videoinput_t *vidin )
     return vidin->inputname;
 }
 
+const char *videoinput_get_v4ldev( videoinput_t *vidin )
+{
+    return vidin->v4ldev;
+}
+
 const char *videoinput_get_driver_name( videoinput_t *vidin )
 {
     return vidin->drivername;
@@ -1141,4 +1148,3 @@ void videoinput_set_capture_volume( videoinput_t *vidin, int volume )
 				     ((double) vidin->volume) / 100.0 );
     }
 }
-
diff --git a/src/videoinput.h b/src/videoinput.h
index 808896d..3f21dee 100644
--- a/src/videoinput.h
+++ b/src/videoinput.h
@@ -278,6 +278,11 @@ void videoinput_set_pal_audio_mode( videoinput_t *vidin, int amode );
 int videoinput_get_pal_audio_mode( videoinput_t *vidin );
 
 /**
+ * Returns the path to the v4ldev.
+ */
+const char *videoinput_get_v4ldev( videoinput_t *vidin );
+
+/**
  * Returns the name of the capture card driver.
  */
 const char *videoinput_get_driver_name( videoinput_t *vidin );
-- 
2.5.0

