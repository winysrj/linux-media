Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36521 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbdGaHV3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 03:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <1501470460-12014-1-git-send-email-jacob-chen@iotwrt.com>
References: <1501470460-12014-1-git-send-email-jacob-chen@iotwrt.com>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Mon, 31 Jul 2017 15:21:27 +0800
Message-ID: <CAFLEztRRq5Eep+c20h_=a+uf30egAYfPmX75=K+F6XnQ2N1+zg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Add Rockchip RGA V4l2 support
To: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        robh+dt@kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        laurent.pinchart+renesas@ideasonboard.com,
        Hans Verkuil <hans.verkuil@cisco.com>, s.nawrocki@samsung.com,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Jacob Chen <jacob-chen@iotwrt.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


2017-07-31 11:07 GMT+08:00 Jacob Chen <jacob-chen@iotwrt.com>:
> This patch series add a v4l2 m2m drvier for rockchip RGA direct rendering based 2d graphics acceleration module.
>
> Before, my colleague yakir have write a drm RGA drvier and send it to the lists.
> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-March/416769.html
> I have been asked to find a userspace user("compositor") for it, but after some studys, my conclusion is that unlike exynos g2d,
> rockchip rga are not suitable for compositor. Rockchip RGA have a limited MMU, which means it can only hold several buffers in the same time.
> When it was used in compositor, it will waste a lot of time to import/export/flush buffer, resulting in a bad performance.
>
> A few months ago, i saw a discussion in dri-devel@lists.freedesktop.org.
> It remind that we could write a v4l2 m2m RGA driver, since we usually use RGA for streaming purpose.
> https://patches.linaro.org/cover/97727/
>
> I have test this driver with gstreamer v4l2transform plugin and it seems work well.
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
> Jacob Chen (5):
>   [media] v4l: add blend modes controls
>   [media]: rockchip/rga: v4l2 m2m support
>   ARM: dts: rockchip: add RGA device node for RK3288
>   ARM: dts: rockchip: add RGA device node for RK3399
>   dt-bindings: Document the Rockchip RGA bindings
>
>  .../devicetree/bindings/media/rockchip-rga.txt     |  33 +
>  arch/arm/boot/dts/rk3288.dtsi                      |  11 +
>  arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  11 +
>  drivers/media/platform/Kconfig                     |  11 +
>  drivers/media/platform/Makefile                    |   2 +
>  drivers/media/platform/rockchip-rga/Makefile       |   3 +
>  drivers/media/platform/rockchip-rga/rga-buf.c      | 141 +++
>  drivers/media/platform/rockchip-rga/rga-hw.c       | 650 ++++++++++++++
>  drivers/media/platform/rockchip-rga/rga-hw.h       | 437 +++++++++
>  drivers/media/platform/rockchip-rga/rga.c          | 987 +++++++++++++++++++++
>  drivers/media/platform/rockchip-rga/rga.h          | 110 +++
>  drivers/media/v4l2-core/v4l2-ctrls.c               |  20 +-
>  include/uapi/linux/v4l2-controls.h                 |  16 +-
>  13 files changed, 2430 insertions(+), 2 deletions(-)
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

We are going to use this driver in our BSP, and write userspace for it.
Though there are some work needed be done for better use, i'm
satisfied with it at present.
It could be improved through usage.
