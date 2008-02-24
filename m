Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp8-g19.free.fr ([212.27.42.65])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <forum.lists@free.fr>) id 1JTPC2-0006EZ-2q
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 23:19:34 +0100
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 5E09917F509
	for <linux-dvb@linuxtv.org>; Sun, 24 Feb 2008 23:19:30 +0100 (CET)
Received: from [192.168.1.3] (pat35-1-82-231-149-41.fbx.proxad.net
	[82.231.149.41])
	by smtp8-g19.free.fr (Postfix) with ESMTP id C2C1B17F552
	for <linux-dvb@linuxtv.org>; Sun, 24 Feb 2008 23:19:29 +0100 (CET)
Message-ID: <47C1EC84.2040907@free.fr>
Date: Sun, 24 Feb 2008 23:15:32 +0100
From: Bertrand <forum.lists@free.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Pinnacle Dual DVB-T diversity and Mplayer/Xine
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello
I recently bought a Pinnacle Dual DVB-T diversity USB stick (ref: 2000e)
After having compiled and installed v4l-dvb and dvb-usb-dib0700-1.10.fw,
everything worked well with VLC and Kaffeine
But, I had no such luck with Mplayer and Xine.
I copied the channels.conf in .xine and .mplayer.

---------------------------------------------------------------------------=
----------------------------------------------------------
Doing xine --verbose=3D2 dvb://NT1 returns:

Voici xine (X11 gui) - un lecteur vid=E9o libre v0.99.5.
(c) 2000-2007 L'Equipe de xine.
G=E9n=E9r=E9 avec la biblioth=E8que xine 1.1.6 (1.1.6).
Version de la biblioth=E8que de xine trouv=E9e : 1.1.8 (1.1.8).
   Plateform informations:
   ----------------------
        system name     : Linux
        node name       : localhost
        release         : 2.6.22.12-1mdvcustom
        version         : #1 SMP Sat Dec 29 10:58:01 CET 2007
        machine         : i686
   CPU Informations:
   ----------------
        processor       : 0
        vendor_id       : GenuineIntel
        cpu family      : 6
        model           : 15
        model name      : Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz
        stepping        : 13
        cpu MHz         : 2001.000
        cache size      : 2048 KB
        physical id     : 0
        siblings        : 2
        core id         : 0
        cpu cores       : 2
        fdiv_bug        : no
        hlt_bug         : no
        f00f_bug        : no
        coma_bug        : no
        fpu             : yes
        fpu_exception   : yes
        cpuid level     : 10
        wp              : yes
        flags           : fpu vme de pse tsc msr pae mce cx8 apic sep
mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
pbe nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr
lahf_lm
        bogomips        : 3995.82
        clflush size    : 64
        processor       : 1
        vendor_id       : GenuineIntel
        cpu family      : 6
        model           : 15
        model name      : Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz
        stepping        : 13
        cpu MHz         : 2001.000
        cache size      : 2048 KB
        physical id     : 0
        siblings        : 2
        core id         : 1
        cpu cores       : 2
        fdiv_bug        : no
        hlt_bug         : no
        f00f_bug        : no
        coma_bug        : no
        fpu             : yes
        fpu_exception   : yes
        cpuid level     : 10
        wp              : yes
        flags           : fpu vme de pse tsc msr pae mce cx8 apic sep
mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
pbe nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr
lahf_lm
        bogomips        : 3990.45
        clflush size    : 64
   -------
   Display Name:          :0.0,
   XServer Vendor:        The X.Org Foundation,
   Protocol Version:      11, Revision: 0,
   Available Screen(s):   1,
   Default screen number: 0,
   Using screen:          0,
   Depth:                 24,
   Maximum request size:  16777212 bytes,
   Motion buffer size:    256,
   Bitmap unit:           32,
     Bit order:           LSBFirst,
     Padding:             32,
   Image byte order:      LSBFirst,
   Number of supported pixmap formats: 7,
   Supported pixmap formats:
     Depth        Bits_per_pixel        Scanline_pad
         1                     1                  32
         4                     8                  32
         8                     8                  32
        15                    16                  32
        16                    16                  32
        24                    32                  32
        32                    32                  32
     -----------------------------------------------

   Focus:                  Window 0x4800067, revert to PointerRoot,
   Number of extensions:   33
     BIG-REQUESTS:                 [opcode: 132]
     Composite:                    [opcode: 159]
     DAMAGE:                       [opcode: 160, base (event: 121,
error: 186)]
     DOUBLE-BUFFER:                [opcode: 128, base (error: 128)]
     DPMS:                         [opcode: 139]
     Extended-Visual-Information:  [opcode: 141]
     GLX:                          [opcode: 144, base (event: 79, error:
155)]
     MIT-SCREEN-SAVER:             [opcode: 134, base (event: 69)]
     MIT-SHM:                      [opcode: 147, base (event: 98, error:
167)]
     MIT-SUNDRY-NONSTANDARD:       [opcode: 131]
     Multi-Buffering:              [opcode: 130, base (event: 65, error:
129)]
     NV-CONTROL:                   [opcode: 146, base (event: 96)]
     NV-GLX:                       [opcode: 145]
     RANDR:                        [opcode: 157, base (event: 119,
error: 183)]
     RENDER:                       [opcode: 156, base (error: 178)]
     SECURITY:                     [opcode: 153, base (event: 116,
error: 175)]
     SHAPE:                        [opcode: 129, base (event: 64)]
     SYNC:                         [opcode: 133, base (event: 67, error:
130)]
     TOG-CUP:                      [opcode: 140]
     X-Resource:                   [opcode: 143]
     XAccessControlExtension:      [opcode: 152]
     XC-APPGROUP:                  [opcode: 151, base (error: 174)]
     XC-MISC:                      [opcode: 135]
     XFIXES:                       [opcode: 154, base (event: 117,
error: 177)]
     XFree86-Bigfont:              [opcode: 155]
     XFree86-DGA:                  [opcode: 138, base (event: 70, error:
147)]
     XFree86-Misc:                 [opcode: 137, base (error: 139)]
     XFree86-VidModeExtension:     [opcode: 136, base (error: 132)]
     XINERAMA:                     [opcode: 158]
     XInputExtension:              [opcode: 148, base (event: 99, error:
168)]
     XKEYBOARD:                    [opcode: 150, base (event: 115,
error: 173)]
     XTEST:                        [opcode: 149]
     XVideo:                       [opcode: 142, base (event: 77, error:
152)]
   Dimensions:             1440x900 pixels (373x231 millimeters).
   Resolution:             98x99 dots per inch.
   Depths (7):             24, 1, 4, 8, 15, 16, 32
   Root window id:         0x13a
   Depth of root window:   24 planes
   Number of colormaps:    min 1, max 1
   Default colormap:       0x20
   Default number of colormap cells:   256
   Preallocated pixels:    black 0, white 16777215
   Options:                backing-store no, save-unders no
   Largest cursor:         64x64
