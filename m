Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m88GmaJ5014155
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 12:48:36 -0400
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m88GmPsM021818
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 12:48:25 -0400
From: Sakari Ailus <sakari.ailus@nokia.com>
To: video4linux-list@redhat.com
Date: Mon,  8 Sep 2008 19:48:11 +0300
Message-Id: <1220892493727-git-send-email-sakari.ailus@nokia.com>
In-Reply-To: <12208924933079-git-send-email-sakari.ailus@nokia.com>
References: <48C55737.4080804@nokia.com>
	<12208924933529-git-send-email-sakari.ailus@nokia.com>
	<12208924931107-git-send-email-sakari.ailus@nokia.com>
	<12208924933015-git-send-email-sakari.ailus@nokia.com>
	<12208924933079-git-send-email-sakari.ailus@nokia.com>
Cc: tuukka.o.toivonen@nokia.com, vherkuil@xs4all.nl, vimarsh.zutshi@nokia.com
Subject: [PATCH 5/7] V4L: Int if: Define new power state changes
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

Use enum v4l2_power instead of int as second argument to
vidioc_int_s_power. The new functionality is that standby state is also
recognised.

Possible transitions:

off -> on (V4L2_POWER_ON)

on -> standby (V4L2_POWER_STANDBY)
on -> off (V4L2_POWER_OFF)

standby -> off (V4L2_POWER_OFF)
standby -> on (V4L2_POWER_RESUME)

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 include/media/v4l2-int-device.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index 161b236..d3c5d22 100644
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
@@ -185,7 +192,7 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_dev_init_num = 1000,
 	/* Delinitialise the device at slave detach. */
 	vidioc_int_dev_exit_num,
-	/* Set device power state: 0 is off, non-zero is on. */
+	/* Set device power state. */
 	vidioc_int_s_power_num,
 	/*
 	* Get slave private data, e.g. platform-specific slave
@@ -279,7 +286,7 @@ V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
 
 V4L2_INT_WRAPPER_0(dev_init);
 V4L2_INT_WRAPPER_0(dev_exit);
-V4L2_INT_WRAPPER_1(s_power, int, );
+V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, );
 V4L2_INT_WRAPPER_1(g_priv, void, *);
 V4L2_INT_WRAPPER_1(g_ifparm, struct v4l2_ifparm, *);
 V4L2_INT_WRAPPER_1(g_needs_reset, void, *);
-- 
1.5.0.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
