Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53141 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3HERwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 13:52:41 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v6 10/10] vsp1: Use the maximum number of entities defined in platform data
Date: Mon,  5 Aug 2013 19:53:29 +0200
Message-Id: <1375725209-2674-11-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375725209-2674-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1375725209-2674-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Katsuya Matsubara <matsu@igel.co.jp>

The VSP1 driver allows to define the maximum number of each module
such as RPF, WPF, and UDS in a platform data definition.
This suppresses operations for nonexistent or unused modules.

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 41dd891..8700842 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -35,7 +35,7 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
 	irqreturn_t ret = IRQ_NONE;
 	unsigned int i;
 
-	for (i = 0; i < VPS1_MAX_WPF; ++i) {
+	for (i = 0; i < vsp1->pdata->wpf_count; ++i) {
 		struct vsp1_rwpf *wpf = vsp1->wpf[i];
 		struct vsp1_pipeline *pipe;
 		u32 status;
@@ -243,7 +243,7 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	/* Reset any channel that might be running. */
 	status = vsp1_read(vsp1, VI6_STATUS);
 
-	for (i = 0; i < VPS1_MAX_WPF; ++i) {
+	for (i = 0; i < vsp1->pdata->wpf_count; ++i) {
 		unsigned int timeout;
 
 		if (!(status & VI6_STATUS_SYS_ACT(i)))
@@ -267,10 +267,10 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_CLK_DCSWT, (8 << VI6_CLK_DCSWT_CSTPW_SHIFT) |
 		   (8 << VI6_CLK_DCSWT_CSTRW_SHIFT));
 
-	for (i = 0; i < VPS1_MAX_RPF; ++i)
+	for (i = 0; i < vsp1->pdata->rpf_count; ++i)
 		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE(i), VI6_DPR_NODE_UNUSED);
 
-	for (i = 0; i < VPS1_MAX_UDS; ++i)
+	for (i = 0; i < vsp1->pdata->uds_count; ++i)
 		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE(i), VI6_DPR_NODE_UNUSED);
 
 	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, VI6_DPR_NODE_UNUSED);
-- 
1.8.1.5

