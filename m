Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:46588 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbdJ2Pn0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 11:43:26 -0400
Received: by mail-wm0-f67.google.com with SMTP id m72so11270970wmc.1
        for <linux-media@vger.kernel.org>; Sun, 29 Oct 2017 08:43:25 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org, mchehab@s-opensource.com,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH] [media] dvb-core: always call invoke_release() in fe_free()
Date: Sun, 29 Oct 2017 16:43:22 +0100
Message-Id: <20171029154322.9983-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Follow-up to: ead666000a5f ("media: dvb_frontend: only use kref after initialized")

The aforementioned commit fixed refcount OOPSes when demod driver attaching
succeeded but tuner driver didn't. However, the use count of the attached
demod drivers don't go back to zero and thus couldn't be cleanly unloaded.
Improve on this by calling dvb_frontend_invoke_release() in
__dvb_frontend_free() regardless of fepriv being NULL, instead of returning
when fepriv is NULL. This is safe to do since _invoke_release() will check
for passed pointers being valid before calling the .release() function.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>

---
I discovered, checked and tested this with ddbridge, which, in
ddbridge-core.c:dvb_input_attach(), follows this common logic:

* attach demod
* if demod ok, attach tuner
* if tuner attach ok, proceed with dvb_reg_fe()
* else (tuner attach NOK): dvb_fe_detach(demod)

Without ead666000a5f, this caused refcount OOPSes when - at the latest -
unloading the kernel modules. This doesn't happen any more, yet the
loaded drivers still have a >0 use count. At first I tested calling
dvb_register_device() directly followed by dvb_unregister_device() on
the failure case, which worked but obviously isn't what is wanted. With
this patch, all refs are finally freed, drivers have a zero use count
on failure and can be unloaded cleanly.

Since dvb_frontend_invoke_release() checks the passed pointers before
calling them, I believe this is a safe thing to do.

 drivers/media/dvb-core/dvb_frontend.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index daaf969719e4..bda1eac8f4c0 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -145,15 +145,15 @@ static void __dvb_frontend_free(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	if (!fepriv)
-		return;
-
-	dvb_free_device(fepriv->dvbdev);
+	if (fepriv)
+		dvb_free_device(fepriv->dvbdev);
 
 	dvb_frontend_invoke_release(fe, fe->ops.release);
 
-	kfree(fepriv);
-	fe->frontend_priv = NULL;
+	if (fepriv) {
+		kfree(fepriv);
+		fe->frontend_priv = NULL;
+	}
 }
 
 static void dvb_frontend_free(struct kref *ref)
-- 
2.13.6
