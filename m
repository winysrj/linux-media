Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab1IFPaV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 11:30:21 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 08/10] Use a saner way to disable screensaver
Date: Tue,  6 Sep 2011 12:29:54 -0300
Message-Id: <1315322996-10576-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1315322996-10576-7-git-send-email-mchehab@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
 <1315322996-10576-2-git-send-email-mchehab@redhat.com>
 <1315322996-10576-3-git-send-email-mchehab@redhat.com>
 <1315322996-10576-4-git-send-email-mchehab@redhat.com>
 <1315322996-10576-5-git-send-email-mchehab@redhat.com>
 <1315322996-10576-6-git-send-email-mchehab@redhat.com>
 <1315322996-10576-7-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Backport a Fedora patch that improves the way to disable
the screensaver:

commit 36cc9d2e1d762eddf5d8278fa58edd4680a7b449
Author: Tomas Smetana <tsmetana@zaphod.usersys.redhat.com>
Date:   Mon Nov 8 22:01:57 2010 +0100

    - fix #571339 use a saner way to disable screensaver, thanks to Debian folks
      for the patch, namely Resul Cetin

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 configure.ac  |   10 +++++-----
 src/xcommon.c |   50 +++++++++++++++++++++++---------------------------
 2 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6cdedfb..f102b5b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -140,11 +140,11 @@ if test x"$no_x" != x"yes"; then
 	    X11_LIBS="$X11_LIBS -lXinerama"],,
 	    [$X_PRE_LIBS $X_LIBS -lX11 $X_EXTRA_LIBS -lXext])
 
-	dnl check for XTest
-        AC_CHECK_LIB([Xtst],[XTestFakeKeyEvent],
-            [AC_DEFINE([HAVE_XTESTEXTENSION],,[XTest support])
-            X11_LIBS="$X11_LIBS -lXtst"],,
-	    [$X_PRE_LIBS $X_LIBS -lX11 $X_EXTRA_LIBS -lXext])
+	dnl check for XSs
+	PKG_CHECK_MODULES(XSS, xscrnsaver >= 1.2.0,
+		AC_DEFINE([HAVE_XSSEXTENSION],,[XScrnSaver support])
+		AC_SUBST(XSS_LIBS)
+		X11_LIBS="$X11_LIBS $XSS_LIBS",)
 
 	dnl check for Xvidmode
 	AC_CHECK_LIB([Xxf86vm],[XF86VidModeGetModeLine],
diff --git a/src/xcommon.c b/src/xcommon.c
index 8e3be4c..681b895 100644
--- a/src/xcommon.c
+++ b/src/xcommon.c
@@ -45,8 +45,8 @@
 #include <X11/keysym.h>
 #include <X11/cursorfont.h>
 #include <X11/extensions/XShm.h>
-#ifdef HAVE_XTESTEXTENSION
-#include <X11/extensions/XTest.h>
+#ifdef HAVE_XSSEXTENSION
+#include <X11/extensions/scrnsaver.h>
 #endif
 
 #include "xfullscreen.h"
@@ -67,7 +67,7 @@ static Window wm_window;
 static Window fs_window;
 static Window output_window;
 static GC gc;
-static int have_xtest;
+static int have_xss;
 static int output_width, output_height;
 static int output_aspect;
 static int output_on_root;
@@ -107,10 +107,6 @@ static Atom wm_delete_window;
 static Atom xawtv_station;
 static Atom xawtv_remote;
 
-#ifdef HAVE_XTESTEXTENSION
-static KeyCode kc_shift_l; /* Fake key to send. */
-#endif
-
 static area_t video_area;
 static area_t window_area;
 static area_t scale_area;
@@ -248,12 +244,12 @@ static void x11_wait_mapped( Display *dpy, Window win )
     } while ( (event.type != MapNotify) || (event.xmap.event != win) );
 }
 
-static int have_xtestextention( void )
+static int have_xssextention( void )
 {  
-#ifdef HAVE_XTESTEXTENSION
-    int dummy1, dummy2, dummy3, dummy4;
+#ifdef HAVE_XSSEXTENSION
+    int dummy1, dummy2;
   
-    return (XTestQueryExtension( display, &dummy1, &dummy2, &dummy3, &dummy4 ) == True);
+    return (XScreenSaverQueryExtension( display, &dummy1, &dummy2 ) == True);
 #endif
     return 0;
 }
@@ -843,7 +839,7 @@ int xcommon_open_display( const char *user_geometry, int aspect, int verbose )
     output_aspect = aspect;
     output_height = 576;
 
-    have_xtest = 0;
+    have_xss = 0;
     output_on_root = 0;
     has_ewmh_state_fullscreen = 0;
     has_ewmh_state_above = 0;
@@ -927,13 +923,16 @@ int xcommon_open_display( const char *user_geometry, int aspect, int verbose )
         xfullscreen_print_summary( xf );
     }
 
-#ifdef HAVE_XTESTEXTENSION
-    kc_shift_l = XKeysymToKeycode( display, XK_Shift_L );
-#endif
-    have_xtest = have_xtestextention();
-    if( have_xtest && xcommon_verbose ) {
-        fprintf( stderr, "xcommon: Have XTest, will use it to ping the screensaver.\n" );
+    have_xss = have_xssextention();
+    if( have_xss && xcommon_verbose ) {
+        fprintf( stderr, "xcommon: Have XSS, will use it to disable the screensaver.\n" );
+    }
+
+#ifdef HAVE_XSSEXTENSION
+    if ( have_xss ) {
+        XScreenSaverSuspend( display, True );
     }
+#endif
 
     /* Initially, get the best width for our height. */
     output_width = xv_get_width_for_height( output_height );
@@ -1112,15 +1111,7 @@ void xcommon_ping_screensaver( void )
     gettimeofday( &curtime, 0 );
     if( timediff( &curtime, &last_ping_time ) > SCREENSAVER_PING_TIME ) { 
         last_ping_time = curtime;
-#ifdef HAVE_XTESTEXTENSION
-        if( have_xtest ) {
-            XTestFakeKeyEvent( display, kc_shift_l, True, CurrentTime );
-            XTestFakeKeyEvent( display, kc_shift_l, False, CurrentTime );
-        } else 
-#endif
-        {
-            XResetScreenSaver( display );
-        }
+        XResetScreenSaver( display );
     }
 }
 
@@ -1715,6 +1706,11 @@ void xcommon_poll_events( input_t *in )
 
 void xcommon_close_display( void )
 {
+#ifdef HAVE_XSSEXTENSION
+    if ( have_xss ) {
+        XScreenSaverSuspend( display, False );
+    }
+#endif
     XDestroyWindow( display, output_window );
     XDestroyWindow( display, wm_window );
     XDestroyWindow( display, fs_window );
-- 
1.7.6.1

