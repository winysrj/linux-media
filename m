Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:43681 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751632AbeBFVVW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 16:21:22 -0500
Subject: Re: [PATCH v8 0/7] TDA1997x HDMI video reciver
To: Tim Harvey <tharvey@gateworks.com>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1517948874-21681-1-git-send-email-tharvey@gateworks.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c7771c44-a9ff-0207-38f6-28bcc06ccdee@xs4all.nl>
Date: Tue, 6 Feb 2018 22:21:17 +0100
MIME-Version: 1.0
In-Reply-To: <1517948874-21681-1-git-send-email-tharvey@gateworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/06/2018 09:27 PM, Tim Harvey wrote:

<snip>

> v4l2-compliance test results:
>  - with the following kernel patches:
>    v4l2-subdev: clear reserved fields
>  . v4l2-subdev: without controls return -ENOTTY
> 
> v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8
> Media Driver Info:
> 	Driver name      : imx-media
> 	Model            : imx-media
> 	Serial           : 
> 	Bus info         : 
> 	Media version    : 4.15.0
> 	Hardware revision: 0x00000000 (0)
> 	Driver version   : 4.15.0
> Interface Info:
> 	ID               : 0x0300008f
> 	Type             : V4L Sub-Device
> Entity Info:
> 	ID               : 0x00000003 (3)
> 	Name             : tda19971 2-0048
> 	Function         : Unknown

This is missing. It should be one of these:

https://hverkuil.home.xs4all.nl/spec/uapi/mediactl/media-types.html#media-entity-type

However, we don't have a proper function defined.

I would suggest adding a new MEDIA_ENT_F_DTV_DECODER analogous to MEDIA_ENT_F_ATV_DECODER.

It would be a new patch adding this + documentation.

> 	Pad 0x01000004   : Source
> 	  Link 0x0200006f: to remote pad 0x1000063 of entity 'ipu1_csi0_mux': Data
> 
> Compliance test for device /dev/v4l-subdev1:
> 
> Allow for multiple opens:
> 	test second /dev/v4l-subdev1 open: OK
> 	test for unlimited opens: OK
> 
> Debug ioctls:
> 	test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
> 	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
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
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK
> 	test VIDIOC_DV_TIMINGS_CAP: OK
> 	test VIDIOC_G/S_EDID: OK

Nice!

> 
> Sub-Device ioctls (Source Pad 0):
> 	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
> 	test Try VIDIOC_SUBDEV_G/S_FMT: OK
> 	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
> 	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
> 	test Active VIDIOC_SUBDEV_G/S_FMT: OK
> 	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
> 	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)
> 
> Control ioctls:
> 	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
> 	test VIDIOC_QUERYCTRL: OK (Not Supported)
> 	test VIDIOC_G/S_CTRL: OK (Not Supported)
> 	test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
> 	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
> 	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 	Standard Controls: 0 Private Controls: 0

Why doesn't this show anything? You have at least one control, so this should
reflect that. Does 'v4l2-ctl -d /dev/v4l-subdev1 -l' show any controls?

I think sd->ctrl_handler is never set to the v4l2_ctrl_handler pointer.

Have you ever tested the controls?

Looking closer I also notice that the control handler is never freed. Or
checked for errors when it is created in the probe function. Hmm, I should
have caught that earlier.

Regards,

	Hans
