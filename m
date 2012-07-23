Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3066 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2GWKek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 06:34:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v6] media: coda: Add driver for Coda video codec.
Date: Mon, 23 Jul 2012 12:33:48 +0200
Cc: javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.hauer@pengutronix.de,
	p.zabel@pengutronix.de
References: <1342782515-24992-1-git-send-email-javier.martin@vista-silicon.com> <201207231214.15835.hverkuil@xs4all.nl> <500D2595.7060009@samsung.com>
In-Reply-To: <500D2595.7060009@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231233.48300.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon July 23 2012 12:21:09 Sylwester Nawrocki wrote:
> On 07/23/2012 12:14 PM, Hans Verkuil wrote:
> > On Mon July 23 2012 12:00:30 javier Martin wrote:
> >> On 23 July 2012 11:45, javier Martin <javier.martin@vista-silicon.com> wrote:
> >>> Sorry, I had a problem with my buildroot environment. This is the
> >>> v4l2-compliance output with the most recent version:
> >>>
> >>> # v4l2-compliance -d /dev/video2
> >>> Driver Info:
> >>>         Driver name   : coda
> >>>         Card type     : coda
> >>>         Bus info      : coda
> >>>         Driver version: 0.0.0
> >>>         Capabilities  : 0x84000003
> >>>                 Video Capture
> >>>                 Video Output
> >>>                 Streaming
> >>>                 Device Capabilities
> >>>         Device Caps   : 0x04000003
> >>>                 Video Capture
> >>>                 Video Output
> >>>                 Streaming
> >>>
> >>> Compliance test for device /dev/video2 (not using libv4l2):
> >>>
> >>> Required ioctls:
> >>>                 fail: v4l2-compliance.cpp(270): (vcap.version >> 16) < 3
> >>>         test VIDIOC_QUERYCAP: FAIL
> >>>
> >>
> >> This was related to a memset() that I did in QUERYCAP.
> >>
> >> Now the output is cleaner.
> > 
> > Ah, much better.
> > 
> >>
> >> # v4l2-compliance -d /dev/video2
> >> Driver Info:
> >>         Driver name   : coda
> >>         Card type     : coda
> >>         Bus info      : coda
> >>         Driver version: 3.5.0
> >>         Capabilities  : 0x84000003
> >>                 Video Capture
> >>                 Video Output
> >>                 Streaming
> >>                 Device Capabilities
> >>         Device Caps   : 0x04000003
> >>                 Video Capture
> >>                 Video Output
> >>                 Streaming
> >>
> >> Compliance test for device /dev/video2 (not using libv4l2):
> >>
> >> Required ioctls:
> >>         test VIDIOC_QUERYCAP: OK
> >>
> >> Allow for multiple opens:
> >>         test second video open: OK
> >>         test VIDIOC_QUERYCAP: OK
> >>         test VIDIOC_G/S_PRIORITY: OK
> >>
> >> Debug ioctls:
> >>         test VIDIOC_DBG_G_CHIP_IDENT: Not Supported
> >>         test VIDIOC_DBG_G/S_REGISTER: Not Supported
> >>         test VIDIOC_LOG_STATUS: Not Supported
> >>
> >> Input ioctls:
> >>         test VIDIOC_G/S_TUNER: Not Supported
> >>         test VIDIOC_G/S_FREQUENCY: Not Supported
> >>         test VIDIOC_S_HW_FREQ_SEEK: Not Supported
> >>         test VIDIOC_ENUMAUDIO: Not Supported
> >>         test VIDIOC_G/S/ENUMINPUT: Not Supported
> >>         test VIDIOC_G/S_AUDIO: Not Supported
> >>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> >>
> >> Output ioctls:
> >>         test VIDIOC_G/S_MODULATOR: Not Supported
> >>         test VIDIOC_G/S_FREQUENCY: Not Supported
> >>         test VIDIOC_ENUMAUDOUT: Not Supported
> >>         test VIDIOC_G/S/ENUMOUTPUT: Not Supported
> >>         test VIDIOC_G/S_AUDOUT: Not Supported
> >>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> >>
> >> Control ioctls:
> >>         test VIDIOC_QUERYCTRL/MENU: OK
> >>         test VIDIOC_G/S_CTRL: OK
> >>                 fail: v4l2-test-controls.cpp(565): try_ext_ctrls did
> >> not check the read-only flag
> > 
> > Hmm, what's the reason for this one I wonder. Can you run with '-v2' and see
> > for which control this fails?
> 
> This might be related to calling video_register_device() with null
> ctrl_handler or not setting V4L2_FL_USES_V4L2_FH flags at struct video_device.

No, that isn't is. ctrl_handling is set in the open (it's a m2m device, so the
controls are per-filehandle), and V4L2_FL_USES_V4L2_FH is set implicitly whenever
you call v4l2_fh_init.

But know I remember, it was a regression in v4l2-ioctl.c that's fixed here:

http://patchwork.linuxtv.org/patch/13377/

Regards,

	Hans
