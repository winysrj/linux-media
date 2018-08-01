Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:36307 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbeHAU75 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 16:59:57 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 04/14] gpu: ipu-v3: Fix U/V offset macros for planar 4:2:0
Date: Wed,  1 Aug 2018 12:12:17 -0700
Message-Id: <1533150747-30677-5-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The U and V offset macros for planar 4:2:0 (U_OFFSET, V_OFFSET, and
UV_OFFSET), are not correct. The height component to the offset was
calculated as:

(pix->width * y / 4)

But this does not produce correct offsets for odd values of y (luma
line #). The luma line # must be decimated by two to produce the
correct U/V line #, so the correct formula is:

(pix->width * (y / 2) / 2)

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-cpmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index 9f2d9ec..e68e473 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -530,17 +530,17 @@ static const struct ipu_rgb def_bgra_16 = {
 
 #define Y_OFFSET(pix, x, y)	((x) + pix->width * (y))
 #define U_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
-				 (pix->width * (y) / 4) + (x) / 2)
+				 (pix->width * ((y) / 2) / 2) + (x) / 2)
 #define V_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
 				 (pix->width * pix->height / 4) +	\
-				 (pix->width * (y) / 4) + (x) / 2)
+				 (pix->width * ((y) / 2) / 2) + (x) / 2)
 #define U2_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
 				 (pix->width * (y) / 2) + (x) / 2)
 #define V2_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
 				 (pix->width * pix->height / 2) +	\
 				 (pix->width * (y) / 2) + (x) / 2)
 #define UV_OFFSET(pix, x, y)	((pix->width * pix->height) +	\
-				 (pix->width * (y) / 2) + (x))
+				 (pix->width * ((y) / 2)) + (x))
 #define UV2_OFFSET(pix, x, y)	((pix->width * pix->height) +	\
 				 (pix->width * y) + (x))
 
-- 
2.7.4
