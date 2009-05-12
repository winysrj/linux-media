Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633AbZELVCV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 17:02:21 -0400
Message-Id: <200905122058.n4CKwhgf004393@imap1.linux-foundation.org>
Subject: [patch 2/4] V4L/DVB: cimax2.c: fix &/&& typo
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	roel.kluin@gmail.com, aospan@netup.ru, liplianin@netup.ru
From: akpm@linux-foundation.org
Date: Tue, 12 May 2009 13:39:27 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Roel Kluin <roel.kluin@gmail.com>

binary/logical and typo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Abylay Ospan <aospan@netup.ru>
Cc: Igor M. Liplianin <liplianin@netup.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx23885/cimax2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/cx23885/cimax2.c~v4l-dvb-cimax2c-fix-typo drivers/media/video/cx23885/cimax2.c
--- a/drivers/media/video/cx23885/cimax2.c~v4l-dvb-cimax2c-fix-typo
+++ a/drivers/media/video/cx23885/cimax2.c
@@ -312,7 +312,7 @@ static void netup_read_ci_status(struct 
 		"TS config = %02x\n", __func__, state->ci_i2c_addr, 0, buf[0],
 		buf[32]);
 
-	if (buf[0] && 1)
+	if (buf[0] & 1)
 		state->status = DVB_CA_EN50221_POLL_CAM_PRESENT |
 			DVB_CA_EN50221_POLL_CAM_READY;
 	else
_
