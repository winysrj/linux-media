Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33862 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZG1Ojd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 10:39:33 -0400
Message-ID: <4A6F0EA8.50604@redhat.com>
Date: Tue, 28 Jul 2009 16:43:52 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: webmaster@programmierforen.de,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Philips SPC230NC: wrong colors / image format?
References: <c9e1a1a2e8d1dc1dd8df21cdc4557e42-EhVZVlxGQB8ODhsVCgAbZ1dfaANWUkNeXEFbCzBSXV5ZUVsWWVtoBlM6XF1bRk0GV1pRQA==-webmailer2@server01.webmailer.hosteurope.de>
In-Reply-To: <c9e1a1a2e8d1dc1dd8df21cdc4557e42-EhVZVlxGQB8ODhsVCgAbZ1dfaANWUkNeXEFbCzBSXV5ZUVsWWVtoBlM6XF1bRk0GV1pRQA==-webmailer2@server01.webmailer.hosteurope.de>
Content-Type: multipart/mixed;
 boundary="------------080709050708090505050608"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080709050708090505050608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 07/17/2009 06:28 PM, Andi Drebes wrote:
> Hi!
> I tried to find a mailing list for the v4l compatibility library, but I
> didn't find any.

You can use "Linux Media Mailing List <linux-media@vger.kernel.org>", guess
I should put that in the README.

> This is why I'm sending this email directly to you.

No problem.

> Some weeks ago I bought a Philips SPC230NC webcam. It seems that the
> camera is supported by the pac7311 driver. In order to use the cam in some
> older applications, I tried out the compatibility library. It almost
> works; the only problem is that the video is distorted and that the colors
> are not right. Here's what a keyboard looks like in camorama:
>
>       http://drebesium.org/~hackbert/Webcam-1247846047.png
>

Ah that is a bug in camorama, I've attached a patch which fixes this. I've also
added a patch which make camorama use libv4l directly so you do not need todo
the LD_PRELOAD thingie.

Regards,

Hans


> I'm using a 2.6.30.1 kernel on debian lenny. I tried out libv4l-0.6.0 and
> libv4l-0.6.1-test. They both provide the same results. As far as the
> hardware is concerned, lsusb tells me:
>
>       093a:262c Pixart Imaging, Inc.
>
> Dmesg does not show any errors:
>
>      [ 3216.124322] gspca: main v2.5.0 registered
>      [ 3216.128254] gspca: probing 093a:262c
>      [ 3216.145196] gspca: probe ok
>
> I used the following command to start camorama:
>
>      LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/src/libv4l-0.6.0/libv4l1/:/usr/src/libv4l-0.6.0/libv4l2/:/usr/src/libv4l-0.6.0/libv4lconvert/
> LD_PRELOAD=/usr/src/libv4l-0.6.0/libv4l1/v4l1compat.so camorama
>
> Do you have any idea what might be wrong? Again, sorry to bug you directly
> with this. If there's any mailinglist or something, I would be glad if you
> could indicate me the address. In that case, feel free to ignore the
> content of this mail.
>
>           Thanks in advance,
>                Andi
>

--------------080709050708090505050608
Content-Type: text/plain;
 name="camorama-0.19-fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="camorama-0.19-fixes.patch"

--- camorama-0.19/src/callbacks.c	2007-09-16 15:36:55.000000000 +0200
+++ camorama-0.19.new/src/callbacks.c	2008-06-29 22:22:44.000000000 +0200
@@ -387,9 +387,6 @@
         }
     }
 
-    cam->pixmap = gdk_pixmap_new (NULL, cam->x, cam->y, cam->desk_depth);
-    gtk_widget_set_size_request (glade_xml_get_widget (cam->xml, "da"),
-                                 cam->x, cam->y);
 
     /*
      * if(cam->read == FALSE) {
@@ -441,6 +438,11 @@
      * * } 
      */
     get_win_info (cam);
+
+    cam->pixmap = gdk_pixmap_new (NULL, cam->x, cam->y, cam->desk_depth);
+    gtk_widget_set_size_request (glade_xml_get_widget (cam->xml, "da"),
+                                 cam->x, cam->y);
+
     frame = 0;
     gtk_window_resize (GTK_WINDOW
                        (glade_xml_get_widget (cam->xml, "main_window")), 320,
@@ -520,8 +522,14 @@
     gtk_widget_show (about);
 }
 
