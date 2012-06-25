Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65099 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2FYTOy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 15:14:54 -0400
Received: by wibhr14 with SMTP id hr14so1443096wib.1
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 12:14:53 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: sakari.ailus@iki.fi, mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v2] [media] Feature removal: V4L2 selections API target and flag definitions
Date: Mon, 25 Jun 2012 21:14:41 +0200
Message-Id: <1340651681-21125-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1340643118-32340-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1340643118-32340-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
Added more precise description of what is being removed.
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
1.7.4.1

