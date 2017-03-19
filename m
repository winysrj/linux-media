Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43020 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751591AbdCSKs7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 06:48:59 -0400
In-Reply-To: <20170319103801.GQ21222@n2100.armlinux.org.uk>
References: <20170319103801.GQ21222@n2100.armlinux.org.uk>
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Subject: [PATCH 1/4] media: imx-media-csi: fix v4l2-compliance check
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1cpYOK-0006EZ-No@rmk-PC.armlinux.org.uk>
Date: Sun, 19 Mar 2017 10:48:52 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance was failing with:

                fail: v4l2-test-formats.cpp(1076): cap->timeperframe.numerator == 0 || cap->timeperframe.denominator == 0
                test VIDIOC_G/S_PARM: FAIL

Fix this.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/staging/media/imx/imx-media-csi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 0336891069dc..65346e789dd6 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -680,8 +680,10 @@ static const struct csi_skip_desc *csi_find_best_skip(struct v4l2_fract *in,
 
 	/* Default to 1:1 ratio */
 	if (out->numerator == 0 || out->denominator == 0 ||
-	    in->numerator == 0 || in->denominator == 0)
+	    in->numerator == 0 || in->denominator == 0) {
+		*out = *in;
 		return best_skip;
+	}
 
 	want_us = div_u64((u64)USEC_PER_SEC * out->numerator, out->denominator);
 
-- 
2.7.4
