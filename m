Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52655 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaCKNmD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 09:42:03 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so3739270eek.32
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 06:42:01 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, m.chehab@samsung.com
Cc: dheitmueller@kernellabs.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] drx39xyj: fix 64 bit division on 32 bit arch
Date: Tue, 11 Mar 2014 14:41:47 +0100
Message-Id: <1394545307-624-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this linker warning:
WARNING: "__divdi3" [media_build/v4l/drx39xyj.ko] undefined!

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 2352327..0dec073 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -12002,13 +12002,16 @@ static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
 static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u64 tmp64;
 
 	if (p->cnr.stat[0].scale == FE_SCALE_NOT_AVAILABLE) {
 		*snr = 0;
 		return 0;
 	}
 
-	*snr = p->cnr.stat[0].svalue / 10;
+	tmp64 = p->cnr.stat[0].svalue;
+	do_div(tmp64, 10);
+	*snr = tmp64;
 	return 0;
 }
 
-- 
1.9.0

