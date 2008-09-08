Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m88GmYj2014141
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 12:48:35 -0400
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m88GmOpb021807
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 12:48:24 -0400
From: Sakari Ailus <sakari.ailus@nokia.com>
To: video4linux-list@redhat.com
Date: Mon,  8 Sep 2008 19:48:08 +0300
Message-Id: <12208924931107-git-send-email-sakari.ailus@nokia.com>
In-Reply-To: <12208924933529-git-send-email-sakari.ailus@nokia.com>
References: <48C55737.4080804@nokia.com>
	<12208924933529-git-send-email-sakari.ailus@nokia.com>
Cc: tuukka.o.toivonen@nokia.com, vherkuil@xs4all.nl, vimarsh.zutshi@nokia.com
Subject: [PATCH 2/7] V4L: Int if: Add cropcap, g_crop and s_crop commands.
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

Signed-off-by: Sameer Venkatraman <sameerv@ti.com>
Signed-off-by: Mohit Jalori <mjalori@ti.com>
---
 include/media/v4l2-int-device.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index d9a0053..cee941c 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -170,6 +170,9 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_queryctrl_num,
 	vidioc_int_g_ctrl_num,
 	vidioc_int_s_ctrl_num,
+	vidioc_int_cropcap_num,
+	vidioc_int_g_crop_num,
+	vidioc_int_s_crop_num,
 	vidioc_int_g_parm_num,
 	vidioc_int_s_parm_num,
 
@@ -266,6 +269,9 @@ V4L2_INT_WRAPPER_1(try_fmt_cap, struct v4l2_format, *);
 V4L2_INT_WRAPPER_1(queryctrl, struct v4l2_queryctrl, *);
 V4L2_INT_WRAPPER_1(g_ctrl, struct v4l2_control, *);
 V4L2_INT_WRAPPER_1(s_ctrl, struct v4l2_control, *);
+V4L2_INT_WRAPPER_1(cropcap, struct v4l2_cropcap, *);
+V4L2_INT_WRAPPER_1(g_crop, struct v4l2_crop, *);
+V4L2_INT_WRAPPER_1(s_crop, struct v4l2_crop, *);
 V4L2_INT_WRAPPER_1(g_parm, struct v4l2_streamparm, *);
 V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
 
-- 
1.5.0.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
