Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40102 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752544AbdJPUbs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 16:31:48 -0400
From: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [GIT PULL for v4.14-rc6] media fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <f89cef26-8003-96cb-a1eb-f9dbe1c0a9d2@infradead.org>
Date: Mon, 16 Oct 2017 13:31:45 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v4.14-2

For the following media core fixes:

   - cec: Respond to unregistered initiators, when applicable
   - dvb_frontend: only use kref after initialized

and the following driver-specific fixes:

   - qcom, camss: Make function vfe_set_selection static
   - qcom: VIDEO_QCOM_CAMSS should depend on HAS_DMA
   - s5p-cec: add NACK detection support
   - media: staging/imx: Fix uninitialized variable warning
   - dib3000mc: i2c transfers over usb cannot be done from stack
   - venus: init registered list on streamoff

Thanks!
Mauro

-

The following changes since commit 1efdf1776e2253b77413c997bed862410e4b6aaf:

  media: leds: as3645a: add V4L2_FLASH_LED_CLASS dependency (2017-09-05 16:32:45 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v4.14-2

for you to fetch changes up to ead666000a5fe34bdc82d61838e4df2d416ea15e:

  media: dvb_frontend: only use kref after initialized (2017-10-11 12:47:36 -0400)

----------------------------------------------------------------
media fixes for v4.14-rc6

----------------------------------------------------------------
Colin Ian King (1):
      media: qcom: camss: Make function vfe_set_selection static

Geert Uytterhoeven (1):
      media: platform: VIDEO_QCOM_CAMSS should depend on HAS_DMA

Hans Verkuil (1):
      media: s5p-cec: add NACK detection support

Jose Abreu (1):
      media: cec: Respond to unregistered initiators, when applicable

Laurent Pinchart (1):
      media: staging/imx: Fix uninitialized variable warning

Mauro Carvalho Chehab (1):
      media: dvb_frontend: only use kref after initialized

Sean Young (1):
      media: dvb: i2c transfers over usb cannot be done from stack

Stanimir Varbanov (1):
      media: venus: init registered list on streamoff

 drivers/media/cec/cec-adap.c                       | 13 +++--
 drivers/media/dvb-core/dvb_frontend.c              | 25 +++++++--
 drivers/media/dvb-frontends/dib3000mc.c            | 50 ++++++++++++++----
 drivers/media/dvb-frontends/dvb-pll.c              | 22 ++++++--
 drivers/media/platform/Kconfig                     |  2 +-
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c |  2 +-
 drivers/media/platform/qcom/venus/helpers.c        |  1 +
 .../media/platform/s5p-cec/exynos_hdmi_cecctrl.c   |  3 +-
 drivers/media/platform/s5p-cec/s5p_cec.c           | 11 +++-
 drivers/media/platform/s5p-cec/s5p_cec.h           |  2 +
 drivers/media/tuners/mt2060.c                      | 59 +++++++++++++++++-----
 drivers/staging/media/imx/imx-media-dev.c          |  4 +-
 12 files changed, 153 insertions(+), 41 deletions(-)


-- 

Cheers,
Mauro
