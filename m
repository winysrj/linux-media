Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44303
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751701AbdINLo1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 07:44:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [RFC 4/5] media: friio-fe: get rid of set_property()
Date: Thu, 14 Sep 2017 08:44:21 -0300
Message-Id: <b12d57885ed3c93ccc553c2f59207e8f5b857cc9.1505389446.git.mchehab@s-opensource.com>
In-Reply-To: <129c5ae599d0502a3fe8c3f09a174ef33879a021.1505389446.git.mchehab@s-opensource.com>
References: <129c5ae599d0502a3fe8c3f09a174ef33879a021.1505389446.git.mchehab@s-opensource.com>
In-Reply-To: <129c5ae599d0502a3fe8c3f09a174ef33879a021.1505389446.git.mchehab@s-opensource.com>
References: <129c5ae599d0502a3fe8c3f09a174ef33879a021.1505389446.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This callback is not actually doing anything but making it to
return an error depending on the DTV frontend command. Well,
that could break userspace for no good reason, and, if needed,
should be implemented, instead, at set_frontend() callback.

So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/friio-fe.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index 0251a4e91d47..41261317bd5c 100644
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ b/drivers/media/usb/dvb-usb/friio-fe.c
@@ -261,28 +261,6 @@ static int jdvbt90502_read_signal_strength(struct dvb_frontend *fe,
 	return 0;
 }
 
-
-/* filter out un-supported properties to notify users */
-static int jdvbt90502_set_property(struct dvb_frontend *fe,
-				   struct dtv_property *tvp)
-{
-	int r = 0;
-
-	switch (tvp->cmd) {
-	case DTV_DELIVERY_SYSTEM:
-		if (tvp->u.data != SYS_ISDBT)
-			r = -EINVAL;
-		break;
-	case DTV_CLEAR:
-	case DTV_TUNE:
-	case DTV_FREQUENCY:
-		break;
-	default:
-		r = -EINVAL;
-	}
-	return r;
-}
-
 static int jdvbt90502_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
@@ -457,8 +435,6 @@ static const struct dvb_frontend_ops jdvbt90502_ops = {
 	.init = jdvbt90502_init,
 	.write = _jdvbt90502_write,
 
-	.set_property = jdvbt90502_set_property,
-
 	.set_frontend = jdvbt90502_set_frontend,
 
 	.read_status = jdvbt90502_read_status,
-- 
2.13.5
