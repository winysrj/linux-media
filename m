Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40281 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbcCXX22 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:28 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 41/51] v4l: vsp1: RPF entities can't be target nodes
Date: Fri, 25 Mar 2016 01:27:37 +0200
Message-Id: <1458862067-19525-42-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RPF entities are located at the very beginning of pipelines, they
can't be target nodes in the Data Path Router matrix. Remove their input
ID from the routing table.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 36d425234cd3..e4f832c764a6 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -160,11 +160,11 @@ static const struct vsp1_route vsp1_routes[] = {
 	{ VSP1_ENTITY_HST, 0, VI6_DPR_HST_ROUTE, { VI6_DPR_NODE_HST, } },
 	{ VSP1_ENTITY_LIF, 0, 0, { VI6_DPR_NODE_LIF, } },
 	{ VSP1_ENTITY_LUT, 0, VI6_DPR_LUT_ROUTE, { VI6_DPR_NODE_LUT, } },
-	{ VSP1_ENTITY_RPF, 0, VI6_DPR_RPF_ROUTE(0), { VI6_DPR_NODE_RPF(0), } },
-	{ VSP1_ENTITY_RPF, 1, VI6_DPR_RPF_ROUTE(1), { VI6_DPR_NODE_RPF(1), } },
-	{ VSP1_ENTITY_RPF, 2, VI6_DPR_RPF_ROUTE(2), { VI6_DPR_NODE_RPF(2), } },
-	{ VSP1_ENTITY_RPF, 3, VI6_DPR_RPF_ROUTE(3), { VI6_DPR_NODE_RPF(3), } },
-	{ VSP1_ENTITY_RPF, 4, VI6_DPR_RPF_ROUTE(4), { VI6_DPR_NODE_RPF(4), } },
+	{ VSP1_ENTITY_RPF, 0, VI6_DPR_RPF_ROUTE(0), { 0, } },
+	{ VSP1_ENTITY_RPF, 1, VI6_DPR_RPF_ROUTE(1), { 0, } },
+	{ VSP1_ENTITY_RPF, 2, VI6_DPR_RPF_ROUTE(2), { 0, } },
+	{ VSP1_ENTITY_RPF, 3, VI6_DPR_RPF_ROUTE(3), { 0, } },
+	{ VSP1_ENTITY_RPF, 4, VI6_DPR_RPF_ROUTE(4), { 0, } },
 	{ VSP1_ENTITY_SRU, 0, VI6_DPR_SRU_ROUTE, { VI6_DPR_NODE_SRU, } },
 	{ VSP1_ENTITY_UDS, 0, VI6_DPR_UDS_ROUTE(0), { VI6_DPR_NODE_UDS(0), } },
 	{ VSP1_ENTITY_UDS, 1, VI6_DPR_UDS_ROUTE(1), { VI6_DPR_NODE_UDS(1), } },
-- 
2.7.3

