Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:38040 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbaK1KYb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 05:24:31 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<g.liakhovetski@gmx.de>, <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 0/4] media: ov2640: add device tree support
Date: Fri, 28 Nov 2014 18:24:44 +0800
Message-ID: <1417170288-11112-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add device tree support for ov2640. And also add
the document for the devicetree properties.

Josh Wu (4):
  media: ov2640: add async probe function
  media: ov2640: add primary dt support
  media: ov2640: add a master clock for sensor
  media: ov2640: dt: add the device tree binding document

 .../devicetree/bindings/media/i2c/ov2640.txt       |  43 ++++++
 drivers/media/i2c/soc_camera/ov2640.c              | 151 ++++++++++++++++++---
 2 files changed, 178 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2640.txt

-- 
1.9.1

