Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58244 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2DBV0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 17:26:42 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so3083820wgb.1
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 14:26:41 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: m@bues.ch, hfvogt@gmx.net, mchehab@redhat.com,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 3/5] tda18218: fix IF frequency for 7MHz bandwidth channels
Date: Mon,  2 Apr 2012 23:25:15 +0200
Message-Id: <1333401917-27203-4-git-send-email-gennarone@gmail.com>
In-Reply-To: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
References: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is necessary to tune VHF channels with the AVerMedia A835 stick.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/common/tuners/tda18218.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/tda18218.c b/drivers/media/common/tuners/tda18218.c
index dfb3a83..b079696 100644
--- a/drivers/media/common/tuners/tda18218.c
+++ b/drivers/media/common/tuners/tda18218.c
@@ -144,7 +144,7 @@ static int tda18218_set_params(struct dvb_frontend *fe)
 		priv->if_frequency = 3000000;
 	} else if (bw <= 7000000) {
 		LP_Fc = 1;
-		priv->if_frequency = 3500000;
+		priv->if_frequency = 4000000;
 	} else {
 		LP_Fc = 2;
 		priv->if_frequency = 4000000;
-- 
1.7.5.4

