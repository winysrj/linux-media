Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:57727 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751129AbeDDISQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Apr 2018 04:18:16 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH] media: dvb_frontend: fix wrong cast in compat_ioctl
Date: Wed,  4 Apr 2018 17:17:56 +0900
Message-Id: <20180404081756.22962-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FE_GET_PROPERTY has always failed as following situations:
  - Use compatible ioctl
  - The array of 'struct dtv_property' has 2 or more items

This patch fixes wrong cast to a pointer 'struct dtv_property' from a
pointer of 2nd or after item of 'struct compat_dtv_property' array.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 21a7d4b47e1a..e33414975065 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2089,7 +2089,7 @@ static int dvb_frontend_handle_compat_ioctl(struct file *file, unsigned int cmd,
 		}
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_get(
-			    fe, &getp, (struct dtv_property *)tvp + i, file);
+			    fe, &getp, (struct dtv_property *)(tvp + i), file);
 			if (err < 0) {
 				kfree(tvp);
 				return err;
-- 
2.16.3
