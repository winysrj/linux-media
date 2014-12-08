Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:19723 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbaLHLaK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 06:30:10 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<g.liakhovetski@gmx.de>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 0/5] media: ov2640: add device tree support
Date: Mon, 8 Dec 2014 19:29:02 +0800
Message-ID: <1418038147-13221-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add device tree support for ov2640. And also add
the document for the devicetree properties.

v1 -> v2:
  1.  modified the dt bindings according to Laurent's suggestion.
  2. add a fix patch for soc_camera. Otherwise the .reset() function won't work.

Josh Wu (5):
  media: soc-camera: use icd->control instead of icd->pdev for reset()
  media: ov2640: add async probe function
  media: ov2640: add primary dt support
  media: ov2640: add a master clock for sensor
  media: ov2640: dt: add the device tree binding document

 .../devicetree/bindings/media/i2c/ov2640.txt       |  44 +++++++
 drivers/media/i2c/soc_camera/ov2640.c              | 140 ++++++++++++++++++---
 drivers/media/platform/soc_camera/soc_camera.c     |  10 +-
 3 files changed, 173 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2640.txt

-- 
1.9.1

