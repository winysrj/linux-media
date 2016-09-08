Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33248 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752826AbcIHJKZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 05:10:25 -0400
Received: by mail-wm0-f66.google.com with SMTP id b187so2850065wme.0
        for <linux-media@vger.kernel.org>; Thu, 08 Sep 2016 02:10:24 -0700 (PDT)
Subject: Re: [PATCH v3 00/10] v4l: platform: Add Renesas R-Car FDP1 Driver
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <a26f4ec8-91be-9de3-a943-06b509c2ec38@bingham.xyz>
Date: Thu, 8 Sep 2016 10:10:22 +0100
MIME-Version: 1.0
In-Reply-To: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/16 23:25, Laurent Pinchart wrote:
> Hello,

Thanks for all of your efforts here!

> Here's the third version of the Renesas R-Car FDP1 driver.
> 
> The FDP1 (Fine Display Processor) is a hardware memory-to-memory de-interlacer
> device, with capability to convert from various YCbCr/YUV formats to both
> YCbCr/YUV and RGB formats at the same time as converting interlaced content to
> progressive.
> 
> Patch 01/10 fixes an issue in the V4L2 ioctl handling core code. It has been
> posted before and hasn't been changed.
> 
> Patch 02/10 adds a new standard V4L2 menu control for the deinterlacing mode.
> The menu items are driver specific.
> 
> Patch 03/10 extends the FCP driver to support the FDP1. It has been posted
> before and hasn't been changed.
> 
> Patch 04/10 adds the FDP1 driver unchanged compared to the v2 posted by
> Kieran. Patches 05/10 to 09/10 then fix issues in the driver and incorporate
> review comments. They will eventually be squashed into patch 04/10, but are
> currently separate to allow easier review of the changes.
> 
> Patch 10/10 reworks buffer handling in the FDP1 driver. This is experimental
> and doesn't fix any known bug. I've included the patch in the series to get
> feedback on whether this is a good idea.
> 
> Kieran, I noticed that your patches are authored by
> 
> 	Kieran Bingham <kieran@ksquared.org.uk>
> 
> Is that correct or should it be changed to
> 
> 	Kieran Bingham <kieran+renesas@bingham.xyz>

Yes, @bingham.xyz is preferred.

Google is rewriting my outgoing mail address.
I fear I may have to set up my own mail server :(

I've had a quick look through the extra patches. I will try to reply to
each of them when I get chance. (I've just done the first two easy ones
so far)
--
Regards

Kieran

> 
> ?
> 
> Here is the V4L2 compliance report.
> 
> v4l2-compliance SHA   : abc1453dfe89f244dccd3460d8e1a2e3091cbadb
> 
> Driver Info:
>         Driver name   : rcar_fdp1
>         Card type     : rcar_fdp1
>         Bus info      : platform:rcar_fdp1
>         Driver version: 4.8.0
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
>                 Standard Controls: 5 Private Controls: 0
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
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
> 
> Geert Uytterhoeven (1):
>   v4l: fdp1: vb2_queue dev conversion
> 
> Kieran Bingham (2):
>   v4l: Extend FCP compatible list to support the FDP
>   v4l: Add Renesas R-Car FDP1 Driver
> 
> Laurent Pinchart (7):
>   v4l: ioctl: Clear the v4l2_pix_format_mplane reserved field
>   v4l: ctrls: Add deinterlacing mode control
>   v4l: fdp1: Incorporate miscellaneous review comments
>   v4l: fdp1: Remove unused struct fdp1_v4l2_buffer
>   v4l: fdp1: Rewrite format setting code
>   v4l: fdp1: Fix field validation when preparing buffer
>   v4l: fdp1: Store buffer information in vb2 buffer
> 
>  Documentation/media/uapi/v4l/extended-controls.rst |    4 +
>  MAINTAINERS                                        |    9 +
>  drivers/media/platform/Kconfig                     |   13 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/rcar-fcp.c                  |    1 +
>  drivers/media/platform/rcar_fdp1.c                 | 2456 ++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c               |    2 +
>  drivers/media/v4l2-core/v4l2-ioctl.c               |    8 +-
>  include/uapi/linux/v4l2-controls.h                 |    1 +
>  9 files changed, 2491 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/media/platform/rcar_fdp1.c
> 

-- 
Regards

Kieran Bingham
