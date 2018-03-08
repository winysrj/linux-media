Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:56054 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755449AbeCHMCF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 07:02:05 -0500
Date: Thu, 8 Mar 2018 14:02:00 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        devicetree@vger.kernel.org, heiko@sntech.de,
        Jacob Chen <jacob2.chen@rock-chips.com>
Subject: Re: [PATCH v6 00/17] Rockchip ISP1 Driver
Message-ID: <20180308120200.wpcjnbglf4x32vrp@tarshish>
References: <20180308094807.9443-1-jacob-chen@iotwrt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180308094807.9443-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

On Thu, Mar 08, 2018 at 05:47:50PM +0800, Jacob Chen wrote:
> This patch series add a ISP(Camera) v4l2 driver for rockchip rk3288/rk3399 
> SoC.
> 
> Wiki Pages:
> http://opensource.rock-chips.com/wiki_Rockchip-isp1
> 
> The deprecated g_mbus_config op is not dropped in  V6 because i am waiting 
> tomasz's patches.

Which tree is this series based on? On top of v4.16-rc4 I get the build 
failure below. The V4L2_BUF_TYPE_META_OUTPUT macro, for example, is not even 
in media_tree.git.

drivers/media/platform/rockchip/isp1/isp_params.c:1321:3: error: ‘const struct v4l2_ioctl_ops’ has no member named ‘vidioc_enum_fmt_meta_out’; did you mean ‘vidioc_enum_fmt_meta_cap’?
  .vidioc_enum_fmt_meta_out = rkisp1_params_enum_fmt_meta_out,
   ^~~~~~~~~~~~~~~~~~~~~~~~
   vidioc_enum_fmt_meta_cap
drivers/media/platform/rockchip/isp1/isp_params.c:1321:30: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
  .vidioc_enum_fmt_meta_out = rkisp1_params_enum_fmt_meta_out,
                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/media/platform/rockchip/isp1/isp_params.c:1321:30: note: (near initialization for ‘rkisp1_params_ioctl.vidioc_g_std’)
drivers/media/platform/rockchip/isp1/isp_params.c:1322:3: error: ‘const struct v4l2_ioctl_ops’ has no member named ‘vidioc_g_fmt_meta_out’; did you mean ‘vidioc_g_fmt_meta_cap’?
  .vidioc_g_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
   ^~~~~~~~~~~~~~~~~~~~~
   vidioc_g_fmt_meta_cap
drivers/media/platform/rockchip/isp1/isp_params.c:1322:27: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
  .vidioc_g_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/media/platform/rockchip/isp1/isp_params.c:1322:27: note: (near initialization for ‘rkisp1_params_ioctl.vidioc_s_std’)
drivers/media/platform/rockchip/isp1/isp_params.c:1323:3: error: ‘const struct v4l2_ioctl_ops’ has no member named ‘vidioc_s_fmt_meta_out’; did you mean ‘vidioc_s_fmt_meta_cap’?
  .vidioc_s_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
   ^~~~~~~~~~~~~~~~~~~~~
   vidioc_s_fmt_meta_cap
drivers/media/platform/rockchip/isp1/isp_params.c:1323:27: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
  .vidioc_s_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/media/platform/rockchip/isp1/isp_params.c:1323:27: note: (near initialization for ‘rkisp1_params_ioctl.vidioc_querystd’)
drivers/media/platform/rockchip/isp1/isp_params.c:1324:3: error: ‘const struct v4l2_ioctl_ops’ has no member named ‘vidioc_try_fmt_meta_out’; did you mean ‘vidioc_try_fmt_meta_cap’?
  .vidioc_try_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
   ^~~~~~~~~~~~~~~~~~~~~~~
   vidioc_try_fmt_meta_cap
drivers/media/platform/rockchip/isp1/isp_params.c:1324:29: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
  .vidioc_try_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/media/platform/rockchip/isp1/isp_params.c:1324:29: note: (near initialization for ‘rkisp1_params_ioctl.vidioc_enum_input’)
drivers/media/platform/rockchip/isp1/isp_params.c: In function ‘rkisp1_params_init_vb2_queue’:
drivers/media/platform/rockchip/isp1/isp_params.c:1462:12: error: ‘V4L2_BUF_TYPE_META_OUTPUT’ undeclared (first use in this function); did you mean ‘V4L2_BUF_TYPE_SDR_OUTPUT’?
  q->type = V4L2_BUF_TYPE_META_OUTPUT;
            ^~~~~~~~~~~~~~~~~~~~~~~~~
            V4L2_BUF_TYPE_SDR_OUTPUT
