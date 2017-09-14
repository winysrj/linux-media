Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:37227 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdINBUk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 21:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <1505351957-14479-1-git-send-email-jacob-chen@iotwrt.com>
References: <1505351957-14479-1-git-send-email-jacob-chen@iotwrt.com>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Thu, 14 Sep 2017 09:20:39 +0800
Message-ID: <CAFLEztTZPjuCpY=WvvKOHCpjM7Ao=b2mUayb-rKbgEBEa1NpTg@mail.gmail.com>
Subject: Re: [PATCH v9 0/4] Add Rockchip RGA V4l2 support
To: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>, robh+dt@kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        laurent.pinchart+renesas@ideasonboard.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Jacob Chen <jacob-chen@iotwrt.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,


2017-09-14 9:19 GMT+08:00 Jacob Chen <jacob-chen@iotwrt.com>:
> This patch series add a v4l2 m2m drvier for rockchip RGA direct rendering based 2d graphics acceleration module.
>
> Recently I tried to add protduff support for gstreamer on rockchip platform, and i found that API
> were not very suitable for my purpose.
> It shouldn't go upstream until we can figure out what people need,
>
> change in V9:
> - remove protduff things
> - test with the latest v4l2-compliance
>
> change in V8:
> - remove protduff things
>
> change in V6,V7:
> - correct warning in checkpatch.pl
>
> change in V5:
> - v4l2-compliance: handle invalid pxielformat
> - v4l2-compliance: add subscribe_event
> - add colorspace support
>
> change in V4:
> - document the controls.
> - change according to Hans's comments
>
> change in V3:
> - rename the controls.
> - add pm_runtime support.
> - enable node by default.
> - correct spelling in documents.
>
> change in V2:
> - generalize the controls.
> - map buffers (10-50 us) in every cmd-run rather than in buffer-import to avoid get_free_pages failed on
> actively used systems.
> - remove status in dt-bindings examples.
>
> Jacob Chen (4):
>   rockchip/rga: v4l2 m2m support
>   ARM: dts: rockchip: add RGA device node for RK3288
>   arm64: dts: rockchip: add RGA device node for RK3399
>   dt-bindings: Document the Rockchip RGA bindings
>
>  .../devicetree/bindings/media/rockchip-rga.txt     |   33 +
>  arch/arm/boot/dts/rk3288.dtsi                      |   11 +
>  arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   11 +
>  drivers/media/platform/Kconfig                     |   11 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/rockchip-rga/Makefile       |    3 +
>  drivers/media/platform/rockchip-rga/rga-buf.c      |  156 +++
>  drivers/media/platform/rockchip-rga/rga-hw.c       |  435 +++++++++
>  drivers/media/platform/rockchip-rga/rga-hw.h       |  437 +++++++++
>  drivers/media/platform/rockchip-rga/rga.c          | 1030 ++++++++++++++++++++
>  drivers/media/platform/rockchip-rga/rga.h          |  110 +++
>  11 files changed, 2239 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-rga.txt
>  create mode 100644 drivers/media/platform/rockchip-rga/Makefile
>  create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
>  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
>  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
>  create mode 100644 drivers/media/platform/rockchip-rga/rga.c
>  create mode 100644 drivers/media/platform/rockchip-rga/rga.h
>
> --
> 2.7.4
>


v4l2-compliance SHA   : d7c41e2576c09f37b33fe8bf2e38615703086045

Driver Info:
        Driver name   : rockchip-rga
        Card type     : rockchip-rga
        Bus info      : platform:rga
        Driver version: 4.13.0
        Capabilities  : 0x84208000
                Video Memory-to-Memory
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04208000
                Video Memory-to-Memory
                Streaming
                Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK
        test for unlimited opens: OK

Debug ioctls:
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
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

        Control ioctls:
                test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                test VIDIOC_QUERYCTRL: OK
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 5 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK (Not Supported)
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                fail: v4l2-test-formats.cpp(796):
fmt_cap.g_colorspace() != col
                test VIDIOC_S_FMT: FAIL
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK
                test Composing: OK
                test Scaling: OK

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK

Test input 0:


Total: 43, Succeeded: 42, Failed: 1, Warnings: 0
