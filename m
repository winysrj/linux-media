Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TNbWHb027560
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:37:33 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TNbI6R002228
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:37:18 -0400
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7TNbDsI023429
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:37:18 -0500
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id m7TNbCGb020498
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:37:12 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 29 Aug 2008 18:37:11 -0500
Message-ID: <A24693684029E5489D1D202277BE89441191E339@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 2/15] OMAP3 camera driver: V4L2: Adding internal IOCTLs for
 crop.
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

From: Sameer Venkatraman <sameerv@ti.com>

V4L2: Adding internal IOCTLs for crop.

Adding internal IOCTLs for crop.

Signed-off-by: Sameer Venkatraman <sameerv@ti.com>
Signed-off-by: Mohit Jalori <mjalori@ti.com>
---
 include/media/v4l2-int-device.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-omap-2.6/include/media/v4l2-int-device.h
===================================================================
--- linux-omap-2.6.orig/include/media/v4l2-int-device.h	2008-08-25 12:19:09.000000000 -0500
+++ linux-omap-2.6/include/media/v4l2-int-device.h	2008-08-25 12:19:10.000000000 -0500
@@ -170,6 +170,9 @@
 	vidioc_int_queryctrl_num,
 	vidioc_int_g_ctrl_num,
 	vidioc_int_s_ctrl_num,
+	vidioc_int_cropcap_num,
+	vidioc_int_g_crop_num,
+	vidioc_int_s_crop_num,
 	vidioc_int_g_parm_num,
 	vidioc_int_s_parm_num,
 
@@ -266,6 +269,9 @@
 V4L2_INT_WRAPPER_1(queryctrl, struct v4l2_queryctrl, *);
 V4L2_INT_WRAPPER_1(g_ctrl, struct v4l2_control, *);
 V4L2_INT_WRAPPER_1(s_ctrl, struct v4l2_control, *);
+V4L2_INT_WRAPPER_1(cropcap, struct v4l2_cropcap, *);
+V4L2_INT_WRAPPER_1(g_crop, struct v4l2_crop, *);
+V4L2_INT_WRAPPER_1(s_crop, struct v4l2_crop, *);
 V4L2_INT_WRAPPER_1(g_parm, struct v4l2_streamparm, *);
 V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
