Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:51012 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821AbcGUImG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 04:42:06 -0400
Subject: Re: [PATCH v6 0/2] [media] atmel-isc: add driver for Atmel ISC
To: Songjun Wu <songjun.wu@microchip.com>, nicolas.ferre@atmel.com,
	robh@kernel.org
References: <1469088900-23935-1-git-send-email-songjun.wu@microchip.com>
Cc: laurent.pinchart@ideasonboard.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?Q?Niklas_S=c3=83=c2=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Benoit Parrot <bparrot@ti.com>, linux-kernel@vger.kernel.org,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Kamil Debski <kamil@wypas.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms+renesas@verge.net.au>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e0592f57-f679-fcde-7446-e3259ad9825b@xs4all.nl>
Date: Thu, 21 Jul 2016 10:41:50 +0200
MIME-Version: 1.0
In-Reply-To: <1469088900-23935-1-git-send-email-songjun.wu@microchip.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/21/2016 10:14 AM, Songjun Wu wrote:
> The Image Sensor Controller driver includes two parts.
> 1) Driver code to implement the ISC function.
> 2) Device tree binding documentation, it describes how
>    to add the ISC in device tree.
> 
> Test result with v4l-utils 1.10.1

Please compile from the v4l-utils repository. The version you used here is out-of-date.
I continually add new tests, so always compile the latest version from the repo.

Regards,

	Hans

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
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK (Not Supported)
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> Stream using all formats:
>         test MMAP for Format BA81, Frame Size 640x480:
>                 Stride 640, Field None: OK
>         test MMAP for Format YUYV, Frame Size 640x480:
>                 Stride 1280, Field None: OK
> 
> Total: 44, Succeeded: 44, Failed: 0, Warnings: 0
> 
> Changes in v6:
> - Add "iscck" and "gck" to clock-names.
> 
> Changes in v5:
> - Modify the macro definition and the related code.
> - Add clock-output-names.
> 
> Changes in v4:
> - Modify the isc clock code since the dt is changed.
> - Remove the isc clock nodes.
> 
> Changes in v3:
> - Add pm runtime feature.
> - Modify the isc clock code since the dt is changed.
> - Remove the 'atmel,sensor-preferred'.
> - Modify the isc clock node according to the Rob's remarks.
> 
> Changes in v2:
> - Add "depends on COMMON_CLK" and "VIDEO_V4L2_SUBDEV_API"
>   in Kconfig file.
> - Correct typos and coding style according to Laurent's remarks
> - Delete the loop while in 'isc_clk_enable' function.
> - Replace 'hsync_active', 'vsync_active' and 'pclk_sample'
>   with 'pfe_cfg0' in struct isc_subdev_entity.
> - Add the code to support VIDIOC_CREATE_BUFS in
>   'isc_queue_setup' function.
> - Invoke isc_config to configure register in
>   'isc_start_streaming' function.
> - Add the struct completion 'comp' to synchronize with
>   the frame end interrupt in 'isc_stop_streaming' function.
> - Check the return value of the clk_prepare_enable
>   in 'isc_open' function.
> - Set the default format in 'isc_open' function.
> - Add an exit condition in the loop while in 'isc_config'.
> - Delete the hardware setup operation in 'isc_set_format'.
> - Refuse format modification during streaming
>   in 'isc_s_fmt_vid_cap' function.
> - Invoke v4l2_subdev_alloc_pad_config to allocate and
>   initialize the pad config in 'isc_async_complete' function.
> - Remove the '.owner  = THIS_MODULE,' in atmel_isc_driver.
> - Replace the module_platform_driver_probe() with
>   module_platform_driver().
> - Remove the unit address of the endpoint.
> - Add the unit address to the clock node.
> - Avoid using underscores in node names.
> - Drop the "0x" in the unit address of the i2c node.
> - Modify the description of 'atmel,sensor-preferred'.
> - Add the description for the ISC internal clock.
> 
> Songjun Wu (2):
>   [media] atmel-isc: add the Image Sensor Controller code
>   [media] atmel-isc: DT binding for Image Sensor Controller driver
> 
>  .../devicetree/bindings/media/atmel-isc.txt        |   65 +
>  drivers/media/platform/Kconfig                     |    1 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/atmel/Kconfig               |    9 +
>  drivers/media/platform/atmel/Makefile              |    1 +
>  drivers/media/platform/atmel/atmel-isc-regs.h      |  165 +++
>  drivers/media/platform/atmel/atmel-isc.c           | 1554 ++++++++++++++++++++
>  7 files changed, 1797 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/atmel-isc.txt
>  create mode 100644 drivers/media/platform/atmel/Kconfig
>  create mode 100644 drivers/media/platform/atmel/Makefile
>  create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
>  create mode 100644 drivers/media/platform/atmel/atmel-isc.c
> 
