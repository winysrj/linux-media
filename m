Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:54533 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaCYKrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 06:47:09 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
	<nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
	<laurent.pinchart@ideasonboard.com>, <josh.wu@atmel.com>
Subject: [PATCH v2 0/3] [media] atmel-isi: Add DT support for Atmel ISI driver
Date: Tue, 25 Mar 2014 18:41:25 +0800
Message-ID: <1395744087-5753-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add DT support for atmel ISI driver. It can support the
common v4l2 DT interfaces.

v1 --> v2:
  modified the device tree binding document to remove the a optional property.

Josh Wu (3):
  [media] atmel-isi: add v4l2 async probe support
  [media] atmel-isi: convert the pdata from pointer to structure
  [media] atmel-isi: add primary DT support

 .../devicetree/bindings/media/atmel-isi.txt        |   50 +++++++++++++++++
 drivers/media/platform/soc_camera/atmel-isi.c      |   56 +++++++++++++++-----
 include/media/atmel-isi.h                          |    4 ++
 3 files changed, 98 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isi.txt

-- 
1.7.9.5

