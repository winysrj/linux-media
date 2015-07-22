Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42637 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbbGVGJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 02:09:53 -0400
Message-ID: <55AF3367.5040503@xs4all.nl>
Date: Wed, 22 Jul 2015 08:08:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	horms@verge.net.au, magnus.damm@gmail.com, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com, mchehab@osg.samsung.com
CC: laurent.pinchart@ideasonboard.com, j.anaszewski@samsung.com,
	kamil@wypas.org, sergei.shtylyov@cogentembedded.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/3] R-Car JPEG Processing Unit
References: <1437444022-28916-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1437444022-28916-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

Just one small thing, see below...

On 07/21/2015 04:00 AM, Mikhail Ulyanov wrote:
> This series of patches contains a driver for the JPEG codec integrated
> peripheral found in the Renesas R-Car SoCs and associated DT documentation.
> 
> This series of patches is against the 'master' branch of
> linuxtv.org/media_tree.git
> 
> v4l2-compliance -s
> 
> Driver Info:
>         Driver name   : rcar_jpu
>         Card type     : rcar_jpu encoder
>         Bus info      : platform:fe980000.jpu
>         Driver version: 4.2.0
>         Capabilities  : 0x84204000
>                 Video Memory-to-Memory Multiplanar
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x04204000
>                 Video Memory-to-Memory Multiplanar
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video0 (not using libv4l2):
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
>         test VIDIOC_DBG_G/S_REGISTER: OK
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 2 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 warn: v4l2-test-buffers.cpp(542): VIDIOC_CREATE_BUFS not supported
>                 warn: v4l2-test-buffers.cpp(542): VIDIOC_CREATE_BUFS not supported

Can you add support for this? There is a v4l2_m2m_ioctl_create_bufs helper function,
so all you need to do is stick in that helper and have jpu_queue_setup verify and
user fmt->fmt.imagesize as the size if fmt is non-NULL.

Please run v4l2-compliance again after it's been added.

I plan on reviewing and hopefully making a pull request for this on Friday.

Regards,

	Hans
