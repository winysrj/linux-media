Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:46154 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab2F3RFl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 13:05:41 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: sylwester.nawrocki@gmail.com, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH 7/8] Feature removal: V4L2 selections API target and flag definitions
Date: Sat, 30 Jun 2012 20:03:58 +0300
Message-Id: <1341075839-18586-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120630170506.GE19384@valkosipuli.retiisi.org.uk>
References: <20120630170506.GE19384@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

After unification of the V4L2 and V4L2 subdev selection targets and flags
the old flags are no longer required. Thus they can be removed. However, as
the API is present in a kernel release, this must go through the feature
removal process.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/feature-removal-schedule.txt |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 09701af..b998030 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -558,3 +558,21 @@ Why:	The V4L2_CID_VCENTER, V4L2_CID_HCENTER controls have been deprecated
 	There are newer controls (V4L2_CID_PAN*, V4L2_CID_TILT*) that provide
 	similar	functionality.
 Who:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
+
+----------------------------
+
+What:	V4L2 selections API target rectangle and flags unification, the
+	following definitions will be removed: V4L2_SEL_TGT_CROP_ACTIVE,
+	V4L2_SEL_TGT_COMPOSE_ACTIVE, V4L2_SUBDEV_SEL_*, V4L2_SUBDEV_SEL_FLAG_*
+	in favor of common V4L2_SEL_TGT_* and V4L2_SEL_FLAG_* definitions.
+	For more details see include/linux/v4l2-common.h.
+When:	3.8
+Why:	The regular V4L2 selections and the subdev selection API originally
+	defined distinct names for the target rectangles and flags - V4L2_SEL_*
+	and V4L2_SUBDEV_SEL_*. Although, it turned out that the meaning of these
+	target rectangles is virtually identical and the APIs were consolidated
+	to use single set of names - V4L2_SEL_*. This didn't involve any ABI
+	changes. Alias definitions were created for the original ones to avoid
+	any instabilities in the user space interface. After few cycles these
+	backward compatibility definitions will be removed.
+Who:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
-- 
1.7.2.5

