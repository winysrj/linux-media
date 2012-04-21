Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48614 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2DUSBq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 14:01:46 -0400
Received: by wejx9 with SMTP id x9so6680527wej.19
        for <linux-media@vger.kernel.org>; Sat, 21 Apr 2012 11:01:44 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] V4L: Schedule V4L2_CID_HCENTER, V4L2_CID_VCENTER controls for removal
Date: Sat, 21 Apr 2012 20:01:34 +0200
Message-Id: <1335031294-12123-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These controls have been marked for ling time as V4L2_CID_HCENTER_DEPRECATED,
V4L2_CID_VCENTER_DEPRECATED in the DocBook and are going to be removed
from include/linux/videodev2.h.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
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