-[ xiTK version 0.10.7 [XFT] ]-[ WM type: (EWMH) KWIN {KWin} ]-
load_plugins: skipping unreadable plugin directory /home/user/.xine/plugins.
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_vo_out_xshm.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_vo_out_xshm.so
found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_goom.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_audio_filters.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_audio_filters.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_audio_filters.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_audio_filters.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_switch.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_visualizations.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_visualizations.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_visualizations.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_mosaico.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_planar.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_planar.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_planar.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_planar.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_planar.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_planar.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_planar.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_planar.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_planar.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_planar.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/post/xineplug_post_tvtime.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_mpeg_ts.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_qt.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_vo_out_xvmc.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_games.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_games.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_games.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_games.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_games.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_games.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_games.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_games.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_games.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_games.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_games.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_vo_out_xxmc.so
found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_w32dll.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_w32dll.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_a52.so
found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_bitplane.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_ao_out_none.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_mpeg.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_speex.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_dmx_matroska.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_ao_out_alsa.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_dts.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_asf.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_avi.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_dmx_mpeg_elem.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_sputext.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_real.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_real.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_fli.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_flv.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_audio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_dvb.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_dvd.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_spucmml.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_iff.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_mad.so
found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_vo_out_vidix.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_vo_out_vidix.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_mpc.so
found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_dmx_mpeg_pes.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_nsf.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_rtsp.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_dvaudio.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_mng.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_inp_stdin_fifo.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_rgb.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_ogg.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_ogg.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_nsv.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_spucc.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_mms.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_spudvb.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_net.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_spu.so
found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_gsm610.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_pva.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_file.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_pnm.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_v4l.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_v4l.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_pvr.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_rtp.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_vo_out_none.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_yuv.so
found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_mpeg2.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_vcd.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_lpcm.so
found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_gdk_pixbuf.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_vo_out_xcbxv.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_ff.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_ff.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_ff.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_ff.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_qt.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_decode_qt.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_sputext.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_real.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_dmx_yuv4mpeg2.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_ao_out_oss.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_slave.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_vo_out_syncfb.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_image.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_dmx_yuv_frames.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_dmx_rawdv.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_ao_out_file.so
found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_vo_out_fb.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_vo_out_xcbshm.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_http.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_vo_out_xv.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_vo_out_xv.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_theora.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_vo_out_opengl.so found
load_plugins: plugin /usr/lib/xine/plugins/1.1.8/xineplug_inp_cdda.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_decode_vorbis.so found
load_plugins: plugin
/usr/lib/xine/plugins/1.1.8/xineplug_dmx_mpeg_block.so found
init class succeeded
main : d=E9tection du plugin de sortie vid=E9o <xv>
video_out_xv: using Xv port 281 from adaptor NV17 Video Texture for
hardware colorspace conversion and scaling.
video_out_xv: port attribute XV_BRIGHTNESS (5) value is 0
video_out_xv: port attribute XV_CONTRAST (4) value is 4096
video_out_xv: port attribute XV_SATURATION (3) value is 4096
video_out_xv: ignoring broken XV_HUE settings on NVidia cards
video_out_xv: this adaptor supports the yuy2 format.
video_out_xv: this adaptor supports the yv12 format.
x11osd: unscaled overlay created (XShape mode).
video_out: thread created
main : d=E9tection du plugin de sortie audio <alsa>
audio_alsa_out : supported modes are 8bit 16bit 24bit 32bit mono stereo
(4-channel not enabled in xine config) (4.1-channel not enabled in xine
config) (5-channel not enabled in xine config) (5.1-channel not enabled
in xine config) (a/52 and DTS pass-through not enabled in xine config)
audio_out: thread created
xine_stream_new
video_out: thread created
audio_out: thread created
xine_interface: unknown or deprecated stream param 10 set
xine_stream_new
xine_interface: unknown or deprecated stream param 10 set
xine_stream_new
xine_interface: unknown or deprecated stream param 10 set
video_out_xv: VO_PROP_ASPECT_RATIO(0)
gui_xine_open_and_play():
        mrl: 'dvb://NT1',
        sub 'NONE',
        start_pos 0, start_time 0, av_offset 0, spu_offset 0.
