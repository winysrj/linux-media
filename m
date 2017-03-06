Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28897 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752799AbdCFLtV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 06:49:21 -0500
Subject: [PATCH] atomisp: fix __udiv warning
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 06 Mar 2017 11:48:30 +0000
Message-ID: <148880090137.25601.18382191536021391777.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Certain combinations of compiler and compiler options product an imx.o that
calls compiler helpers for a u64 divide. Use the do_div() call instead.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/imx/imx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/imx/imx.c b/drivers/staging/media/atomisp/i2c/imx/imx.c
index 47286de..f6e12c6 100644
--- a/drivers/staging/media/atomisp/i2c/imx/imx.c
+++ b/drivers/staging/media/atomisp/i2c/imx/imx.c
@@ -819,13 +819,14 @@ static int imx_get_intg_factor(struct i2c_client *client,
 
 	if (dev->sensor_id == IMX132_ID || dev->sensor_id == IMX208_ID)
 		vt_pix_clk_freq_mhz = ext_clk_freq_hz / div;
-	else if (dev->sensor_id == IMX227_ID)
+	else if (dev->sensor_id == IMX227_ID) {
 		/* according to IMX227 datasheet:
 		 * vt_pix_freq_mhz = * num_of_vt_lanes(4) * ivt_pix_clk_freq_mhz
 		 */
 		vt_pix_clk_freq_mhz =
-			(u64)4 * ext_clk_freq_hz * pll_multiplier / div;
-	else
+			(u64)4 * ext_clk_freq_hz * pll_multiplier;
+		do_div(vt_pix_clk_freq_mhz, div);
+	} else
 		vt_pix_clk_freq_mhz = 2 * ext_clk_freq_hz / div;
 
 	vt_pix_clk_freq_mhz *= pll_multiplier;
