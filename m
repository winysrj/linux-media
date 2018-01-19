Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:38038 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754562AbeASL0P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 06:26:15 -0500
Subject: Re: [PATCH v6 0/9] Renesas Capture Engine Unit (CEU) V4L2 driver
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6fcd22c1-19a5-e0b7-2b00-961e1cd1ebaa@xs4all.nl>
Date: Fri, 19 Jan 2018 12:26:09 +0100
MIME-Version: 1.0
In-Reply-To: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 01/16/18 22:44, Jacopo Mondi wrote:
> Hello,
>    new version of CEU after Hans' review.
> 
> Added his Acked-by to most patches and closed review comments.
> Running v4l2-compliance, I noticed a new failure introduced by the way I now
> calculate the plane sizes in set/try_fmt.
> 
> This is the function used to update per-plane bytesperline and sizeimage:
> 
> static void ceu_update_plane_sizes(struct v4l2_plane_pix_format *plane,
> 				   unsigned int bpl, unsigned int szimage)
> {
> 	if (plane->bytesperline < bpl)
> 		plane->bytesperline = bpl;
> 	if (plane->sizeimage < szimage)
> 		plane->sizeimage = szimage;
> }
> 
> I'm seeing a failure as v4l2-compliance requires buffers with both bytesperline
> and sizeimage set to MAX_INT . Hans, is this expected from v4l2-compliance?
> How should I handle this, if that has to be handled by the single drivers?

I commented on this in my review of patch 3/9.

> 
> Apart from that, here it is the output of v4l2-compliance, with the last tests
> failing due to the above stated reason, and two errors in try/set format due to
> the fact the driver is not setting ycbcr encoding after it receives an invalid

Which driver? The CEU driver or the sensor driver? I don't actually see where
it fails.

> format. I would set those, but I'm not sure what it the correct value and not
> all mainline drivers do that.

In any case, the default for ycbcr_enc, xfer_func and quantization is 0.

> 
> -------------------------------------------------------------------------------
> v4l2-compliance SHA   : 1d3c611dee82090d9456730e24af368b51dcb4a9

I can't find this SHA in the v4l-utils repo. You should always compile
v4l2-compliance from the master branch.

Also test with 'v4l2-compliance -f': this tests streaming in all formats.

> 
> Driver Info:
> 	Driver name   : renesas-ceu
> 	Card type     : Renesas CEU e8210000.ceu
> 	Bus info      : platform:renesas-ceu-e8210000.c
> 	Driver version: 4.14.0
> 	Capabilities  : 0x84201000
> 		Video Capture Multiplanar
> 		Streaming
> 		Extended Pix Format
> 		Device Capabilities
> 	Device Caps   : 0x04201000
> 		Video Capture Multiplanar
> 		Streaming
> 		Extended Pix Format
> 
> Compliance test for device /dev/video0 (not using libv4l2):
> 
> Required ioctls:
> 	test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
> 	test second video open: OK
> 	test VIDIOC_QUERYCAP: OK
> 	test VIDIOC_G/S_PRIORITY: OK
> 	test for unlimited opens: OK
> 
> Debug ioctls:
> 	test VIDIOC_DBG_G/S_REGISTER: OK
> 	test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
> 	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMINPUT: OK
> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
> 	Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
> 	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
> 	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> 	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> 	test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
> 	Control ioctls:
> 		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
> 		test VIDIOC_QUERYCTRL: OK
> 		test VIDIOC_G/S_CTRL: OK
> 		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> 		fail: v4l2-test-controls.cpp(782): subscribe event for control 'User Controls' failed
> 		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
> 		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 		Standard Controls: 12 Private Controls: 0
> 
> 	Format ioctls:
> 		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 		fail: v4l2-test-formats.cpp(1162): ret && node->has_frmintervals
> 		test VIDIOC_G/S_PARM: FAIL
> 		test VIDIOC_G_FBUF: OK (Not Supported)
> 		test VIDIOC_G_FMT: OK
> 		fail: v4l2-test-formats.cpp(335): ycbcr_enc >= 0xff
> 		fail: v4l2-test-formats.cpp(451): testColorspace(pix_mp.pixelformat, pix_mp.colorspace, pix_mp.ycbcr_enc, pix_mp.quantization)
> 		fail: v4l2-test-formats.cpp(736): Video Capture Multiplanar is valid, but TRY_FMT failed to return a format
> 		test VIDIOC_TRY_FMT: FAIL
> 		fail: v4l2-test-formats.cpp(335): ycbcr_enc >= 0xff
> 		fail: v4l2-test-formats.cpp(451): testColorspace(pix_mp.pixelformat, pix_mp.colorspace, pix_mp.ycbcr_enc, pix_mp.quantization)
> 		fail: v4l2-test-formats.cpp(996): Video Capture Multiplanar is valid, but no S_FMT was implemented
> 		test VIDIOC_S_FMT: FAIL
> 		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 		test Cropping: OK (Not Supported)
> 		test Composing: OK (Not Supported)
> 		test Scaling: OK (Not Supported)
> 
> 	Codec ioctls:
> 		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> 		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> 		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> 	Buffer ioctls:
> 		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> 		test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> 
> Total: 43, Succeeded: 39, Failed: 4, Warnings: 0

'Failed' must be 0, otherwise I won't Ack this driver.

Regards,

	Hans
