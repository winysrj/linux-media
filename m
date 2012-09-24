Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35468 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab2IXLhr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 07:37:47 -0400
Received: by wibhr14 with SMTP id hr14so4723588wib.1
        for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 04:37:45 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: mchehab@redhat.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 2/3] fc2580: silence uninitialized variable warning
Date: Mon, 24 Sep 2012 13:37:17 +0200
Message-Id: <1348486638-31169-3-git-send-email-gennarone@gmail.com>
In-Reply-To: <1348486638-31169-1-git-send-email-gennarone@gmail.com>
References: <1348486638-31169-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fc2580.c: In function 'fc2580_set_params':
fc2580.c:118: warning: 'ret' may be used uninitialized in this function

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/tuners/fc2580.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 036e94b..3ad68e9 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -115,7 +115,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 {
 	struct fc2580_priv *priv = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i;
+	int ret=0, i;
 	unsigned int r_val, n_val, k_val, k_val_reg, f_ref;
 	u8 tmp_val, r18_val;
 	u64 f_vco;
-- 
1.7.0.4

