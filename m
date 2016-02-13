Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSr6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:47:58 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id ACAD28051B
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:47:58 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 08/17] videoinput: Add support for automatically selecting the video input device
Date: Sat, 13 Feb 2016 19:47:29 +0100
Message-Id: <1455389258-13470-8-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Based on the xawtv3 code to do the same. This is useful for a more
plug and play operation esp. when a usb webcam sometimes gets plugged
in which may change the video-dev enumeration order.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/tvtimeconf.c |  14 ++++--
 src/videoinput.c | 141 +++++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 116 insertions(+), 39 deletions(-)

diff --git a/src/tvtimeconf.c b/src/tvtimeconf.c
index 3667dd7..ee80d02 100644
--- a/src/tvtimeconf.c
+++ b/src/tvtimeconf.c
@@ -51,6 +51,12 @@
 #define MAX_KEYSYMS 350
 #define MAX_BUTTONS 15
 
+#ifdef __linux__ /* This depends on sysfs, so it is linux only */
+#define DEFAULT_VIDEO_DEV "auto"
+#else
+#define DEFAULT_VIDEO_DEV "/dev/video0"
+#endif
+
 struct config_s
 {
     char *geometry;
@@ -616,7 +622,7 @@ static void print_usage( char **argv )
     lfputs( _("  -A, --nowidescreen         4:3 mode.\n"), stderr );
     lfputs( _("  -b, --vbidevice=DEVICE     VBI device (defaults to /dev/vbi0).\n"), stderr );
     lfputs( _("  -c, --channel=CHANNEL      Tune to the specified channel on startup.\n"), stderr );
-    lfputs( _("  -d, --device=DEVICE        video4linux device (defaults to /dev/video0).\n"), stderr );
+    lfputs( _("  -d, --device=DEVICE        video4linux device (defaults to " DEFAULT_VIDEO_DEV ").\n"), stderr );
     lfputs( _("  -f, --frequencies=NAME     The frequency table to use for the tuner.\n"
               "                             (defaults to us-cable).\n\n"
               "                             Valid values are:\n"
@@ -671,7 +677,7 @@ static void print_config_usage( char **argv )
     lfputs( _("  -A, --nowidescreen         4:3 mode.\n"), stderr );
     lfputs( _("  -b, --vbidevice=DEVICE     VBI device (defaults to /dev/vbi0).\n"), stderr );
     lfputs( _("  -c, --channel=CHANNEL      Tune to the specified channel on startup.\n"), stderr );
-    lfputs( _("  -d, --device=DEVICE        video4linux device (defaults to /dev/video0).\n"), stderr );
+    lfputs( _("  -d, --device=DEVICE        video4linux device (defaults to " DEFAULT_VIDEO_DEV ").\n"), stderr );
     lfputs( _("  -f, --frequencies=NAME     The frequency table to use for the tuner.\n"
               "                             (defaults to us-cable).\n\n"
               "                             Valid values are:\n"
@@ -727,7 +733,7 @@ static void print_config_usage( char **argv )
 static void print_scanner_usage( char **argv )
 {
     lfprintf( stderr, _("usage: %s [OPTION]...\n\n"), argv[ 0 ]);
-    lfputs( _("  -d, --device=DEVICE        video4linux device (defaults to /dev/video0).\n"), stderr );
+    lfputs( _("  -d, --device=DEVICE        video4linux device (defaults to " DEFAULT_VIDEO_DEV ").\n"), stderr );
     lfputs( _("  -F, --configfile=FILE      Additional config file to load settings from.\n"), stderr );
     lfputs( _("  -h, --help                 Show this help message.\n"), stderr );
     lfputs( _("  -i, --input=INPUTNUM       video4linux input number (defaults to 0).\n"), stderr );
@@ -785,7 +791,7 @@ config_t *config_new( void )
 
     ct->inputwidth = 720;
     ct->inputnum = 0;
-    ct->v4ldev = strdup( "/dev/video0" );
+    ct->v4ldev = strdup( DEFAULT_VIDEO_DEV );
     ct->norm = strdup( "ntsc" );
     ct->freq = strdup( "us-cable" );
     temp_dirname = getenv( "HOME" );
diff --git a/src/videoinput.c b/src/videoinput.c
index f66a35e..698d4b5 100644
--- a/src/videoinput.c
+++ b/src/videoinput.c
@@ -19,6 +19,7 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <limits.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdint.h>
@@ -38,6 +39,7 @@
 #include <linux/videodev2.h>
 #include "videoinput.h"
 #include "mixer.h"
+#include "get_media_devices.h"
 
 /**
  * How long to wait when we lose a signal, or acquire a signal.
@@ -319,11 +321,59 @@ int videoinput_buffer_invalid( videoinput_t *vidin, int frameid )
     return vidin->capbuffers[ frameid ].free;
 }
 
+int videoinput_open_v4l_device( videoinput_t *vidin, const char *path,
+                                int caps, const char *type)
+{
+    struct v4l2_capability caps_v4l2;
+    int fd;
+
+    /* First, open the device. */
+    fd = open( path, O_RDWR );
+    if( fd == -1 ) {
+        fprintf( stderr, "videoinput: Cannot open device %s: %s\n",
+                 path, strerror( errno ) );
+    }
+
+    /**
+     * Next, ask for its capabilities.  This will also confirm it's a V4L2 
+     * device. 
+     */
+    if( ioctl( fd, VIDIOC_QUERYCAP, &caps_v4l2 ) < 0 ) {
+        /* Can't get V4L2 capabilities, maybe this is a V4L1 device? */
+        fprintf( stderr, "videoinput: %s: V4L1 devices not supported\n", path );
+        close( fd );
+        return -1;
+    }
+
+    if( (caps_v4l2.capabilities & caps) != caps ) {
+        if( vidin->verbose ) {
+            fprintf( stderr, "videoinput: %s: does not have %s caps\n",
+                     path, type );
+        }
+        close( fd );
+        return -1;
+    }
+
+    if( vidin->verbose ) {
+        fprintf( stderr, "videoinput: Using video4linux2 driver '%s', card '%s' (bus %s).\n"
+                         "videoinput: Version is %u, capabilities %x.\n",
+                 caps_v4l2.driver, caps_v4l2.card, caps_v4l2.bus_info,
+                 caps_v4l2.version, caps_v4l2.capabilities );
+    }
+    vidin->isv4l2 = 1;
+    snprintf( vidin->drivername, sizeof( vidin->drivername ), "%s [%s/%s/%u]",
+              caps_v4l2.driver, caps_v4l2.card,
+              caps_v4l2.bus_info, caps_v4l2.version );
+    snprintf( vidin->shortdriver, sizeof( vidin->shortdriver ), "%s",
+              caps_v4l2.driver );
+
+    return fd;
+}
+
 videoinput_t *videoinput_new( config_t *cfg, int norm, int verbose,
                               char *error_string )
 {
     videoinput_t *vidin = malloc( sizeof( videoinput_t ) );
-    struct v4l2_capability caps_v4l2;
     struct v4l2_input in;
     int i;
 
@@ -379,43 +429,64 @@ videoinput_t *videoinput_new( config_t *cfg, int norm, int verbose,
     memset( vidin->drivername, 0, sizeof( vidin->drivername ) );
     memset( vidin->shortdriver, 0, sizeof( vidin->shortdriver ) );
 
-    /* First, open the device. */
-    vidin->grab_fd = open( v4l_device, O_RDWR );
-    if( vidin->grab_fd < 0 ) {
-        fprintf( stderr, "videoinput: Cannot open capture device %s: %s\n",
-                 v4l_device, strerror( errno ) );
-        sprintf( error_string, "%s", strerror( errno ) );
-        free( vidin );
-        return 0;
-    }
+    vidin->grab_fd = -1;
 
-    /**
-     * Next, ask for its capabilities.  This will also confirm it's a V4L2 
-     * device. 
-     */
-    if( ioctl( vidin->grab_fd, VIDIOC_QUERYCAP, &caps_v4l2 ) < 0 ) {
-        /* Can't get V4L2 capabilities, maybe this is a V4L1 device? */
-	fprintf(stderr, "V4L1 devices not supported\n");
-	sprintf( error_string, "V4L1 devices not supported" );
-	close( vidin->grab_fd );
-	free( vidin );
-	return 0;
-    } else {
-        if( vidin->verbose ) {
-            fprintf( stderr, "videoinput: Using video4linux2 driver '%s', card '%s' (bus %s).\n"
-                             "videoinput: Version is %u, capabilities %x.\n",
-                     caps_v4l2.driver, caps_v4l2.card, caps_v4l2.bus_info,
-                     caps_v4l2.version, caps_v4l2.capabilities );
+#ifdef __linux__ /* Because this depends on get_media_devices.c */
+    if( !strcmp( v4l_device, "auto") ) {
+        char path[PATH_MAX];
+        const char *type;
+        int caps;
+        void *md;
+
+        md = discover_media_devices();
+        if( !md ) {
+            sprintf( error_string, "Cannot enumerate video devices" );
+            free( vidin );
+            return 0;
         }
-        vidin->isv4l2 = 1;
-        snprintf( vidin->drivername, sizeof( vidin->drivername ),
-                  "%s [%s/%s/%u]",
-                  caps_v4l2.driver, caps_v4l2.card,
-                  caps_v4l2.bus_info, caps_v4l2.version );
-        snprintf( vidin->shortdriver, sizeof( vidin->shortdriver ),
-                  "%s", caps_v4l2.driver );
-    }
 
+        /* Step 1: try TV cards first */
+        type = "analog TV";
+        caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER;
+retry:
+        v4l_device = NULL;
+        while( 1 ) {
+            v4l_device = get_associated_device( md, v4l_device, MEDIA_V4L_VIDEO,
+                                                NULL, NONE );
+            if( !v4l_device )
+                break; /* No more video devices to try */
+            snprintf( path, PATH_MAX, "/dev/%s", v4l_device );
+            if( verbose )
+                fprintf(stderr, "videoinput-auto: trying: %s... \n", path);
+            vidin->grab_fd = videoinput_open_v4l_device( vidin, path, caps,
+                                                         type );
+            if( vidin->grab_fd != -1 ) {
+                fprintf( stderr, "videoinput-auto: using %s device %s\n",
+                         type, path);
+                break;
+            }
+        }
+
+        /* Step 2: try grabber devices and webcams */
+        if( vidin->grab_fd == -1 &&
+                caps == (V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER) ) {
+            type = "capture";
+            caps = V4L2_CAP_VIDEO_CAPTURE;
+            goto retry;
+        }
+
+        free_media_devices(md);
+    } else
+#endif
+        vidin->grab_fd = videoinput_open_v4l_device( vidin, v4l_device,
+                                                     V4L2_CAP_VIDEO_CAPTURE,
+                                                     "capture" );
+
+    if( vidin->grab_fd == -1 ) {
+        sprintf( error_string, "Cannot open/use video device %s", v4l_device );
+        free( vidin );
+        return 0;
+    }
 
     vidin->numinputs = 0;
     in.index = vidin->numinputs;
-- 
2.5.0

