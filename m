Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m96B8UDV002989
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 07:08:30 -0400
Received: from mgw-mx09.nokia.com (smtp.nokia.com [192.100.105.134])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m96B8JQ9008041
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 07:08:20 -0400
From: Sakari Ailus <sakari.ailus@nokia.com>
To: video4linux-list@redhat.com
Date: Mon,  6 Oct 2008 14:07:50 +0300
Message-Id: <1223291272973-git-send-email-sakari.ailus@nokia.com>
In-Reply-To: <12232912721943-git-send-email-sakari.ailus@nokia.com>
References: <48E9F178.50507@nokia.com>
	<12232912722008-git-send-email-sakari.ailus@nokia.com>
	<12232912722050-git-send-email-sakari.ailus@nokia.com>
	<12232912721943-git-send-email-sakari.ailus@nokia.com>
Cc: vimarsh.zutshi@nokia.com, tuukka.o.toivonen@nokia.com, hnagalla@ti.com
Subject: [PATCH] V4L: Int if: Define new power state changes
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

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 include/media/v4l2-int-device.h |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index cee941c..bf11de7 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -96,6 +96,26 @@ int v4l2_int_ioctl_1(struct v4l2_int_device *d, int cmd, void *arg);
  *
  */
 
+/*
+ * Slave power state & commands
+ *
+ * V4L2_POWER_OFF, V4L2_POWER_ON and V4L2_POWER_STANDBY are the slave
+ * power states. Resume is a command for transitioning form
+ * V4L2_POWER_STANDBY to V4L2_POWER_ON.
+ *
+ * Possible state transitions:
+ *
+ * V4L2_POWER_OFF: V4L2_POWER_ON
+ * V4L2_POWER_ON: V4L2_POWER_OFF, V4L2_POWER_STANDBY
+ * V4L2_POWER_STANDBY: V4L2_POWER_OFF, V4L2_POWER_ON (V4L2_POWER_RESUME)
+ */
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
@@ -185,7 +205,7 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_dev_init_num = 1000,
 	/* Delinitialise the device at slave detach. */
 	vidioc_int_dev_exit_num,
-	/* Set device power state: 0 is off, non-zero is on. */
+	/* Set device power state. */
 	vidioc_int_s_power_num,
 	/*
 	* Get slave private data, e.g. platform-specific slave
@@ -277,7 +297,7 @@ V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
 
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
