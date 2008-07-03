Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63IfHsq005475
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 14:41:17 -0400
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m63If2I9004716
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 14:41:03 -0400
Message-ID: <486D1DB5.8070400@free.fr>
Date: Thu, 03 Jul 2008 20:43:01 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <486CB8F1.2060701@hhs.nl>
In-Reply-To: <486CB8F1.2060701@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: Re: PATCH: libv4l: update mercurial tree to latest 0.3.1 release
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

Hans de Goede a écrit :
> Hi,
>
> This patch syncs (updates) the libv4l in mercurial with (to) the
> latest 0.3.1
> release.
>
> Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
>
> Regards,
>
> Hans
> This patch syncs (updates) the libv4l in mercurial with (to) the latest 0.3.1
> release.
>
> Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
>
> diff -r 6169e79de2d2 v4l2-apps/lib/libv4l/ChangeLog
> --- a/v4l2-apps/lib/libv4l/ChangeLog	Tue Jul 01 21:18:23 2008 +0200
> +++ b/v4l2-apps/lib/libv4l/ChangeLog	Thu Jul 03 13:29:13 2008 +0200
> @@ -1,3 +1,20 @@
> +libv4l-0.3.1
> +------------
> +* Only serialize V4L2_BUF_TYPE_VIDEO_CAPTURE type ioctls
> +* Do not return an uninitialized variable as result code for GPICT
> +  (fixes vlc, but see below)
> +* Add an apps-patches directory which includes:
> +  * vlc-0.8.6-libv4l1.patch, modify vlc's v4l1 plugin to directly call into
> +    libv4l1, in the end we want all apps todo this as its better then
> +    LD_PRELOAD tricks, but for vlc this is needed as vlc's plugin system
> +    causes LD_PRELOAD to not work on symbols in the plugins
> +  * camorama-0.19-fixes.patch, small bugfixes to camorama's v4l1 support,
> +    this patch only fixes _real_ bugs in camorama and does not change it to
> +    work with v4l1compat. Although it does work better with these bugs fixed
> +     :)  With this patch and LD_PRELOAD=<path>/v4l1compat.so it works
> +    flawless. 
> +
> +
>  libv4l-0.3
>  ----------
>  * add extern "C" magic to public header files for c++ usage (Gregor Jasny)
> diff -r 6169e79de2d2 v4l2-apps/lib/libv4l/apps-patches/camorama-0.19-fixes.patch
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/v4l2-apps/lib/libv4l/apps-patches/camorama-0.19-fixes.patch	Thu Jul 03 13:29:13 2008 +0200
> @@ -0,0 +1,90 @@
> +--- camorama-0.19/src/callbacks.c	2007-09-16 15:36:55.000000000 +0200
> ++++ camorama-0.19.new/src/callbacks.c	2008-06-29 22:22:44.000000000 +0200
> +@@ -387,9 +387,6 @@
> +         }
> +     }
> + 
> +-    cam->pixmap = gdk_pixmap_new (NULL, cam->x, cam->y, cam->desk_depth);
> +-    gtk_widget_set_size_request (glade_xml_get_widget (cam->xml, "da"),
> +-                                 cam->x, cam->y);
> + 
> +     /*
> +      * if(cam->read == FALSE) {
> +@@ -441,6 +438,11 @@
> +      * * } 
> +      */
> +     get_win_info (cam);
> ++
> ++    cam->pixmap = gdk_pixmap_new (NULL, cam->x, cam->y, cam->desk_depth);
> ++    gtk_widget_set_size_request (glade_xml_get_widget (cam->xml, "da"),
> ++                                 cam->x, cam->y);
> ++
> +     frame = 0;
> +     gtk_window_resize (GTK_WINDOW
> +                        (glade_xml_get_widget (cam->xml, "main_window")), 320,
> +@@ -520,8 +522,14 @@
> +     gtk_widget_show (about);
> + }
> + 
> ++void
> ++camorama_filter_color_filter(void* filter, guchar *image, int x, int y, int depth);
> ++
> + static void
> + apply_filters(cam* cam) {
> ++	/* v4l has reverse rgb order from what camora expect so call the color
> ++	   filter to fix things up before running the user selected filters */
> ++	camorama_filter_color_filter(NULL, cam->pic_buf, cam->x, cam->y, cam->depth);
> + 	camorama_filter_chain_apply(cam->filter_chain, cam->pic_buf, cam->x, cam->y, cam->depth);
> + #warning "FIXME: enable the threshold channel filter"
> + //	if((effect_mask & CAMORAMA_FILTER_THRESHOLD_CHANNEL)  != 0) 
> +--- camorama-0.19/src/filter.c	2007-09-16 14:48:50.000000000 +0200
> ++++ camorama-0.19.new/src/filter.c	2008-06-29 22:11:42.000000000 +0200
> +@@ -151,12 +151,12 @@
> + static void
> + camorama_filter_color_init(CamoramaFilterColor* self) {}
> + 
> +-static void
> ++void
> + camorama_filter_color_filter(CamoramaFilterColor* filter, guchar *image, int x, int y, int depth) {
> + 	int i;
> + 	char tmp;
> + 	i = x * y;
> +-	while (--i) {
> ++	while (i--) {
> + 		tmp = image[0];
> + 		image[0] = image[2];
> + 		image[2] = tmp;
> +--- camorama-0.19/src/main.c	2007-09-16 15:36:55.000000000 +0200
> ++++ camorama-0.19.new/src/main.c	2008-06-29 22:20:04.000000000 +0200
> +@@ -224,8 +224,7 @@
> + 
> +     /* get picture attributes */
> +     get_pic_info (cam);
> +-//	set_pic_info(cam);
> +-    /* set_pic_info(cam); */
> ++    set_pic_info (cam);
> +     cam->contrast = cam->vid_pic.contrast;
> +     cam->brightness = cam->vid_pic.brightness;
> +     cam->colour = cam->vid_pic.colour;
> +--- camorama-0.19/src/v4l.c	2007-09-16 14:48:05.000000000 +0200
> ++++ camorama-0.19.new/src/v4l.c	2008-06-29 22:20:23.000000000 +0200
> +@@ -158,8 +158,8 @@
> + 	if(cam->debug) {
> + 		g_message("SET PIC");
> + 	}
> +-	//cam->vid_pic.palette = VIDEO_PALETTE_RGB24;
> +-	//cam->vid_pic.depth = 24;
> ++	cam->vid_pic.palette = VIDEO_PALETTE_RGB24;
> ++	cam->vid_pic.depth = 24;
> + 	//cam->vid_pic.palette = VIDEO_PALETTE_YUV420P;
> + 	if(ioctl(cam->dev, VIDIOCSPICT, &cam->vid_pic) == -1) {
> + 		if(cam->debug) {
> +@@ -232,6 +232,8 @@
> +       exit(0);
> +    }
> + 
> ++   cam->x = cam->vid_win.width;
> ++   cam->y = cam->vid_win.height;
> + }
> + 
> + void set_buffer(cam * cam)
> diff -r 6169e79de2d2 v4l2-apps/lib/libv4l/apps-patches/vlc-0.8.6-libv4l1.patch
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/v4l2-apps/lib/libv4l/apps-patches/vlc-0.8.6-libv4l1.patch	Thu Jul 03 13:29:13 2008 +0200
> @@ -0,0 +1,319 @@
> +diff -up vlc-0.8.6f/modules/access/v4l/Makefile.am~ vlc-0.8.6f/modules/access/v4l/Makefile.am
> +--- vlc-0.8.6f/modules/access/v4l/Makefile.am~	2008-06-29 17:14:11.000000000 +0200
> ++++ vlc-0.8.6f/modules/access/v4l/Makefile.am	2008-06-29 17:16:39.000000000 +0200
> +@@ -100,7 +100,7 @@ libv4l_plugin_la_CXXFLAGS = `$(VLC_CONFI
> + libv4l_plugin_la_OBJCFLAGS = `$(VLC_CONFIG) --objcflags plugin v4l`
> + libv4l_plugin_la_LDFLAGS = `$(VLC_CONFIG) --libs plugin v4l` \
> + 	-rpath '$(libvlcdir)' -avoid-version -module -shrext $(LIBEXT)
> +-libv4l_plugin_la_LIBADD = $(LTLIBVLC)
> ++libv4l_plugin_la_LIBADD = $(LTLIBVLC) -lv4l1
> + 
> + libv4l_a_SOURCES = $(SOURCES_v4l)
> + libv4l_builtin_la_SOURCES = $(SOURCES_v4l)
> +diff -up vlc-0.8.6f/modules/access/v4l/Makefile.in~ vlc-0.8.6f/modules/access/v4l/Makefile.in
> +--- vlc-0.8.6f/modules/access/v4l/Makefile.in~	2008-06-29 17:16:22.000000000 +0200
> ++++ vlc-0.8.6f/modules/access/v4l/Makefile.in	2008-06-29 17:16:42.000000000 +0200
> +@@ -390,7 +390,7 @@ libv4l_plugin_la_OBJCFLAGS = `$(VLC_CONF
> + libv4l_plugin_la_LDFLAGS = `$(VLC_CONFIG) --libs plugin v4l` \
> + 	-rpath '$(libvlcdir)' -avoid-version -module -shrext $(LIBEXT)
> + 
> +-libv4l_plugin_la_LIBADD = $(LTLIBVLC)
> ++libv4l_plugin_la_LIBADD = $(LTLIBVLC) -lv4l1
> + libv4l_a_SOURCES = $(SOURCES_v4l)
> + libv4l_builtin_la_SOURCES = $(SOURCES_v4l)
> + libv4l_a_CFLAGS = `$(VLC_CONFIG) --cflags builtin pic v4l`
> +diff -up vlc-0.8.6f/modules/access/v4l/v4l.c~ vlc-0.8.6f/modules/access/v4l/v4l.c
> +--- vlc-0.8.6f/modules/access/v4l/v4l.c~	2008-06-29 17:13:30.000000000 +0200
> ++++ vlc-0.8.6f/modules/access/v4l/v4l.c	2008-06-29 17:13:30.000000000 +0200
> +@@ -64,6 +64,9 @@
> + 
> + #include <sys/soundcard.h>
> + 
> ++#include <libv4l1.h>
> ++
> ++
> + /*****************************************************************************
> +  * Module descriptior
> +  *****************************************************************************/
> +@@ -546,23 +549,23 @@ static void Close( vlc_object_t *p_this 
> +     if( p_sys->psz_device ) free( p_sys->psz_device );
> +     if( p_sys->psz_vdev )   free( p_sys->psz_vdev );
> +     if( p_sys->psz_adev )   free( p_sys->psz_adev );
> +-    if( p_sys->fd_video >= 0 ) close( p_sys->fd_video );
> ++    if( p_sys->fd_video >= 0 ) v4l1_close( p_sys->fd_video );
> +     if( p_sys->fd_audio >= 0 ) close( p_sys->fd_audio );
> +     if( p_sys->p_block_audio ) block_Release( p_sys->p_block_audio );
> + 
> +     if( p_sys->b_mjpeg )
> +     {
> +         int i_noframe = -1;
> +-        ioctl( p_sys->fd_video, MJPIOC_QBUF_CAPT, &i_noframe );
> ++        v4l1_ioctl( p_sys->fd_video, MJPIOC_QBUF_CAPT, &i_noframe );
> +     }
> + 
> +     if( p_sys->p_video_mmap && p_sys->p_video_mmap != MAP_FAILED )
> +     {
> +         if( p_sys->b_mjpeg )
> +-            munmap( p_sys->p_video_mmap, p_sys->mjpeg_buffers.size *
> ++            v4l1_munmap( p_sys->p_video_mmap, p_sys->mjpeg_buffers.size *
> +                     p_sys->mjpeg_buffers.count );
> +         else
> +-            munmap( p_sys->p_video_mmap, p_sys->vid_mbuf.size );
> ++            v4l1_munmap( p_sys->p_video_mmap, p_sys->vid_mbuf.size );
> +     }
> + 
> +     free( p_sys );
> +@@ -875,13 +878,13 @@ static int OpenVideoDev( demux_t *p_demu
> +     struct mjpeg_params mjpeg;
> +     int i;
> + 
> +-    if( ( i_fd = open( psz_device, O_RDWR ) ) < 0 )
> ++    if( ( i_fd = v4l1_open( psz_device, O_RDWR ) ) < 0 )
> +     {
> +         msg_Err( p_demux, "cannot open device (%s)", strerror( errno ) );
> +         goto vdev_failed;
> +     }
> + 
> +-    if( ioctl( i_fd, VIDIOCGCAP, &p_sys->vid_cap ) < 0 )
> ++    if( v4l1_ioctl( i_fd, VIDIOCGCAP, &p_sys->vid_cap ) < 0 )
> +     {
> +         msg_Err( p_demux, "cannot get capabilities (%s)", strerror( errno ) );
> +         goto vdev_failed;
> +@@ -926,7 +929,7 @@ static int OpenVideoDev( demux_t *p_demu
> +     }
> + 
> +     vid_channel.channel = p_sys->i_channel;
> +-    if( ioctl( i_fd, VIDIOCGCHAN, &vid_channel ) < 0 )
> ++    if( v4l1_ioctl( i_fd, VIDIOCGCHAN, &vid_channel ) < 0 )
> +     {
> +         msg_Err( p_demux, "cannot get channel infos (%s)",
> +                           strerror( errno ) );
> +@@ -944,7 +947,7 @@ static int OpenVideoDev( demux_t *p_demu
> +     }
> + 
> +     vid_channel.norm = p_sys->i_norm;
> +-    if( ioctl( i_fd, VIDIOCSCHAN, &vid_channel ) < 0 )
> ++    if( v4l1_ioctl( i_fd, VIDIOCSCHAN, &vid_channel ) < 0 )
> +     {
> +         msg_Err( p_demux, "cannot set channel (%s)", strerror( errno ) );
> +         goto vdev_failed;
> +@@ -959,7 +962,7 @@ static int OpenVideoDev( demux_t *p_demu
> +         if( p_sys->i_tuner >= 0 )
> +         {
> +             vid_tuner.tuner = p_sys->i_tuner;
> +-            if( ioctl( i_fd, VIDIOCGTUNER, &vid_tuner ) < 0 )
> ++            if( v4l1_ioctl( i_fd, VIDIOCGTUNER, &vid_tuner ) < 0 )
> +             {
> +                 msg_Err( p_demux, "cannot get tuner (%s)", strerror( errno ) );
> +                 goto vdev_failed;
> +@@ -974,7 +977,7 @@ static int OpenVideoDev( demux_t *p_demu
> + 
> +             /* FIXME FIXME to be checked FIXME FIXME */
> +             //vid_tuner.mode = p_sys->i_norm;
> +-            if( ioctl( i_fd, VIDIOCSTUNER, &vid_tuner ) < 0 )
> ++            if( v4l1_ioctl( i_fd, VIDIOCSTUNER, &vid_tuner ) < 0 )
> +             {
> +                 msg_Err( p_demux, "cannot set tuner (%s)", strerror( errno ) );
> +                 goto vdev_failed;
> +@@ -990,7 +993,7 @@ static int OpenVideoDev( demux_t *p_demu
> +         if( p_sys->i_frequency >= 0 )
> +         {
> +             int driver_frequency = p_sys->i_frequency * 16 /1000;
> +-            if( ioctl( i_fd, VIDIOCSFREQ, &driver_frequency ) < 0 )
> ++            if( v4l1_ioctl( i_fd, VIDIOCSFREQ, &driver_frequency ) < 0 )
> +             {
> +                 msg_Err( p_demux, "cannot set frequency (%s)",
> +                                   strerror( errno ) );
> +@@ -1010,7 +1013,7 @@ static int OpenVideoDev( demux_t *p_demu
> +         if( p_sys->i_audio >= 0 )
> +         {
> +             vid_audio.audio = p_sys->i_audio;
> +-            if( ioctl( i_fd, VIDIOCGAUDIO, &vid_audio ) < 0 )
> ++            if( v4l1_ioctl( i_fd, VIDIOCGAUDIO, &vid_audio ) < 0 )
> +             {
> +                 msg_Err( p_demux, "cannot get audio (%s)", strerror( errno ) );
> +                 goto vdev_failed;
> +@@ -1019,7 +1022,7 @@ static int OpenVideoDev( demux_t *p_demu
> +             /* unmute audio */
> +             vid_audio.flags &= ~VIDEO_AUDIO_MUTE;
> + 
> +-            if( ioctl( i_fd, VIDIOCSAUDIO, &vid_audio ) < 0 )
> ++            if( v4l1_ioctl( i_fd, VIDIOCSAUDIO, &vid_audio ) < 0 )
> +             {
> +                 msg_Err( p_demux, "cannot set audio (%s)", strerror( errno ) );
> +                 goto vdev_failed;
> +@@ -1035,7 +1038,7 @@ static int OpenVideoDev( demux_t *p_demu
> +         struct quicktime_mjpeg_app1 *p_app1;
> +         int32_t i_offset;
> + 
> +-        if( ioctl( i_fd, MJPIOC_G_PARAMS, &mjpeg ) < 0 )
> ++        if( v4l1_ioctl( i_fd, MJPIOC_G_PARAMS, &mjpeg ) < 0 )
> +         {
> +             msg_Err( p_demux, "cannot get mjpeg params (%s)",
> +                               strerror( errno ) );
> +@@ -1086,7 +1089,7 @@ static int OpenVideoDev( demux_t *p_demu
> +          * optional.  They will be present in the output. */
> +         mjpeg.jpeg_markers = JPEG_MARKER_DHT | JPEG_MARKER_DQT;
> + 
> +-        if( ioctl( i_fd, MJPIOC_S_PARAMS, &mjpeg ) < 0 )
> ++        if( v4l1_ioctl( i_fd, MJPIOC_S_PARAMS, &mjpeg ) < 0 )
> +         {
> +             msg_Err( p_demux, "cannot set mjpeg params (%s)",
> +                               strerror( errno ) );
> +@@ -1103,7 +1106,7 @@ static int OpenVideoDev( demux_t *p_demu
> +     {
> +         struct video_window vid_win;
> + 
> +-        if( ioctl( i_fd, VIDIOCGWIN, &vid_win ) < 0 )
> ++        if( v4l1_ioctl( i_fd, VIDIOCGWIN, &vid_win ) < 0 )
> +         {
> +             msg_Err( p_demux, "cannot get win (%s)", strerror( errno ) );
> +             goto vdev_failed;
> +@@ -1130,7 +1133,7 @@ static int OpenVideoDev( demux_t *p_demu
> +     if( !p_sys->b_mjpeg )
> +     {
> +         /* set hue/color/.. */
> +-        if( ioctl( i_fd, VIDIOCGPICT, &p_sys->vid_picture ) == 0 )
> ++        if( v4l1_ioctl( i_fd, VIDIOCGPICT, &p_sys->vid_picture ) == 0 )
> +         {
> +             struct video_picture vid_picture = p_sys->vid_picture;
> + 
> +@@ -1150,7 +1153,7 @@ static int OpenVideoDev( demux_t *p_demu
> +             {
> +                 vid_picture.contrast = p_sys->i_contrast;
> +             }
> +-            if( ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
> ++            if( v4l1_ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
> +             {
> +                 msg_Dbg( p_demux, "v4l device uses brightness: %d",
> +                          vid_picture.brightness );
> +@@ -1164,7 +1167,7 @@ static int OpenVideoDev( demux_t *p_demu
> +         }
> + 
> +         /* Find out video format used by device */
> +-        if( ioctl( i_fd, VIDIOCGPICT, &p_sys->vid_picture ) == 0 )
> ++        if( v4l1_ioctl( i_fd, VIDIOCGPICT, &p_sys->vid_picture ) == 0 )
> +         {
> +             struct video_picture vid_picture = p_sys->vid_picture;
> +             char *psz;
> +@@ -1191,7 +1194,7 @@ static int OpenVideoDev( demux_t *p_demu
> +             free( psz );
> + 
> +             if( vid_picture.palette &&
> +-                !ioctl( i_fd, VIDIOCSPICT, &vid_picture ) )
> ++                !v4l1_ioctl( i_fd, VIDIOCSPICT, &vid_picture ) )
> +             {
> +                 p_sys->vid_picture = vid_picture;
> +             }
> +@@ -1199,14 +1202,14 @@ static int OpenVideoDev( demux_t *p_demu
> +             {
> +                 /* Try to set the format to something easy to encode */
> +                 vid_picture.palette = VIDEO_PALETTE_YUV420P;
> +-                if( ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
> ++                if( v4l1_ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
> +                 {
> +                     p_sys->vid_picture = vid_picture;
> +                 }
> +                 else
> +                 {
> +                     vid_picture.palette = VIDEO_PALETTE_YUV422P;
> +-                    if( ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
> ++                    if( v4l1_ioctl( i_fd, VIDIOCSPICT, &vid_picture ) == 0 )
> +                     {
> +                         p_sys->vid_picture = vid_picture;
> +                     }
> +@@ -1237,13 +1240,13 @@ static int OpenVideoDev( demux_t *p_demu
> +         p_sys->mjpeg_buffers.count = 8;
> +         p_sys->mjpeg_buffers.size = MJPEG_BUFFER_SIZE;
> + 
> +-        if( ioctl( i_fd, MJPIOC_REQBUFS, &p_sys->mjpeg_buffers ) < 0 )
> ++        if( v4l1_ioctl( i_fd, MJPIOC_REQBUFS, &p_sys->mjpeg_buffers ) < 0 )
> +         {
> +             msg_Err( p_demux, "mmap unsupported" );
> +             goto vdev_failed;
> +         }
> + 
> +-        p_sys->p_video_mmap = mmap( 0,
> ++        p_sys->p_video_mmap = v4l1_mmap( 0,
> +                 p_sys->mjpeg_buffers.size * p_sys->mjpeg_buffers.count,
> +                 PROT_READ | PROT_WRITE, MAP_SHARED, i_fd, 0 );
> +         if( p_sys->p_video_mmap == MAP_FAILED )
> +@@ -1258,7 +1261,7 @@ static int OpenVideoDev( demux_t *p_demu
> +         /* queue up all the frames */
> +         for( i = 0; i < (int)p_sys->mjpeg_buffers.count; i++ )
> +         {
> +-            if( ioctl( i_fd, MJPIOC_QBUF_CAPT, &i ) < 0 )
> ++            if( v4l1_ioctl( i_fd, MJPIOC_QBUF_CAPT, &i ) < 0 )
> +             {
> +                 msg_Err( p_demux, "unable to queue frame" );
> +                 goto vdev_failed;
> +@@ -1289,13 +1292,13 @@ static int OpenVideoDev( demux_t *p_demu
> +                 (char*)&p_sys->i_fourcc );
> + 
> +         /* Allocate mmap buffer */
> +-        if( ioctl( i_fd, VIDIOCGMBUF, &p_sys->vid_mbuf ) < 0 )
> ++        if( v4l1_ioctl( i_fd, VIDIOCGMBUF, &p_sys->vid_mbuf ) < 0 )
> +         {
> +             msg_Err( p_demux, "mmap unsupported" );
> +             goto vdev_failed;
> +         }
> + 
> +-        p_sys->p_video_mmap = mmap( 0, p_sys->vid_mbuf.size,
> ++        p_sys->p_video_mmap = v4l1_mmap( 0, p_sys->vid_mbuf.size,
> +                                     PROT_READ|PROT_WRITE, MAP_SHARED,
> +                                     i_fd, 0 );
> +         if( p_sys->p_video_mmap == MAP_FAILED )
> +@@ -1310,7 +1313,7 @@ static int OpenVideoDev( demux_t *p_demu
> +         p_sys->vid_mmap.width  = p_sys->i_width;
> +         p_sys->vid_mmap.height = p_sys->i_height;
> +         p_sys->vid_mmap.format = p_sys->vid_picture.palette;
> +-        if( ioctl( i_fd, VIDIOCMCAPTURE, &p_sys->vid_mmap ) < 0 )
> ++        if( v4l1_ioctl( i_fd, VIDIOCMCAPTURE, &p_sys->vid_mmap ) < 0 )
> +         {
> +             msg_Warn( p_demux, "%4.4s refused", (char*)&p_sys->i_fourcc );
> +             msg_Err( p_demux, "chroma selection failed" );
> +@@ -1321,7 +1324,7 @@ static int OpenVideoDev( demux_t *p_demu
> + 
> + vdev_failed:
> + 
> +-    if( i_fd >= 0 ) close( i_fd );
> ++    if( i_fd >= 0 ) v4l1_close( i_fd );
> +     return -1;
> + }
> + 
> +@@ -1431,7 +1434,7 @@ static uint8_t *GrabCapture( demux_t *p_
> + 
> +     p_sys->vid_mmap.frame = (p_sys->i_frame_pos + 1) % p_sys->vid_mbuf.frames;
> + 
> +-    while( ioctl( p_sys->fd_video, VIDIOCMCAPTURE, &p_sys->vid_mmap ) < 0 )
> ++    while( v4l1_ioctl( p_sys->fd_video, VIDIOCMCAPTURE, &p_sys->vid_mmap ) < 0 )
> +     {
> +         if( errno != EAGAIN )
> +         {
> +@@ -1447,7 +1450,7 @@ static uint8_t *GrabCapture( demux_t *p_
> +         msg_Dbg( p_demux, "grab failed, trying again" );
> +     }
> + 
> +-    while( ioctl(p_sys->fd_video, VIDIOCSYNC, &p_sys->i_frame_pos) < 0 )
> ++    while( v4l1_ioctl(p_sys->fd_video, VIDIOCSYNC, &p_sys->i_frame_pos) < 0 )
> +     {
> +         if( errno != EAGAIN && errno != EINTR )    
> +         {
> +@@ -1473,7 +1476,7 @@ static uint8_t *GrabMJPEG( demux_t *p_de
> +     /* re-queue the last frame we sync'd */
> +     if( p_sys->i_frame_pos != -1 )
> +     {
> +-        while( ioctl( p_sys->fd_video, MJPIOC_QBUF_CAPT,
> ++        while( v4l1_ioctl( p_sys->fd_video, MJPIOC_QBUF_CAPT,
> +                                        &p_sys->i_frame_pos ) < 0 )
> +         {
> +             if( errno != EAGAIN && errno != EINTR )
> +@@ -1485,7 +1488,7 @@ static uint8_t *GrabMJPEG( demux_t *p_de
> +     }
> + 
> +     /* sync on the next frame */
> +-    while( ioctl( p_sys->fd_video, MJPIOC_SYNC, &sync ) < 0 )
> ++    while( v4l1_ioctl( p_sys->fd_video, MJPIOC_SYNC, &sync ) < 0 )
> +     {
> +         if( errno != EAGAIN && errno != EINTR )    
> +         {
> diff -r 6169e79de2d2 v4l2-apps/lib/libv4l/libv4l1/libv4l1.c
> --- a/v4l2-apps/lib/libv4l/libv4l1/libv4l1.c	Tue Jul 01 21:18:23 2008 +0200
> +++ b/v4l2-apps/lib/libv4l/libv4l1/libv4l1.c	Thu Jul 03 13:29:13 2008 +0200
> @@ -532,6 +532,8 @@
>  					   V4L2_CID_WHITENESS);
>  	pic->brightness = v4l2_get_control(devices[index].fd,
>  					   V4L2_CID_BRIGHTNESS);
> +
> +        result = 0;
>        }
>        break;
>  
> diff -r 6169e79de2d2 v4l2-apps/lib/libv4l/libv4l2/libv4l2.c
> --- a/v4l2-apps/lib/libv4l/libv4l2/libv4l2.c	Tue Jul 01 21:18:23 2008 +0200
> +++ b/v4l2-apps/lib/libv4l/libv4l2/libv4l2.c	Thu Jul 03 13:29:13 2008 +0200
> @@ -527,31 +527,13 @@
>    return fd;
>  }
>  
> -static int v4l2_buf_ioctl_pre_check(int index, unsigned long int request,
> -  struct v4l2_buffer *buf, int *result)
> -{
> -  if (buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -    *result = syscall(SYS_ioctl, devices[index].fd, request, buf);
> -    return 1;
> -  }
> -
> -  /* IMPROVEME (maybe?) add support for userptr's? */
> -  if (devices[index].io != v4l2_io_mmap ||
> -      buf->memory != V4L2_MEMORY_MMAP ||
> -      buf->index  >= devices[index].no_frames) {
> -    errno = EINVAL;
> -    *result = -1;
> -    return 1;
> -  }
> -
> -  return 0;
> -}
>  
>  int v4l2_ioctl (int fd, unsigned long int request, ...)
>  {
>    void *arg;
>    va_list ap;
> -  int result, converting, index, saved_err, stream_locked = 0;
> +  int result, converting, index, saved_err;
> +  int is_capture_request = 0, stream_needs_locking = 0;
>  
>    va_start (ap, request);
>    arg = va_arg (ap, void *);
> @@ -560,19 +542,52 @@
>    if ((index = v4l2_get_index(fd)) == -1)
>      return syscall(SYS_ioctl, fd, request, arg);
>  
> -  /* do we need to take the stream lock for this ioctl? */
> +  /* Is this a capture request and do we need to take the stream lock? */
>    switch (request) {
> +    case VIDIOC_ENUM_FMT:
> +      if (((struct v4l2_fmtdesc *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	is_capture_request = 1;
> +      break;
> +    case VIDIOC_TRY_FMT:
> +      if (((struct v4l2_format *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	is_capture_request = 1;
> +      break;
>      case VIDIOC_S_FMT:
>      case VIDIOC_G_FMT:
> -    case VIDIOC_REQBUFS:
> +      if (((struct v4l2_format *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +	is_capture_request = 1;
> +	stream_needs_locking = 1;
> +      }
> +      break;
> +    case VIDIOC_REQBUFS: 
> +      if (((struct v4l2_requestbuffers *)arg)->type == 
> +	  V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +	is_capture_request = 1;
> +	stream_needs_locking = 1;
> +      }
> +      break;
>      case VIDIOC_QUERYBUF:
>      case VIDIOC_QBUF:
>      case VIDIOC_DQBUF:
> +      if (((struct v4l2_buffer *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +	is_capture_request = 1;
> +	stream_needs_locking = 1;
> +      }
> +      break;
>      case VIDIOC_STREAMON:
>      case VIDIOC_STREAMOFF:
> -      pthread_mutex_lock(&devices[index].stream_lock);
> -      stream_locked = 1;
> +      if (*((enum v4l2_buf_type *)arg) == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +	is_capture_request = 1;
> +	stream_needs_locking = 1;
> +      }
>    }
> +
> +  if (!is_capture_request)
> +    return syscall(SYS_ioctl, fd, request, arg);
> +
> +
> +  if (stream_needs_locking)
> +    pthread_mutex_lock(&devices[index].stream_lock);
>  
>    converting = devices[index].src_fmt.fmt.pix.pixelformat !=
>  	       devices[index].dest_fmt.fmt.pix.pixelformat;
> @@ -580,40 +595,16 @@
>  
>    switch (request) {
>      case VIDIOC_ENUM_FMT:
> -      {
> -	struct v4l2_fmtdesc *fmtdesc = arg;
> -
> -	if (fmtdesc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> -	    !(devices[index].flags & V4L2_ENABLE_ENUM_FMT_EMULATION))
> -	  result = syscall(SYS_ioctl, devices[index].fd, request, arg);
> -	else
> -	  result = v4lconvert_enum_fmt(devices[index].convert, fmtdesc);
> -      }
> +      result = v4lconvert_enum_fmt(devices[index].convert, arg);
>        break;
>  
>      case VIDIOC_TRY_FMT:
> -      {
> -	struct v4l2_format *fmt = arg;
> -
> -	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> -	    (devices[index].flags & V4L2_DISABLE_CONVERSION)) {
> -	  result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_TRY_FMT, fmt);
> -	  break;
> -	}
> -
> -	result = v4lconvert_try_format(devices[index].convert, fmt, NULL);
> -      }
> +      result = v4lconvert_try_format(devices[index].convert, arg, NULL);
>        break;
>  
>      case VIDIOC_S_FMT:
>        {
>  	struct v4l2_format src_fmt, *dest_fmt = arg;
> -
> -	if (dest_fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -	  result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_S_FMT,
> -			   dest_fmt);
> -	  break;
> -	}
>  
>  	if (!memcmp(&devices[index].dest_fmt, dest_fmt, sizeof(*dest_fmt))) {
>  	  result = 0;
> @@ -658,7 +649,7 @@
>  	    if (v4l2_activate_read_stream(index))
>  	      V4L2_LOG_ERR(
>  		"reactivating stream after deactivate failure (AAIIEEEE)\n");
> -	    return result;
> +	    break;
>  	  }
>  	}
>  
> @@ -681,11 +672,6 @@
>        {
>  	struct v4l2_format* fmt = arg;
>  
> -	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -	  result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_G_FMT, fmt);
> -	  break;
> -	}
> -
>  	*fmt = devices[index].dest_fmt;
>  	result = 0;
>        }
> @@ -694,11 +680,6 @@
>      case VIDIOC_REQBUFS:
>        {
>  	struct v4l2_requestbuffers *req = arg;
> -
> -	if (req->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -	  result = syscall(SYS_ioctl, devices[index].fd, request, arg);
> -	  return 1;
> -	}
>  
>  	/* Don't allow mixing read / mmap io, either we control the buffers
>  	   (read based io), or the app does */
> @@ -753,9 +734,6 @@
>        {
>  	struct v4l2_buffer *buf = arg;
>  
> -	if (v4l2_buf_ioctl_pre_check(index, request, buf, &result))
> -	  break;
> -
>  	/* Do a real query even when converting to let the driver fill in
>  	   things like buf->field */
>  	result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_QUERYBUF, buf);
> @@ -768,22 +746,12 @@
>        break;
>  
>      case VIDIOC_QBUF:
> -      {
> -	struct v4l2_buffer *buf = arg;
> -
> -	if (v4l2_buf_ioctl_pre_check(index, request, buf, &result))
> -	  break;
> -
> -	result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_QBUF, buf);
> -      }
> +      result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_QBUF, arg);
>        break;
>  
>      case VIDIOC_DQBUF:
>        {
>  	struct v4l2_buffer *buf = arg;
> -
> -	if (v4l2_buf_ioctl_pre_check(index, request, buf, &result))
> -	  break;
>  
>  	result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_DQBUF, buf);
>  	if (result || !converting)
> @@ -832,32 +800,23 @@
>  
>      case VIDIOC_STREAMON:
>      case VIDIOC_STREAMOFF:
> -      {
> -	enum v4l2_buf_type *type = arg;
> +      if (devices[index].io != v4l2_io_mmap) {
> +	errno = EINVAL;
> +	result = -1;
> +	break;
> +      }
>  
> -	if (*type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -	  result = syscall(SYS_ioctl, devices[index].fd, request, type);
> -	  break;
> -	}
> -
> -	if (devices[index].io != v4l2_io_mmap) {
> -	  errno = EINVAL;
> -	  result = -1;
> -	  break;
> -	}
> -
> -	if (request == VIDIOC_STREAMON)
> -	  result = v4l2_streamon(index);
> -	else
> -	  result = v4l2_streamoff(index);
> -      }
> +      if (request == VIDIOC_STREAMON)
> +	result = v4l2_streamon(index);
> +      else
> +	result = v4l2_streamoff(index);
>        break;
>  
>      default:
>        result = syscall(SYS_ioctl, fd, request, arg);
>    }
>  
> -  if (stream_locked)
> +  if (stream_needs_locking)
>      pthread_mutex_unlock(&devices[index].stream_lock);
>  
>    saved_err = errno;
>   
Applied on http://www.linuxtv.org/hg/~tmerle/v4l2-library
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
