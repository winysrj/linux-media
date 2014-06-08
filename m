Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1636 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbaFHIgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 04:36:53 -0400
Message-ID: <53942098.9000109@xs4all.nl>
Date: Sun, 08 Jun 2014 10:36:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
CC: Steve Longerbeam <steve_longerbeam@mentor.com>,
	David Peverley <pev@audiogeek.co.uk>
Subject: Re: [PATCH 00/43] i.MX6 Video capture
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve!

On 06/07/2014 11:56 PM, Steve Longerbeam wrote:
> Hi all,
> 
> This patch set adds video capture support for the Freescale i.MX6 SOC.
> 
> It is a from-scratch standardized driver that works with community
> v4l2 utilities, such as v4l2-ctl, v4l2-cap, and the v4l2src gstreamer
> plugin. It uses the latest v4l2 interfaces (subdev, videobuf2).
> Please see Documentation/video4linux/mx6_camera.txt for it's full list
> of features!
> 
> The first 38 patches:
> 
> - prepare the ipu-v3 driver for video capture support. The current driver
>   contains only video display functionality to support the imx DRM drivers.
>   At some point ipu-v3 should be moved out from under staging/imx-drm since
>   it will no longer only support DRM.
> 
> - Adds the device tree nodes and OF graph bindings for video capture support
>   on sabrelite, sabresd, and sabreauto reference platforms.
> 
> The new i.MX6 capture host interface driver is at patch 39.
> 
> To support the sensors found on the sabrelite, sabresd, and sabreauto,
> three patches add sensor subdev's for parallel OV5642, MIPI CSI-2 OV5640,
> and the ADV7180 decoder chip, beginning at patch 40.
> 
> There is an existing adv7180 subdev driver under drivers/media/i2c, but
> it needs some extra functionality to work on the sabreauto. It will need
> OF graph bindings support and gpio for a power-on pin on the sabreauto.
> It would also need to send a new subdev notification to take advantage
> of decoder status change handling provided by the host driver. This
> feature makes it possible to correctly handle "hot" (while streaming)
> signal lock/unlock and autodetected video standard changes.

A new V4L2_EVENT_SOURCE_CHANGE event has just been added for that.

> Usage notes are found in Documentation/video4linux/mx6_camera.txt for the
> above three reference platforms.
> 
> The driver source is under drivers/staging/media/imx6/capture/.

Thank you for this patch series! Much appreciated that this hardware is
finally going to supported with a proper driver.

I did a quick scan of the driver and I noticed a few things that need
to be fixed: instead of implementing g/s_crop, implement g/s_selection:
new drivers should implement the selection API and they will get the crop
API for free.

You should use the vb2 helper functions (vb2_fop_*, vb2_ioctl_*) unless
there is a good reason not to do it. Those functions should simplify the
code and they give you proper 'streaming ownership'. See also the example
code Documentation/video4linux/v4l2-pci-skeleton.c.

Finally you should run the v4l2-compliance test tool and fix any failures.

That tool is part of git://linuxtv.org/v4l-utils.git. Always compile from
that repository to be sure you use the latest code.

Test first with 'v4l2-compliance'. When all issues are fixed, then test
with 'v4l2-compliance -s' to test actual streaming behavior as well.

When you post v2 of this patch series I want to see the output of
'v4l2-compliance -s'! New drivers should pass v4l2-compliance. However,
this is a staging driver so I won't be that strict, but it seems to be
the intention that this driver will become a mainline driver, so I would
recommend to fix any issues now rather than later.

If you have questions about v4l2-compliance it it might be easiest to
set up an irc session where we go through them. In that case mail me
so we can set up a time and date to do that. I'm in timezone UTC+2.

Regards,

	Hans

