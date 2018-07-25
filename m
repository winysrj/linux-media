Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:35591 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729379AbeGYRvY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 13:51:24 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 09/34] media: camss: Unify the clock names
Date: Wed, 25 Jul 2018 19:38:18 +0300
Message-Id: <1532536723-19062-10-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
References: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use more logical clock names - similar to the names in documentation.
This will allow better handling of the clocks in the driver when support
for more hardware versions is added - equivalent clocks on different
hardware versions will have the same name.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index abf6184..0b663e0 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -32,8 +32,7 @@ static const struct resources csiphy_res[] = {
 	/* CSIPHY0 */
 	{
 		.regulator = { NULL },
-		.clock = { "camss_top_ahb", "ispif_ahb",
-			   "camss_ahb", "csiphy0_timer" },
+		.clock = { "top_ahb", "ispif_ahb", "ahb", "csiphy0_timer" },
 		.clock_rate = { { 0 },
 				{ 0 },
 				{ 0 },
@@ -45,8 +44,7 @@ static const struct resources csiphy_res[] = {
 	/* CSIPHY1 */
 	{
 		.regulator = { NULL },
-		.clock = { "camss_top_ahb", "ispif_ahb",
-			   "camss_ahb", "csiphy1_timer" },
+		.clock = { "top_ahb", "ispif_ahb", "ahb", "csiphy1_timer" },
 		.clock_rate = { { 0 },
 				{ 0 },
 				{ 0 },
@@ -60,8 +58,7 @@ static const struct resources csid_res[] = {
 	/* CSID0 */
 	{
 		.regulator = { "vdda" },
-		.clock = { "camss_top_ahb", "ispif_ahb",
-			   "csi0_ahb", "camss_ahb",
+		.clock = { "top_ahb", "ispif_ahb", "csi0_ahb", "ahb",
 			   "csi0", "csi0_phy", "csi0_pix", "csi0_rdi" },
 		.clock_rate = { { 0 },
 				{ 0 },
@@ -78,8 +75,7 @@ static const struct resources csid_res[] = {
 	/* CSID1 */
 	{
 		.regulator = { "vdda" },
-		.clock = { "camss_top_ahb", "ispif_ahb",
-			   "csi1_ahb", "camss_ahb",
+		.clock = { "top_ahb", "ispif_ahb", "csi1_ahb", "ahb",
 			   "csi1", "csi1_phy", "csi1_pix", "csi1_rdi" },
 		.clock_rate = { { 0 },
 				{ 0 },
@@ -96,10 +92,10 @@ static const struct resources csid_res[] = {
 
 static const struct resources_ispif ispif_res = {
 	/* ISPIF */
-	.clock = { "camss_top_ahb", "camss_ahb", "ispif_ahb",
+	.clock = { "top_ahb", "ahb", "ispif_ahb",
 		   "csi0", "csi0_pix", "csi0_rdi",
 		   "csi1", "csi1_pix", "csi1_rdi" },
-	.clock_for_reset = { "camss_vfe_vfe", "camss_csi_vfe" },
+	.clock_for_reset = { "vfe0", "csi_vfe0" },
 	.reg = { "ispif", "csi_clk_mux" },
 	.interrupt = "ispif"
 
@@ -108,8 +104,8 @@ static const struct resources_ispif ispif_res = {
 static const struct resources vfe_res = {
 	/* VFE0 */
 	.regulator = { NULL },
-	.clock = { "camss_top_ahb", "camss_vfe_vfe", "camss_csi_vfe",
-		   "iface", "bus", "camss_ahb" },
+	.clock = { "top_ahb", "vfe0", "csi_vfe0",
+		   "vfe_ahb", "vfe_axi", "ahb" },
 	.clock_rate = { { 0 },
 			{ 50000000, 80000000, 100000000, 160000000,
 			  177780000, 200000000, 266670000, 320000000,
-- 
2.7.4
