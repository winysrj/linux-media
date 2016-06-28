Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbcF1Otm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 10:49:42 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>, devel@driverdev.osuosl.org
Subject: [PATCH 2/2] [media] s5p_cec: get rid of an unused var
Date: Tue, 28 Jun 2016 11:49:34 -0300
Message-Id: <c51202d358409cb7afb9c01b6fe440e5e398ae9d.1467125336.git.mchehab@s-opensource.com>
In-Reply-To: <78fc853b5532b22639e691357fd59aa19833d81a.1467125336.git.mchehab@s-opensource.com>
References: <78fc853b5532b22639e691357fd59aa19833d81a.1467125336.git.mchehab@s-opensource.com>
In-Reply-To: <78fc853b5532b22639e691357fd59aa19833d81a.1467125336.git.mchehab@s-opensource.com>
References: <78fc853b5532b22639e691357fd59aa19833d81a.1467125336.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/staging/media/s5p-cec/s5p_cec.c: In function 's5p_cec_adap_enable':
drivers/staging/media/s5p-cec/s5p_cec.c:42:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret;
      ^~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/s5p-cec/s5p_cec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/s5p-cec/s5p_cec.c b/drivers/staging/media/s5p-cec/s5p_cec.c
index 3844f3915220..f90b7c4e48fe 100644
--- a/drivers/staging/media/s5p-cec/s5p_cec.c
+++ b/drivers/staging/media/s5p-cec/s5p_cec.c
@@ -39,10 +39,9 @@ MODULE_PARM_DESC(debug, "debug level (0-2)");
 static int s5p_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
 	struct s5p_cec_dev *cec = adap->priv;
-	int ret;
 
 	if (enable) {
-		ret = pm_runtime_get_sync(cec->dev);
+		pm_runtime_get_sync(cec->dev);
 
 		s5p_cec_reset(cec);
 
-- 
2.7.4

