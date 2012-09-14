Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:52458 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab2INK6A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:58:00 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBi013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:55 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 13/31] Feature removal: Remove CUSTOM_TIMINGS defines in 3.9.
Date: Fri, 14 Sep 2012 12:57:28 +0200
Message-Id: <3629d5063c36dfc2a570c7afa831b8d849814bb5.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These have been replaced by new defines without the "CUSTOM_" part.
Get rid of the old ones.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index a52924e..4f7e6ad 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -646,3 +646,12 @@ Who:	Russell King <linux@arm.linux.org.uk>,
 	Santosh Shilimkar <santosh.shilimkar@ti.com>
 
 ----------------------------
+
+What:	Remove deprecated DV timings capability defines V4L2_IN_CAP_CUSTOM_TIMINGS
+	and V4L2_OUT_CAP_CUSTOM_TIMINGS.
+When:	3.9
+Why:	These defines have been replaced by V4L2_IN_CAP_TIMINGS and
+	V4L2_OUT_CAP_TIMINGS respectively.
+Who:	Hans Verkuil <hans.verkuil@cisco.com>
+
+----------------------------
-- 
1.7.10.4

