Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbcBILAG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2016 06:00:06 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 0F6B614AA9
	for <linux-media@vger.kernel.org>; Tue,  9 Feb 2016 11:00:06 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 2/2] xvoutput: Add support for planar yuv formats
Date: Tue,  9 Feb 2016 11:59:58 +0100
Message-Id: <1455015598-18805-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455015598-18805-1-git-send-email-hdegoede@redhat.com>
References: <1455015598-18805-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When running on video cards which are using the modesetting driver +
glamor, or when running under XWayland + glamor, only planar yuv
formats are supported by the XVideo extension.

This commits adds support for planar yuv formats to tvtime, making it
works on these kind of video-cards and XWayland.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/xvoutput.c | 148 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 112 insertions(+), 36 deletions(-)

diff --git a/src/xvoutput.c b/src/xvoutput.c
index d9d9656..4c3f076 100644
--- a/src/xvoutput.c
+++ b/src/xvoutput.c
@@ -41,18 +41,21 @@
 #include "xcommon.h"
 
 #define FOURCC_YUY2 0x32595559
+#define FOURCC_YV12 0x32315659
+#define FOURCC_I420 0x30323449
 
 static Display *display;
 static Window output_window;
 
 static XvImage *image;
-static uint8_t *image_data;
+static uint8_t *front_buf, *back_buf;
 static XShmSegmentInfo shminfo;
 static XvPortID xv_port;
 
 static int input_width, input_height;
 static int xvoutput_verbose;
 static int xvoutput_error = 0;
+static int xvoutput_fourcc_id;
 static int use_shm = 1;
 
 static int HandleXError( Display *display, XErrorEvent *xevent )
@@ -85,7 +88,8 @@ static void x11_InstallXErrorHandler( void )
     XFlush( display );
 }
 
