Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57230 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaKQRpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 12:45:41 -0500
Message-ID: <546A343F.401@collabora.com>
Date: Mon, 17 Nov 2014 12:45:35 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: Using the coda driver with Gstreamer
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>
In-Reply-To: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note, I'm only commenting about the GStreamer side...

Le 2014-11-17 12:29, Fabio Estevam a écrit :
> Hi,
>
> I am running linux-next 20141117 on a mx6qsabresd board and trying to
> play a mp4 video via Gstreamer 1.4.1, but I am getting the following
> error:
You should update to latest stable version, this is a general rule. Not
keeping track of stable branches is never a good idea. Current stable is
1.4.4.

Note that as of today, there is known issue with supporting this driver
(not that driver itself, I really mean supporting the driver features):

- Need to fix EOS Handling,
https://bugzilla.gnome.org/show_bug.cgi?id=733864
- Output size negotiation https://bugzilla.gnome.org/show_bug.cgi?id=733828
- Output pixel format negotiation
https://bugzilla.gnome.org/show_bug.cgi?id=733827
- Encoding is not yet supported
https://bugzilla.gnome.org/show_bug.cgi?id=728438

First one is the main blocker, but kernel folks will be able to clarify
more. Help is of course appreciated. Note that some of the issues kind
of lack a specification to accomplished. We recently had a meeting in
Dusseldorf to propose solutions.

>
> root@imx6qsabresd:/mnt/nfs# gst-play-1.0 sample.mp4
> Volume: 100%
> Now playing /mnt/nfs/sample.mp4
> [  506.983809] ------------[ cut here ]------------
> [  506.988522] WARNING: CPU: 0 PID: 954 at
> drivers/media/v4l2-core/videobuf2-core.c:1781
> vb2_start_streaming+0xc4/0x160()
> [  506.999301] Modules linked in:
> [  507.002489] CPU: 0 PID: 954 Comm: multiqueue0:src Tainted: G
> W      3.18.0-rc4-next-20141117-dirty #2044
> [  507.012660] Backtrace:
> [  507.015253] [<80011f44>] (dump_backtrace) from [<800120e0>]
> (show_stack+0x18/0x1c)
> [  507.022891]  r6:000006f5 r5:00000000 r4:00000000 r3:00000000
> [  507.028707] [<800120c8>] (show_stack) from [<806b730c>]
> (dump_stack+0x88/0xa4)
> [  507.035954] [<806b7284>] (dump_stack) from [<8002a4dc>]
> (warn_slowpath_common+0x80/0xbc)
> [  507.044135]  r5:804a80a8 r4:00000000
> [  507.047802] [<8002a45c>] (warn_slowpath_common) from [<8002a53c>]
> (warn_slowpath_null+0x24/0x2c)
> [  507.056605]  r8:00000000 r7:bd71c640 r6:bd614ef0 r5:bd614ee0 r4:ffffffea
> [  507.063470] [<8002a518>] (warn_slowpath_null) from [<804a80a8>]
> (vb2_start_streaming+0xc4/0x160)
> [  507.072293] [<804a7fe4>] (vb2_start_streaming) from [<804a9efc>]
> (vb2_internal_streamon+0xfc/0x158)
> [  507.081385]  r7:bd71c640 r6:bd6c29ec r5:bd614c00 r4:bd614de0
> [  507.087133] [<804a9e00>] (vb2_internal_streamon) from [<804ab0a8>]
> (vb2_streamon+0x34/0x58)
> [  507.095567]  r5:bd614c00 r4:00000002
> [  507.099231] [<804ab074>] (vb2_streamon) from [<804a3b10>]
> (v4l2_m2m_streamon+0x28/0x40)
> [  507.107287] [<804a3ae8>] (v4l2_m2m_streamon) from [<804a3b40>]
> (v4l2_m2m_ioctl_streamon+0x18/0x1c)
> [  507.116292]  r5:bd9083c8 r4:40045612
> [  507.120016] [<804a3b28>] (v4l2_m2m_ioctl_streamon) from
> [<80492e48>] (v4l_streamon+0x20/0x24)
> [  507.128693] [<80492e28>] (v4l_streamon) from [<80494dc4>]
> (__video_do_ioctl+0x24c/0x2e0)
> [  507.136826] [<80494b78>] (__video_do_ioctl) from [<804953a8>]
> (video_usercopy+0x118/0x480)
> [  507.145133]  r10:00000001 r9:bd6cbe10 r8:74a1164c r7:00000000
> r6:00000000 r5:80494b78
> [  507.153073]  r4:40045612
> [  507.155632] [<80495290>] (video_usercopy) from [<80495724>]
> (video_ioctl2+0x14/0x1c)
> [  507.163408]  r10:bd8fccb8 r9:74a1164c r8:bd909064 r7:74a1164c
> r6:40045612 r5:bd71c640
> [  507.171343]  r4:bd9083c8
> [  507.173902] [<80495710>] (video_ioctl2) from [<804918f8>]
> (v4l2_ioctl+0x104/0x14c)
> [  507.181512] [<804917f4>] (v4l2_ioctl) from [<800fc944>]
> (do_vfs_ioctl+0x80/0x634)
> [  507.189019]  r8:00000009 r7:74a1164c r6:00000009 r5:800fcf34
> r4:bd71c640 r3:804917f4
> [  507.196870] [<800fc8c4>] (do_vfs_ioctl) from [<800fcf34>]
> (SyS_ioctl+0x3c/0x60)
> [  507.204203]  r10:00000000 r9:bd6ca000 r8:00000009 r7:74a1164c
> r6:40045612 r5:bd71c640
> [  507.212159]  r4:bd71c641
> [  507.214722] [<800fcef8>] (SyS_ioctl) from [<8000ec60>]
> (ret_fast_syscall+0x0/0x48)
> [  507.222311]  r8:8000ee24 r7:00000036 r6:73c183a0 r5:754248e0
> r4:00000000 r3:00000000
> [  507.230168] ---[ end trace c3703a604edaf0d0 ]---
Looks like a backtrace of a warning, though I'm not sure I get what this
warning is about. Maybe you are missing some information, or one need to
look at videobuf2-core.c:178.
> ERROR Failed to connect to X display server for file:///mnt/nfs/sample.mp4
You have built glimagesink (hence libgstgl, part of gst-plugins-bad)
against X11 but you don't have a X11 display running, or DISPLAY
environment isn't set properly.
> ERROR debug information:
> /code/yocto/dizzy/build/tmp/work/cortexa9hf-vfp-neon-mx6qdl-poky-linux-gnueabi/gstreamer1.0-plugins-bad/1.4.1-r0/gst-plugins-bad-1.4.1/ext/gl/gstglimagesink.c(453):
> _ensure_gl_setup ():
> /GstPlayBin:playbin/GstPlaySink:playsink/GstBin:vbin/GstGLImageSink:glimagesink0
> GLib (gthread-posix.c): Unexpected error from C library during
> 'pthread_mutex_lock': Invalid argument.  Aborting.
> Aborted
This is most likely fixed in stable releases. It's probably a bug in an
error path (spurious unlock, or use after free). If not fixed, valgrind
would tell us more.

Nicolas

