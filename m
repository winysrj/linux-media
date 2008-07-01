Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m614HIG3002376
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:17:18 -0400
Received: from calf.ext.ti.com (calf.ext.ti.com [198.47.26.144])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m614H5Rl020151
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:17:05 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by calf.ext.ti.com (8.13.7/8.13.7) with ESMTP id m614GtFT012464
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:17:00 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id m614Gs9Q015666
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:16:55 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m614GsG21146
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:16:54 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m614Gsuh028177
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:16:54 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m614Gs79028151
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 23:16:54 -0500
Date: Mon, 30 Jun 2008 23:16:54 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080701041654.GA28129@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [patch 1/16 resend] OMAP3 camera driver V4L2 get_slave
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

>From 0be1009427e55115058bfe72521a2a2811a976e8 Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@nokia.com>
Date: Tue, 15 Apr 2008 10:35:15 +0300
Subject: [PATCH] Adding IOCTL command to get slave private data.

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 include/media/v4l2-int-device.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index c8b80e0..d9a0053 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -184,6 +184,11 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_dev_exit_num,
 	/* Set device power state: 0 is off, non-zero is on. */
 	vidioc_int_s_power_num,
+	/*
+	* Get slave private data, e.g. platform-specific slave
+	* configuration used by the master.
+	*/
+	vidioc_int_g_priv_num,
 	/* Get slave interface parameters. */
 	vidioc_int_g_ifparm_num,
 	/* Does the slave need to be reset after VIDIOC_DQBUF? */
@@ -267,6 +272,7 @@ V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
 V4L2_INT_WRAPPER_0(dev_init);
 V4L2_INT_WRAPPER_0(dev_exit);
 V4L2_INT_WRAPPER_1(s_power, int, );
+V4L2_INT_WRAPPER_1(g_priv, void, *);
 V4L2_INT_WRAPPER_1(g_ifparm, struct v4l2_ifparm, *);
 V4L2_INT_WRAPPER_1(g_needs_reset, void, *);
 
-- 
1.5.5.1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
