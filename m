Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57511 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab2IXLht (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 07:37:49 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so144083wey.19
        for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 04:37:48 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: mchehab@redhat.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 3/3] fc2580: use macro for 64 bit division and reminder
Date: Mon, 24 Sep 2012 13:37:18 +0200
Message-Id: <1348486638-31169-4-git-send-email-gennarone@gmail.com>
In-Reply-To: <1348486638-31169-1-git-send-email-gennarone@gmail.com>
References: <1348486638-31169-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warnings on a 32 bit system with GCC 4.4.3 and kernel Ubuntu 2.6.32-43 32 bit:

WARNING: "__udivdi3" [fc2580.ko] undefined!
WARNING: "__umoddi3" [fc2580.ko] undefined!

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/tuners/fc2580.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 3ad68e9..2e8ebac 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -168,8 +168,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	}
 
 	f_ref = 2UL * priv->cfg->clock / r_val;
-	n_val = f_vco / f_ref;
-	k_val = f_vco % f_ref;
+	n_val = div_u64_rem(f_vco, f_ref, &k_val);
 	k_val_reg = 1UL * k_val * (1 << 20) / f_ref;
 
 	ret = fc2580_wr_reg(priv, 0x18, r18_val | ((k_val_reg >> 16) & 0xff));
-- 
1.7.0.4

