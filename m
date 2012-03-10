Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp509.mail.kks.yahoo.co.jp ([114.111.99.158]:23437 "HELO
	smtp509.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755345Ab2CJPpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 10:45:32 -0500
From: tskd2@yahoo.co.jp
To: linux-media@vger.kernel.org
Cc: Akihiro Tsukada <tskd2@yahoo.co.jp>
Subject: [PATCH 3/4] dvb: earth-pt1: decrease the too large DMA buffer size
Date: Sun, 11 Mar 2012 00:38:15 +0900
Message-Id: <1331393896-17902-3-git-send-email-tskd2@yahoo.co.jp>
In-Reply-To: <1331393896-17902-1-git-send-email-tskd2@yahoo.co.jp>
References: <1331393896-17902-1-git-send-email-tskd2@yahoo.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd2@yahoo.co.jp>

Current default value of "nr_tables" option corresponds to the DMA buffer of about 10 to 48 seconds long, which is obviously too much.

Signed-off-by: Akihiro Tsukada <tskd2@yahoo.co.jp>
---
 drivers/media/dvb/pt1/pt1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/pt1/pt1.c b/drivers/media/dvb/pt1/pt1.c
index 8229a91..9cd161c 100644
--- a/drivers/media/dvb/pt1/pt1.c
+++ b/drivers/media/dvb/pt1/pt1.c
@@ -123,7 +123,7 @@ static u32 pt1_read_reg(struct pt1 *pt1, int reg)
 	return readl(pt1->regs + reg * 4);
 }
 
-static int pt1_nr_tables = 64;
+static int pt1_nr_tables = 8;
 module_param_named(nr_tables, pt1_nr_tables, int, 0);
 
 static void pt1_increment_table_count(struct pt1 *pt1)
-- 
1.7.7.6

