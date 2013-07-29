Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:15131 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3G2Mrl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:47:41 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r6TClZLk009651
	for <linux-media@vger.kernel.org>; Mon, 29 Jul 2013 12:47:37 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] qv4l2: Fixed a bug in the v4l2-api
Date: Mon, 29 Jul 2013 14:47:33 +0200
Message-Id: <20b0016794892a35cfc11b4f1aecd2dbb1b10466.1375102016.git.bwinther@cisco.com>
In-Reply-To: <1375102053-3603-1-git-send-email-bwinther@cisco.com>
References: <1375102053-3603-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The get_interval would return false even if devices had support for this

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/v4l2-api.cpp | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/utils/qv4l2/v4l2-api.cpp b/utils/qv4l2/v4l2-api.cpp
index 9c37be3..7a438af 100644
--- a/utils/qv4l2/v4l2-api.cpp
+++ b/utils/qv4l2/v4l2-api.cpp
@@ -613,13 +613,11 @@ bool v4l2::set_interval(v4l2_fract interval)
 bool v4l2::get_interval(v4l2_fract &interval)
 {
 	v4l2_streamparm parm;
-
 	parm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	if (ioctl(VIDIOC_G_PARM, &parm) >= 0 &&
-	    (parm.parm.capture.capability & V4L2_CAP_TIMEPERFRAME)) {
-		interval = parm.parm.capture.timeperframe;
-		return true;
-        }
 
-	return false;
+	if (ioctl(VIDIOC_G_PARM, &parm) < 0)
+		return false;
+
+	interval = parm.parm.capture.timeperframe;
+	return interval.numerator && interval.denominator;
 }
-- 
1.8.3.2

