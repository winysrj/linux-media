Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:43712 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab2GaEAF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 00:00:05 -0400
Message-Id: <E1Sw3Hp-0006s0-Ec@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Tue, 31 Jul 2012 04:31:42 +0200
Subject: [git:v4l-dvb/for_v3.6] [media] xc5000: Add MODULE_FIRMWARE statements
To: linuxtv-commits@linuxtv.org
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org, Eddi De Pieri <eddi@depieri.net>,
	Tim Gardner <tim.gardner@canonical.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] xc5000: Add MODULE_FIRMWARE statements
Author:  Tim Gardner <tim.gardner@canonical.com>
Date:    Wed Jul 25 09:15:19 2012 -0300

This will make modinfo more useful with regard
to discovering necessary firmware files.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@kernellabs.com>
Cc: Eddi De Pieri <eddi@depieri.net>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/common/tuners/xc5000.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=3422f2a6bc0ed9b1fa159a33d94efef08f142570

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index bac8009..362a8d7 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -210,13 +210,15 @@ struct xc5000_fw_cfg {
 	u16 size;
 };
 
+#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.114.fw"
 static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
-	.name = "dvb-fe-xc5000-1.6.114.fw",
+	.name = XC5000A_FIRMWARE,
 	.size = 12401,
 };
 
+#define XC5000C_FIRMWARE "dvb-fe-xc5000c-41.024.5.fw"
 static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
-	.name = "dvb-fe-xc5000c-41.024.5.fw",
+	.name = XC5000C_FIRMWARE,
 	.size = 16497,
 };
 
@@ -1259,3 +1261,5 @@ EXPORT_SYMBOL(xc5000_attach);
 MODULE_AUTHOR("Steven Toth");
 MODULE_DESCRIPTION("Xceive xc5000 silicon tuner driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(XC5000A_FIRMWARE);
+MODULE_FIRMWARE(XC5000C_FIRMWARE);
