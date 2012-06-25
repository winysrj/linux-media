Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45574 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab2FYQwL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 12:52:11 -0400
Received: by wibhr14 with SMTP id hr14so1323289wib.1
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 09:52:09 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: sakari.ailus@iki.fi, mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] [media] Schedule the selections API compatibility definitions for removal
Date: Mon, 25 Jun 2012 18:51:58 +0200
Message-Id: <1340643118-32340-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <4FDB80C8.4060505@iki.fi>
References: <4FDB80C8.4060505@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/feature-removal-schedule.txt |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 09701af..ef9f942 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -558,3 +558,18 @@ Why:	The V4L2_CID_VCENTER, V4L2_CID_HCENTER controls have been deprecated
 	There are newer controls (V4L2_CID_PAN*, V4L2_CID_TILT*) that provide
 	similar	functionality.
 Who:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
+
+----------------------------
+
+What:	Remove the backward compatibility V4L2 selections target and selections
+	flags definitions
+When:	3.8
+Why:	The regular V4L2 selections and the subdev selection API originally
+	defined distinct names for the target rectangles and flags - V4L2_SEL_*
+	and V4L2_SUBDEV_SEL_*. Although, it turned out that the meaning of these
+	target rectangles is virtually identical and the APIs were consolidated
+	to use single set of names - V4L2_SEL_*. This consolidation didn't
+	change the ABI in any way. Alias definitions were created for the
+	original ones to avoid any instabilities in the user space interface.
+	After few cycles these comptibility definitions will be removed.
+Who:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
-- 
1.7.4.1

