Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38872 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab0EYJWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 05:22:16 -0400
Date: Tue, 25 May 2010 11:21:50 +0200
From: Dan Carpenter <error27@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v3 2/2] video/saa7134: remove duplicate break
Message-ID: <20100525092149.GA13089@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original code had two break statements in a row.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
v3: Put this in a seperate patch.

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index e5565e2..7691bf2 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -815,7 +815,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keyup   = 0x020000;
 		polling      = 50; /* ms */
 		break;
-	break;
 	}
 	if (NULL == ir_codes) {
 		printk("%s: Oops: IR config error [card=%d]\n",

