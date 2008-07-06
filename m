Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6661NrB008746
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 02:01:23 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6660ZIm029909
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 02:00:36 -0400
Message-ID: <48706115.5050707@hhs.nl>
Date: Sun, 06 Jul 2008 08:07:17 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------010606070304010108040406"
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: PATCH: libv4l-sync-with-0.3.3-release.patch
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------010606070304010108040406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch syncs mercurial with the 0.3.3 tarbal I've just released. note, 
please "hg add" all the files under appl-patches, you forgot this the last 
time, so these files are not in mercurial yet.

Let me know if you want this split up in 3 or 4 incremental patches.

Regards,

Hans


--------------010606070304010108040406
Content-Type: text/x-patch;
 name="libv4l-sync-with-0.3.3-release.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libv4l-sync-with-0.3.3-release.patch"

Sync with the 0.3.3 tarbal release, changes:

* Add open64 and mmap64 wrappers to the LD_PRELOAD wrapper libs, so that
  they also work for applications compiled with FILE_OFFSET_BITS=64, this
  fixes using them with v4l-info
* While looking at xawtv in general, found a few bugs in xawtv itself, added
  a patch to fix those to the appl-patches dir
* Talking about the appl-patches dir, restore that as it accidentally got
  dropped from 0.3.2
* Be more verbose in various places when it comes to logging (esp errors)
* Change v4lconvert_enum_fmt code a bit, so that it is easier to add more
  supported destination formats to libv4lconvert
* Don't return -EINVAL from try_fmt when we cannot convert because the cam
  doesn't have any formats we know. Instead just return as format whatever the
  cam returns from try_fmt, this new behavior is compliant with the v4l2
  api as documented

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r c5084203af61 v4l2-apps/lib/libv4l/ChangeLog
--- a/v4l2-apps/lib/libv4l/ChangeLog	Fri Jul 04 19:34:02 2008 +0200
+++ b/v4l2-apps/lib/libv4l/ChangeLog	Sun Jul 06 07:32:42 2008 +0200
@@ -1,3 +1,20 @@
+libv4l-0.3.3
+------------
+* Add open64 and mmap64 wrappers to the LD_PRELOAD wrapper libs, so that
+  they also work for applications compiled with FILE_OFFSET_BITS=64, this
+  fixes using them with v4l-info
+* While looking at xawtv in general, found a few bugs in xawtv itself, added
+  a patch to fix those to the appl-patches dir
+* Talking about the appl-patches dir, restore that as it accidentally got
+  dropped from 0.3.2
+* Be more verbose in various places when it comes to logging (esp errors)
+* Change v4lconvert_enum_fmt code a bit, so that it is easier to add more
+  supported destination formats to libv4lconvert
+* Don't return -EINVAL from try_fmt when we cannot convert because the cam
+  doesn't have any formats we know. Instead just return as format whatever the
+  cam returns from try_fmt, this new behavior is compliant with the v4l2
+  api as documented
+
 libv4l-0.3.2
 ------------
 * Add support for converting from sn9c10x compressed data