-static int xv_port_has_yuy2( XvPortID port )
+static int xv_port_has_fourcc( XvPortID port, int fourcc_id,
+                               const char *fourcc_str )
 {
     XvImageFormatValues *formatValues;
     int formats;
@@ -93,7 +97,8 @@ static int xv_port_has_yuy2( XvPortID port )
 
     formatValues = XvListImageFormats( display, port, &formats );
     for( i = 0; i < formats; i++ ) {
-        if((formatValues[ i ].id == FOURCC_YUY2) && (!(strcmp( formatValues[ i ].guid, "YUY2" )))) {
+        if( formatValues[ i ].id == fourcc_id &&
+            !strcmp( formatValues[ i ].guid, fourcc_str ) ) {
             XFree (formatValues);
             return 1;
         }
@@ -102,7 +107,7 @@ static int xv_port_has_yuy2( XvPortID port )
     return 0;
 }
 
-static int xv_check_extension( void )
+static int xv_check_extension( int fourcc_id, const char *fourcc_str )
 {
     unsigned int version;
     unsigned int release;
@@ -110,7 +115,7 @@ static int xv_check_extension( void )
     unsigned int adaptors;
     unsigned int i;
     unsigned long j;
-    int has_yuy2 = 0;
+    int has_fourcc = 0;
     XvAdaptorInfo *adaptorInfo;
 
     if( ( XvQueryExtension( display, &version, &release,
@@ -126,7 +131,8 @@ static int xv_check_extension( void )
     for( i = 0; i < adaptors; i++ ) {
         if( adaptorInfo[ i ].type & XvImageMask ) {
             for( j = 0; j < adaptorInfo[ i ].num_ports; j++ ) {
-                if( xv_port_has_yuy2( adaptorInfo[ i ].base_id + j ) ) {
+                if( xv_port_has_fourcc( adaptorInfo[ i ].base_id + j,
+                                        fourcc_id, fourcc_str ) ) {
                     if( XvGrabPort( display, adaptorInfo[ i ].base_id + j, 0 ) == Success ) {
                         xv_port = adaptorInfo[ i ].base_id + j;
                         if( xvoutput_verbose ) {
@@ -134,9 +140,10 @@ static int xv_check_extension( void )
                                      adaptorInfo[ i ].base_id + j, adaptorInfo[ i ].name );
                         }
                         XvFreeAdaptorInfo( adaptorInfo );
+                        xvoutput_fourcc_id = fourcc_id;
                         return 1;
                     }
-                    has_yuy2 = 1;
+                    has_fourcc = 1;
                 }
             }
         }
@@ -144,24 +151,14 @@ static int xv_check_extension( void )
 
     XvFreeAdaptorInfo( adaptorInfo );
 
-    if( has_yuy2 ) {
-        fprintf( stderr, "xvoutput: No YUY2 XVIDEO port available.\n" );
+    if( has_fourcc ) {
+        fprintf( stderr, "xvoutput: No %s XVIDEO port available.\n", fourcc_str );
 
-        fprintf( stderr, "\n*** tvtime requires a hardware YUY2 overlay.  One is supported\n"
+        fprintf( stderr, "\n*** tvtime requires a hardware %s overlay.  One is supported\n"
                            "*** by your driver, but we could not grab it.  It is likely\n"
                            "*** being used by another application, either another tvtime\n"
                            "*** instance or a media player.  Please shut down this other\n"
-                           "*** application and try tvtime again.\n\n" );
-    } else {
-        fprintf( stderr, "xvoutput: No XVIDEO port found which supports YUY2 images.\n" );
-
-        fprintf( stderr, "\n*** tvtime requires hardware YUY2 overlay support from your video card\n"
-                           "*** driver.  If you are using an older NVIDIA card (TNT2), then\n"
-                           "*** this capability is only available with their binary drivers.\n"
-                           "*** For some ATI cards, this feature may be found in the experimental\n"
-                           "*** GATOS drivers: http://gatos.sourceforge.net/\n"
-                           "*** If unsure, please check with your distribution to see if your\n"
-                           "*** X driver supports hardware overlay surfaces.\n\n" );
+                           "*** application and try tvtime again.\n\n", fourcc_str );
     }
     return 0;
 }
@@ -229,32 +226,91 @@ static void *create_shm( int size )
     }
 }
 
+/* Note for simplicity this code always blits to dest coordinates 0x0! */
+static void xv_blit( uint8_t *dest, uint8_t *src,
+                     int x, int y, int width, int height )
+{
+    uint8_t *y_dest, *u_dest, *v_dest, *src1;
+
+    /* Adjust src for x and y start coordinates */
+    src += y * input_width * 2 + (x & ~1) * 2;
+
+    /* copy the Y values */
+    src1 = src;
+    y_dest = dest + image->offsets[0];
+    for( y = 0; y < height; y++ ) {
+        for( x = 0; x < width; x += 2 ) {
+            *y_dest++ = src1[0];
+            *y_dest++ = src1[2];
+            src1 += 4;
+        }
+        src1 += (input_width - width) * 2;
+        y_dest += image->pitches[0] - width;
+    }
+
+    /* copy the U and V values */
+    src = src;
+    src1 = src + input_width * 2; /* next line */
+    if( xvoutput_fourcc_id == FOURCC_I420 ) {
+        u_dest = dest + image->offsets[1];
+        v_dest = dest + image->offsets[2];
+    } else { /* FOURCC_YV12 */
+        v_dest = dest + image->offsets[1];
+        u_dest = dest + image->offsets[2];
+    }
+    for( y = 0; y < height; y += 2 ) {
+        for( x = 0; x < width; x += 2 ) {
+            *u_dest++ = ((int) src[1] + src1[1]) / 2; /* U */
+            *v_dest++ = ((int) src[3] + src1[3]) / 2; /* V */
+            src += 4;
+            src1 += 4;
+        }
+        src += (2 * input_width - width) * 2;
+        src1 += (2 * input_width - width) * 2;
+        /* Assume both plane pitches are identical */
+        u_dest += image->pitches[1] - width / 2;
+        v_dest += image->pitches[1] - width / 2;
+    }
+}
+
 static int xv_alloc_frame( void )
 {
     int size;
-    uint8_t *alloc;
 
-    size = input_width * input_height * 2;
+    if( xvoutput_fourcc_id == FOURCC_YUY2 ) {
+        size = input_width * input_height * 2;
+    } else {
+        size = ((input_width + 7) & ~7) * input_height * 3 / 2;
+    }
+
     if( use_shm ) {
-        alloc = create_shm( size );
+        front_buf = create_shm( size );
+    } else {
+        front_buf = malloc( size );
+    }
+
+    if( xvoutput_fourcc_id == FOURCC_YUY2 ) {
+        back_buf = front_buf;
     } else {
-        alloc = malloc( input_width * input_height * 2 );
+        back_buf = malloc( input_width * input_height * 2 );
     }
 
-    if( alloc ) {
+    if( front_buf && back_buf ) {
         /* Initialize the input image to black. */
-        blit_colour_packed422_scanline( alloc, input_width * input_height,
+        blit_colour_packed422_scanline( back_buf, input_width * input_height,
                                         16, 128, 128 );
         if( use_shm ) {
-            image = XvShmCreateImage( display, xv_port, FOURCC_YUY2,
-                                      (char *) alloc, input_width,
+            image = XvShmCreateImage( display, xv_port, xvoutput_fourcc_id,
+                                      (char *) front_buf, input_width,
                                       input_height, &shminfo );
         } else {
-            image = XvCreateImage( display, xv_port, FOURCC_YUY2,
-                                   (char *) alloc, input_width,
+            image = XvCreateImage( display, xv_port, xvoutput_fourcc_id,
+                                   (char *) front_buf, input_width,
                                    input_height );
         }
-        image_data = alloc;
+        if( front_buf != back_buf ) {
+            xv_blit( front_buf, back_buf, 0, 0, input_width, input_height );
+        }
         return 1;
     }
 
@@ -309,7 +365,15 @@ static int xv_init( const char *user_geometry, int aspect, int squarepixel, int
     display = xcommon_get_display();
     output_window = xcommon_get_output_window();
 
-    if( !xv_check_extension() ) return 0;
+    if( !xv_check_extension( FOURCC_YUY2, "YUY2" ) &&
+        !xv_check_extension( FOURCC_YV12, "YV12" ) &&
+        !xv_check_extension( FOURCC_YV12, "YV12" ) ) {
+        fprintf( stderr, "xvoutput: No XVIDEO port which supports YUY2 or YV12 or I420 images found.\n\n"
+                         "*** tvtime requires hardware overlay support from your video card\n"
+                         "*** If unsure, please check with your distribution to see if your\n"
+                         "*** X driver supports hardware overlay surfaces.\n\n" );
+        return 0;
+    }
     xcommon_set_colourkey( get_colourkey() );
     return 1;
 }
@@ -327,6 +391,11 @@ static int xv_show_frame( int x, int y, int width, int height )
     xcommon_set_video_scale( scale_area );
 
     xcommon_ping_screensaver();
+    if( front_buf != back_buf ) {
+        xv_blit( front_buf, back_buf, x, y, width, height );
+        x = 0; /* xv_blit blits to dest 0x0 */
+        y = 0; /* xv_blit blits to dest 0x0 */
+    }
     if( use_shm ) {
         XvShmPutImage( display, xv_port, output_window, xcommon_get_gc(),
                        image, x, y, width, height, video_area.x, video_area.y,
@@ -358,18 +427,25 @@ static int xv_set_input_size( int inputwidth, int inputheight )
 
 static void xv_quit( void )
 {
+    if( back_buf != front_buf) {
+        free( back_buf );
+    }
     if( use_shm ) {
         XShmDetach( display, &shminfo );
         shmdt( shminfo.shmaddr );
     } else {
-        free( image_data );
+        free( front_buf );
     }
     xcommon_close_display();
 }
 
 static int xv_get_stride( void )
 {
-    return image->pitches[ 0 ];
+    if( front_buf == back_buf ) {
+        return image->pitches[ 0 ];
+    } else {
+        return input_width * 2;
+    }
 }
 
 static int xv_is_interlaced( void )
@@ -391,7 +467,7 @@ static void xv_unlock_output( void )
 
 static uint8_t *xv_get_output( void )
 {
-    return image_data;
+    return back_buf;
 }
 
 static int xv_can_read_from_buffer( void )
-- 
2.5.0

