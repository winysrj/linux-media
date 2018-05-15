Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52280 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751626AbeEOMoC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 08:44:02 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jasmin Jessich <jasmin@anw.at>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        Daniel Scheller <d.scheller@gmx.net>
Subject: [PATCH] media: dvb_ca_en50221: prevent using slot_info for Spectre attacs
Date: Tue, 15 May 2018 08:43:55 -0400
Message-Id: <ae2d6eda8cfc9db99fc4ce8d775fa7d4bf7d2068.1526388231.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

slot can be controlled by user-space, hence leading to
a potential exploitation of the Spectre variant 1 vulnerability,
as warned by smatch:
	drivers/media/dvb-core/dvb_ca_en50221.c:1479 dvb_ca_en50221_io_write() warn: potential spectre issue 'ca->slot_info' (local cap)

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 97365a863519..1310526b0d49 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/nospec.h>
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
@@ -1476,6 +1477,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 
 	if (slot >= ca->slot_count)
 		return -EINVAL;
+	slot = array_index_nospec(slot, ca->slot_count);
 	sl = &ca->slot_info[slot];
 
 	/* check if the slot is actually running */
-- 
2.17.0
