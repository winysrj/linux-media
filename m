Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:23002 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759584AbaGYKNq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 06:13:46 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<laurent.pinchart@ideasonboard.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v3 0/3] media: atmel-isi: Add DT support for Atmel ISI driver
Date: Fri, 25 Jul 2014 18:13:37 +0800
Message-ID: <1406283219-32015-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add DT support for atmel ISI driver. It can support the
common v4l2 DT interfaces.

v2 -> v3:
  support bus-width property for atmel-isi endpoint.

v1 -> v2:
  modified the device tree binding document to remove an optonal property.

Josh Wu (3):
  atmel-isi: add v4l2 async probe support
  atmel-isi: convert the pdata from pointer to structure
  atmel-isi: add primary DT support

 .../devicetree/bindings/media/atmel-isi.txt        | 51 +++++++++++++
 drivers/media/platform/soc_camera/atmel-isi.c      | 89 +++++++++++++++++++---
 include/media/atmel-isi.h                          |  4 +
 3 files changed, 132 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isi.txt

-- 
1.9.1

