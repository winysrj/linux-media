Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:51769 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751508AbeEDSYq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 14:24:46 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] media: pt3: no need to check if null for dvb_module_release()
Date: Fri,  4 May 2018 14:24:41 -0400
Message-Id: <59a8914011a01e71ae93789f2fca7bea35dc0b60.1525458277.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Such check is already there at the routine. So, no need to
repeat it outside.

Cc: Akihiro Tsukada <tskd08@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/pci/pt3/pt3.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index b2d9fb976c9a..cbec5c42fcbc 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -619,10 +619,8 @@ static void pt3_cleanup_adapter(struct pt3_board *pt3, int index)
 		adap->fe->callback = NULL;
 		if (adap->fe->frontend_priv)
 			dvb_unregister_frontend(adap->fe);
-		if (adap->i2c_tuner)
-			dvb_module_release(adap->i2c_tuner);
-		if (adap->i2c_demod)
-			dvb_module_release(adap->i2c_demod);
+		dvb_module_release(adap->i2c_tuner);
+		dvb_module_release(adap->i2c_demod);
 	}
 	pt3_free_dmabuf(adap);
 	dvb_dmxdev_release(&adap->dmxdev);
-- 
2.17.0
