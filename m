Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59761 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753710AbdLLMvo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 07:51:44 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH] media: dvb_frontend: fix return error code
Date: Tue, 12 Dec 2017 07:51:31 -0500
Message-Id: <330dada5957e3ca0c8811b14c45e3ac42c694651.1513083074.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The correct error code when a function is not defined is
-ENOTSUPP. It was typoed wrong as -EOPNOTSUPP, with,
unfortunately, exists, but it is not used by the DVB core.

Thanks-to: Geert Uytterhoeven <geert@linux-m68k.org>
Thanks-to: Arnd Bergmann <arnd@arndb.de>

To make me revisit this code.

Fixes: a9cb97c3e628 ("media: dvb_frontend: be sure to init dvb_frontend_handle_ioctl() return code")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 46f977177faf..4eedaa5922eb 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2110,7 +2110,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int i, err = -EOPNOTSUPP;
+	int i, err = -ENOTSUPP;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
-- 
2.14.3
