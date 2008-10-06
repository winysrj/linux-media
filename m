Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m96B8aHA003015
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 07:08:36 -0400
Received: from mgw-mx09.nokia.com (smtp.nokia.com [192.100.105.134])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m96B8Q5L008107
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 07:08:26 -0400
From: Sakari Ailus <sakari.ailus@nokia.com>
To: video4linux-list@redhat.com
Date: Mon,  6 Oct 2008 14:07:52 +0300
Message-Id: <12232912722650-git-send-email-sakari.ailus@nokia.com>
In-Reply-To: <12232912721018-git-send-email-sakari.ailus@nokia.com>
References: <48E9F178.50507@nokia.com>
	<12232912722008-git-send-email-sakari.ailus@nokia.com>
	<12232912722050-git-send-email-sakari.ailus@nokia.com>
	<12232912721943-git-send-email-sakari.ailus@nokia.com>
	<1223291272973-git-send-email-sakari.ailus@nokia.com>
	<12232912721018-git-send-email-sakari.ailus@nokia.com>
Cc: vimarsh.zutshi@nokia.com, tuukka.o.toivonen@nokia.com, hnagalla@ti.com
Subject: [PATCH] V4L: Int if: Add enum_framesizes and enum_frameintervals
	ioctls.
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

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 include/media/v4l2-int-device.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index 9b7b008..1356055 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -218,6 +218,8 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_g_ifparm_num,
 	/* Does the slave need to be reset after VIDIOC_DQBUF? */
 	vidioc_int_g_needs_reset_num,
+	vidioc_int_enum_framesizes_num,
+	vidioc_int_enum_frameintervals_num,
 
 	/*
 	 *
@@ -303,6 +305,8 @@ V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, );
 V4L2_INT_WRAPPER_1(g_priv, void, *);
 V4L2_INT_WRAPPER_1(g_ifparm, struct v4l2_ifparm, *);
 V4L2_INT_WRAPPER_1(g_needs_reset, void, *);
+V4L2_INT_WRAPPER_1(enum_framesizes, struct v4l2_frmsizeenum, *);
+V4L2_INT_WRAPPER_1(enum_frameintervals, struct v4l2_frmivalenum, *);
 
 V4L2_INT_WRAPPER_0(reset);
 V4L2_INT_WRAPPER_0(init);
-- 
1.5.0.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
