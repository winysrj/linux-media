Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37274 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbcHLHcy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 03:32:54 -0400
Subject: Re: [PATCH v9 0/2] [media] atmel-isc: add driver for Atmel ISC
To: Songjun Wu <songjun.wu@microchip.com>, nicolas.ferre@atmel.com,
	robh@kernel.org
References: <1470899202-13933-1-git-send-email-songjun.wu@microchip.com>
Cc: laurent.pinchart@ideasonboard.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?Q?Niklas_S=c3=83=c2=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Benoit Parrot <bparrot@ti.com>, linux-kernel@vger.kernel.org,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Kamil Debski <kamil@wypas.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms+renesas@verge.net.au>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c6593866-db70-b2a6-ee5a-32b6fecc3775@xs4all.nl>
Date: Fri, 12 Aug 2016 09:32:42 +0200
MIME-Version: 1.0
In-Reply-To: <1470899202-13933-1-git-send-email-songjun.wu@microchip.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One quick question:

On 08/11/2016 09:06 AM, Songjun Wu wrote:
> The Image Sensor Controller driver includes two parts.
> 1) Driver code to implement the ISC function.
> 2) Device tree binding documentation, it describes how
>    to add the ISC in device tree.
> 
> Test result with v4l-utils.
> # v4l2-compliance -f
> v4l2-compliance SHA   : not available
> 
> Driver Info:
>         Driver name   : atmel_isc
>         Card type     : Atmel Image Sensor Controller
>         Bus info      : platform:atmel_isc f0008000.isc
>         Driver version: 4.7.0
>         Capabilities  : 0x84200001
>                 Video Capture
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x04200001
>                 Video Capture
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
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 1 Audio Inputs: 0 Tuners: 0
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
> Test input 0:
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
>                 test VIDIOC_QUERYCTRL: OK (Not Supported)
>                 test VIDIOC_G/S_CTRL: OK (Not Supported)
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 0 Private Controls: 0

Can you confirm that the sensor subdevice you are using does not have any controls?
I ask since that is fairly unusual, so I want to make sure that controls are really
not supported in this setup.

Regards,

	Hans
