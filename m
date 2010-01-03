Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50321 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab0ACRBP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jan 2010 12:01:15 -0500
Message-ID: <4B40CE2A.2090209@gmail.com>
Date: Sun, 03 Jan 2010 18:04:42 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] V4L/DVB (12930): Wrong variable tested
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The return of saa7164_i2caddr_to_reglen() was not tested.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/media/video/saa7164/saa7164-api.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa7164/saa7164-api.c b/drivers/media/video/saa7164/saa7164-api.c
index 6f094a9..1d487c1 100644
--- a/drivers/media/video/saa7164/saa7164-api.c
+++ b/drivers/media/video/saa7164/saa7164-api.c
@@ -523,7 +523,7 @@ int saa7164_api_i2c_write(struct saa7164_i2c *bus, u8 addr, u32 datalen,
 	}
 
 	reglen = saa7164_i2caddr_to_reglen(bus, addr);
-	if (unitid < 0) {
+	if (reglen < 0) {
 		printk(KERN_ERR
 			"%s() error, cannot translate regaddr to reglen\n",
 			__func__);
