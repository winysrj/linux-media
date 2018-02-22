Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43393 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753279AbeBVKhm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 05:37:42 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 00/10] Renesas Capture Engine Unit (CEU) V4L2 driver
Date: Thu, 22 Feb 2018 11:37:16 +0100
Message-Id: <1519295846-11612-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   Hans reported he sees a few warnings when compiling CEU driver with gcc7.3.0

I have silenced them, and the one reported in "probe" was actually a bug.
That's the diff from v10:

diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index 6624fba..cfabe1a 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -412,6 +412,9 @@ static int ceu_hw_config(struct ceu_device *ceudev)
                cfzsr   = (pix->height << 16) | pix->width;
                cdwdr   = pix->width;
                break;
+
+       default:
+               return -EINVAL;
        }

        camcr |= mbus_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
@@ -1568,8 +1571,10 @@ static int ceu_probe(struct platform_device *pdev)

        res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
        ceudev->base = devm_ioremap_resource(dev, res);
-       if (IS_ERR(ceudev->base))
+       if (IS_ERR(ceudev->base)) {
+               ret = PTR_ERR(ceudev->base);
                goto error_free_ceudev;
+       }

        ret = platform_get_irq(pdev, 0);
        if (ret < 0) {


Now that I've switch to a new compiler I see two more warnings, which are to be
ignored imo, as this behaviour is expected:

../drivers/media/platform/renesas-ceu.c: In function ‘ceu_hw_config’:
../drivers/media/platform/renesas-ceu.c:392:9: warning: this statement may fall through [-Wimplicit-fallthrough=]
   cdocr |= CEU_CDOCR_NO_DOWSAMPLE;
../drivers/media/platform/renesas-ceu.c:393:2: note: here
  case V4L2_PIX_FMT_NV12:
  ^~~~
../drivers/media/platform/renesas-ceu.c:405:9: warning: this statement may fall through [-Wimplicit-fallthrough=]
   cdocr |= CEU_CDOCR_NO_DOWSAMPLE;
../drivers/media/platform/renesas-ceu.c:406:2: note: here
  case V4L2_PIX_FMT_NV21:
  ^~~~

MAINTAINERS file update has been sent as separate series, and I guess Hans you
can now send a pull request for this driver!

Cheers!
   j

v10->v11:
- Silence two compiler warnings reported by Hans on CEU driver v10

v9->v10:
- Close 0-days warning on ov772x frame interval
- Set default format on CEU after input change
- Drop ov7670 mbus frame format set not to block this series while topic
  gets clarified

v8->v9:
- Address Laurent's review of ov772x frame rate
- Address Sergei comment on ceu node name

v7->v8:
- Calculate PLL divider/multiplier and do not use static tables
- Change RZ/A1-H to RZ/A1H (same for L) in bindings documentation
- Use rounded clock rate in Migo-R board code as SH clk_set_clk()
  implementation does not perform rounding
- Set ycbcr_enc and other fields of v4l2_mbus_format for ov772x as patch
  [11/11] does for ov7670

v6->v7:
- Add patch to handle ycbr_enc and other fields of v4l2_mbus_format for ov7670
- Add patch to handle frame interval for ov772x
- Rebased on Hans' media-tree/parm branch with v4l2_g/s_parm_cap
- Drop const modifier in CEU releated fields of Migo-R setup.c board file
  to silence complier warnings.

v5->v6:
- Add Hans' Acked-by to most patches
- Fix a bad change in ov772x get_selection
- Add .buf_prepare callack to CEU and verify plane sizes there
- Remove VB2_USERPTR from supported io_modes in CEU driver
- Remove read() fops in CEU driver

v4->v5:
- Added Rob's and Laurent's Reviewed-by tag to DT bindings
- Change CEU driver module license to "GPL v2" to match SPDX identifier as
  suggested by Philippe Ombredanne
- Make struct ceu_data static as suggested by Laurent and add his
  Reviewed-by to CEU driver.

v3->v4:
- Drop generic fallback compatible string "renesas,ceu"
- Addressed Laurent's comments on [3/9]
  - Fix error messages on irq get/request
  - Do not leak ceudev if irq_get fails
  - Make irq_mask a const field

v2->v3:
- Improved DT bindings removing standard properties (pinctrl- ones and
  remote-endpoint) not specific to this driver and improved description of
  compatible strings
- Remove ov772x's xlkc_rate property and set clock rate in Migo-R board file
- Made 'xclk' clock private to ov772x driver in Migo-R board file
- Change 'rstb' GPIO active output level and changed ov772x and tw9910 drivers
  accordingly as suggested by Fabio
- Minor changes in CEU driver to address Laurent's comments
- Moved Migo-R setup patch to the end of the series to silence 0-day bot
- Renamed tw9910 clock to 'xti' as per video decoder manual
- Changed all SPDX identifiers to GPL-2.0 from previous GPL-2.0+

v1->v2:
 - DT
 -- Addressed Geert's comments and added clocks for CEU to mstp6 clock source
 -- Specified supported generic video iterfaces properties in dt-bindings and
    simplified example

 - CEU driver
 -- Re-worked interrupt handler, interrupt management, reset(*) and capture
    start operation
 -- Re-worked querycap/enum_input/enum_frameintervals to fix some
    v4l2_compliance failures
 -- Removed soc_camera legacy operations g/s_mbus_format
 -- Update to new notifier implementation
 -- Fixed several comments from Hans, Laurent and Sakari

 - Migo-R
 -- Register clocks and gpios for sensor drivers in Migo-R setup
 -- Updated sensors (tw9910 and ov772x) drivers headers and drivers to close
    remarks from Hans and Laurent:
 --- Removed platform callbacks and handle clocks and gpios from sensor drivers
 --- Remove g/s_mbus_config operations



Jacopo Mondi (10):
  dt-bindings: media: Add Renesas CEU bindings
  include: media: Add Renesas CEU driver interface
  media: platform: Add Renesas CEU driver
  ARM: dts: r7s72100: Add Capture Engine Unit (CEU)
  media: i2c: Copy ov772x soc_camera sensor driver
  media: i2c: ov772x: Remove soc_camera dependencies
  media: i2c: ov772x: Support frame interval handling
  media: i2c: Copy tw9910 soc_camera sensor driver
  media: i2c: tw9910: Remove soc_camera dependencies
  arch: sh: migor: Use new renesas-ceu camera driver

 .../devicetree/bindings/media/renesas,ceu.txt      |   81 +
 arch/arm/boot/dts/r7s72100.dtsi                    |   15 +-
 arch/sh/boards/mach-migor/setup.c                  |  225 ++-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c             |    2 +-
 drivers/media/i2c/Kconfig                          |   20 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/ov772x.c                         | 1365 ++++++++++++++++
 drivers/media/i2c/tw9910.c                         | 1039 ++++++++++++
 drivers/media/platform/Kconfig                     |    9 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/renesas-ceu.c               | 1675 ++++++++++++++++++++
 include/media/drv-intf/renesas-ceu.h               |   26 +
 include/media/i2c/ov772x.h                         |    6 +-
 include/media/i2c/tw9910.h                         |    9 +
 14 files changed, 4344 insertions(+), 131 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
 create mode 100644 drivers/media/i2c/ov772x.c
 create mode 100644 drivers/media/i2c/tw9910.c
 create mode 100644 drivers/media/platform/renesas-ceu.c
 create mode 100644 include/media/drv-intf/renesas-ceu.h

--
2.7.4
