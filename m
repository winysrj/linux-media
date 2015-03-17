Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39004 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbbCQPsd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2015 11:48:33 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	Ian Molton <imolton@ad-holdings.co.uk>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/5] gpu: ipu-v3: Register scaler platform device
Date: Tue, 17 Mar 2015 16:48:08 +0100
Message-Id: <1426607290-13380-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1426607290-13380-1-git-send-email-p.zabel@pengutronix.de>
References: <1426607290-13380-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch registers the scaler device using the IC post-processing task,
to be handled by a mem2mem scaler driver.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 67bab5c..cf89692 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1026,6 +1026,8 @@ static const struct ipu_platform_reg client_reg[] = {
 		},
 		.reg_offset = IPU_CM_CSI1_REG_OFS,
 		.name = "imx-ipuv3-camera",
+	}, {
+		.name = "imx-ipuv3-scaler",
 	},
 };
 
-- 
2.1.4

