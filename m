Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2347 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2GWK6D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 06:58:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH v6] media: coda: Add driver for Coda video codec.
Date: Mon, 23 Jul 2012 12:56:56 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	s.hauer@pengutronix.de, p.zabel@pengutronix.de
References: <1342782515-24992-1-git-send-email-javier.martin@vista-silicon.com> <201207231214.15835.hverkuil@xs4all.nl> <CACKLOr0+ge3Rxh1w26pdPUKA3BZEHY8qvWS=kysNuCdx3L8tSg@mail.gmail.com>
In-Reply-To: <CACKLOr0+ge3Rxh1w26pdPUKA3BZEHY8qvWS=kysNuCdx3L8tSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231256.56862.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon July 23 2012 12:43:59 javier Martin wrote:
> On 23 July 2012 12:14, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Mon July 23 2012 12:00:30 javier Martin wrote:
> >> On 23 July 2012 11:45, javier Martin <javier.martin@vista-silicon.com> wrote:
> >> > Sorry, I had a problem with my buildroot environment. This is the
> >> > v4l2-compliance output with the most recent version:
> >> >
> >> > # v4l2-compliance -d /dev/video2
> >> > Driver Info:
> >> >         Driver name   : coda
> >> >         Card type     : coda
> >> >         Bus info      : coda
> >> >         Driver version: 0.0.0
> >> >         Capabilities  : 0x84000003
> >> >                 Video Capture
> >> >                 Video Output
> >> >                 Streaming
> >> >                 Device Capabilities
> >> >         Device Caps   : 0x04000003
> >> >                 Video Capture
> >> >                 Video Output
> >> >                 Streaming
> >> >
> >> > Compliance test for device /dev/video2 (not using libv4l2):
> >> >
> >> > Required ioctls:
> >> >                 fail: v4l2-compliance.cpp(270): (vcap.version >> 16) < 3
> >> >         test VIDIOC_QUERYCAP: FAIL
> >> >
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
> >
> >>         test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
> >>                 fail: v4l2-test-controls.cpp(698): subscribe event for
> >> control 'MPEG Encoder Controls' failed
> >
> > Known bug in v4l2-memtest.c. Fixed in my pending patch.
> >
> >>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
> >>         test VIDIOC_G/S_JPEGCOMP: Not Supported
> >>         Standard Controls: 10 Private Controls: 0
> >>
> >> Input/Output configuration ioctls:
> >>         test VIDIOC_ENUM/G/S/QUERY_STD: Not Supported
> >>         test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: Not Supported
> >>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: Not Supported
> >>         test VIDIOC_DV_TIMINGS_CAP: Not Supported
> >>
> >> Format ioctls:
> >>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> >>                 fail: v4l2-test-formats.cpp(558): cap->readbuffers
> >
> > Fixed in pending patch for v4l2-ioctl.c
> >
> >>         test VIDIOC_G/S_PARM: FAIL
> >>         test VIDIOC_G_FBUF: Not Supported
> >>                 fail: v4l2-test-formats.cpp(382): !pix.width || !pix.height
> >
> > This isn't right and you should fix this. I did a similar fix for mem2mem_testdev:
> >
> > http://www.spinics.net/lists/linux-media/msg50487.html
> 
> It seems this is the only problem left since the rest are related to
> framework issues which are already fixed.

Correct.

> Ok, the problem here is that for video encoded formats I return 0 for
> both width and height. I've seen Samsung do the same in this driver:
> http://lxr.linux.no/#linux+v3.5/drivers/media/video/s5p-mfc/s5p_mfc_enc.c#L838

And that's a bug.
 
> Is this correct? Does setting width and height make sense for a video
> encodec format such as H.264, MPEG4?

Why wouldn't it? Otherwise the application would have to parse the encoded
frame to determine the width and height. And the driver should know the
width and height already, right?

And initially you just setup some default format. V4L2 requires that G_FMT
always returns something sensible, so you have to pick some initial format.

Regards,

	Hans