input_dvb: continuing in get_instance
xine: found input plugin  : DVB (Digital TV) input plugin
input_dvb: Frontend is <DiBcom 7000PC> TER Card
input_dvb: Card has no hardware decoder
input_dvb: found 20 channels...
input_dvb: searching for channel NT1
input_dvb: media.dvb.tuning_timeout is 7
input_dvb: tuner_tune_it - waiting for lock...
input_dvb: status: a
Trying to get lock...input_dvb: status: a
Trying to get lock...input_dvb: status: a
Trying to get lock...input_dvb: status: a
Trying to get lock...input_dvb: status: 1a
input_dvb: Tuner status:   FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_SYNC
input_dvb: Bit error rate: 2097151
input_dvb: Signal strength: 60443
input_dvb: Signal/Noise Ratio: 0
input_dvb: Lock achieved at 626000000 Hz
input_dvb: Setting up Internal PAT filter
input_dvb: Error setting up Internal PAT filter - reverting to rc6 hehaviour
video_out_xv: VO_PROP_ZOOM_X =3D 100
video_out_xv: VO_PROP_ZOOM_Y =3D 100
load_plugins: probing demux 'anx'
load_plugins: probing demux 'image'
load_plugins: probing demux 'wve'
load_plugins: probing demux 'idcin'
load_plugins: probing demux 'ipmovie'
load_plugins: probing demux 'vqa'
load_plugins: probing demux 'wc3movie'
load_plugins: probing demux 'roq'
input not seekable, can not handle!
load_plugins: probing demux 'str'
input not seekable, can not handle!
load_plugins: probing demux 'film'
load_plugins: probing demux 'smjpeg'
input not seekable, can not handle!
load_plugins: probing demux 'fourxm'
load_plugins: probing demux 'vmd'
load_plugins: probing demux 'quicktime'
load_plugins: probing demux 'matroska'
load_plugins: probing demux 'asf'
load_plugins: probing demux 'avi'
load_plugins: probing demux 'fli'
load_plugins: probing demux 'flashvideo'
load_plugins: probing demux 'aud'
load_plugins: probing demux 'aiff'
load_plugins: probing demux 'flac'
input not seekable, can not handle!
load_plugins: probing demux 'nsf'
input not seekable, can not handle!
load_plugins: probing demux 'realaudio'
load_plugins: probing demux 'snd'
load_plugins: probing demux 'tta'
load_plugins: probing demux 'voc'
load_plugins: probing demux 'vox'
load_plugins: probing demux 'mod'
input not seekable, can not handle!
load_plugins: probing demux 'iff'
load_plugins: probing demux 'mpeg_pes'
load_plugins: probing demux 'mng'
load_plugins: probing demux 'ogg'
load_plugins: probing demux 'nsv'
load_plugins: probing demux 'pva'
input not seekable, can not handle!
load_plugins: probing demux 'real'
load_plugins: probing demux 'yuv4mpeg2'
load_plugins: probing demux 'slave'
load_plugins: probing demux 'mpeg_block'
load_plugins: probing demux 'mpeg-ts'
load_plugins: probing demux 'mpeg'
load_plugins: probing demux 'ac3'
load_plugins: probing demux 'dts'
load_plugins: probing demux 'cdda'
load_plugins: probing demux 'wav'
load_plugins: probing demux 'rawdv'
load_plugins: probing demux 'mpc'
load_plugins: probing demux 'mp3'
load_plugins: probing demux 'shn'
load_plugins: probing demux 'sputext'
load_plugins: probing demux 'yuv_frames'
load_plugins: probing demux 'elem'
load_plugins: probing demux 'aac'
load_plugins: probing demux 'anx'
load_plugins: probing demux 'image'
load_plugins: probing demux 'wve'
load_plugins: probing demux 'idcin'
load_plugins: probing demux 'ipmovie'
load_plugins: probing demux 'vqa'
load_plugins: probing demux 'wc3movie'
load_plugins: probing demux 'roq'
input not seekable, can not handle!
load_plugins: probing demux 'str'
input not seekable, can not handle!
load_plugins: probing demux 'film'
load_plugins: probing demux 'smjpeg'
input not seekable, can not handle!
load_plugins: probing demux 'fourxm'
load_plugins: probing demux 'vmd'
load_plugins: probing demux 'quicktime'
load_plugins: probing demux 'matroska'
load_plugins: probing demux 'asf'
load_plugins: probing demux 'avi'
load_plugins: probing demux 'fli'
load_plugins: probing demux 'flashvideo'
load_plugins: probing demux 'aud'
load_plugins: probing demux 'aiff'
load_plugins: probing demux 'flac'
input not seekable, can not handle!
load_plugins: probing demux 'nsf'
input not seekable, can not handle!
load_plugins: probing demux 'realaudio'
load_plugins: probing demux 'snd'
load_plugins: probing demux 'tta'
load_plugins: probing demux 'voc'
load_plugins: probing demux 'vox'
load_plugins: probing demux 'mod'
input not seekable, can not handle!
load_plugins: probing demux 'iff'
load_plugins: probing demux 'mpeg_pes'
load_plugins: probing demux 'mng'
load_plugins: probing demux 'ogg'
load_plugins: probing demux 'nsv'
load_plugins: probing demux 'pva'
input not seekable, can not handle!
load_plugins: probing demux 'real'
load_plugins: probing demux 'yuv4mpeg2'
load_plugins: probing demux 'slave'
load_plugins: probing demux 'mpeg_block'
load_plugins: probing demux 'mpeg-ts'
xine: found demuxer plugin: MPEG Transport Stream demuxer