drivers/media/platform/rockchip/isp1/isp_params.c:1462:12: note: each undeclared identifier is reported only once for each function it appears in
  CC      drivers/media/platform/rockchip/isp1/mipi_dphy_sy.o
drivers/media/platform/rockchip/isp1/isp_params.c: In function ‘rkisp1_register_params_vdev’:
drivers/media/platform/rockchip/isp1/isp_params.c:1507:43: error: ‘V4L2_CAP_META_OUTPUT’ undeclared (first use in this function); did you mean ‘V4L2_CAP_VBI_OUTPUT’?
  vdev->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_META_OUTPUT;
                                           ^~~~~~~~~~~~~~~~~~~~
                                           V4L2_CAP_VBI_OUTPUT

Thanks,
baruch

> Jacob Chen (12):
>   media: doc: add document for rkisp1 meta buffer format
>   media: rkisp1: add Rockchip MIPI Synopsys DPHY driver
>   media: rkisp1: add Rockchip ISP1 subdev driver
>   media: rkisp1: add ISP1 statistics driver
>   media: rkisp1: add ISP1 params driver
>   media: rkisp1: add capture device driver
>   media: rkisp1: add rockchip isp1 core driver
>   dt-bindings: Document the Rockchip ISP1 bindings
>   dt-bindings: Document the Rockchip MIPI RX D-PHY bindings
>   ARM: dts: rockchip: add isp node for rk3288
>   ARM: dts: rockchip: add rx0 mipi-phy for rk3288
>   MAINTAINERS: add entry for Rockchip ISP1 driver
> 
> Jeffy Chen (1):
>   media: rkisp1: Add user space ABI definitions
> 
> Shunqian Zheng (3):
>   media: videodev2.h, v4l2-ioctl: add rkisp1 meta buffer format
>   arm64: dts: rockchip: add isp0 node for rk3399
>   arm64: dts: rockchip: add rx0 mipi-phy for rk3399
> 
> Wen Nuan (1):
>   ARM: dts: rockchip: Add dts mipi-dphy TXRX1 node for rk3288
> 
>  .../devicetree/bindings/media/rockchip-isp1.txt    |   69 +
>  .../bindings/media/rockchip-mipi-dphy.txt          |   90 +
>  Documentation/media/uapi/v4l/meta-formats.rst      |    2 +
>  .../media/uapi/v4l/pixfmt-meta-rkisp1-params.rst   |   20 +
>  .../media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst     |   18 +
>  MAINTAINERS                                        |   10 +
>  arch/arm/boot/dts/rk3288.dtsi                      |   33 +
>  arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   25 +
>  drivers/media/platform/Kconfig                     |   10 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/rockchip/isp1/Makefile      |    8 +
>  drivers/media/platform/rockchip/isp1/capture.c     | 1751 ++++++++++++++++++++
>  drivers/media/platform/rockchip/isp1/capture.h     |  167 ++
>  drivers/media/platform/rockchip/isp1/common.h      |  110 ++
>  drivers/media/platform/rockchip/isp1/dev.c         |  626 +++++++
>  drivers/media/platform/rockchip/isp1/dev.h         |   93 ++
>  drivers/media/platform/rockchip/isp1/isp_params.c  | 1539 +++++++++++++++++
>  drivers/media/platform/rockchip/isp1/isp_params.h  |   49 +
>  drivers/media/platform/rockchip/isp1/isp_stats.c   |  508 ++++++
>  drivers/media/platform/rockchip/isp1/isp_stats.h   |   58 +
>  .../media/platform/rockchip/isp1/mipi_dphy_sy.c    |  868 ++++++++++
>  .../media/platform/rockchip/isp1/mipi_dphy_sy.h    |   15 +
>  drivers/media/platform/rockchip/isp1/regs.c        |  239 +++
>  drivers/media/platform/rockchip/isp1/regs.h        | 1550 +++++++++++++++++
>  drivers/media/platform/rockchip/isp1/rkisp1.c      | 1177 +++++++++++++
>  drivers/media/platform/rockchip/isp1/rkisp1.h      |  105 ++
>  drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +
>  include/uapi/linux/rkisp1-config.h                 |  798 +++++++++
>  include/uapi/linux/videodev2.h                     |    4 +
>  29 files changed, 9945 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-isp1.txt
>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-params.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst
>  create mode 100644 drivers/media/platform/rockchip/isp1/Makefile
>  create mode 100644 drivers/media/platform/rockchip/isp1/capture.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/capture.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/common.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/dev.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/dev.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_stats.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_stats.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/mipi_dphy_sy.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/mipi_dphy_sy.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/regs.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/regs.h
>  create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.h
>  create mode 100644 include/uapi/linux/rkisp1-config.h
> 
> -- 
> 2.16.1
> 

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