> 
> 
> Steve Longerbeam (43):
>   imx-drm: ipu-v3: Move imx-ipu-v3.h to include/linux/platform_data/
>   ARM: dts: imx6qdl: Add ipu aliases
>   imx-drm: ipu-v3: Add ipu_get_num()
>   imx-drm: ipu-v3: Add solo/dual-lite IPU device type
>   imx-drm: ipu-v3: Map IOMUXC registers
>   imx-drm: ipu-v3: Add functions to set CSI/IC source muxes
>   imx-drm: ipu-v3: Rename and add IDMAC channels
>   imx-drm: ipu-v3: Add units required for video capture
>   imx-drm: ipu-v3: Add ipu_mbus_code_to_colorspace()
>   imx-drm: ipu-v3: Add rotation mode conversion utilities
>   imx-drm: ipu-v3: Add helper function checking if pixfmt is planar
>   imx-drm: ipu-v3: Move IDMAC channel names to imx-ipu-v3.h
>   imx-drm: ipu-v3: Add ipu_idmac_buffer_is_ready()
>   imx-drm: ipu-v3: Add ipu_idmac_clear_buffer()
>   imx-drm: ipu-v3: Add ipu_idmac_current_buffer()
>   imx-drm: ipu-v3: Add __ipu_idmac_reset_current_buffer()
>   imx-drm: ipu-v3: Add ipu_stride_to_bytes()
>   imx-drm: ipu-v3: Add ipu_idmac_enable_watermark()
>   imx-drm: ipu-v3: Add ipu_idmac_lock_enable()
>   imx-drm: ipu-v3: Add idmac channel linking support
>   imx-drm: ipu-v3: Add ipu_bits_per_pixel()
>   imx-drm: ipu-v3: Add ipu-cpmem unit
>   imx-drm: ipu-cpmem: Add ipu_cpmem_set_block_mode()
>   imx-drm: ipu-cpmem: Add ipu_cpmem_set_axi_id()
>   imx-drm: ipu-cpmem: Add ipu_cpmem_set_rotation()
>   imx-drm: ipu-cpmem: Add second buffer support to ipu_cpmem_set_image()
>   imx-drm: ipu-v3: Add more planar formats support
>   imx-drm: ipu-cpmem: Add ipu_cpmem_dump()
>   imx-drm: ipu-v3: Add ipu_dump()
>   ARM: dts: imx6: add pin groups for imx6q/dl for IPU1 CSI0
>   ARM: dts: imx6qdl: Flesh out MIPI CSI2 receiver node
>   ARM: dts: imx: sabrelite: add video capture ports and endpoints
>   ARM: dts: imx6-sabresd: add video capture ports and endpoints
>   ARM: dts: imx6-sabreauto: add video capture ports and endpoints
>   ARM: dts: imx6qdl: Add simple-bus to ipu compatibility
>   gpio: pca953x: Add reset-gpios property
>   ARM: imx6q: clk: Add video 27m clock
>   media: imx6: Add device tree binding documentation
>   media: Add new camera interface driver for i.MX6
>   media: imx6: Add support for MIPI CSI-2 OV5640
>   media: imx6: Add support for Parallel OV5642
>   media: imx6: Add support for ADV7180 Video Decoder
>   ARM: imx_v6_v7_defconfig: Enable video4linux drivers
> 
>  .../devicetree/bindings/clock/imx6q-clock.txt      |    1 +
>  Documentation/devicetree/bindings/media/imx6.txt   |  433 ++
>  .../bindings/staging/imx-drm/fsl-imx-drm.txt       |    6 +-
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  Documentation/video4linux/mx6_camera.txt           |  188 +
>  arch/arm/boot/dts/imx6q.dtsi                       |    3 +-
>  arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  149 +
>  arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |   91 +
>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  116 +
>  arch/arm/boot/dts/imx6qdl.dtsi                     |   62 +-
>  arch/arm/configs/imx_v6_v7_defconfig               |    4 +
>  arch/arm/mach-imx/clk-imx6q.c                      |    3 +-
>  drivers/gpio/gpio-pca953x.c                        |   26 +
>  drivers/staging/imx-drm/imx-hdmi.c                 |    2 +-
>  drivers/staging/imx-drm/imx-tve.c                  |    2 +-
>  drivers/staging/imx-drm/ipu-v3/Makefile            |    3 +-
>  drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h        |  326 --
>  drivers/staging/imx-drm/ipu-v3/ipu-common.c        | 1151 ++++--
>  drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c         |  814 ++++
>  drivers/staging/imx-drm/ipu-v3/ipu-csi.c           |  821 ++++
>  drivers/staging/imx-drm/ipu-v3/ipu-dc.c            |    2 +-
>  drivers/staging/imx-drm/ipu-v3/ipu-di.c            |    2 +-
>  drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c          |    2 +-
>  drivers/staging/imx-drm/ipu-v3/ipu-dp.c            |    2 +-
>  drivers/staging/imx-drm/ipu-v3/ipu-ic.c            |  835 ++++
>  drivers/staging/imx-drm/ipu-v3/ipu-irt.c           |  103 +
>  drivers/staging/imx-drm/ipu-v3/ipu-prv.h           |  126 +-
>  drivers/staging/imx-drm/ipu-v3/ipu-smfc.c          |  348 ++
>  drivers/staging/imx-drm/ipuv3-crtc.c               |    2 +-
>  drivers/staging/imx-drm/ipuv3-plane.c              |   18 +-
>  drivers/staging/media/Kconfig                      |    2 +
>  drivers/staging/media/Makefile                     |    1 +
>  drivers/staging/media/imx6/Kconfig                 |   25 +
>  drivers/staging/media/imx6/Makefile                |    1 +
>  drivers/staging/media/imx6/capture/Kconfig         |   33 +
>  drivers/staging/media/imx6/capture/Makefile        |    7 +
>  drivers/staging/media/imx6/capture/adv7180.c       | 1298 ++++++
>  drivers/staging/media/imx6/capture/mipi-csi2.c     |  322 ++
>  drivers/staging/media/imx6/capture/mx6-camif.c     | 2235 ++++++++++
>  drivers/staging/media/imx6/capture/mx6-camif.h     |  197 +
>  drivers/staging/media/imx6/capture/mx6-encode.c    |  775 ++++
>  drivers/staging/media/imx6/capture/mx6-preview.c   |  748 ++++
>  drivers/staging/media/imx6/capture/ov5640-mipi.c   | 2158 ++++++++++
>  drivers/staging/media/imx6/capture/ov5642.c        | 4258 ++++++++++++++++++++
>  include/linux/platform_data/imx-ipu-v3.h           |  425 ++
>  include/media/imx6.h                               |   18 +
>  46 files changed, 17340 insertions(+), 805 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/imx6.txt
>  create mode 100644 Documentation/video4linux/mx6_camera.txt
>  delete mode 100644 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
>  create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
>  create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-csi.c
>  create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-ic.c
>  create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-irt.c
>  create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-smfc.c
>  create mode 100644 drivers/staging/media/imx6/Kconfig
>  create mode 100644 drivers/staging/media/imx6/Makefile
>  create mode 100644 drivers/staging/media/imx6/capture/Kconfig
>  create mode 100644 drivers/staging/media/imx6/capture/Makefile
>  create mode 100644 drivers/staging/media/imx6/capture/adv7180.c
>  create mode 100644 drivers/staging/media/imx6/capture/mipi-csi2.c
>  create mode 100644 drivers/staging/media/imx6/capture/mx6-camif.c
>  create mode 100644 drivers/staging/media/imx6/capture/mx6-camif.h
>  create mode 100644 drivers/staging/media/imx6/capture/mx6-encode.c
>  create mode 100644 drivers/staging/media/imx6/capture/mx6-preview.c
>  create mode 100644 drivers/staging/media/imx6/capture/ov5640-mipi.c
>  create mode 100644 drivers/staging/media/imx6/capture/ov5642.c
>  create mode 100644 include/linux/platform_data/imx-ipu-v3.h
>  create mode 100644 include/media/imx6.h
> 