+void
+camorama_filter_color_filter(void* filter, guchar *image, int x, int y, int depth);
+
 static void
 apply_filters(cam* cam) {
+	/* v4l has reverse rgb order from what camora expect so call the color
+	   filter to fix things up before running the user selected filters */
+	camorama_filter_color_filter(NULL, cam->pic_buf, cam->x, cam->y, cam->depth);
 	camorama_filter_chain_apply(cam->filter_chain, cam->pic_buf, cam->x, cam->y, cam->depth);
 #warning "FIXME: enable the threshold channel filter"
 //	if((effect_mask & CAMORAMA_FILTER_THRESHOLD_CHANNEL)  != 0) 
--- camorama-0.19/src/filter.c	2007-09-16 14:48:50.000000000 +0200
+++ camorama-0.19.new/src/filter.c	2008-06-29 22:11:42.000000000 +0200
@@ -151,12 +151,12 @@
 static void
 camorama_filter_color_init(CamoramaFilterColor* self) {}
 
-static void
+void
 camorama_filter_color_filter(CamoramaFilterColor* filter, guchar *image, int x, int y, int depth) {
 	int i;
 	char tmp;
 	i = x * y;
-	while (--i) {
+	while (i--) {
 		tmp = image[0];
 		image[0] = image[2];
 		image[2] = tmp;
--- camorama-0.19/src/main.c	2007-09-16 15:36:55.000000000 +0200
+++ camorama-0.19.new/src/main.c	2008-06-29 22:20:04.000000000 +0200
@@ -224,8 +224,7 @@
 
     /* get picture attributes */
     get_pic_info (cam);
-//	set_pic_info(cam);
-    /* set_pic_info(cam); */
+    set_pic_info (cam);
     cam->contrast = cam->vid_pic.contrast;
     cam->brightness = cam->vid_pic.brightness;
     cam->colour = cam->vid_pic.colour;
--- camorama-0.19/src/v4l.c	2007-09-16 14:48:05.000000000 +0200
+++ camorama-0.19.new/src/v4l.c	2008-06-29 22:20:23.000000000 +0200
@@ -158,8 +158,8 @@
 	if(cam->debug) {
 		g_message("SET PIC");
 	}
-	//cam->vid_pic.palette = VIDEO_PALETTE_RGB24;
-	//cam->vid_pic.depth = 24;
+	cam->vid_pic.palette = VIDEO_PALETTE_RGB24;
+	cam->vid_pic.depth = 24;
 	//cam->vid_pic.palette = VIDEO_PALETTE_YUV420P;
 	if(ioctl(cam->dev, VIDIOCSPICT, &cam->vid_pic) == -1) {
 		if(cam->debug) {
@@ -232,6 +232,8 @@
       exit(0);
    }
 
+   cam->x = cam->vid_win.width;
+   cam->y = cam->vid_win.height;
 }
 
 void set_buffer(cam * cam)
--- camorama-0.19/src/camorama-window.c~	2007-09-16 15:36:55.000000000 +0200
+++ camorama-0.19/src/camorama-window.c	2009-06-23 20:19:16.000000000 +0200
@@ -209,11 +209,7 @@ load_interface(cam* cam) {
 
     logo = gtk_icon_theme_load_icon(gtk_icon_theme_get_for_screen(gtk_widget_get_screen(glade_xml_get_widget(cam->xml, "main_window"))), CAMORAMA_STOCK_WEBCAM, 24, 0, NULL);
     gtk_window_set_default_icon(logo);
-    logo = (GdkPixbuf *) create_pixbuf (PACKAGE_DATA_DIR "/pixmaps/camorama.png");
-    if (logo == NULL) {
-        printf ("\n\nLOGO NO GO\n\n");
-    }
-
+    logo = gtk_icon_theme_load_icon(gtk_icon_theme_get_for_screen(gtk_widget_get_screen(glade_xml_get_widget(cam->xml, "main_window"))), "camorama", 48, 0, NULL);
     if (cam->show_adjustments == FALSE) {
         gtk_widget_hide (glade_xml_get_widget
                          (cam->xml, "adjustments_table"));

--------------080709050708090505050608
Content-Type: text/plain;
 name="camorama-0.19-libv4l.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="camorama-0.19-libv4l.patch"

--- camorama-0.19/src/Makefile.am	2007-09-16 14:48:05.000000000 +0200
+++ camorama-0.19.new/src/Makefile.am	2009-06-24 15:01:37.000000000 +0200
@@ -36,7 +36,7 @@
 	filter.h	\
 	$(BUILT_SOURCES)\
 	$(NULL)
-camorama_LDADD = $(PACKAGE_LIBS)
+camorama_LDADD = $(PACKAGE_LIBS) -lv4l1
 
 DISTCLEANFILES=$(BUILT_SOURCES)
 
--- camorama-0.19/src/Makefile.in	2007-10-06 21:06:28.000000000 +0200
+++ camorama-0.19.new/src/Makefile.in	2009-06-24 15:01:50.000000000 +0200
@@ -248,7 +248,7 @@
 	$(BUILT_SOURCES)\
 	$(NULL)
 
-camorama_LDADD = $(PACKAGE_LIBS)
+camorama_LDADD = $(PACKAGE_LIBS) -lv4l1
 DISTCLEANFILES = $(BUILT_SOURCES)
 all: $(BUILT_SOURCES)
 	$(MAKE) $(AM_MAKEFLAGS) all-am
--- camorama-0.19/src/callbacks.c	2009-06-24 15:01:55.000000000 +0200
+++ camorama-0.19.new/src/callbacks.c	2009-06-24 14:55:42.000000000 +0200
@@ -9,6 +9,7 @@
 #include <libgnomeui/gnome-propertybox.h>
 #include <libgnomeui/gnome-window-icon.h>
 #include <pthread.h>
+#include <libv4l1.h>
 
 extern GtkWidget *main_window, *prefswindow;
 //extern state func_state;
@@ -390,7 +391,7 @@
 
     /*
      * if(cam->read == FALSE) {
-     *  cam->pic = mmap(0, cam->vid_buf.size, PROT_READ | PROT_WRITE, MAP_SHARED, cam->dev, 0);
+     *  cam->pic = v4l1_mmap(0, cam->vid_buf.size, PROT_READ | PROT_WRITE, MAP_SHARED, cam->dev, 0);
      *  
      *  if((unsigned char *) -1 == (unsigned char *) cam->pic) {
      *   if(cam->debug == TRUE) {
@@ -401,7 +402,7 @@
      *  }
      *  }else{
      *   cam->pic_buf = malloc(cam->x * cam->y * cam->depth);
-     *   read(cam->dev,cam->pic,(cam->x * cam->y * 3));
+     *   v4l1_read(cam->dev,cam->pic,(cam->x * cam->y * 3));
      *  } 
      */
 
@@ -427,7 +428,7 @@
      * if(cam->read == FALSE) {
      * * for(frame = 0; frame < cam->vid_buf.frames; frame++) {
      * * cam->vid_map.frame = frame;
-     * * if(ioctl(cam->dev, VIDIOCMCAPTURE, &cam->vid_map) < 0) {
+     * * if(v4l1_ioctl(cam->dev, VIDIOCMCAPTURE, &cam->vid_map) < 0) {
      * * if(cam->debug == TRUE) {
      * * fprintf(stderr, "Unable to capture image (VIDIOCMCAPTURE) during resize.\n");
      * * }
@@ -547,7 +548,7 @@
     int i, count = 0;
     GdkGC *gc;
 
-    read (cam->dev, cam->pic, (cam->x * cam->y * 3));
+    v4l1_read (cam->dev, cam->pic, (cam->x * cam->y * 3));
     frames2++;
     /*
      * update_rec.x = 0;
@@ -588,7 +589,7 @@
 
     i = -1;
     while (i < 0) {
-        i = ioctl (cam->dev, VIDIOCSYNC, &frame);
+        i = v4l1_ioctl (cam->dev, VIDIOCSYNC, &frame);
 
         if (i < 0 && errno == EINTR) {
             if (cam->debug == TRUE) {
@@ -630,7 +631,7 @@
                                 0, cam->x, cam->y);
 
     cam->vid_map.frame = frame;
-    if (ioctl (cam->dev, VIDIOCMCAPTURE, &cam->vid_map) < 0) {
+    if (v4l1_ioctl (cam->dev, VIDIOCMCAPTURE, &cam->vid_map) < 0) {
         if (cam->debug == TRUE) {
             fprintf (stderr, "Unable to capture image (VIDIOCMCAPTURE)\n");
         }
@@ -677,7 +678,7 @@
 void init_cam (GtkWidget * capture, cam * cam)
 {
     cam->pic =
-        mmap (0, cam->vid_buf.size, PROT_READ | PROT_WRITE,
+        v4l1_mmap (0, cam->vid_buf.size, PROT_READ | PROT_WRITE,
               MAP_SHARED, cam->dev, 0);
 
     if ((unsigned char *) -1 == (unsigned char *) cam->pic) {
@@ -692,7 +693,7 @@
     cam->vid_map.format = cam->vid_pic.palette;
     for (frame = 0; frame < cam->vid_buf.frames; frame++) {
         cam->vid_map.frame = frame;
-        if (ioctl (cam->dev, VIDIOCMCAPTURE, &cam->vid_map) < 0) {
+        if (v4l1_ioctl (cam->dev, VIDIOCMCAPTURE, &cam->vid_map) < 0) {
             if (cam->debug == TRUE) {
                 fprintf (stderr,
                          "Unable to capture image (VIDIOCMCAPTURE).\n");
--- camorama-0.19/src/main.c	2009-06-24 15:01:55.000000000 +0200
+++ camorama-0.19.new/src/main.c	2009-06-24 14:59:35.000000000 +0200
@@ -9,6 +9,7 @@
 #include <gdk-pixbuf-xlib/gdk-pixbuf-xlib.h>
 #include <gdk-pixbuf-xlib/gdk-pixbuf-xlibrgb.h>
 #include <locale.h>
+#include <libv4l1.h>
 
 #include "camorama-display.h"
 #include "camorama-stock-items.h"
@@ -206,7 +207,7 @@
     gdk_pixbuf_xlib_init (display, 0);
     cam->desk_depth = xlib_rgb_get_depth ();
 
-    cam->dev = open (cam->video_dev, O_RDWR);
+    cam->dev = v4l1_open (cam->video_dev, O_RDWR);
 
     camera_cap (cam);
     get_win_info (cam);
@@ -284,5 +285,8 @@
 
     gtk_timeout_add (2000, (GSourceFunc) fps, cam->status);
     gtk_main ();
+    v4l1_munmap(cam->pic, cam->vid_buf.size);
+    v4l1_close(cam->dev);
+    
     return 0;
 }
--- camorama-0.19/src/v4l.c	2009-06-24 15:01:55.000000000 +0200
+++ camorama-0.19.new/src/v4l.c	2009-06-24 14:54:09.000000000 +0200
@@ -2,6 +2,7 @@
 #include<time.h>
 #include<errno.h>
 #include<gnome.h>
+#include <libv4l1.h>
 #include "support.h"
 
 extern int frame_number;
@@ -87,7 +88,7 @@
 void camera_cap(cam * cam)
 {
    char *msg;
-   if(ioctl(cam->dev, VIDIOCGCAP, &cam->vid_cap) == -1) {
+   if(v4l1_ioctl(cam->dev, VIDIOCGCAP, &cam->vid_cap) == -1) {
       if(cam->debug == TRUE) {
          fprintf(stderr, "VIDIOCGCAP  --  could not get camera capabilities, exiting.....\n");
       }
@@ -161,7 +162,7 @@
 	cam->vid_pic.palette = VIDEO_PALETTE_RGB24;
 	cam->vid_pic.depth = 24;
 	//cam->vid_pic.palette = VIDEO_PALETTE_YUV420P;
-	if(ioctl(cam->dev, VIDIOCSPICT, &cam->vid_pic) == -1) {
+	if(v4l1_ioctl(cam->dev, VIDIOCSPICT, &cam->vid_pic) == -1) {
 		if(cam->debug) {
 			g_message("VIDIOCSPICT  --  could not set picture info, exiting....");
 		}
@@ -176,7 +177,7 @@
 //set_pic_info(cam);
    char *msg;
 	
-   if(ioctl(cam->dev, VIDIOCGPICT, &cam->vid_pic) == -1) {
+   if(v4l1_ioctl(cam->dev, VIDIOCGPICT, &cam->vid_pic) == -1) {
       msg = g_strdup_printf(_("Could not connect to video device (%s).\nPlease check connection."), cam->video_dev);
       error_dialog(msg);
       if(cam->debug == TRUE) {
@@ -201,7 +202,7 @@
 void get_win_info(cam * cam)
 {
    gchar *msg;
-   if(ioctl(cam->dev, VIDIOCGWIN, &cam->vid_win) == -1) {
+   if(v4l1_ioctl(cam->dev, VIDIOCGWIN, &cam->vid_win) == -1) {
       msg = g_strdup_printf(_("Could not connect to video device (%s).\nPlease check connection."), cam->video_dev);
       error_dialog(msg);
       if(cam->debug == TRUE) {
@@ -222,7 +223,7 @@
 void set_win_info(cam * cam)
 {
    gchar *msg;
-   if(ioctl(cam->dev, VIDIOCSWIN, &cam->vid_win) == -1) {
+   if(v4l1_ioctl(cam->dev, VIDIOCSWIN, &cam->vid_win) == -1) {
       msg = g_strdup_printf(_("Could not connect to video device (%s).\nPlease check connection."), cam->video_dev);
       error_dialog(msg);
       if(cam->debug == TRUE) {
@@ -239,7 +240,7 @@
 void set_buffer(cam * cam)
 {
    char *msg;
-   if(ioctl(cam->dev, VIDIOCGMBUF, &cam->vid_buf) == -1) {
+   if(v4l1_ioctl(cam->dev, VIDIOCGMBUF, &cam->vid_buf) == -1) {
       msg = g_strdup_printf(_("Could not connect to video device (%s).\nPlease check connection."), cam->video_dev);
       error_dialog(msg);
       if(cam->debug == TRUE) {

--------------080709050708090505050608--
