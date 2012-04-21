Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50337 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2DUSLS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 14:11:18 -0400
Received: by wibhj6 with SMTP id hj6so1632603wib.1
        for <linux-media@vger.kernel.org>; Sat, 21 Apr 2012 11:11:17 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v2] V4L: Schedule V4L2_CID_HCENTER, V4L2_CID_VCENTER controls for removal
Date: Sat, 21 Apr 2012 20:11:06 +0200
Message-Id: <1335031866-30945-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These controls have been marked for long time as V4L2_CID_HCENTER_DEPRECATED,
V4L2_CID_VCENTER_DEPRECATED in the DocBook and are going to be removed
from include/linux/videodev2.h.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Fixed small typo that snicked in in v1.

 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 03ca210..e4b5775 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -539,4 +539,13 @@ When:	3.6
 Why:	setitimer is not returning -EFAULT if user pointer is NULL. This
 	violates the spec.
 Who:	Sasikantha Babu <sasikanth.v19@gmail.com>
+
+----------------------------
+
+What:	V4L2_CID_HCENTER, V4L2_CID_VCENTER V4L2 controls
+When:	3.7
+Why:	The V4L2_CID_VCENTER, V4L2_CID_HCENTER controls have been deprecated
+	for about 4 years and they are not used by any mainline driver.
+	There are newer controls (V4L2_CID_PAN*, V4L2_CID_TILT*) that provide
+	similar	functionality.
+Who:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
--
1.7.4.1

