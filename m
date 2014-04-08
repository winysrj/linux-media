Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4336 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385AbaDHIJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 04:09:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] v4l2-dv-timings.c: add the new 4K timings to the list.
Date: Tue,  8 Apr 2014 10:07:36 +0200
Message-Id: <9c6eb841696ba4a5fe47523ac87f93b7c6c06fce.1396944189.git.hans.verkuil@cisco.com>
In-Reply-To: <1396944456-20008-1-git-send-email-hverkuil@xs4all.nl>
References: <1396944456-20008-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3f4a49ed4bac96ac5bd05eb733a7d28fa37aee59.1396944189.git.hans.verkuil@cisco.com>
References: <3f4a49ed4bac96ac5bd05eb733a7d28fa37aee59.1396944189.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the new CEA-861-F and DMT 4K timings to the list of predefined
timings.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 48b20df..4ae54ca 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -131,6 +131,17 @@ const struct v4l2_dv_timings v4l2_dv_timings_presets[] = {
 	V4L2_DV_BT_DMT_2560X1600P75,
 	V4L2_DV_BT_DMT_2560X1600P85,
 	V4L2_DV_BT_DMT_2560X1600P120_RB,
+	V4L2_DV_BT_CEA_3840X2160P24,
+	V4L2_DV_BT_CEA_3840X2160P25,
+	V4L2_DV_BT_CEA_3840X2160P30,
+	V4L2_DV_BT_CEA_3840X2160P50,
+	V4L2_DV_BT_CEA_3840X2160P60,
+	V4L2_DV_BT_CEA_4096X2160P24,
+	V4L2_DV_BT_CEA_4096X2160P25,
+	V4L2_DV_BT_CEA_4096X2160P30,
+	V4L2_DV_BT_CEA_4096X2160P50,
+	V4L2_DV_BT_DMT_4096X2160P59_94_RB,
+	V4L2_DV_BT_CEA_4096X2160P60,
 	{ }
 };
 EXPORT_SYMBOL_GPL(v4l2_dv_timings_presets);
-- 
1.8.4.rc3

