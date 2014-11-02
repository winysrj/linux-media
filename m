Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaKBMcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 07:32:51 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCHv2 13/14] [media] cx231xx: too much changes. Bump version number
Date: Sun,  2 Nov 2014 10:32:36 -0200
Message-Id: <c031b10bd229f0179585409e40edcdea06a4c8a7.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The I2C mux changes are significant. Bump version number.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 5ea8124f5d20..c5b5e9541669 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -43,7 +43,7 @@
 
 #include "cx231xx-vbi.h"
 
-#define CX231XX_VERSION "0.0.2"
+#define CX231XX_VERSION "0.0.3"
 
 #define DRIVER_AUTHOR   "Srinivasa Deevi <srinivasa.deevi@conexant.com>"
 #define DRIVER_DESC     "Conexant cx231xx based USB video device driver"
-- 
1.9.3

