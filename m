Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38391 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbGPQZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 12:25:09 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>,
	Ian Molton <imolton@ad-holdings.co.uk>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 1/5] gpu: ipu-v3: Add missing IDMAC channel names
Date: Thu, 16 Jul 2015 18:24:39 +0200
Message-Id: <1437063883-23981-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1437063883-23981-1-git-send-email-p.zabel@pengutronix.de>
References: <1437063883-23981-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the remaining missing IDMAC channel names: all VDIC
channels for deinterlacing and combining, the separate alpha channels
for the MEM->IC and MEM->DC ASYNC channels, and the DC read, command,
and output mask channels.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/video/imx-ipu-v3.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 85dedca..0cf0a51 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -96,20 +96,34 @@ enum ipu_channel_irq {
 #define IPUV3_CHANNEL_CSI2			 2
 #define IPUV3_CHANNEL_CSI3			 3
 #define IPUV3_CHANNEL_VDI_MEM_IC_VF		 5
+#define IPUV3_CHANNEL_MEM_VDI_PREV		 8
+#define IPUV3_CHANNEL_MEM_VDI_CUR		 9
+#define IPUV3_CHANNEL_MEM_VDI_NEXT		10
 #define IPUV3_CHANNEL_MEM_IC_PP			11
 #define IPUV3_CHANNEL_MEM_IC_PRP_VF		12
+#define IPUV3_CHANNEL_VDI_MEM_RECENT		13
 #define IPUV3_CHANNEL_G_MEM_IC_PRP_VF		14
 #define IPUV3_CHANNEL_G_MEM_IC_PP		15
+#define IPUV3_CHANNEL_G_MEM_IC_PRP_VF_ALPHA	17
+#define IPUV3_CHANNEL_G_MEM_IC_PP_ALPHA		18
+#define IPUV3_CHANNEL_MEM_VDI_PLANE1_COMB_ALPHA	19
 #define IPUV3_CHANNEL_IC_PRP_ENC_MEM		20
 #define IPUV3_CHANNEL_IC_PRP_VF_MEM		21
 #define IPUV3_CHANNEL_IC_PP_MEM			22
 #define IPUV3_CHANNEL_MEM_BG_SYNC		23
 #define IPUV3_CHANNEL_MEM_BG_ASYNC		24
+#define IPUV3_CHANNEL_MEM_VDI_PLANE1_COMB	25
+#define IPUV3_CHANNEL_MEM_VDI_PLANE3_COMB	26
 #define IPUV3_CHANNEL_MEM_FG_SYNC		27
 #define IPUV3_CHANNEL_MEM_DC_SYNC		28
 #define IPUV3_CHANNEL_MEM_FG_ASYNC		29
 #define IPUV3_CHANNEL_MEM_FG_SYNC_ALPHA		31
+#define IPUV3_CHANNEL_MEM_FG_ASYNC_ALPHA	33
+#define IPUV3_CHANNEL_DC_MEM_READ		40
 #define IPUV3_CHANNEL_MEM_DC_ASYNC		41
+#define IPUV3_CHANNEL_MEM_DC_COMMAND		42
+#define IPUV3_CHANNEL_MEM_DC_COMMAND2		43
+#define IPUV3_CHANNEL_MEM_DC_OUTPUT_MASK	44
 #define IPUV3_CHANNEL_MEM_ROT_ENC		45
 #define IPUV3_CHANNEL_MEM_ROT_VF		46
 #define IPUV3_CHANNEL_MEM_ROT_PP		47
@@ -117,6 +131,7 @@ enum ipu_channel_irq {
 #define IPUV3_CHANNEL_ROT_VF_MEM		49
 #define IPUV3_CHANNEL_ROT_PP_MEM		50
 #define IPUV3_CHANNEL_MEM_BG_SYNC_ALPHA		51
+#define IPUV3_CHANNEL_MEM_BG_ASYNC_ALPHA	52
 
 int ipu_map_irq(struct ipu_soc *ipu, int irq);
 int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
-- 
2.1.4

