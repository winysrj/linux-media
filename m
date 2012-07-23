Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3669 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab2GWIVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 04:21:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH v6] media: coda: Add driver for Coda video codec.
Date: Mon, 23 Jul 2012 10:20:58 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	s.hauer@pengutronix.de, p.zabel@pengutronix.de
References: <1342782515-24992-1-git-send-email-javier.martin@vista-silicon.com> <201207211150.15296.hverkuil@xs4all.nl> <CACKLOr3ZuAru9knFv4M=BWxRWP27ztoZdbACPXVHPrNLhzKPng@mail.gmail.com>
In-Reply-To: <CACKLOr3ZuAru9knFv4M=BWxRWP27ztoZdbACPXVHPrNLhzKPng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231020.58305.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon July 23 2012 10:02:04 javier Martin wrote:
> Hi Hans,
> 
> On 21 July 2012 11:50, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Fri July 20 2012 13:08:35 Javier Martin wrote:
> >> Coda is a range of video codecs from Chips&Media that
> >> support H.264, H.263, MPEG4 and other video standards.
> >>
> >> Currently only support for the codadx6 included in the
> >> i.MX27 SoC is added. H.264 and MPEG4 video encoding
> >> are the only supported capabilities by now.
> >>
> >> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> >> Reviewed-by: Philipp Zabel<p.zabel@pengutronix.de>
> >> ---
> >> Changes since v5:
> >>  - Fixed some v4l2-compliance issues.
> >
> > Some or all? Can you give me the 'v4l2-compliance -v1' output?
> 
> I've not corrected some mistakes that are pointed by v4l2-compliance
> that I consider bogus for my mem2mem video encoder.
> 
> I don't mind helping you test the new m2m capabilities of
> 'v4l2-compliance' but I don't think delaying this driver to enter
> mainline for this merge window for this is reasonable. Please, find
> the output you requested below:
> 
> 
> Driver Info:
>         Driver name   : coda
>         Card type     : coda
>         Bus info      : coda
>         Driver version: 0.0.0

??? This should be set to the kernel version by v4l2-ioctl.c. What kernel
are you using?

>         Capabilities  : 0x84000003
>                 Video Capture
>                 Video Output
>                 Streaming
> 
> Compliance test for device /dev/video2 (not using libv4l2):
> 
> Required ioctls:
>                 fail: v4l2-compliance.cpp(251): check_0(vcap.reserved,
> sizeof(vcap.reserved))

This is very strange. Please investigate! vcap is zeroed in v4l2-ioctl.c before
calling vidioc_querycap in the driver, so why would reserved[] be non-zero?
Perhaps some memory overwrite?

>         test VIDIOC_QUERYCAP: FAIL
> 
> Allow for multiple opens:
>         test second video open: OK
>                 fail: v4l2-compliance.cpp(251): check_0(vcap.reserved,
> sizeof(vcap.reserved))
>         test VIDIOC_QUERYCAP: FAIL
>                 fail: v4l2-compliance.cpp(273): doioctl(node,
> VIDIOC_G_PRIORITY, &prio)

Are you using the latest v4l2-compliance? You shouldn't see this fail for mem2mem
devices.

>         test VIDIOC_G/S_PRIORITY: FAIL
> 
> Debug ioctls:
>         test VIDIOC_DBG_G_CHIP_IDENT: FAIL
>                 fail: v4l2-test-debug.cpp(82): uid == 0 && ret
>         test VIDIOC_DBG_G/S_REGISTER: FAIL
>         test VIDIOC_LOG_STATUS: FAIL

Weird as well. This suggests you are using this driver with an old kernel. The
return code for unimplemented ioctls changed from EINVAL to ENOTTY some kernel
versions ago. This may actually be the cause of the G_PRIO fail above.

> 
> Input ioctls:
>                 fail: v4l2-test-input-output.cpp(133): couldn't get tuner 0
>         test VIDIOC_G/S_TUNER: FAIL
>                 fail: v4l2-test-input-output.cpp(228): could get
> frequency for invalid tuner 0
>         test VIDIOC_G/S_FREQUENCY: FAIL
>                 fail: v4l2-test-input-output.cpp(358): could not
> enumerate audio input 0
>         test VIDIOC_ENUMAUDIO: FAIL
>                 fail: v4l2-test-input-output.cpp(290): could not get
> current input
>         test VIDIOC_G/S/ENUMINPUT: FAIL
>         test VIDIOC_G/S_AUDIO: Not Supported
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>                 fail: v4l2-test-input-output.cpp(479): couldn't get modulator 0
>         test VIDIOC_G/S_MODULATOR: FAIL
>                 fail: v4l2-test-input-output.cpp(563): could get
> frequency for invalid modulator 0
>         test VIDIOC_G/S_FREQUENCY: FAIL
>                 fail: v4l2-test-input-output.cpp(682): could not
> enumerate audio output 0
>         test VIDIOC_ENUMAUDOUT: FAIL
>         test VIDIOC_G/S/ENUMOUTPUT: FAIL
>         test VIDIOC_G/S_AUDOUT: Not Supported
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Control ioctls:
>         test VIDIOC_QUERYCTRL/MENU: OK
>         test VIDIOC_G/S_CTRL: OK
>                 fail: v4l2-test-controls.cpp(532): try_ext_ctrls did
> not check the read-only flag
>         test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
>         Standard Controls: 10 Private Controls: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: Not Supported
>         test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: Not Supported
>         test VIDIOC_G/S_DV_TIMINGS: Not Supported
> 
> Format ioctls:
>                 fail: v4l2-test-formats.cpp(138): expected EINVAL, but
> got 25 when enumerating framesize 0
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL
>                 fail: v4l2-test-formats.cpp(327): expected EINVAL, but
> got 25 when getting framebuffer format
>         test VIDIOC_G_FBUF: FAIL
>                 fail: v4l2-test-formats.cpp(383): !pix.width || !pix.height
>         test VIDIOC_G_FMT: FAIL
>                 fail: v4l2-test-formats.cpp(509): ret && ret != EINVAL
> && sliced_type
>         test VIDIOC_G_SLICED_VBI_CAP: FAIL
> Total: 27 Succeeded: 8 Failed: 19 Warnings: 0

It would be much more helpful if you can test this against a recent kernel.

Regards,

	Hans
