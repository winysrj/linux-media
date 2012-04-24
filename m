Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:7222 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab2DXNsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 09:48:36 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFCv3 PATCH 6/6] Feature removal: remove invalid DV presets.
Date: Tue, 24 Apr 2012 15:48:05 +0200
Message-Id: <53adbed3d23acfd2f340c90d7fb3250eb36d5974.1335274503.git.hans.verkuil@cisco.com>
In-Reply-To: <1335275285-13333-1-git-send-email-hans.verkuil@cisco.com>
References: <1335275285-13333-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <c5dd21524394247c53a2d58797c64f974f4bd6ca.1335274503.git.hans.verkuil@cisco.com>
References: <c5dd21524394247c53a2d58797c64f974f4bd6ca.1335274503.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
1.7.9.5

