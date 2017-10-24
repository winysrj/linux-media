Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:53672 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbdJXLhQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 07:37:16 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, max.kellermann@gmail.com, shuah@kernel.org,
        yamada.masahiro@socionext.com, sakari.ailus@linux.intel.com,
        colin.king@canonical.com, andreyknvl@google.com,
        dvyukov@google.com, kcc@google.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        syzkaller@googlegroups.com
Subject: [RFT] media: dvb_frontend: Fix use-after-free in __dvb_frontend_free
Date: Tue, 24 Oct 2017 17:06:48 +0530
Message-Id: <0ade6e417fbf2cd119aa1f2345f88a3810c03e11.1508844352.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here, dvb_free_device will free dvb_device. dvb_frontend_invoke_release
is using  dvb_device after free.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
This bug report by Andrey Konovalov (usb/media/dtt200u: use-after-free
in __dvb_frontend_free).

 drivers/media/dvb-core/dvb_frontend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2fcba16..7f1ef12 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -147,10 +147,10 @@ static void dvb_frontend_free(struct kref *ref)
 		container_of(ref, struct dvb_frontend, refcount);
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	dvb_free_device(fepriv->dvbdev);
-
 	dvb_frontend_invoke_release(fe, fe->ops.release);
 
+	dvb_free_device(fepriv->dvbdev);
+
 	kfree(fepriv);
 }
 
-- 
1.9.1
