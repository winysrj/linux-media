Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38063 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2F3TYd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 15:24:33 -0400
Received: by eaak11 with SMTP id k11so1705020eaa.19
        for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 12:24:31 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: posciak@google.com, andrzej.p@samsung.com, hans.verkuil@cisco.com,
	hdegoede@redhat.com, javier.martin@vista-silicon.com,
	jtp.park@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, mchehab@infradead.org,
	m.szyprowski@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH/RFC 2/2] Feature removal: using capture and output capabilities for m2m devices
Date: Sat, 30 Jun 2012 21:23:43 +0200
Message-Id: <1341084223-4616-3-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1341084223-4616-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1341084223-4616-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Identifying a memory-to-memory video device through an ORed output and capture
capability flags is not reliable. Schedule this for removal.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/feature-removal-schedule.txt |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 09701af..950d84a 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -558,3 +558,17 @@ Why:	The V4L2_CID_VCENTER, V4L2_CID_HCENTER controls have been deprecated
 	There are newer controls (V4L2_CID_PAN*, V4L2_CID_TILT*) that provide
 	similar	functionality.
 Who:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
+
+----------------------------
+
+What:	Using V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_OUTPUT flags
+	to indicate a V4L2 memory-to-memory device capability
+When:	3.8
+Why:	New drivers should use new V4L2_CAP_VIDEO_M2M capability flag
+	to indicate a V4L2 video memory-to-memory (M2M) device and
+	applications can now identify a M2M video device by checking
+	for V4L2_CAP_VIDEO_M2M, with VIDIOC_QUERYCAP ioctl. Using ORed
+	V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_OUTPUT flags for M2M
+	devices is ambiguous and may lead, for example, to identifying
+	a M2M device as a video	capture or output device.
+Who:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
--
1.7.4.1

