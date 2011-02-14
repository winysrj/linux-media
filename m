Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1BNVQr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:16:47 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1ELGlGx023657
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:16:47 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TGG012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:16:46 -0500
Date: Mon, 14 Feb 2011 19:03:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 13/14] [media] tuner-core: Fix a few comments on it
Message-ID: <20110214190323.4557a54e@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 2a0bea1..dcf03fa 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -128,7 +128,7 @@ struct tuner {
  * tuner attach/detach logic
  */
 
-/** This macro allows us to probe dynamically, avoiding static links */
+/* This macro allows us to probe dynamically, avoiding static links */
 #ifdef CONFIG_MEDIA_ATTACH
 #define tuner_symbol_probe(FUNCTION, ARGS...) ({ \
 	int __r = -EINVAL; \
@@ -412,13 +412,20 @@ attach_failed:
 	return;
 }
 
-/*
- * This function apply tuner config to tuner specified
- * by tun_setup structure. I addr is unset, then admin status
- * and tun addr status is more precise then current status,
- * it's applied. Otherwise status and type are applied only to
- * tuner with exactly the same addr.
-*/
+/**
+ * tuner_s_type_addr - Sets the tuner type for a device
+ *
+ * @sd:		subdev descriptor
+ * @tun_setup:	type to be associated to a given tuner i2c address
+ *
+ * This function applys the tuner config to tuner specified
+ * by tun_setup structure.
+ * If tuner I2C address is UNSET, then it will only set the device
+ * if the tuner supports the mode specified in the call.
+ * If the address is specified, the change will be applied only if
+ * tuner I2C address matches.
+ * The call can change the tuner number and the tuner mode.
+ */
 static int tuner_s_type_addr(struct v4l2_subdev *sd,
 			     struct tuner_setup *tun_setup)
 {
-- 
1.7.1


