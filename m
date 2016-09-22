Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53684 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbcIVQjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 12:39:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Olli Salonen <olli.salonen@iki.fi>,
        Stephen Backway <stev391@gmail.com>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH] [media] cx23885: Fix some smatch warnings
Date: Thu, 22 Sep 2016 13:38:44 -0300
Message-Id: <e837d85c614e8d6e2d93daed972874ea3a8daec7.1474562316.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure that it won't go past the config buffers

	drivers/media/pci/cx23885/cx23885-dvb.c:1733 dvb_register() warn: buffer overflow 'netup_xc5000_config' 2 <= s32max
	drivers/media/pci/cx23885/cx23885-dvb.c:1745 dvb_register() warn: buffer overflow 'netup_stv0367_config' 2 <= s32max
	drivers/media/pci/cx23885/cx23885-dvb.c:1752 dvb_register() warn: buffer overflow 'netup_xc5000_config' 2 <= s32max

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 3 +++
 drivers/media/pci/cx23885/cx23885.h     | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 828b54afd59e..818f3c2fc98d 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1720,6 +1720,9 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 		break;
 	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
+		if (port->nr > 2)
+			return 0;
+
 		i2c_bus = &dev->i2c_bus[0];
 		mfe_shared = 1;/* MFE */
 		port->frontends.gate = 0;/* not clear for me yet */
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 2ebece93d111..a6735afe2269 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -257,7 +257,7 @@ struct cx23885_dmaqueue {
 struct cx23885_tsport {
 	struct cx23885_dev *dev;
 
-	int                        nr;
+	unsigned                   nr;
 	int                        sram_chno;
 
 	struct vb2_dvb_frontends   frontends;
-- 
2.7.4

