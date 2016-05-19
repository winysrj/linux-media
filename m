Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56483 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbcESXmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 19:42:01 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 2/3] v4l: vsp1: Fix descriptions of Gen2 VSP instances
Date: Fri, 20 May 2016 02:41:57 +0300
Message-Id: <1463701318-22081-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1463701318-22081-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1463701318-22081-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The number of UDS and WPF are set to incorrect values, fix them.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index e655639af7e2..70e7a81e8255 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -560,7 +560,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_SRU,
 		.rpf_count = 5,
-		.uds_count = 1,
+		.uds_count = 3,
 		.wpf_count = 4,
 		.num_bru_inputs = 4,
 		.uapi = true,
@@ -570,7 +570,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_LUT,
 		.rpf_count = 4,
 		.uds_count = 1,
-		.wpf_count = 4,
+		.wpf_count = 1,
 		.num_bru_inputs = 4,
 		.uapi = true,
 	}, {
@@ -578,7 +578,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_LUT | VSP1_HAS_SRU,
 		.rpf_count = 5,
-		.uds_count = 3,
+		.uds_count = 1,
 		.wpf_count = 4,
 		.num_bru_inputs = 4,
 		.uapi = true,
-- 
2.7.3

