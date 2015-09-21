Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:43485 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756470AbbIULmK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 07:42:10 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cobalt: fix Kconfig dependency
Cc: fengguang.wu@intel.com
Message-ID: <55FFED0C.6080403@xs4all.nl>
Date: Mon, 21 Sep 2015 13:42:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cobalt driver should depend on VIDEO_V4L2_SUBDEV_API.

This fixes this kbuild error:

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   99bc7215bc60f6cd414cf1b85cd9d52cc596cccb
commit: 85756a069c55e0315ac5990806899cfb607b987f [media] cobalt: add new driver
date:   4 months ago
config: x86_64-randconfig-s0-09201514 (attached as .config)
reproduce:
  git checkout 85756a069c55e0315ac5990806899cfb607b987f
  # save the attached .config to linux build tree
  make ARCH=x86_64 

All error/warnings (new ones prefixed by >>):

   drivers/media/i2c/adv7604.c: In function 'adv76xx_get_format':
>> drivers/media/i2c/adv7604.c:1853:9: error: implicit declaration of function 'v4l2_subdev_get_try_format' [-Werror=implicit-function-declaration]
      fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
            ^
   drivers/media/i2c/adv7604.c:1853:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
          ^
   drivers/media/i2c/adv7604.c: In function 'adv76xx_set_format':
   drivers/media/i2c/adv7604.c:1882:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
          ^
   cc1: some warnings being treated as errors
--
   drivers/media/i2c/adv7842.c: In function 'adv7842_get_format':
>> drivers/media/i2c/adv7842.c:2093:9: error: implicit declaration of function 'v4l2_subdev_get_try_format' [-Werror=implicit-function-declaration]
      fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
            ^
   drivers/media/i2c/adv7842.c:2093:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
          ^
   drivers/media/i2c/adv7842.c: In function 'adv7842_set_format':
   drivers/media/i2c/adv7842.c:2125:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
          ^
   cc1: some warnings being treated as errors
--
   drivers/media/i2c/adv7511.c: In function 'adv7511_get_fmt':
>> drivers/media/i2c/adv7511.c:859:9: error: implicit declaration of function 'v4l2_subdev_get_try_format' [-Werror=implicit-function-declaration]
      fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
            ^
   drivers/media/i2c/adv7511.c:859:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
          ^
   drivers/media/i2c/adv7511.c: In function 'adv7511_set_fmt':
   drivers/media/i2c/adv7511.c:910:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
          ^
   cc1: some warnings being treated as errors

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported by: kbuild test robot <fengguang.wu@intel.com>

diff --git a/drivers/media/pci/cobalt/Kconfig b/drivers/media/pci/cobalt/Kconfig
index 1f88ccc..a01f0cc 100644
--- a/drivers/media/pci/cobalt/Kconfig
+++ b/drivers/media/pci/cobalt/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_COBALT
 	tristate "Cisco Cobalt support"
-	depends on VIDEO_V4L2 && I2C && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on PCI_MSI && MTD_COMPLEX_MAPPINGS
 	depends on GPIOLIB || COMPILE_TEST
 	depends on SND