net_buf_ctrl: nbc_put_cb: starts buffering

net_buf_ctrl: nbc_set_speed_pause
set_speed 0
video discontinuity #1, type is 0, disc_off 0
waiting for audio discontinuity #1
audio discontinuity #1, type is 0, disc_off 0
waiting for in_discontinuity update #1
vpts adjusted with prebuffer to 1181896
seek 0 bytes, origin 0
av_offset=3D0 pts
spu_offset=3D0 pts
xine_play
got event 00000008
play_internal ...done
input_dvb:  No data available.  Signal Lost??

net_buf_ctrl: nbc_put_cb: stops buffering

net_buf_ctrl: nbc_set_speed_normal
set_speed 1000000
demux_ts: read 0 packets
gui_xine_open_and_play():
        mrl: 'file:/usr/share/xine/skins/xine-ui_logo.mpv',
        sub 'NONE',
        start_pos 0, start_time 0, av_offset 0, spu_offset 0.
input_cache: read calls: 1, main input read calls: 1
input_cache: seek_calls: 1, main input seek calls: 1

net_buf_ctrl: nbc_close

net_buf_ctrl: nbc_close: done
xine: found input plugin  : file input plugin
load_plugins: probing demux 'anx'
load_plugins: probing demux 'image'
load_plugins: probing demux 'wve'
load_plugins: probing demux 'idcin'
load_plugins: probing demux 'ipmovie'
load_plugins: probing demux 'vqa'
load_plugins: probing demux 'wc3movie'
load_plugins: probing demux 'roq'
load_plugins: probing demux 'str'
load_plugins: probing demux 'film'
load_plugins: probing demux 'smjpeg'
load_plugins: probing demux 'fourxm'
load_plugins: probing demux 'vmd'
load_plugins: probing demux 'quicktime'
load_plugins: probing demux 'matroska'
ebml: invalid EBML ID size (0x0) at position 1
ebml: invalid master element
load_plugins: probing demux 'asf'
load_plugins: probing demux 'avi'
load_plugins: probing demux 'fli'
load_plugins: probing demux 'flashvideo'
load_plugins: probing demux 'aud'
load_plugins: probing demux 'aiff'
load_plugins: probing demux 'flac'
load_plugins: probing demux 'nsf'
load_plugins: probing demux 'realaudio'
load_plugins: probing demux 'snd'
load_plugins: probing demux 'tta'
load_plugins: probing demux 'voc'
load_plugins: probing demux 'vox'
load_plugins: probing demux 'mod'
TEST mod decode
load_plugins: probing demux 'iff'
load_plugins: probing demux 'mpeg_pes'
load_plugins: probing demux 'mng'
load_plugins: probing demux 'ogg'
load_plugins: probing demux 'nsv'
load_plugins: probing demux 'pva'
load_plugins: probing demux 'real'
load_plugins: probing demux 'yuv4mpeg2'
load_plugins: probing demux 'slave'
load_plugins: probing demux 'mpeg_block'
load_plugins: probing demux 'mpeg-ts'
load_plugins: probing demux 'mpeg'
load_plugins: probing demux 'ac3'
load_plugins: probing demux 'dts'
load_plugins: probing demux 'cdda'
load_plugins: probing demux 'wav'
load_plugins: probing demux 'rawdv'
load_plugins: probing demux 'mpc'
load_plugins: probing demux 'mp3'
load_plugins: probing demux 'shn'
load_plugins: probing demux 'sputext'
load_plugins: probing demux 'yuv_frames'
load_plugins: probing demux 'elem'
xine: found demuxer plugin: Elementary MPEG stream demux plugin
load_plugins: plugin mpeg2 will be used for video streamtype 00.
av_offset=3D0 pts
spu_offset=3D0 pts
xine_play
AFD changed from -2 to -1
play_internal ...done
video_out: throwing away image with pts 1184896 because it's too old
(diff : 134841).
video_out: throwing away image with pts 1187896 because it's too old
(diff : 131841).
video_out: throwing away image with pts 1190896 because it's too old
(diff : 128841).
video_out: throwing away image with pts 1193896 because it's too old
(diff : 126507).
video_out: throwing away image with pts 1196896 because it's too old
(diff : 123507).

