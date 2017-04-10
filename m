Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:59224 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752844AbdDJT12 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 15:27:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 15/15] vsp1: set V4L2_CTRL_FLAG_MODIFY_LAYOUT for histogram controls
Date: Mon, 10 Apr 2017 21:26:51 +0200
Message-Id: <20170410192651.18486-16-hverkuil@xs4all.nl>
In-Reply-To: <20170410192651.18486-1-hverkuil@xs4all.nl>
References: <20170410192651.18486-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The two histogram controls will modify the layout of the
metadata, so this flag should be set.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vsp1/vsp1_hgo.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
index a138c6b7fb05..50309c053b78 100644
--- a/drivers/media/platform/vsp1/vsp1_hgo.c
+++ b/drivers/media/platform/vsp1/vsp1_hgo.c
@@ -111,6 +111,7 @@ static const struct v4l2_ctrl_config hgo_max_rgb_control = {
 	.max = 1,
 	.def = 0,
 	.step = 1,
+	.flags = V4L2_CTRL_FLAG_MODIFY_LAYOUT,
 };
 
 static const s64 hgo_num_bins[] = {
@@ -125,6 +126,7 @@ static const struct v4l2_ctrl_config hgo_num_bins_control = {
 	.max = 1,
 	.def = 0,
 	.qmenu_int = hgo_num_bins,
+	.flags = V4L2_CTRL_FLAG_MODIFY_LAYOUT,
 };
 
 /* -----------------------------------------------------------------------------
-- 
2.11.0
