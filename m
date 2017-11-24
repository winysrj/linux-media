Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:20458 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753828AbdKXOCc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 09:02:32 -0500
Date: Fri, 24 Nov 2017 15:02:30 +0100
From: Wolfgang Rohdewald <wolfgang@rohdewald.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: dvb_frontend: dvb_unregister_frontend must not call
 dvb_detach for fe->ops.release
Message-ID: <20171124140230.saeqbltjkdjkwtyo@rohdewald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

because ops.release was never dvb_attached.
Which makes sense because f->ops.release does not attach anything.

Now, rmmod dvb_usb_pctv452e correctly sets counters for
stb6100/stb0899 to 0.

Before, stb0899 got a counter -1, and for my 4 receivers I got 3 OOPses
like

Nov 24 14:40:41 s5 kernel: [  194.211014] WARNING: CPU: 6 PID: 3055 at
   module_put.part.45+0x132/0x1a0
Call Trace:
 ? _stb0899_read_reg+0x100/0x100 [stb0899]
 ? _stb0899_read_reg+0x100/0x100 [stb0899]
 symbol_put_addr+0x38/0x60
 dvb_frontend_put+0x42/0x60 [dvb_core]
 ? stb0899_sleep+0x50/0x50 [stb0899]
 dvb_frontend_detach+0x7c/0x90 [dvb_core]
 dvb_usb_adapter_frontend_exit+0x57/0x80 [dvb_usb]
 dvb_usb_exit+0x39/0xb0 [dvb_usb]
 dvb_usb_device_exit+0x3f/0x60 [dvb_usb]
 pctv452e_usb_disconnect+0x6f/0x80 [dvb_usb_pctv452e]
 usb_unbind_interface+0x75/0x290
 ? _raw_spin_unlock_irqrestore+0x4a/0x80
 device_release_driver_internal+0x160/0x210
 driver_detach+0x40/0x80
 bus_remove_driver+0x5c/0xd0
 driver_unregister+0x2c/0x40
 usb_deregister+0x6c/0xf0
 pctv452e_usb_driver_exit+0x10/0xec0 [dvb_usb_pctv452e]

Signed-off-by: Wolfgang Rohdewald <wolfgang@rohdewald.de>
---
 drivers/media/dvb-core/dvb_frontend.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 9139d01ba7ed..c2cc794299c9 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -150,7 +150,8 @@ static void __dvb_frontend_free(struct dvb_frontend *fe)
 
 	dvb_free_device(fepriv->dvbdev);
 
-	dvb_frontend_invoke_release(fe, fe->ops.release);
+	if (fe->ops.release)
+		fe->ops.release(fe);
 
 	kfree(fepriv);
 	fe->frontend_priv = NULL;
-- 
2.11.0
