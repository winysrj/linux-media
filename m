Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44311 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaICUd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 38/46] [media] saa7164: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:10 -0300
Message-Id: <c08494a5ae442fc0d8d8d622efe76a2f7f1a4074.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating a var to store 0 and just return it,
change the code to return 0 directly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/pci/saa7164/saa7164-api.c b/drivers/media/pci/saa7164/saa7164-api.c
index e042963d377d..4f3b1dd18ba4 100644
--- a/drivers/media/pci/saa7164/saa7164-api.c
+++ b/drivers/media/pci/saa7164/saa7164-api.c
@@ -680,7 +680,6 @@ static int saa7164_api_set_dif(struct saa7164_port *port, u8 reg, u8 val)
 int saa7164_api_configure_dif(struct saa7164_port *port, u32 std)
 {
 	struct saa7164_dev *dev = port->dev;
-	int ret = 0;
 	u8 agc_disable;
 
 	dprintk(DBGLVL_API, "%s(nr=%d, 0x%x)\n", __func__, port->nr, std);
@@ -733,7 +732,7 @@ int saa7164_api_configure_dif(struct saa7164_port *port, u32 std)
 	saa7164_api_set_dif(port, 0x04, 0x00); /* Active (again) */
 	msleep(100);
 
-	return ret;
+	return 0;
 }
 
 /* Ensure the dif is in the correct state for the operating mode
-- 
1.9.3

