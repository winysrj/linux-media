Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36282 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751524AbdJaQE0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 12:04:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 3/7] media: atomisp: fix switch coding style at input_system.c
Date: Tue, 31 Oct 2017 12:04:16 -0400
Message-Id: <849af8bbc79553ca6962caaec782c5ab92743344.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a switch at input_system.c that were causing smatch warnings:

drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c:610 rx_channel_get_state() warn: inconsistent indenting
drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c:616 rx_channel_get_state() warn: inconsistent indenting
drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c:622 rx_channel_get_state() warn: inconsistent indenting
drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c:610 rx_channel_get_state() warn: inconsistent indenting
drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c:616 rx_channel_get_state() warn: inconsistent indenting
drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c:622 rx_channel_get_state() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../hive_isp_css_common/host/input_system.c        | 32 +++++++++++-----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
index c9af2bfc1f88..cd2096fa75c8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c
@@ -602,30 +602,30 @@ STORAGE_CLASS_INLINE void rx_channel_get_state(
 	assert(state != NULL);
 
 	switch (ch_id) {
-		case 0:
-			state->comp_scheme0 = receiver_reg_load(ID,
+	case 0:
+		state->comp_scheme0 = receiver_reg_load(ID,
 				_HRT_CSS_RECEIVER_2400_COMP_SCHEME_VC0_REG0_IDX);
-			state->comp_scheme1 = receiver_reg_load(ID,
+		state->comp_scheme1 = receiver_reg_load(ID,
 				_HRT_CSS_RECEIVER_2400_COMP_SCHEME_VC0_REG1_IDX);
-	break;
-		case 1:
-			state->comp_scheme0 = receiver_reg_load(ID,
+		break;
+	case 1:
+		state->comp_scheme0 = receiver_reg_load(ID,
 				_HRT_CSS_RECEIVER_2400_COMP_SCHEME_VC1_REG0_IDX);
-			state->comp_scheme1 = receiver_reg_load(ID,
+		state->comp_scheme1 = receiver_reg_load(ID,
 				_HRT_CSS_RECEIVER_2400_COMP_SCHEME_VC1_REG1_IDX);
-	break;
-		case 2:
-			state->comp_scheme0 = receiver_reg_load(ID,
+		break;
+	case 2:
+		state->comp_scheme0 = receiver_reg_load(ID,
 				_HRT_CSS_RECEIVER_2400_COMP_SCHEME_VC2_REG0_IDX);
-			state->comp_scheme1 = receiver_reg_load(ID,
+		state->comp_scheme1 = receiver_reg_load(ID,
 				_HRT_CSS_RECEIVER_2400_COMP_SCHEME_VC2_REG1_IDX);
-	break;
-		case 3:
-			state->comp_scheme0 = receiver_reg_load(ID,
+		break;
+	case 3:
+		state->comp_scheme0 = receiver_reg_load(ID,
 				_HRT_CSS_RECEIVER_2400_COMP_SCHEME_VC3_REG0_IDX);
-			state->comp_scheme1 = receiver_reg_load(ID,
+		state->comp_scheme1 = receiver_reg_load(ID,
 				_HRT_CSS_RECEIVER_2400_COMP_SCHEME_VC3_REG1_IDX);
-	break;
+		break;
 	}
 
 /* See Table 7.1.17,..., 7.1.24 */
-- 
2.13.6
