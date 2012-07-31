Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:43713 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab2GaEAH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 00:00:07 -0400
Message-Id: <E1Sw3Ho-0006rb-Qc@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Tue, 31 Jul 2012 04:46:36 +0200
Subject: [git:v4l-dvb/for_v3.6] [media] lgs8gxx: Declare MODULE_FIRMWARE usage
To: linuxtv-commits@linuxtv.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] lgs8gxx: Declare MODULE_FIRMWARE usage
Author:  Tim Gardner <tim.gardner@canonical.com>
Date:    Wed Jul 25 12:54:02 2012 -0300

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/dvb/frontends/lgs8gxx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=ccb7c5939cc7185fdecb913f4c7cba94cf82287e

diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index 568363a..c2ea274 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -40,6 +40,8 @@
 static int debug;
 static int fake_signal_str = 1;
 
+#define LGS8GXX_FIRMWARE "lgs8g75.fw"
+
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 
@@ -592,7 +594,7 @@ static int lgs8g75_init_data(struct lgs8gxx_state *priv)
 	int rc;
 	int i;
 
-	rc = request_firmware(&fw, "lgs8g75.fw", &priv->i2c->dev);
+	rc = request_firmware(&fw, LGS8GXX_FIRMWARE, &priv->i2c->dev);
 	if (rc)
 		return rc;
 
@@ -1070,3 +1072,4 @@ EXPORT_SYMBOL(lgs8gxx_attach);
 MODULE_DESCRIPTION("Legend Silicon LGS8913/LGS8GXX DMB-TH demodulator driver");
 MODULE_AUTHOR("David T. L. Wong <davidtlwong@gmail.com>");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(LGS8GXX_FIRMWARE);
