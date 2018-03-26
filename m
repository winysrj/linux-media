Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46525 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbeCZVK4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:10:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/18] media: r820t: don't crash if attach fails
Date: Mon, 26 Mar 2018 17:10:34 -0400
Message-Id: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As pointed by smatch:
	drivers/media/tuners/r820t.c:2374 r820t_attach() error: potential null dereference 'priv'.  (kzalloc returns null)

The current function with prints error assumes that the attach
succeeds. So, don't use it in case of failures.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/r820t.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index bc9299059f48..3e14b9e2e763 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -20,6 +20,8 @@
 //
 //	RF Gain set/get is not implemented.
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/videodev2.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -2371,7 +2373,7 @@ struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 err_no_gate:
 	mutex_unlock(&r820t_list_mutex);
 
-	tuner_info("%s: failed=%d\n", __func__, rc);
+	pr_info("%s: failed=%d\n", __func__, rc);
 	r820t_release(fe);
 	return NULL;
 }
-- 
2.14.3
