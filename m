Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4750 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab2EAJGB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 05:06:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/7] Feature removal: remove invalid DV presets.
Date: Tue,  1 May 2012 11:05:51 +0200
Message-Id: <b2077c2a56c33a65c9625ab04fe1ef166ea95f60.1335862609.git.hans.verkuil@cisco.com>
In-Reply-To: <1335863152-15791-1-git-send-email-hverkuil@xs4all.nl>
References: <1335863152-15791-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <de77f3452a3710c48282ebe24937731b252a1ef7.1335862609.git.hans.verkuil@cisco.com>
References: <de77f3452a3710c48282ebe24937731b252a1ef7.1335862609.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Formats V4L2_DV_1080I25, V4L2_DV_1080I30 and V4L2_DV_1080I29_97
do not exist, so these presets are bogus. Remove them in 3.6.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 03ca210..efbe878 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -539,3 +539,12 @@ When:	3.6
 Why:	setitimer is not returning -EFAULT if user pointer is NULL. This
 	violates the spec.
 Who:	Sasikantha Babu <sasikanth.v19@gmail.com>
+
+----------------------------
+
+What:	remove bogus DV presets V4L2_DV_1080I29_97, V4L2_DV_1080I30 and
+	V4L2_DV_1080I25
+When:	3.6
+Why:	These HDTV formats do not exist and were added by a confused mind
+	(that was me, to be precise...)
+Who:	Hans Verkuil <hans.verkuil@cisco.com>
-- 
1.7.10

