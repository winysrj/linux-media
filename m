Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57511 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2IXLho (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 07:37:44 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so144083wey.19
        for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 04:37:43 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: mchehab@redhat.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 1/3] fc2580: define const as UL to silence a warning
Date: Mon, 24 Sep 2012 13:37:16 +0200
Message-Id: <1348486638-31169-2-git-send-email-gennarone@gmail.com>
In-Reply-To: <1348486638-31169-1-git-send-email-gennarone@gmail.com>
References: <1348486638-31169-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fc2580.c: In function 'fc2580_set_params':
fc2580.c:150: warning: this decimal constant is unsigned only in ISO C90

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/tuners/fc2580.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index afc0491..036e94b 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -147,7 +147,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	f_vco = c->frequency;
 	f_vco *= fc2580_pll_lut[i].div;
 
-	if (f_vco >= 2600000000)
+	if (f_vco >= 2600000000UL)
 		tmp_val = 0x0e | fc2580_pll_lut[i].band;
 	else
 		tmp_val = 0x06 | fc2580_pll_lut[i].band;
-- 
1.7.0.4

