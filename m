Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43281 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3KENDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:49 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 09/29] [media] rc: Fir warnings on m68k arch
Date: Tue,  5 Nov 2013 08:01:22 -0200
Message-Id: <1383645702-30636-10-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following warnings:
	drivers/media/rc/fintek-cir.c: In function 'fintek_cr_write':
	drivers/media/rc/fintek-cir.c:45:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/fintek-cir.c:46:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/fintek-cir.c: In function 'fintek_cr_read':
	drivers/media/rc/fintek-cir.c:54:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/fintek-cir.c:55:8: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/fintek-cir.c: In function 'fintek_config_mode_enable':
	drivers/media/rc/fintek-cir.c:80:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/fintek-cir.c:81:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/fintek-cir.c: In function 'fintek_config_mode_disable':
	drivers/media/rc/fintek-cir.c:87:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/nuvoton-cir.c: In function 'nvt_cr_write':
	drivers/media/rc/nuvoton-cir.c:45:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/nuvoton-cir.c:46:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/nuvoton-cir.c: In function 'nvt_cr_read':
	drivers/media/rc/nuvoton-cir.c:52:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/nuvoton-cir.c:53:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/nuvoton-cir.c: In function 'nvt_efm_enable':
	drivers/media/rc/nuvoton-cir.c:74:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/nuvoton-cir.c:75:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/nuvoton-cir.c: In function 'nvt_efm_disable':
	drivers/media/rc/nuvoton-cir.c:81:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/nuvoton-cir.c: In function 'nvt_select_logical_dev':
	drivers/media/rc/nuvoton-cir.c:91:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
	drivers/media/rc/nuvoton-cir.c:92:2: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
Those are caused because the I/O port is u32, instead of u8.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/rc/fintek-cir.h  | 4 ++--
 drivers/media/rc/nuvoton-cir.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/fintek-cir.h b/drivers/media/rc/fintek-cir.h
index 82516a1d39b0..b698f3d2ced9 100644
--- a/drivers/media/rc/fintek-cir.h
+++ b/drivers/media/rc/fintek-cir.h
@@ -76,8 +76,8 @@ struct fintek_dev {
 	} tx;
 
 	/* Config register index/data port pair */
-	u8 cr_ip;
-	u8 cr_dp;
+	u32 cr_ip;
+	u32 cr_dp;
 
 	/* hardware I/O settings */
 	unsigned long cir_addr;
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 7c3674ff5ea2..07e83108df0f 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -84,8 +84,8 @@ struct nvt_dev {
 	} tx;
 
 	/* EFER Config register index/data pair */
-	u8 cr_efir;
-	u8 cr_efdr;
+	u32 cr_efir;
+	u32 cr_efdr;
 
 	/* hardware I/O settings */
 	unsigned long cir_addr;
-- 
1.8.3.1

