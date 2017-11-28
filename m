Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:19072 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751883AbdK1Ldz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 06:33:55 -0500
Date: Tue, 28 Nov 2017 12:33:52 +0100
From: Wolfgang Rohdewald <wolfgang@rohdewald.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: dvb_usb_pctv452e: module refcount changes were
 unbalanced
Message-ID: <20171128113352.5jm3ur3bszey3y4l@rohdewald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_frontend will call dvb_detach for:
- stb0899_detach in dvb_frontend_release and
- stb0899_release in __dvb_frontend_free

But we only do dvb_attach(stb0899_attach).
Increment the module refcount instead.

Signed-off-by: Wolfgang Rohdewald <wolfgang@rohdewald.de>
---
 drivers/media/usb/dvb-usb/pctv452e.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index 601ade7ca48d..3b7f8298b24d 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -913,6 +913,14 @@ static int pctv452e_frontend_attach(struct dvb_usb_adapter *a)
 						&a->dev->i2c_adap);
 	if (!a->fe_adap[0].fe)
 		return -ENODEV;
+
+	/*
+	 * dvb_frontend will call dvb_detach for both stb0899_detach
+	 * and stb0899_release but we only do dvb_attach(stb0899_attach).
+	 * Increment the module refcount instead.
+	 */
+	symbol_get(stb0899_attach);
+
 	if ((dvb_attach(lnbp22_attach, a->fe_adap[0].fe,
 					&a->dev->i2c_adap)) == NULL)
 		err("Cannot attach lnbp22\n");
-- 
2.11.0
