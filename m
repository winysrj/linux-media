Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51683 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbcHQG3t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 02:29:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Songjun Wu <songjun.wu@microchip.com>
Subject: [RFC PATCH 0/7] atmel-isi: convert to a standalone driver
Date: Wed, 17 Aug 2016 08:29:36 +0200
Message-Id: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series converts the soc-camera atmel-isi to a standalone V4L2
driver.

The first 5 patches improve the ov7670 sensor driver, mostly adding modern
features such as MC and DT support.

The next patch converts the atmel-isi in-place. The final patch adds support
for this to the dts. I'm not at this moment planning to actually merge it,
it's an example only.

Once Songjun Wu's atmel-isc driver is merged I plan to make a follow-up patch
that moves this driver into the new platform/atmel directory.

Tested with my sama5d3-Xplained board and two ov7670 sensors: one with and one
without reset/pwdn pins.

Regards,

	Hans

Hans Verkuil (7):
  ov7670: add media controller support
  ov7670: call v4l2_async_register_subdev
  ov7670: fix g/s_parm
  ov7670: get xvclk
  ov7670: add devicetree support
  atmel-isi: remove dependency of the soc-camera framework
  sama5d3 dts: enable atmel-isi

 .../devicetree/bindings/media/i2c/ov7670.txt       |   44 +
 MAINTAINERS                                        |    1 +
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |   61 +-
 arch/arm/boot/dts/sama5d3.dtsi                     |    4 +-
 drivers/media/i2c/ov7670.c                         |   92 +-
 drivers/media/platform/soc_camera/Kconfig          |    3 +-
 drivers/media/platform/soc_camera/atmel-isi.c      | 1216 ++++++++++++--------
 7 files changed, 913 insertions(+), 508 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7670.txt

-- 
2.8.1

