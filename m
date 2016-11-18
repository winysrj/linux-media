Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:60378 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753543AbcKRXVP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:15 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 23/35] media: ti-vpe: sc: Fix incorrect optimization
Date: Fri, 18 Nov 2016 17:20:33 -0600
Message-ID: <20161118232045.24665-24-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

Current scaler library implementation of sc_set_hs_coeffs and
sc_set_vs_coeffs tries to return immediately if the calculated
coefficient index is already being used.

As the same scaler block is going to be used for all the VPE contexts,
even if the calculated index is same, the parameters have to be
reconfigured for each of the context.

Because of this, when multiple contexts use the same coefficients,
all other contexts would have zero scaling coefficients.
Fix this and also remove the unnecessary hs_index and vs_index fields.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/sc.c | 9 ---------
 drivers/media/platform/ti-vpe/sc.h | 3 ---
 2 files changed, 12 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/sc.c b/drivers/media/platform/ti-vpe/sc.c
index f82d1c7f667f..02f3dae8ae42 100644
--- a/drivers/media/platform/ti-vpe/sc.c
+++ b/drivers/media/platform/ti-vpe/sc.c
@@ -84,9 +84,6 @@ void sc_set_hs_coeffs(struct sc_data *sc, void *addr, unsigned int src_w,
 		}
 	}
 
-	if (idx == sc->hs_index)
-		return;
-
 	cp = scaler_hs_coeffs[idx];
 
 	for (i = 0; i < SC_NUM_PHASES * 2; i++) {
@@ -101,8 +98,6 @@ void sc_set_hs_coeffs(struct sc_data *sc, void *addr, unsigned int src_w,
 		coeff_h += SC_NUM_TAPS_MEM_ALIGN - SC_H_NUM_TAPS;
 	}
 
-	sc->hs_index = idx;
-
 	sc->load_coeff_h = true;
 }
 
@@ -130,9 +125,6 @@ void sc_set_vs_coeffs(struct sc_data *sc, void *addr, unsigned int src_h,
 		idx = VS_LT_9_16_SCALE + sixteenths - 8;
 	}
 
-	if (idx == sc->vs_index)
-		return;
-
 	cp = scaler_vs_coeffs[idx];
 
 	for (i = 0; i < SC_NUM_PHASES * 2; i++) {
@@ -146,7 +138,6 @@ void sc_set_vs_coeffs(struct sc_data *sc, void *addr, unsigned int src_h,
 		coeff_v += SC_NUM_TAPS_MEM_ALIGN - SC_V_NUM_TAPS;
 	}
 
-	sc->vs_index = idx;
 	sc->load_coeff_v = true;
 }
 
diff --git a/drivers/media/platform/ti-vpe/sc.h b/drivers/media/platform/ti-vpe/sc.h
index 60e411e05c30..de947db98990 100644
--- a/drivers/media/platform/ti-vpe/sc.h
+++ b/drivers/media/platform/ti-vpe/sc.h
@@ -189,9 +189,6 @@ struct sc_data {
 	bool			load_coeff_h;	/* have new h SC coeffs */
 	bool			load_coeff_v;	/* have new v SC coeffs */
 
-	unsigned int		hs_index;	/* h SC coeffs selector */
-	unsigned int		vs_index;	/* v SC coeffs selector */
-
 	struct platform_device *pdev;
 };
 
-- 
2.9.0

