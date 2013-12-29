Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:31762 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab3L2Vv6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Dec 2013 16:51:58 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Antti Palosaari <crope@iki.fi>
Cc: kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/25]  fix error return code
Date: Sun, 29 Dec 2013 23:47:35 +0100
Message-Id: <1388357260-4843-21-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

Set the return variable to an error code as done elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/media/tuners/e4000.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 72971a8..40c1da7 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -243,8 +243,10 @@ static int e4000_set_params(struct dvb_frontend *fe)
 			break;
 	}
 
-	if (i == ARRAY_SIZE(e4000_pll_lut))
+	if (i == ARRAY_SIZE(e4000_pll_lut)) {
+		ret = -EINVAL;
 		goto err;
+	}
 
 	/*
 	 * Note: Currently f_vco overflows when c->frequency is 1 073 741 824 Hz
@@ -271,8 +273,10 @@ static int e4000_set_params(struct dvb_frontend *fe)
 			break;
 	}
 
-	if (i == ARRAY_SIZE(e400_lna_filter_lut))
+	if (i == ARRAY_SIZE(e400_lna_filter_lut)) {
+		ret = -EINVAL;
 		goto err;
+	}
 
 	ret = e4000_wr_reg(priv, 0x10, e400_lna_filter_lut[i].val);
 	if (ret < 0)
@@ -284,8 +288,10 @@ static int e4000_set_params(struct dvb_frontend *fe)
 			break;
 	}
 
-	if (i == ARRAY_SIZE(e4000_if_filter_lut))
+	if (i == ARRAY_SIZE(e4000_if_filter_lut)) {
+		ret = -EINVAL;
 		goto err;
+	}
 
 	buf[0] = e4000_if_filter_lut[i].reg11_val;
 	buf[1] = e4000_if_filter_lut[i].reg12_val;
@@ -300,8 +306,10 @@ static int e4000_set_params(struct dvb_frontend *fe)
 			break;
 	}
 
-	if (i == ARRAY_SIZE(e4000_band_lut))
+	if (i == ARRAY_SIZE(e4000_band_lut)) {
+		ret = -EINVAL;
 		goto err;
+	}
 
 	ret = e4000_wr_reg(priv, 0x07, e4000_band_lut[i].reg07_val);
 	if (ret < 0)

