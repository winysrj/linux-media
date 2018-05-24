Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36954 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968866AbeEXLaW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 07:30:22 -0400
Received: by mail-wm0-f66.google.com with SMTP id l1-v6so4255053wmb.2
        for <linux-media@vger.kernel.org>; Thu, 24 May 2018 04:30:21 -0700 (PDT)
References: <20180523092423.4386-1-p.zabel@pengutronix.de>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Rui Miguel Silva <rui.silva@linaro.org>,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] media: video-mux: fix compliance failures
In-reply-to: <20180523092423.4386-1-p.zabel@pengutronix.de>
Date: Thu, 24 May 2018 12:30:19 +0100
Message-ID: <m3o9h570l0.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
On Wed 23 May 2018 at 09:24, Philipp Zabel wrote:
> Limit frame sizes to the [1, 65536] interval, media bus formats 
> to
> the available list of formats, and initialize pad and try 
> formats.
>
> Reported-by: Rui Miguel Silva <rui.silva@linaro.org>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>  - Limit to [1, 65536] instead of [1, UINT_MAX - 1]
>  - Add missing break in default case
>  - Use .init_cfg pad op instead of .open internal op
> ---

FWIW, in i.MX7:
Tested-by: Rui Miguel Silva <rui.silva@linaro.org>

v4l2-compliance SHA   : 47d43b130dc6e9e0edc900759fb37649208371e4

Compliance test for device /dev/v4l-subdev1:

Media Driver Info:
        Driver name      : imx7-csi
        Model            : imx-media
        Serial           : 
        Bus info         : 
        Media version    : 4.17.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.17.0
Interface Info:
        ID               : 0x0300001b
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x0000000a (10)
        Name             : csi_mux
        Function         : Video Muxer
        Pad 0x0100000b   : Sink
        Pad 0x0100000c   : Sink
          Link 0x02000013: from remote pad 0x1000010 of entity 
          'imx7-mipi-csis.0': Data, Enabled
        Pad 0x0100000d   : Source
          Link 0x02000015: to remote pad 0x1000002 of entity 
          'csi': Data, Enabled

Required ioctls:
        test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
        test second /dev/v4l-subdev1 open: OK
        test for unlimited opens: OK

Debug ioctls:
        test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_ENUMAUDOUT: OK (Not Supported)
        test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDOUT: OK (Not Supported)
        Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
        test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
        test VIDIOC_G/S_EDID: OK (Not Supported)

Sub-Device ioctls (Sink Pad 0):
        test Try 
        VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK 
        (Not Supported)
        test Try VIDIOC_SUBDEV_G/S_FMT: OK
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not 
        Supported)
        test Active 
        VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK 
        (Not Supported)
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not 
        Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Sink Pad 1):
        test Try 
        VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK 
        (Not Supported)
        test Try VIDIOC_SUBDEV_G/S_FMT: OK
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not 
        Supported)
        test Active 
        VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK 
        (Not Supported)
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not 
        Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 2):
        test Try 
        VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK 
        (Not Supported)
        test Try VIDIOC_SUBDEV_G/S_FMT: OK
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not 
        Supported)
        test Active 
        VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK 
        (Not Supported)
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not 
        Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
        test VIDIOC_QUERYCTRL: OK (Not Supported)
        test VIDIOC_G/S_CTRL: OK (Not Supported)
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not 
        Supported)
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 0 Private Controls: 0

Format ioctls:
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not 
        Supported)
        test VIDIOC_G/S_PARM: OK (Not Supported)
        test VIDIOC_G_FBUF: OK (Not Supported)
        test VIDIOC_G_FMT: OK (Not Supported)
        test VIDIOC_TRY_FMT: OK (Not Supported)
        test VIDIOC_S_FMT: OK (Not Supported)
        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
        test Cropping: OK (Not Supported)
        test Composing: OK (Not Supported)
        test Scaling: OK (Not Supported)

Codec ioctls:
        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not 
        Supported)
        test VIDIOC_EXPBUF: OK (Not Supported)

Total: 61, Succeeded: 61, Failed: 0, Warnings: 0
