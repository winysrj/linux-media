Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48956 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaB0Qo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 11:44:59 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] [media] tvp5150: Make debug module parameter visible in sysfs
Date: Thu, 27 Feb 2014 17:44:48 +0100
Message-Id: <1393519488-5427-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1393519488-5427-1-git-send-email-p.zabel@pengutronix.de>
References: <1393519488-5427-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set permissions on the debug module parameter to make it appear in sysfs.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 8ac52fc..4fd3688 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -29,7 +29,7 @@ MODULE_LICENSE("GPL");
 
 
 static int debug;
-module_param(debug, int, 0);
+module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 struct tvp5150 {
-- 
1.8.5.3

