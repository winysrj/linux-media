Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3761 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3BEPfU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 10:35:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arvydas Sidorenko <asido4@gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
Date: Tue, 5 Feb 2013 16:35:08 +0100
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl> <201302041435.26878.hverkuil@xs4all.nl> <CA+6av4kp54eQSeefAnJxY80HtOJ5iCBh+ETOZaKQHbo=m86-DQ@mail.gmail.com>
In-Reply-To: <CA+6av4kp54eQSeefAnJxY80HtOJ5iCBh+ETOZaKQHbo=m86-DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302051635.08448.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue February 5 2013 16:28:17 Arvydas Sidorenko wrote:
> On Mon, Feb 4, 2013 at 2:35 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > Hi Arvydas,
> >
> > Yes indeed, it would be great if you could test this!
> >
> > Note that the patch series is also available in my git tree:
> >
> > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/stkwebcam
> >
> > Besides the normal testing that everything works as expected, it would also
> > be great if you could run the v4l2-compliance tool. It's part of the v4l-utils
> > repository (http://git.linuxtv.org/v4l-utils.git) and it tests whether a driver
> > complies to the V4L2 specification.
> >
> > Just compile the tool from the repository (don't use a distro-provided version)
> > and run it as 'v4l2-compliance -d /dev/videoX' and mail me the output. You will
> > get at least one failure at the end, but I'd like to know if there are other
> > issues remaining.
> >
> > Regards,
> >
> >         Hans
> 
> I have tested the patches using STK-1135 webcam. Everything works well.
> 
> $ v4l2-compliance -d /dev/video0
> Driver Info:
> 	Driver name   : stk
> 	Card type     : stk
> 	Bus info      :
> 	Driver version: 0.0.1

This is the old version of the driver you are testing with :-)

If you have the right version, then the driver version is much higher,
bus info is filled in and you will see 'Device Caps' after the 'Capabilities'
list.

Regards,

	Hans

> 	Capabilities  : 0x05000001
> 		Video Capture
> 		Read/Write
> 		Streaming
> 
> Compliance test for device /dev/video0 (not using libv4l2):
> 
> Required ioctls:
> 		fail: v4l2-compliance.cpp(224): string empty
> 		fail: v4l2-compliance.cpp(276): check_ustring(vcap.bus_info,
> sizeof(vcap.bus_info))
> 	test VIDIOC_QUERYCAP: FAIL
> 
> Allow for multiple opens:
> 	test second video open: OK
> 		fail: v4l2-compliance.cpp(224): string empty
> 		fail: v4l2-compliance.cpp(276): check_ustring(vcap.bus_info,
> sizeof(vcap.bus_info))
> 	test VIDIOC_QUERYCAP: FAIL
> 		fail: v4l2-compliance.cpp(334): doioctl(node, VIDIOC_G_PRIORITY, &prio)
> 	test VIDIOC_G/S_PRIORITY: FAIL
> 
> Debug ioctls:
> 	test VIDIOC_DBG_G_CHIP_IDENT: OK (Not Supported)
> 	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
> 	test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
> 	test VIDIOC_G/S_TUNER: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
> 		fail: v4l2-test-input-output.cpp(354): std == 0
> 		fail: v4l2-test-input-output.cpp(409): invalid attributes for input 0
> 	test VIDIOC_G/S/ENUMINPUT: FAIL
> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
> 	Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
> 	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
> 	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Control ioctls:
> 		fail: v4l2-test-controls.cpp(145): can do querymenu on a non-menu control
> 		fail: v4l2-test-controls.cpp(254): invalid control 00980900
> 	test VIDIOC_QUERYCTRL/MENU: FAIL
> 	test VIDIOC_G/S_CTRL: OK
> 	test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
> 	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
> 	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 	Standard Controls: 0 Private Controls: 0
> 
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> 	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: OK (Not Supported)
> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> 	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> 
> Format ioctls:
> 	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 	test VIDIOC_G/S_PARM: OK
> 	test VIDIOC_G_FBUF: OK (Not Supported)
> 	test VIDIOC_G_FMT: OK
> 		fail: v4l2-test-formats.cpp(385): priv is non-zero!
> 	test VIDIOC_TRY_FMT: FAIL
> 		fail: v4l2-test-formats.cpp(719): Video Capture is valid, but no
> S_FMT was implemented
> 	test VIDIOC_S_FMT: FAIL
> 	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 
> Codec ioctls:
> 	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> 	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> 	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
> 		fail: v4l2-test-buffers.cpp(132): ret != -1
> 	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
> 
> Total: 38, Succeeded: 30, Failed: 8, Warnings: 1
> 
> 
> Arvydas
> 
