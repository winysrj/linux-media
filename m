Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbaHZVzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:18 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 04/35] [media] dm355_ccdc: declare a function as static
Date: Tue, 26 Aug 2014 18:54:40 -0300
Message-Id: <1409090111-8290-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/davinci/dm355_ccdc.c:463:5: warning: no previous prototy
pe for 'ccdc_write_dfc_entry' [-Wmissing-prototypes]
 int ccdc_write_dfc_entry(int index, struct ccdc_vertical_dft *dfc)
     ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/davinci/dm355_ccdc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index 05f8fb7f7b70..3f44deb5b7a7 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -460,7 +460,7 @@ static void ccdc_config_black_compense(struct ccdc_black_compensation *bcomp)
  * ccdc_write_dfc_entry()
  * write an entry in the dfc table.
  */
-int ccdc_write_dfc_entry(int index, struct ccdc_vertical_dft *dfc)
+static int ccdc_write_dfc_entry(int index, struct ccdc_vertical_dft *dfc)
 {
 /* TODO This is to be re-visited and adjusted */
 #define DFC_WRITE_WAIT_COUNT	1000
-- 
1.9.3

