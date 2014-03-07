Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4155 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaCGKh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 05:37:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH for v3.14 2/3] v4l2-dv-timings: add module name, description, license.
Date: Fri,  7 Mar 2014 11:37:48 +0100
Message-Id: <1394188669-22260-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394188669-22260-1-git-send-email-hverkuil@xs4all.nl>
References: <1394188669-22260-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 41bf3f9..37ad777 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -26,6 +26,10 @@
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-dv-timings.h>
 
+MODULE_AUTHOR("Hans Verkuil");
+MODULE_DESCRIPTION("V4L2 DV Timings Helper Functions");
+MODULE_LICENSE("GPL");
+
 const struct v4l2_dv_timings v4l2_dv_timings_presets[] = {
 	V4L2_DV_BT_CEA_640X480P59_94,
 	V4L2_DV_BT_CEA_720X480I59_94,
-- 
1.9.0

