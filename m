Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:32107 "EHLO
	email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753137AbcHORXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 13:23:43 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Songjun Wu <songjun.wu@atmel.com>,
	Ludovic Desroches <ludovic.desroches@atmel.com>
CC: <hverkuil@xs4all.nl>, <robh@kernel.org>,
	<laurent.pinchart@ideasonboard.com>, <mchehab@kernel.org>,
	<geert@linux-m68k.org>, <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Songjun Wu <songjun.wu@microchip.com>
Subject: [PATCH] MAINTAINERS: atmel-isc: add entry for Atmel ISC
Date: Mon, 15 Aug 2016 19:24:04 +0200
Message-ID: <20160815172404.5954-1-nicolas.ferre@atmel.com>
In-Reply-To: <160e313b-9a3e-2ca7-93cd-ef23eb412535@microchip.com>
References: <160e313b-9a3e-2ca7-93cd-ef23eb412535@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the MAINTAINERS' entry for Microchip / Atmel Image Sensor Controller.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Songjun Wu <songjun.wu@microchip.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 45c98485c3f0..84786643ba4c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7750,6 +7750,14 @@ T:	git git://git.monstr.eu/linux-2.6-microblaze.git
 S:	Supported
 F:	arch/microblaze/
 
+MICROCHIP / ATMEL ISC DRIVER
+M:	Songjun Wu <songjun.wu@microchip.com>
+L:	linux-media@vger.kernel.org
+S:	Supported
+F:	drivers/media/platform/atmel/atmel-isc.c
+F:	drivers/media/platform/atmel/atmel-isc-regs.h
+F:	devicetree/bindings/media/atmel-isc.txt
+
 MICROSOFT SURFACE PRO 3 BUTTON DRIVER
 M:	Chen Yu <yu.c.chen@intel.com>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.9.0

