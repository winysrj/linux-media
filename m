Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:17688 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754112AbcIOHna (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 03:43:30 -0400
Subject: Re: [PATCH 0/3] Add Mediatek JPEG Decoder
To: Rick Chang <rick.chang@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <1473834993-1196-1-git-send-email-rick.chang@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mediatek@lists.infradead.org, srv_heupstream@mediatek.com,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <62f27741-e5e9-e1df-5698-3198259c7c9e@cisco.com>
Date: Thu, 15 Sep 2016 09:43:21 +0200
MIME-Version: 1.0
In-Reply-To: <1473834993-1196-1-git-send-email-rick.chang@mediatek.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rick,

I'm not sure why, but for some reason this patch series never made it to 
the linux-media mailinglist.

Can you repost?

Regards,

	Hans

On 09/14/2016 08:36 AM, Rick Chang wrote:
> This series of patches provide a v4l2 driver to control Mediatek JPEG hw
> for decoding JPEG image and Motion JPEG bitstream.
>
> * Dependency
> The patch "arm: dts: mt2701: Add node for JPEG decoder" depends on:
>   CCF "arm: dts: mt2701: Add clock controller device nodes"[1]
>   power domain patch "Mediatek MT2701 SCPSYS power domain support v7"[2]
>   iommu and smi "Add the dtsi node of iommu and smi for mt2701"[3]
>
> [1] https://patchwork.kernel.org/patch/9109081
> [2] http://lists.infradead.org/pipermail/linux-mediatek/2016-May/005429.html
> [3] https://patchwork.kernel.org/patch/9164013/
>
> * Compliance test
> v4l2-compliance SHA   : abc1453dfe89f244dccd3460d8e1a2e3091cbadb
>
> Driver Info:
>         Driver name   : mtk-jpeg decode
>         Card type     : mtk-jpeg decoder
>         Bus info      : platform:15004000.jpegdec
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
> Compliance test for device /dev/video3 (not using libv4l2):
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
>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK
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
>
> Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
>
> Rick Chang (3):
>   dt-bindings: mediatek: Add a binding for Mediatek JPEG Decoder
>   vcodec: mediatek: Add Mediatek JPEG Decoder Driver
>   arm: dts: mt2701: Add node for Mediatek JPEG Decoder
>
>  .../bindings/media/mediatek-jpeg-codec.txt         |   35 +
>  arch/arm/boot/dts/mt2701.dtsi                      |   14 +
>  drivers/media/platform/Kconfig                     |   15 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/mtk-jpeg/Makefile           |    4 +
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    | 1271 ++++++++++++++++++++
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h    |  141 +++
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c      |  417 +++++++
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h      |   91 ++
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c   |  160 +++
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h   |   25 +
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h     |   58 +
>  12 files changed, 2233 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
>  create mode 100644 drivers/media/platform/mtk-jpeg/Makefile
>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h
>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c
>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h
>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c
>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h
>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h
>

