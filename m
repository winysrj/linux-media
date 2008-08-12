Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7C9MpXg021175
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 05:22:51 -0400
Received: from calf.ext.ti.com (calf.ext.ti.com [198.47.26.144])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7C9M4EF023245
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 05:22:10 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by calf.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7C9LpKt027161
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 04:21:58 -0500
From: Sivaraj R <sivaraj@ti.com>
To: video4linux-list@redhat.com
Date: Tue, 12 Aug 2008 14:51:48 +0530
Message-Id: <1218532908-11505-1-git-send-email-sivaraj@ti.com>
In-Reply-To: <sivaraj@ti.com>
References: <sivaraj@ti.com>
Cc: 
Subject: [PATCH] Addition of Input/Output related V4L2 Int Ioctl
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

Added v4l2 interface ioctls for query std, set std, enum input, set input,
get input, enum output, set output and get output.

Reason for change:
v4l2-int-device.h file was introduced to interface with sensor device drivers
(slave) with main video driver (master). But the ioctls required to interface
with decoders and encoders were missing. Most of the decoders and encoders
support multiple inputs/outputs interfaces like s-video/composite. These ioctls
are used to select between these inputs/outputs.

Signed-off-by: Brijesh R Jadav <brijesh.j@ti.com>
               Hardik Shah <hardik.shah@ti.com>
               Manjunath Hadli <mrh@ti.com>
               Sivaraj R <sivaraj@ti.com>
               Vaibhav Hiremath <hvaibhav@ti.com>
---
 include/media/v4l2-int-device.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index c8b80e0..856f1fe 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -172,6 +172,14 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_s_ctrl_num,
 	vidioc_int_g_parm_num,
 	vidioc_int_s_parm_num,
+	vidioc_int_querystd_num,
+	vidioc_int_s_std_num,
+	vidioc_int_enum_input_num,
+	vidioc_int_g_input_num,
+	vidioc_int_s_input_num,
+	vidioc_int_enumoutput_num,
+	vidioc_int_g_output_num,
+	vidioc_int_s_output_num,

 	/*
 	 *
@@ -263,6 +271,14 @@ V4L2_INT_WRAPPER_1(g_ctrl, struct v4l2_control, *);
 V4L2_INT_WRAPPER_1(s_ctrl, struct v4l2_control, *);
 V4L2_INT_WRAPPER_1(g_parm, struct v4l2_streamparm, *);
 V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
+V4L2_INT_WRAPPER_1(querystd, v4l2_std_id, *);
+V4L2_INT_WRAPPER_1(s_std, v4l2_std_id, *);
+V4L2_INT_WRAPPER_1(enum_input, struct v4l2_input, *);
+V4L2_INT_WRAPPER_1(g_input, int, *);
+V4L2_INT_WRAPPER_1(s_input, int, );
+V4L2_INT_WRAPPER_1(enumoutput, struct v4l2_output, *);
+V4L2_INT_WRAPPER_1(g_output, int, *);
+V4L2_INT_WRAPPER_1(s_output, int, );

 V4L2_INT_WRAPPER_0(dev_init);
 V4L2_INT_WRAPPER_0(dev_exit);
--
1.5.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