---------------------------------------------------------------------------=
----------------------------------------------------------
Doing mplayer -v dvb://NT1 gives the following:

MPlayer 1.0-1.rc1.20.2plf2008.0-4.2.2 (C) 2000-2006 MPlayer Team
CPU: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz (Family: 6, Model:
15, Stepping: 13)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
get_path('codecs.conf') -> '/home/user/.mplayer/codecs.conf'
Reading /home/user/.mplayer/codecs.conf: Can't open
'/home/user/.mplayer/codecs.conf': No such file or directory
Reading /etc/mplayer/codecs.conf: 98 audio & 216 video codecs
CommandLine: '-v' 'dvb://NT1'
init_freetype
Using MMX (with tiny bit MMX2) Optimized OnScreenDisplay
Using nanosleep() timing
get_path('input.conf') -> '/home/user/.mplayer/input.conf'
Can't open input config file /home/user/.mplayer/input.conf: No such
file or directory
Parsing input config file /etc/mplayer/input.conf
Input config file /etc/mplayer/input.conf parsed: 67 binds
Setting up LIRC support...
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.
get_path('NT1.conf') -> '/home/user/.mplayer/NT1.conf'

Playing dvb://NT1.
get_path('sub/') -> '/home/user/.mplayer/sub/'
TUNER TYPE SEEMS TO BE DVB-T
get_path('channels.conf.ter') -> '/home/user/.mplayer/channels.conf.ter'
get_path('channels.conf') -> '/home/user/.mplayer/channels.conf'
CONFIG_READ FILE: /home/user/.mplayer/channels.conf, type: 2
TER, NUM: 0, NUM_FIELDS: 11, NAME: TF1, FREQ: 562000000 PIDS:  120  130  0
TER, NUM: 1, NUM_FIELDS: 11, NAME: NRJ12, FREQ: 562000000 PIDS:  220  230  0
TER, NUM: 2, NUM_FIELDS: 11, NAME: TMC, FREQ: 562000000 PIDS:  620  630  0
TER, NUM: 3, NUM_FIELDS: 11, NAME: France 2, FREQ: 586000000 PIDS:  120
130  0
TER, NUM: 4, NUM_FIELDS: 11, NAME: France 5, FREQ: 586000000 PIDS:  320
330  0
TER, NUM: 5, NUM_FIELDS: 11, NAME: ARTE, FREQ: 586000000 PIDS:  520  530  0
TER, NUM: 6, NUM_FIELDS: 11, NAME: LCP, FREQ: 586000000 PIDS:  620  630  0
TER, NUM: 7, NUM_FIELDS: 11, NAME: France 3, FREQ: 586000000 PIDS:  220
230  0
TER, NUM: 8, NUM_FIELDS: 11, NAME: TV Rennes 35, FREQ: 586000000 PIDS:
720  730  0
TER, NUM: 9, NUM_FIELDS: 11, NAME: CANAL+, FREQ: 650000000 PIDS:  0  80  0
TER, NUM: 10, NUM_FIELDS: 11, NAME: TPS STAR, FREQ: 650000000 PIDS:  0
100  0
TER, NUM: 11, NUM_FIELDS: 11, NAME: Direct 8, FREQ: 674000000 PIDS:
160  80  0
TER, NUM: 12, NUM_FIELDS: 11, NAME: France 4, FREQ: 674000000 PIDS:
166  104  0
TER, NUM: 13, NUM_FIELDS: 11, NAME: Gulli, FREQ: 674000000 PIDS:  165
100  0
TER, NUM: 14, NUM_FIELDS: 11, NAME: Europe 2 TV, FREQ: 674000000 PIDS:
164  96  0
TER, NUM: 15, NUM_FIELDS: 11, NAME: i>TELE, FREQ: 674000000 PIDS:  163
92  0
TER, NUM: 16, NUM_FIELDS: 11, NAME: BFM TV, FREQ: 674000000 PIDS:  162
88  0
TER, NUM: 17, NUM_FIELDS: 11, NAME: M6, FREQ: 626000000 PIDS:  120  130  0
TER, NUM: 18, NUM_FIELDS: 11, NAME: W9, FREQ: 626000000 PIDS:  220  230  0
TER, NUM: 19, NUM_FIELDS: 11, NAME: NT1, FREQ: 626000000 PIDS:  320  330  0
TUNER TYPE SEEMS TO BE DVB-T
get_path('channels.conf.ter') -> '/home/user/.mplayer/channels.conf.ter'
get_path('channels.conf') -> '/home/user/.mplayer/channels.conf'
CONFIG_READ FILE: /home/user/.mplayer/channels.conf, type: 2
TER, NUM: 0, NUM_FIELDS: 11, NAME: TF1, FREQ: 562000000 PIDS:  120  130  0
TER, NUM: 1, NUM_FIELDS: 11, NAME: NRJ12, FREQ: 562000000 PIDS:  220  230  0
TER, NUM: 2, NUM_FIELDS: 11, NAME: TMC, FREQ: 562000000 PIDS:  620  630  0
TER, NUM: 3, NUM_FIELDS: 11, NAME: France 2, FREQ: 586000000 PIDS:  120
130  0
TER, NUM: 4, NUM_FIELDS: 11, NAME: France 5, FREQ: 586000000 PIDS:  320
330  0
TER, NUM: 5, NUM_FIELDS: 11, NAME: ARTE, FREQ: 586000000 PIDS:  520  530  0
TER, NUM: 6, NUM_FIELDS: 11, NAME: LCP, FREQ: 586000000 PIDS:  620  630  0
TER, NUM: 7, NUM_FIELDS: 11, NAME: France 3, FREQ: 586000000 PIDS:  220
230  0
TER, NUM: 8, NUM_FIELDS: 11, NAME: TV Rennes 35, FREQ: 586000000 PIDS:
720  730  0
TER, NUM: 9, NUM_FIELDS: 11, NAME: CANAL+, FREQ: 650000000 PIDS:  0  80  0
TER, NUM: 10, NUM_FIELDS: 11, NAME: TPS STAR, FREQ: 650000000 PIDS:  0
100  0
TER, NUM: 11, NUM_FIELDS: 11, NAME: Direct 8, FREQ: 674000000 PIDS:
160  80  0
TER, NUM: 12, NUM_FIELDS: 11, NAME: France 4, FREQ: 674000000 PIDS:
166  104  0
TER, NUM: 13, NUM_FIELDS: 11, NAME: Gulli, FREQ: 674000000 PIDS:  165
100  0
TER, NUM: 14, NUM_FIELDS: 11, NAME: Europe 2 TV, FREQ: 674000000 PIDS:
164  96  0
TER, NUM: 15, NUM_FIELDS: 11, NAME: i>TELE, FREQ: 674000000 PIDS:  163
92  0
TER, NUM: 16, NUM_FIELDS: 11, NAME: BFM TV, FREQ: 674000000 PIDS:  162
88  0
TER, NUM: 17, NUM_FIELDS: 11, NAME: M6, FREQ: 626000000 PIDS:  120  130  0
TER, NUM: 18, NUM_FIELDS: 11, NAME: W9, FREQ: 626000000 PIDS:  220  230  0
TER, NUM: 19, NUM_FIELDS: 11, NAME: NT1, FREQ: 626000000 PIDS:  320  330  0
DVB_CONFIG, can't open device /dev/dvb/adapter2/frontend0, skipping
DVB_CONFIG, can't open device /dev/dvb/adapter3/frontend0, skipping
OPEN_DVB: prog=3DNT1, card=3D1, type=3D2, vid=3D0, aid=3D0