diff -r c5084203af61 v4l2-apps/lib/libv4l/appl-patches/camorama-0.19-fixes.patch
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/v4l2-apps/lib/libv4l/appl-patches/camorama-0.19-fixes.patch	Sun Jul 06 07:32:42 2008 +0200
@@ -0,0 +1,90 @@
+--- camorama-0.19/src/callbacks.c	2007-09-16 15:36:55.000000000 +0200
++++ camorama-0.19.new/src/callbacks.c	2008-06-29 22:22:44.000000000 +0200
+@@ -387,9 +387,6 @@
+         }
+     }
+ 
+-    cam->pixmap = gdk_pixmap_new (NULL, cam->x, cam->y, cam->desk_depth);
+-    gtk_widget_set_size_request (glade_xml_get_widget (cam->xml, "da"),
+-                                 cam->x, cam->y);
+ 
+     /*
+      * if(cam->read == FALSE) {
+@@ -441,6 +438,11 @@
+      * * } 
+      */
+     get_win_info (cam);
++
++    cam->pixmap = gdk_pixmap_new (NULL, cam->x, cam->y, cam->desk_depth);
++    gtk_widget_set_size_request (glade_xml_get_widget (cam->xml, "da"),
++                                 cam->x, cam->y);
++
+     frame = 0;
+     gtk_window_resize (GTK_WINDOW
+                        (glade_xml_get_widget (cam->xml, "main_window")), 320,
+@@ -520,8 +522,14 @@
+     gtk_widget_show (about);
+ }
+ 
++void
++camorama_filter_color_filter(void* filter, guchar *image, int x, int y, int depth);
++
+ static void
+ apply_filters(cam* cam) {
++	/* v4l has reverse rgb order from what camora expect so call the color
++	   filter to fix things up before running the user selected filters */
++	camorama_filter_color_filter(NULL, cam->pic_buf, cam->x, cam->y, cam->depth);
+ 	camorama_filter_chain_apply(cam->filter_chain, cam->pic_buf, cam->x, cam->y, cam->depth);
+ #warning "FIXME: enable the threshold channel filter"
+ //	if((effect_mask & CAMORAMA_FILTER_THRESHOLD_CHANNEL)  != 0) 
+--- camorama-0.19/src/filter.c	2007-09-16 14:48:50.000000000 +0200
++++ camorama-0.19.new/src/filter.c	2008-06-29 22:11:42.000000000 +0200
+@@ -151,12 +151,12 @@
+ static void
+ camorama_filter_color_init(CamoramaFilterColor* self) {}
+ 
+-static void
++void
+ camorama_filter_color_filter(CamoramaFilterColor* filter, guchar *image, int x, int y, int depth) {
+ 	int i;
+ 	char tmp;
+ 	i = x * y;
+-	while (--i) {
++	while (i--) {
+ 		tmp = image[0];
+ 		image[0] = image[2];
+ 		image[2] = tmp;
+--- camorama-0.19/src/main.c	2007-09-16 15:36:55.000000000 +0200
++++ camorama-0.19.new/src/main.c	2008-06-29 22:20:04.000000000 +0200
+@@ -224,8 +224,7 @@
+ 
+     /* get picture attributes */
+     get_pic_info (cam);
+-//	set_pic_info(cam);
+-    /* set_pic_info(cam); */
++    set_pic_info (cam);
+     cam->contrast = cam->vid_pic.contrast;
+     cam->brightness = cam->vid_pic.brightness;
+     cam->colour = cam->vid_pic.colour;
+--- camorama-0.19/src/v4l.c	2007-09-16 14:48:05.000000000 +0200
++++ camorama-0.19.new/src/v4l.c	2008-06-29 22:20:23.000000000 +0200
+@@ -158,8 +158,8 @@
+ 	if(cam->debug) {
+ 		g_message("SET PIC");
+ 	}
+-	//cam->vid_pic.palette = VIDEO_PALETTE_RGB24;
+-	//cam->vid_pic.depth = 24;
++	cam->vid_pic.palette = VIDEO_PALETTE_RGB24;
++	cam->vid_pic.depth = 24;
+ 	//cam->vid_pic.palette = VIDEO_PALETTE_YUV420P;
+ 	if(ioctl(cam->dev, VIDIOCSPICT, &cam->vid_pic) == -1) {
+ 		if(cam->debug) {
+@@ -232,6 +232,8 @@
+       exit(0);
+    }
+ 
++   cam->x = cam->vid_win.width;
++   cam->y = cam->vid_win.height;
+ }
+ 
+ void set_buffer(cam * cam)
diff -r c5084203af61 v4l2-apps/lib/libv4l/appl-patches/vlc-0.8.6-libv4l1.patch
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/v4l2-apps/lib/libv4l/appl-patches/vlc-0.8.6-libv4l1.patch	Sun Jul 06 07:32:42 2008 +0200
@@ -0,0 +1,319 @@
+diff -up vlc-0.8.6f/modules/access/v4l/Makefile.am~ vlc-0.8.6f/modules/access/v4l/Makefile.am
+--- vlc-0.8.6f/modules/access/v4l/Makefile.am~	2008-06-29 17:14:11.000000000 +0200
++++ vlc-0.8.6f/modules/access/v4l/Makefile.am	2008-06-29 17:16:39.000000000 +0200
+@@ -100,7 +100,7 @@ libv4l_plugin_la_CXXFLAGS = `$(VLC_CONFI
+ libv4l_plugin_la_OBJCFLAGS = `$(VLC_CONFIG) --objcflags plugin v4l`
+ libv4l_plugin_la_LDFLAGS = `$(VLC_CONFIG) --libs plugin v4l` \
+ 	-rpath '$(libvlcdir)' -avoid-version -module -shrext $(LIBEXT)
+-libv4l_plugin_la_LIBADD = $(LTLIBVLC)
++libv4l_plugin_la_LIBADD = $(LTLIBVLC) -lv4l1
+ 
+ libv4l_a_SOURCES = $(SOURCES_v4l)
+ libv4l_builtin_la_SOURCES = $(SOURCES_v4l)
+diff -up vlc-0.8.6f/modules/access/v4l/Makefile.in~ vlc-0.8.6f/modules/access/v4l/Makefile.in
+--- vlc-0.8.6f/modules/access/v4l/Makefile.in~	2008-06-29 17:16:22.000000000 +0200
++++ vlc-0.8.6f/modules/access/v4l/Makefile.in	2008-06-29 17:16:42.000000000 +0200
+@@ -390,7 +390,7 @@ libv4l_plugin_la_OBJCFLAGS = `$(VLC_CONF
+ libv4l_plugin_la_LDFLAGS = `$(VLC_CONFIG) --libs plugin v4l` \
+ 	-rpath '$(libvlcdir)' -avoid-version -module -shrext $(LIBEXT)
+ 
+-libv4l_plugin_la_LIBADD = $(LTLIBVLC)
++libv4l_plugin_la_LIBADD = $(LTLIBVLC) -lv4l1
+ libv4l_a_SOURCES = $(SOURCES_v4l)
+ libv4l_builtin_la_SOURCES = $(SOURCES_v4l)
+ libv4l_a_CFLAGS = `$(VLC_CONFIG) --cflags builtin pic v4l`
+diff -up vlc-0.8.6f/modules/access/v4l/v4l.c~ vlc-0.8.6f/modules/access/v4l/v4l.c
+--- vlc-0.8.6f/modules/access/v4l/v4l.c~	2008-06-29 17:13:30.000000000 +0200
++++ vlc-0.8.6f/modules/access/v4l/v4l.c	2008-06-29 17:13:30.000000000 +0200
+@@ -64,6 +64,9 @@
+ 
+ #include <sys/soundcard.h>
+ 
++#include <libv4l1.h>
++
++
+ /*****************************************************************************
+  * Module descriptior
+  *****************************************************************************/
+@@ -546,23 +549,23 @@ static void Close( vlc_object_t *p_this 
+     if( p_sys->psz_device ) free( p_sys->psz_device );
+     if( p_sys->psz_vdev )   free( p_sys->psz_vdev );
+     if( p_sys->psz_adev )   free( p_sys->psz_adev );
+-    if( p_sys->fd_video >= 0 ) close( p_sys->fd_video );
++    if( p_sys->fd_video >= 0 ) v4l1_close( p_sys->fd_video );
+     if( p_sys->fd_audio >= 0 ) close( p_sys->fd_audio );
+     if( p_sys->p_block_audio ) block_Release( p_sys->p_block_audio );
+ 
+     if( p_sys->b_mjpeg )
+     {
+         int i_noframe = -1;
+-        ioctl( p_sys->fd_video, MJPIOC_QBUF_CAPT, &i_noframe );
++        v4l1_ioctl( p_sys->fd_video, MJPIOC_QBUF_CAPT, &i_noframe );
+     }
+ 
+     if( p_sys->p_video_mmap && p_sys->p_video_mmap != MAP_FAILED )
+     {
+         if( p_sys->b_mjpeg )
+-            munmap( p_sys->p_video_mmap, p_sys->mjpeg_buffers.size *
++            v4l1_munmap( p_sys->p_video_mmap, p_sys->mjpeg_buffers.size *
+                     p_sys->mjpeg_buffers.count );
+         else
+-            munmap( p_sys->p_video_mmap, p_sys->vid_mbuf.size );
++            v4l1_munmap( p_sys->p_video_mmap, p_sys->vid_mbuf.size );
+     }
+ 
+     free( p_sys );
+@@ -875,13 +878,13 @@ static int OpenVideoDev( demux_t *p_demu
+     struct mjpeg_params mjpeg;
+     int i;
+ 
+-    if( ( i_fd = open( psz_device, O_RDWR ) ) < 0 )
++    if( ( i_fd = v4l1_open( psz_device, O_RDWR ) ) < 0 )
+     {
+         msg_Err( p_demux, "cannot open device (%s)", strerror( errno ) );
+         goto vdev_failed;
+     }
+ 
+-    if( ioctl( i_fd, VIDIOCGCAP, &p_sys->vid_cap ) < 0 )
++    if( v4l1_ioctl( i_fd, VIDIOCGCAP, &p_sys->vid_cap ) < 0 )
+     {
+         msg_Err( p_demux, "cannot get capabilities (%s)", strerror( errno ) );
+         goto vdev_failed;
+@@ -926,7 +929,7 @@ static int OpenVideoDev( demux_t *p_demu
+     }
+ 
+     vid_channel.channel = p_sys->i_channel;
+-    if( ioctl( i_fd, VIDIOCGCHAN, &vid_channel ) < 0 )
++    if( v4l1_ioctl( i_fd, VIDIOCGCHAN, &vid_channel ) < 0 )
+     {
+         msg_Err( p_demux, "cannot get channel infos (%s)",
+                           strerror( errno ) );
+@@ -944,7 +947,7 @@ static int OpenVideoDev( demux_t *p_demu
+     }
+ 
+     vid_channel.norm = p_sys->i_norm;
+-    if( ioctl( i_fd, VIDIOCSCHAN, &vid_channel ) < 0 )
++    if( v4l1_ioctl( i_fd, VIDIOCSCHAN, &vid_channel ) < 0 )
+     {
+         msg_Err( p_demux, "cannot set channel (%s)", strerror( errno ) );
+         goto vdev_failed;
+@@ -959,7 +962,7 @@ static int OpenVideoDev( demux_t *p_demu
+         if( p_sys->i_tuner >= 0 )
+         {
+             vid_tuner.tuner = p_sys->i_tuner;
+-            if( ioctl( i_fd, VIDIOCGTUNER, &vid_tuner ) < 0 )
++            if( v4l1_ioctl( i_fd, VIDIOCGTUNER, &vid_tuner ) < 0 )
+             {
+                 msg_Err( p_demux, "cannot get tuner (%s)", strerror( errno ) );
+                 goto vdev_failed;
+@@ -974,7 +977,7 @@ static int OpenVideoDev( demux_t *p_demu
+ 
+             /* FIXME FIXME to be checked FIXME FIXME */
+             //vid_tuner.mode = p_sys->i_norm;
+-            if( ioctl( i_fd, VIDIOCSTUNER, &vid_tuner ) < 0 )
++            if( v4l1_ioctl( i_fd, VIDIOCSTUNER, &vid_tuner ) < 0 )
+             {
+                 msg_Err( p_demux, "cannot set tuner (%s)", strerror( errno ) );
+                 goto vdev_failed;
+@@ -990,7 +993,7 @@ static int OpenVideoDev( demux_t *p_demu
+         if( p_sys->i_frequency >= 0 )
+         {
+             int driver_frequency = p_sys->i_frequency * 16 /1000;
+-            if( ioctl( i_fd, VIDIOCSFREQ, &driver_frequency ) < 0 )
++            if( v4l1_ioctl( i_fd, VIDIOCSFREQ, &driver_frequency ) < 0 )
+             {
+                 msg_Err( p_demux, "cannot set frequency (%s)",
+                                   strerror( errno ) );
+@@ -1010,7 +1013,7 @@ static int OpenVideoDev( demux_t *p_demu
+         if( p_sys->i_audio >= 0 )
+         {
+             vid_audio.audio = p_sys->i_audio;
+-            if( ioctl( i_fd, VIDIOCGAUDIO, &vid_audio ) < 0 )
++            if( v4l1_ioctl( i_fd, VIDIOCGAUDIO, &vid_audio ) < 0 )
+             {
+                 msg_Err( p_demux, "cannot get audio (%s)", strerror( errno ) );
+                 goto vdev_failed;
+@@ -1019,7 +1022,7 @@ static int OpenVideoDev( demux_t *p_demu
+             /* unmute audio */
+             vid_audio.flags &= ~VIDEO_AUDIO_MUTE;
+ 
+-            if( ioctl( i_fd, VIDIOCSAUDIO, &vid_audio ) < 0 )
++            if( v4l1_ioctl( i_fd, VIDIOCSAUDIO, &vid_audio ) < 0 )
+             {
+                 msg_Err( p_demux, "cannot set audio (%s)", strerror( errno ) );
+                 goto vdev_failed;
+@@ -1035,7 +1038,7 @@ static int OpenVideoDev( demux_t *p_demu
+         struct quicktime_mjpeg_app1 *p_app1;
+         int32_t i_offset;
+ 
+-        if( ioctl( i_fd, MJPIOC_G_PARAMS, &mjpeg ) < 0 )
++        if( v4l1_ioctl( i_fd, MJPIOC_G_PARAMS, &mjpeg ) < 0 )
+         {
+             msg_Err( p_demux, "cannot get mjpeg params (%s)",
+                               strerror( errno ) );
+@@ -1086,7 +1089,7 @@ static int OpenVideoDev( demux_t *p_demu
+          * optional.  They will be present in the output. */
+         mjpeg.jpeg_markers = JPEG_MARKER_DHT | JPEG_MARKER_DQT;
+ 
+-        if( ioctl( i_fd, MJPIOC_S_PARAMS, &mjpeg ) < 0 )
++        if( v4l1_ioctl( i_fd, MJPIOC_S_PARAMS, &mjpeg ) < 0 )
+         {
+             msg_Err( p_demux, "cannot set mjpeg params (%s)",
+                               strerror( errno ) );
+@@ -1103,7 +1106,7 @@ static int OpenVideoDev( demux_t *p_demu
+     {
+         struct video_window vid_win;
+ 
+-        if( ioctl( i_fd, VIDIOCGWIN, &vid_win ) < 0 )
++        if( v4l1_ioctl( i_fd, VIDIOCGWIN, &vid_win ) < 0 )
+         {
+             msg_Err( p_demux, "cannot get win (%s)", strerror( errno ) );
+             goto vdev_failed;
+@@ -1130,7 +1133,7 @@ static int OpenVideoDev( demux_t *p_demu
+     if( !p_sys->b_mjpeg )
+     {
+         /* set hue/color/.. */
+-        if( ioctl( i_fd, VIDIOCGPICT, &p_sys->vid_picture ) == 0 )
++        if( v4l1_ioctl( i_fd, VIDIOCGPICT, &p_sys->vid_picture ) == 0 )
+         {
+             struct video_picture vid_picture = p_sys->vid_picture;
+ 
+@@ -1150,7 +1153,7 @@ static int OpenVideoDev( demux_t *p_demu
+             {
+                 vid_picture.contrast = p_sys->i_contrast;
+             }
+-            if( ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
++            if( v4l1_ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
+             {
+                 msg_Dbg( p_demux, "v4l device uses brightness: %d",
+                          vid_picture.brightness );
+@@ -1164,7 +1167,7 @@ static int OpenVideoDev( demux_t *p_demu
+         }
+ 
+         /* Find out video format used by device */
+-        if( ioctl( i_fd, VIDIOCGPICT, &p_sys->vid_picture ) == 0 )
++        if( v4l1_ioctl( i_fd, VIDIOCGPICT, &p_sys->vid_picture ) == 0 )
+         {
+             struct video_picture vid_picture = p_sys->vid_picture;
+             char *psz;
+@@ -1191,7 +1194,7 @@ static int OpenVideoDev( demux_t *p_demu
+             free( psz );
+ 
+             if( vid_picture.palette &&
+-                !ioctl( i_fd, VIDIOCSPICT, &vid_picture ) )
++                !v4l1_ioctl( i_fd, VIDIOCSPICT, &vid_picture ) )
+             {
+                 p_sys->vid_picture = vid_picture;
+             }
+@@ -1199,14 +1202,14 @@ static int OpenVideoDev( demux_t *p_demu
+             {
+                 /* Try to set the format to something easy to encode */
+                 vid_picture.palette = VIDEO_PALETTE_YUV420P;
+-                if( ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
++                if( v4l1_ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
+                 {
+                     p_sys->vid_picture = vid_picture;
+                 }
+                 else
+                 {
+                     vid_picture.palette = VIDEO_PALETTE_YUV422P;
+-                    if( ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
++                    if( v4l1_ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
+                     {
+                         p_sys->vid_picture = vid_picture;
+                     }
+@@ -1237,13 +1240,13 @@ static int OpenVideoDev( demux_t *p_demu
+         p_sys->mjpeg_buffers.count = 8;
+         p_sys->mjpeg_buffers.size = MJPEG_BUFFER_SIZE;
+ 
+-        if( ioctl( i_fd, MJPIOC_REQBUFS, &p_sys->mjpeg_buffers ) < 0 )
++        if( v4l1_ioctl( i_fd, MJPIOC_REQBUFS, &p_sys->mjpeg_buffers ) < 0 )
+         {
+             msg_Err( p_demux, "mmap unsupported" );
+             goto vdev_failed;
+         }
+ 
+-        p_sys->p_video_mmap = mmap( 0,
++        p_sys->p_video_mmap = v4l1_mmap( 0,
+                 p_sys->mjpeg_buffers.size * p_sys->mjpeg_buffers.count,
+                 PROT_READ | PROT_WRITE, MAP_SHARED, i_fd, 0 );
+         if( p_sys->p_video_mmap == MAP_FAILED )
+@@ -1258,7 +1261,7 @@ static int OpenVideoDev( demux_t *p_demu
+         /* queue up all the frames */
+         for( i = 0; i < (int)p_sys->mjpeg_buffers.count; i++ )
+         {
+-            if( ioctl( i_fd, MJPIOC_QBUF_CAPT, &i ) < 0 )
++            if( v4l1_ioctl( i_fd, MJPIOC_QBUF_CAPT, &i ) < 0 )
+             {
+                 msg_Err( p_demux, "unable to queue frame" );
+                 goto vdev_failed;
+@@ -1289,13 +1292,13 @@ static int OpenVideoDev( demux_t *p_demu
+                 (char*)&p_sys->i_fourcc );
+ 
+         /* Allocate mmap buffer */
+-        if( ioctl( i_fd, VIDIOCGMBUF, &p_sys->vid_mbuf ) < 0 )
++        if( v4l1_ioctl( i_fd, VIDIOCGMBUF, &p_sys->vid_mbuf ) < 0 )
+         {
+             msg_Err( p_demux, "mmap unsupported" );
+             goto vdev_failed;
+         }
+ 
+-        p_sys->p_video_mmap = mmap( 0, p_sys->vid_mbuf.size,
++        p_sys->p_video_mmap = v4l1_mmap( 0, p_sys->vid_mbuf.size,
+                                     PROT_READ|PROT_WRITE, MAP_SHARED,
+                                     i_fd, 0 );
+         if( p_sys->p_video_mmap == MAP_FAILED )
+@@ -1310,7 +1313,7 @@ static int OpenVideoDev( demux_t *p_demu
+         p_sys->vid_mmap.width  = p_sys->i_width;
+         p_sys->vid_mmap.height = p_sys->i_height;
+         p_sys->vid_mmap.format = p_sys->vid_picture.palette;
+-        if( ioctl( i_fd, VIDIOCMCAPTURE, &p_sys->vid_mmap ) < 0 )
++        if( v4l1_ioctl( i_fd, VIDIOCMCAPTURE, &p_sys->vid_mmap ) < 0 )
+         {
+             msg_Warn( p_demux, "%4.4s refused", (char*)&p_sys->i_fourcc );
+             msg_Err( p_demux, "chroma selection failed" );
+@@ -1321,7 +1324,7 @@ static int OpenVideoDev( demux_t *p_demu
+ 
+ vdev_failed:
+ 
+-    if( i_fd >= 0 ) close( i_fd );
++    if( i_fd >= 0 ) v4l1_close( i_fd );
+     return -1;
+ }
+ 
+@@ -1431,7 +1434,7 @@ static uint8_t *GrabCapture( demux_t *p_
+ 
+     p_sys->vid_mmap.frame = (p_sys->i_frame_pos + 1) % p_sys->vid_mbuf.frames;
+ 
+-    while( ioctl( p_sys->fd_video, VIDIOCMCAPTURE, &p_sys->vid_mmap ) < 0 )
++    while( v4l1_ioctl( p_sys->fd_video, VIDIOCMCAPTURE, &p_sys->vid_mmap ) < 0 )
+     {
+         if( errno != EAGAIN )
+         {
+@@ -1447,7 +1450,7 @@ static uint8_t *GrabCapture( demux_t *p_
+         msg_Dbg( p_demux, "grab failed, trying again" );
+     }
+ 
+-    while( ioctl(p_sys->fd_video, VIDIOCSYNC, &p_sys->i_frame_pos) < 0 )
++    while( v4l1_ioctl(p_sys->fd_video, VIDIOCSYNC, &p_sys->i_frame_pos) < 0 )
+     {
+         if( errno != EAGAIN && errno != EINTR )    
+         {
+@@ -1473,7 +1476,7 @@ static uint8_t *GrabMJPEG( demux_t *p_de
+     /* re-queue the last frame we sync'd */
+     if( p_sys->i_frame_pos != -1 )
+     {
+-        while( ioctl( p_sys->fd_video, MJPIOC_QBUF_CAPT,
++        while( v4l1_ioctl( p_sys->fd_video, MJPIOC_QBUF_CAPT,
+                                        &p_sys->i_frame_pos ) < 0 )
+         {
+             if( errno != EAGAIN && errno != EINTR )
+@@ -1485,7 +1488,7 @@ static uint8_t *GrabMJPEG( demux_t *p_de
+     }
+ 
+     /* sync on the next frame */
+-    while( ioctl( p_sys->fd_video, MJPIOC_SYNC, &sync ) < 0 )
++    while( v4l1_ioctl( p_sys->fd_video, MJPIOC_SYNC, &sync ) < 0 )
+     {
+         if( errno != EAGAIN && errno != EINTR )    
+         {
diff -r c5084203af61 v4l2-apps/lib/libv4l/appl-patches/xawtv-3.95-fixes.patch
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/v4l2-apps/lib/libv4l/appl-patches/xawtv-3.95-fixes.patch	Sun Jul 06 07:32:42 2008 +0200
@@ -0,0 +1,29 @@
+--- xawtv-3.95/libng/plugins/drv0-v4l2.c	2005-02-11 18:56:24.000000000 +0100
++++ xawtv-3.95.new/libng/plugins/drv0-v4l2.c	2008-07-05 21:12:37.000000000 +0200
+@@ -161,7 +161,7 @@
+ #define PREFIX "ioctl: "
+ 
+ static int
+-xioctl(int fd, int cmd, void *arg, int mayfail)
++xioctl(int fd, unsigned long int cmd, void *arg, int mayfail)
+ {
+     int rc;
+ 
+@@ -768,6 +768,7 @@
+     /* get it */
+     memset(&buf,0,sizeof(buf));
+     buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
++    buf.memory = V4L2_MEMORY_MMAP;
+     if (-1 == xioctl(h->fd,VIDIOC_DQBUF,&buf, 0))
+ 	return -1;
+     h->waiton++;
+@@ -813,8 +814,7 @@
+ 	if (-1 == xioctl(h->fd, VIDIOC_QUERYBUF, &h->buf_v4l2[i], 0))
+ 	    return -1;
+ 	h->buf_me[i].fmt  = h->fmt_me;
+-	h->buf_me[i].size = h->buf_me[i].fmt.bytesperline *
+-	    h->buf_me[i].fmt.height;
++	h->buf_me[i].size = h->buf_v4l2[i].length;
+ 	h->buf_me[i].data = mmap(NULL, h->buf_v4l2[i].length,
+ 				 PROT_READ | PROT_WRITE, MAP_SHARED,
+ 				 h->fd, h->buf_v4l2[i].m.offset);
diff -r c5084203af61 v4l2-apps/lib/libv4l/include/libv4l1.h
--- a/v4l2-apps/lib/libv4l/include/libv4l1.h	Fri Jul 04 19:34:02 2008 +0200
+++ b/v4l2-apps/lib/libv4l/include/libv4l1.h	Sun Jul 06 07:32:42 2008 +0200
@@ -57,7 +57,7 @@
 int v4l1_ioctl (int fd, unsigned long int request, ...);
 ssize_t v4l1_read (int fd, void* buffer, size_t n);
 void *v4l1_mmap(void *start, size_t length, int prot, int flags, int fd,
-  off_t offset);
+  __off64_t offset);
 int v4l1_munmap(void *_start, size_t length);
 
 #ifdef __cplusplus
diff -r c5084203af61 v4l2-apps/lib/libv4l/include/libv4l2.h
--- a/v4l2-apps/lib/libv4l/include/libv4l2.h	Fri Jul 04 19:34:02 2008 +0200
+++ b/v4l2-apps/lib/libv4l/include/libv4l2.h	Sun Jul 06 07:32:42 2008 +0200
@@ -58,7 +58,7 @@
 int v4l2_ioctl (int fd, unsigned long int request, ...);
 ssize_t v4l2_read (int fd, void* buffer, size_t n);
 void *v4l2_mmap(void *start, size_t length, int prot, int flags, int fd,
-  off_t offset);
+  __off64_t offset);
 int v4l2_munmap(void *_start, size_t length);
 
 
diff -r c5084203af61 v4l2-apps/lib/libv4l/libv4l1/libv4l1.c
--- a/v4l2-apps/lib/libv4l/libv4l1/libv4l1.c	Fri Jul 04 19:34:02 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l1/libv4l1.c	Sun Jul 06 07:32:42 2008 +0200
@@ -40,9 +40,6 @@
       in turn will call v4l1_open, so therefor v4l1_open (for example) may not
       use the regular open()!
 */
-
-#define _LARGEFILE64_SOURCE 1
-
 #include <errno.h>
 #include <stdarg.h>
 #include <stdio.h>
@@ -642,7 +639,8 @@
 	}
 
 	if (devices[index].v4l1_frame_pointer == MAP_FAILED) {
-	  devices[index].v4l1_frame_pointer = mmap64(NULL, mbuf->size,
+	  devices[index].v4l1_frame_pointer = (void *)syscall(SYS_mmap, NULL,
+				      (size_t)mbuf->size,
 				      PROT_READ|PROT_WRITE,
 				      MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
 	  if (devices[index].v4l1_frame_pointer == MAP_FAILED) {
@@ -749,7 +747,7 @@
 
 
 void *v4l1_mmap(void *start, size_t length, int prot, int flags, int fd,
-  __off_t offset)
+  __off64_t offset)
 {
   int index;
   void *result;
diff -r c5084203af61 v4l2-apps/lib/libv4l/libv4l1/v4l1compat.c
--- a/v4l2-apps/lib/libv4l/libv4l1/v4l1compat.c	Fri Jul 04 19:34:02 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l1/v4l1compat.c	Sun Jul 06 07:32:42 2008 +0200
@@ -18,6 +18,8 @@
 # along with this program; if not, write to the Free Software
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
+
+#define _LARGEFILE64_SOURCE 1
 
 #include <stdlib.h>
 #include <stdarg.h>
@@ -46,6 +48,27 @@
     va_end(ap);
   } else
     fd = v4l1_open(file, oflag);
+
+  return fd;
+}
+
+int open64 (const char *file, int oflag, ...)
+{
+  int fd;
+
+  if (oflag & O_CREAT)
+  {
+    va_list ap;
+    mode_t mode;
+
+    va_start (ap, oflag);
+    mode = va_arg (ap, mode_t);
+
+    fd = v4l1_open(file, oflag | O_LARGEFILE, mode);
+
+    va_end(ap);
+  } else
+    fd = v4l1_open(file, oflag | O_LARGEFILE);
 
   return fd;
 }
@@ -82,6 +105,12 @@
   return v4l1_mmap(start, length, prot, flags, fd, offset);
 }
 
+void mmap64(void *start, size_t length, int prot, int flags, int fd,
+  __off64_t offset)
+{
+  return v4l1_mmap(start, length, prot, flags, fd, offset);
+}
+
 int munmap(void *start, size_t length)
 {
   return v4l1_munmap(start, length);
diff -r c5084203af61 v4l2-apps/lib/libv4l/libv4l2/libv4l2-priv.h
--- a/v4l2-apps/lib/libv4l/libv4l2/libv4l2-priv.h	Fri Jul 04 19:34:02 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l2/libv4l2-priv.h	Sun Jul 06 07:32:42 2008 +0200
@@ -22,6 +22,15 @@
 #include <stdio.h>
 #include <pthread.h>
 #include <libv4lconvert.h> /* includes videodev2.h for us */
+
+/* On 32 bits archs we always use mmap2, on 64 bits archs there is no mmap2 */
+#ifdef __NR_mmap2
+#define SYS_mmap2 __NR_mmap2
+#define MMAP2_PAGE_SHIFT 12
+#else
+#define SYS_mmap2 SYS_mmap
+#define MMAP2_PAGE_SHIFT 0
+#endif
 
 #define V4L2_MAX_DEVICES 16
 /* Warning when making this larger the frame_queued and frame_mapped members of
diff -r c5084203af61 v4l2-apps/lib/libv4l/libv4l2/libv4l2.c
--- a/v4l2-apps/lib/libv4l/libv4l2/libv4l2.c	Fri Jul 04 19:34:02 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l2/libv4l2.c	Sun Jul 06 07:32:42 2008 +0200
@@ -55,9 +55,6 @@
    When modifications are made, one should be carefull that this behavior is
    preserved.
 */
-
-#define _LARGEFILE64_SOURCE 1
-
 #include <errno.h>
 #include <stdarg.h>
 #include <stdio.h>
@@ -161,8 +158,9 @@
       break;
     }
 
-    devices[index].frame_pointers[i] = mmap64(NULL, buf.length,
-      PROT_READ, MAP_SHARED, devices[index].fd, buf.m.offset);
+    devices[index].frame_pointers[i] = (void *)syscall(SYS_mmap2, NULL,
+      (size_t)buf.length, PROT_READ, MAP_SHARED, devices[index].fd,
+      (__off_t)(buf.m.offset >> MMAP2_PAGE_SHIFT));
     if (devices[index].frame_pointers[i] == MAP_FAILED) {
       int saved_err = errno;
       V4L2_LOG_ERR("mmapping buffer %u: %s\n", i, strerror(errno));
@@ -583,8 +581,13 @@
       }
   }
 
-  if (!is_capture_request)
-    return syscall(SYS_ioctl, fd, request, arg);
+  if (!is_capture_request) {
+    result = syscall(SYS_ioctl, fd, request, arg);
+    saved_err = errno;
+    v4l2_log_ioctl(request, arg, result);
+    errno = saved_err;
+    return result;
+  }
 
 
   if (stream_needs_locking)
@@ -755,16 +758,22 @@
 	struct v4l2_buffer *buf = arg;
 
 	result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_DQBUF, buf);
-	if (result || !converting)
+	if (result) {
+	  V4L2_LOG_ERR("dequeing buffer: %s\n", strerror(errno));
+	  break;
+	}
+
+	if (!converting)
 	  break;
 
 	/* An application can do a DQBUF before mmap-ing in the buffer,
 	   but we need the buffer _now_ to write our converted data
 	   to it! */
 	if (devices[index].convert_mmap_buf == MAP_FAILED) {
-	  devices[index].convert_mmap_buf = mmap64(NULL,
-						   devices[index].no_frames *
-						     V4L2_FRAME_BUF_SIZE,
+	  devices[index].convert_mmap_buf = (void *)syscall(SYS_mmap2,
+						   (size_t)(
+						     devices[index].no_frames *
+						     V4L2_FRAME_BUF_SIZE),
 						   PROT_READ|PROT_WRITE,
 						   MAP_ANONYMOUS|MAP_PRIVATE,
 						   -1, 0);
@@ -789,8 +798,11 @@
 		   devices[index].convert_mmap_buf +
 		     buf->index * V4L2_FRAME_BUF_SIZE,
 		   V4L2_FRAME_BUF_SIZE);
-	if (result < 0)
+	if (result < 0) {
+	  V4L2_LOG_ERR("converting / decoding frame data: %s\n",
+			v4lconvert_get_error_message(devices[index].convert));
 	  break;
+	}
 
 	buf->bytesused = result;
 	buf->length = V4L2_FRAME_BUF_SIZE;
@@ -861,6 +873,10 @@
 
   v4l2_queue_read_buffer(index, frame_index);
 
+  if (result < 0)
+    V4L2_LOG_ERR("converting / decoding frame data: %s\n",
+		 v4lconvert_get_error_message(devices[index].convert));
+
 leave:
   pthread_mutex_unlock(&devices[index].stream_lock);
 
@@ -868,7 +884,7 @@
 }
 
 void *v4l2_mmap(void *start, size_t length, int prot, int flags, int fd,
-  __off_t offset)
+  __off64_t offset)
 {
   int index;
   unsigned int buffer_index;
@@ -882,7 +898,14 @@
     if (index != -1)
       V4L2_LOG("Passing mmap(%p, %d, ..., %x, through to the driver\n",
 	start, (int)length, (int)offset);
-    return mmap64(start, length, prot, flags, fd, offset);
+
+    if (offset & ((1 << MMAP2_PAGE_SHIFT) - 1)) {
+      errno = EINVAL;
+      return MAP_FAILED;
+    }
+
+    return (void *)syscall(SYS_mmap2, start, length, prot, flags, fd,
+			   (__off_t)(offset >> MMAP2_PAGE_SHIFT));
   }
 
   pthread_mutex_lock(&devices[index].stream_lock);
@@ -899,9 +922,10 @@
   }
 
   if (devices[index].convert_mmap_buf == MAP_FAILED) {
-    devices[index].convert_mmap_buf = mmap64(NULL,
-					     devices[index].no_frames *
-					       V4L2_FRAME_BUF_SIZE,
+    devices[index].convert_mmap_buf = (void *)syscall(SYS_mmap2, NULL,
+					     (size_t)(
+					       devices[index].no_frames *
+					       V4L2_FRAME_BUF_SIZE),
 					     PROT_READ|PROT_WRITE,
 					     MAP_ANONYMOUS|MAP_PRIVATE,
 					     -1, 0);
diff -r c5084203af61 v4l2-apps/lib/libv4l/libv4l2/v4l2convert.c
--- a/v4l2-apps/lib/libv4l/libv4l2/v4l2convert.c	Fri Jul 04 19:34:02 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l2/v4l2convert.c	Sun Jul 06 07:32:42 2008 +0200
@@ -19,6 +19,8 @@
 # along with this program; if not, write to the Free Software
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
+
+#define _LARGEFILE64_SOURCE 1
 
 #include <stdarg.h>
 #include <stdlib.h>
@@ -82,6 +84,29 @@
   return fd;
 }
 
+int open64(const char *file, int oflag, ...)
+{
+  int fd;
+
+  /* original open code */
+  if (oflag & O_CREAT)
+  {
+    va_list ap;
+    mode_t mode;
+
+    va_start (ap, oflag);
+    mode = va_arg (ap, mode_t);
+
+    fd = open(file, oflag | O_LARGEFILE, mode);
+
+    va_end(ap);
+  } else
+    fd = open(file, oflag | O_LARGEFILE);
+  /* end of original open code */
+
+  return fd;
+}
+
 int close(int fd)
 {
   return v4l2_close(fd);
@@ -115,6 +140,12 @@
   return v4l2_mmap(start, length, prot, flags, fd, offset);
 }
 
+void mmap64(void *start, size_t length, int prot, int flags, int fd,
+  __off64_t offset)
+{
+  return v4l2_mmap(start, length, prot, flags, fd, offset);
+}
+
 int munmap(void *start, size_t length)
 {
   return v4l2_munmap(start, length);
diff -r c5084203af61 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Fri Jul 04 19:34:02 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Sun Jul 06 07:32:42 2008 +0200
@@ -27,9 +27,14 @@
 #define MIN(a,b) (((a)<(b))?(a):(b))
 #define ARRAY_SIZE(x) ((int)sizeof(x)/(int)sizeof((x)[0]))
 
+/* Note for proper functioning of v4lconvert_enum_fmt the first entries in
+  supported_src_pixfmts must match with the entries in supported_dst_pixfmts */
+#define SUPPORTED_DST_PIXFMTS \
+  V4L2_PIX_FMT_BGR24, \
+  V4L2_PIX_FMT_YUV420
+
 static const unsigned int supported_src_pixfmts[] = {
-  V4L2_PIX_FMT_BGR24,
-  V4L2_PIX_FMT_YUV420,
+  SUPPORTED_DST_PIXFMTS,
   V4L2_PIX_FMT_MJPEG,
   V4L2_PIX_FMT_JPEG,
   V4L2_PIX_FMT_SBGGR8,
@@ -43,8 +48,7 @@
 };
 
 static const unsigned int supported_dst_pixfmts[] = {
-  V4L2_PIX_FMT_BGR24,
-  V4L2_PIX_FMT_YUV420,
+  SUPPORTED_DST_PIXFMTS
 };
 
 
@@ -93,37 +97,34 @@
 /* See libv4lconvert.h for description of in / out parameters */
 int v4lconvert_enum_fmt(struct v4lconvert_data *data, struct v4l2_fmtdesc *fmt)
 {
+  int i, no_faked_fmts = 0;
+  unsigned int faked_fmts[ARRAY_SIZE(supported_dst_pixfmts)];
+
   if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
       fmt->index < data->no_formats ||
       !data->supported_src_formats)
     return syscall(SYS_ioctl, data->fd, VIDIOC_ENUM_FMT, fmt);
 
-  fmt->flags = 0;
-  fmt->pixelformat = 0;
-  memset(fmt->reserved, 0, 4);
+  for (i = 0; i < ARRAY_SIZE(supported_dst_pixfmts); i++)
+    if (!(data->supported_src_formats & (1 << i))) {
+      faked_fmts[no_faked_fmts] = supported_dst_pixfmts[i];
+      no_faked_fmts++;
+    }
 
-  /* Note bgr24 and yuv420 are the first 2 in our mask of supported formats */
-  switch (fmt->index - data->no_formats) {
-    case 0:
-      if (!(data->supported_src_formats & 1)) {
-	strcpy((char *)fmt->description, "BGR24");
-	fmt->pixelformat = V4L2_PIX_FMT_BGR24;
-      } else if (!(data->supported_src_formats & 2)) {
-	strcpy((char *)fmt->description, "YUV420");
-	fmt->pixelformat = V4L2_PIX_FMT_YUV420;
-      }
-      break;
-    case 1:
-      if (!(data->supported_src_formats & 3)) {
-	strcpy((char *)fmt->description, "YUV420");
-	fmt->pixelformat = V4L2_PIX_FMT_YUV420;
-      }
-      break;
-  }
-  if (fmt->pixelformat == 0) {
+  i = fmt->index - data->no_formats;
+  if (i >= no_faked_fmts) {
     errno = EINVAL;
     return -1;
   }
+
+  fmt->flags = 0;
+  fmt->pixelformat = faked_fmts[i];
+  fmt->description[0] = faked_fmts[i] & 0xff;
+  fmt->description[1] = (faked_fmts[i] >> 8) & 0xff;
+  fmt->description[2] = (faked_fmts[i] >> 16) & 0xff;
+  fmt->description[3] = faked_fmts[i] >> 24;
+  fmt->description[4] = '\0';
+  memset(fmt->reserved, 0, 4);
 
   return 0;
 }
@@ -176,8 +177,10 @@
   }
 
   if (closest_fmt.type == 0) {
-    errno = EINVAL;
-    return -1;
+    int ret = syscall(SYS_ioctl, data->fd, VIDIOC_TRY_FMT, dest_fmt);
+    if (src_fmt)
+      *src_fmt = *dest_fmt;
+    return ret;
   }
 
   *dest_fmt = closest_fmt;

--------------010606070304010108040406
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------010606070304010108040406--
