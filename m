Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3908 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2GWKPO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 06:15:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH v6] media: coda: Add driver for Coda video codec.
Date: Mon, 23 Jul 2012 12:14:15 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	s.hauer@pengutronix.de, p.zabel@pengutronix.de
References: <1342782515-24992-1-git-send-email-javier.martin@vista-silicon.com> <CACKLOr312a=KTrm9=N48=SHN5Z=0yTPceopG9MJBu8he_3yjrw@mail.gmail.com> <CACKLOr1RF2PLECz7Y9kFRnFqnCMfHQOcCTT0TgdFvNyFVynCpg@mail.gmail.com>
In-Reply-To: <CACKLOr1RF2PLECz7Y9kFRnFqnCMfHQOcCTT0TgdFvNyFVynCpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231214.15835.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon July 23 2012 12:00:30 javier Martin wrote:
> On 23 July 2012 11:45, javier Martin <javier.martin@vista-silicon.com> wrote:
> > Sorry, I had a problem with my buildroot environment. This is the
> > v4l2-compliance output with the most recent version:
> >
> > # v4l2-compliance -d /dev/video2
> > Driver Info:
> >         Driver name   : coda
> >         Card type     : coda
> >         Bus info      : coda
> >         Driver version: 0.0.0
> >         Capabilities  : 0x84000003
> >                 Video Capture
> >                 Video Output
> >                 Streaming
> >                 Device Capabilities
> >         Device Caps   : 0x04000003
> >                 Video Capture
> >                 Video Output
> >                 Streaming
> >
> > Compliance test for device /dev/video2 (not using libv4l2):
> >
> > Required ioctls:
> >                 fail: v4l2-compliance.cpp(270): (vcap.version >> 16) < 3
> >         test VIDIOC_QUERYCAP: FAIL
> >
> 
> This was related to a memset() that I did in QUERYCAP.
> 
> Now the output is cleaner.

Ah, much better.

> 
> # v4l2-compliance -d /dev/video2
> Driver Info:
>         Driver name   : coda
>         Card type     : coda
>         Bus info      : coda
>         Driver version: 3.5.0
>         Capabilities  : 0x84000003
>                 Video Capture
>                 Video Output
>                 Streaming
>                 Device Capabilities
>         Device Caps   : 0x04000003
>                 Video Capture
>                 Video Output
>                 Streaming
> 
> Compliance test for device /dev/video2 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G_CHIP_IDENT: Not Supported
>         test VIDIOC_DBG_G/S_REGISTER: Not Supported
>         test VIDIOC_LOG_STATUS: Not Supported
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER: Not Supported
>         test VIDIOC_G/S_FREQUENCY: Not Supported
>         test VIDIOC_S_HW_FREQ_SEEK: Not Supported
>         test VIDIOC_ENUMAUDIO: Not Supported
>         test VIDIOC_G/S/ENUMINPUT: Not Supported
>         test VIDIOC_G/S_AUDIO: Not Supported
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: Not Supported
>         test VIDIOC_G/S_FREQUENCY: Not Supported
>         test VIDIOC_ENUMAUDOUT: Not Supported
>         test VIDIOC_G/S/ENUMOUTPUT: Not Supported
>         test VIDIOC_G/S_AUDOUT: Not Supported
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Control ioctls:
>         test VIDIOC_QUERYCTRL/MENU: OK
>         test VIDIOC_G/S_CTRL: OK
>                 fail: v4l2-test-controls.cpp(565): try_ext_ctrls did
> not check the read-only flag

Hmm, what's the reason for this one I wonder. Can you run with '-v2' and see
for which control this fails?

>         test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
>                 fail: v4l2-test-controls.cpp(698): subscribe event for
> control 'MPEG Encoder Controls' failed

Known bug in v4l2-memtest.c. Fixed in my pending patch.

>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
>         test VIDIOC_G/S_JPEGCOMP: Not Supported
>         Standard Controls: 10 Private Controls: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: Not Supported
>         test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: Not Supported
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: Not Supported
>         test VIDIOC_DV_TIMINGS_CAP: Not Supported
> 
> Format ioctls:
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 fail: v4l2-test-formats.cpp(558): cap->readbuffers

Fixed in pending patch for v4l2-ioctl.c

>         test VIDIOC_G/S_PARM: FAIL
>         test VIDIOC_G_FBUF: Not Supported
>                 fail: v4l2-test-formats.cpp(382): !pix.width || !pix.height

This isn't right and you should fix this. I did a similar fix for mem2mem_testdev:

http://www.spinics.net/lists/linux-media/msg50487.html

>         test VIDIOC_G_FMT: FAIL
>         test VIDIOC_G_SLICED_VBI_CAP: Not Supported
> Buffer ioctls:
>         test VIDIOC_REQBUFS/CREATE_BUFS: OK
>         test read/write: OK
> Total: 34 Succeeded: 30 Failed: 4 Warnings: 2

Two warnings... One warning is about a missing CREATE_BUFS which is OK, but what's
the other warning? (-v1 will show the warnings as well).

Regards,

	Hans