dvb_streaming_start(PROG: NT1, CARD: 1, VID: 0, AID: 0, TYPE: , FILE:
(null))
PROGRAM NUMBER 19: name=3DNT1, freq=3D626000000
DVB_OPEN_DEVICES(3)
OPEN(0), file /dev/dvb/adapter0/demux0: FD=3D4, CNT=3D0
OPEN(1), file /dev/dvb/adapter0/demux0: FD=3D5, CNT=3D1
OPEN(2), file /dev/dvb/adapter0/demux0: FD=3D6, CNT=3D2
DVB_SET_CHANNEL: new channel name=3DNT1, card: 0, channel 19
DIFFERENT TUNING THAN THE PREVIOUS:   -> 0|626000000|2|0|1|1|1|0
dvb_tune Freq: 626000000
TUNE_IT, fd_frontend 3, fd_sec 0
freq 626000000, srate 0, pol Using DVB card "DiBcom 7000PC"
tuning DVB-T to 626000000 Hz, bandwidth: 0
Getting frontend status
Event:  Frequency: 626000000
Bit error rate: 2097151
Signal strength: 65535
SNR: 0
UNC: 0
FE_STATUS: FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_SYNC
SET PES FILTER ON PID 320 to fd 4, RESULT: 0, ERRNO: 0
SET PES FILTER ON PID 330 to fd 5, RESULT: 0, ERRNO: 0
SET PES FILTER ON PID 0 to fd 6, RESULT: 0, ERRNO: 0
SUCCESSFUL EXIT from dvb_streaming_start
STREAM: [dvbin] dvb://NT1
STREAM: Description: Dvb Input
STREAM: Author: Nico
STREAM: Comment: based on the code from ??? (probably Arpi)
Checking for MPEG-TS...
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 1860 bytes
dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 1860 bytes
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, return 0 bytes
COULDN'T READ ENOUGH DATA, EXITING TS_CHECK

DVBIN_CLOSE, close(2), fd=3D6, COUNT=3D2
DVBIN_CLOSE, close(1), fd=3D5, COUNT=3D1
DVBIN_CLOSE, close(0), fd=3D4, COUNT=3D0
vo: x11 uninit called but X11 not inited..

Exiting... (End of file)
---------------------------------------------------------------------------=
-----------------------------------------------------

Do you have any idea ?
Thanks for your help

Bertrand



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
