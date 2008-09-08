Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m88GmTjN014107
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 12:48:30 -0400
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m88GmI6G021768
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 12:48:19 -0400
From: Sakari Ailus <sakari.ailus@nokia.com>
To: video4linux-list@redhat.com
Date: Mon,  8 Sep 2008 19:48:13 +0300
Message-Id: <12208924931940-git-send-email-sakari.ailus@nokia.com>
In-Reply-To: <12208924934155-git-send-email-sakari.ailus@nokia.com>
References: <48C55737.4080804@nokia.com>
	<12208924933529-git-send-email-sakari.ailus@nokia.com>
	<12208924931107-git-send-email-sakari.ailus@nokia.com>
	<12208924933015-git-send-email-sakari.ailus@nokia.com>
	<12208924933079-git-send-email-sakari.ailus@nokia.com>
	<1220892493727-git-send-email-sakari.ailus@nokia.com>
	<12208924934155-git-send-email-sakari.ailus@nokia.com>
Cc: tuukka.o.toivonen@nokia.com, vherkuil@xs4all.nl, vimarsh.zutshi@nokia.com
Subject: [PATCH 7/7] V4L: Int if: Add enum_framesizes and
	enum_frameintervals ioctls.
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
index 489808e..62c92cf 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -205,6 +205,8 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_g_ifparm_num,
 	/* Does the slave need to be reset after VIDIOC_DQBUF? */
 	vidioc_int_g_needs_reset_num,
+	vidioc_int_enum_framesizes_num,
+	vidioc_int_enum_frameintervals_num,
 
 	/*
 	 *
@@ -292,6 +294,8 @@ V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, );
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
