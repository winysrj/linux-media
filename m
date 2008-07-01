Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6144ZbF029380
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:04:35 -0400
Received: from soda.ext.ti.com (soda.ext.ti.com [198.47.26.145])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6144M2K014004
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:04:22 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by soda.ext.ti.com (8.13.7/8.13.7) with ESMTP id m6144Cod015049
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:04:17 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id m6144CJf002958
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:04:12 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m6144CG19594
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:04:12 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m6144Bs0018632
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:04:11 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m6144BcY018591
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 23:04:11 -0500
Date: Mon, 30 Jun 2008 23:04:11 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080701040411.GA18576@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 6/16] OMAP3 camera driver V4L2 power states
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

>From e2277399f9a46a2c6dbe7aacf072d0b9a457dbff Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@nokia.com>
Date: Thu, 8 May 2008 19:29:19 +0300
Subject: [PATCH] V4L: Int if: define new power states

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 include/media/v4l2-int-device.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index fc14264..6795b32 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -96,6 +96,13 @@ int v4l2_int_ioctl_1(struct v4l2_int_device *d, int cmd, void *arg);
  *
  */
 
+enum v4l2_power {
+	V4L2_POWER_OFF = 0,
+	V4L2_POWER_ON,
+	V4L2_POWER_STANDBY,
+	V4L2_POWER_RESUME,
+};
+
 /* Slave interface type. */
 enum v4l2_if_type {
 	/*
@@ -286,7 +293,7 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_dev_init_num = 1000,
 	/* Delinitialise the device at slave detach. */
 	vidioc_int_dev_exit_num,
-	/* Set device power state: 0 is off, non-zero is on. */
+	/* Set device power state. */
 	vidioc_int_s_power_num,
 	/*
 	* Get slave private data, e.g. platform-specific slave
@@ -380,7 +387,7 @@ V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
 
 V4L2_INT_WRAPPER_0(dev_init);
 V4L2_INT_WRAPPER_0(dev_exit);
-V4L2_INT_WRAPPER_1(s_power, int, );
+V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, );
 V4L2_INT_WRAPPER_1(g_priv, void, *);
 V4L2_INT_WRAPPER_1(g_ifparm, struct v4l2_ifparm, *);
 V4L2_INT_WRAPPER_1(g_needs_reset, void, *);
-- 
1.5.5.1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
