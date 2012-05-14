Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3253 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab2ENTMO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 15:12:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/2] feature-removal: ISA video capture and parport webcams drivers
Date: Mon, 14 May 2012 21:11:59 +0200
Message-Id: <b92d0c68f094e8e8bf9b18158eeca000e7ce4eff.1337022203.git.hans.verkuil@cisco.com>
In-Reply-To: <1337022719-13868-1-git-send-email-hverkuil@xs4all.nl>
References: <1337022719-13868-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c367be3c7c534b7b3124bd45dbdd87776e86fec7.1337022203.git.hans.verkuil@cisco.com>
References: <c367be3c7c534b7b3124bd45dbdd87776e86fec7.1337022203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Announce the removal of the pms ISA video capture driver and the
parallel port w9966, bw-qcam and c-qcam drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 03ca210..65b8883 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -539,3 +539,13 @@ When:	3.6
 Why:	setitimer is not returning -EFAULT if user pointer is NULL. This
 	violates the spec.
 Who:	Sasikantha Babu <sasikanth.v19@gmail.com>
+
+----------------------------
+
+What:	Remove the ISA video capture driver pms and parallel port webcam
+	drivers bw-qcam, c-qcam and w9966.
+When:	3.6
+Why:	Nobody has the hardware anymore to test these, and ISA video boards and
+	parallel port webcams are really obsolete these days. Time to retire
+	these drivers.
+Who:	Hans Verkuil <hans.verkuil@cisco.com>
-- 
1.7.10

