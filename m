Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:60261 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab0EZPGS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 11:06:18 -0400
Received: by wwb13 with SMTP id 13so405515wwb.19
        for <linux-media@vger.kernel.org>; Wed, 26 May 2010 08:06:16 -0700 (PDT)
Date: Wed, 26 May 2010 16:58:10 +0200
From: Dan Carpenter <error27@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v4 1/2] video/saa7134: change dprintk() to i2cdprintk()
Message-ID: <20100526145810.GN22515@bicker>
References: <20100525091816.GA13034@bicker> <20100526144313.1d15222f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526144313.1d15222f@hyperion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The problem is that dprintk() dereferences "dev" which is null here.
The i2cdprintk() uses "ir" so that's OK.

Also Jean Delvare pointed out a typo in the comment so we may as well
fix that.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
---
v2: Jean Delvare suggested that I use i2cdprintk() instead of modifying
dprintk().
v3: V2 had a bonus cleanup that I removed from v3
v4: Fixed typo in the comment.

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index e5565e2..7691bf2 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -141,8 +141,8 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	struct saa7134_dev *dev = ir->c->adapter->algo_data;
 
 	if (dev == NULL) {
-		dprintk("get_key_flydvb_trio: "
-			 "gir->c->adapter->algo_data is NULL!\n");
+		i2cdprintk("get_key_flydvb_trio: "
+			   "ir->c->adapter->algo_data is NULL!\n");
 		return -EIO;
 	}
 
@@ -195,8 +195,8 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, u32 *ir_key,
 	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
 	struct saa7134_dev *dev = ir->c->adapter->algo_data;
 	if (dev == NULL) {
-		dprintk("get_key_msi_tvanywhere_plus: "
-			"gir->c->adapter->algo_data is NULL!\n");
+		i2cdprintk("get_key_msi_tvanywhere_plus: "
+			   "ir->c->adapter->algo_data is NULL!\n");
 		return -EIO;
 	}
 


