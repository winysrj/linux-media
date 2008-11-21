Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALFLhcS017522
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 10:21:43 -0500
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALFLWSW029482
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 10:21:32 -0500
From: hvaibhav@ti.com
To: video4linux-list@redhat.com
Date: Fri, 21 Nov 2008 20:51:19 +0530
Message-Id: <1227280879-31440-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Cc: linux-omap@vger.kernel.org,
	davinci-linux-open-source-bounces@linux.davincidsp.com
Subject: [PATCH 1/2] Add Input/Output related ioctl support
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

From: Vaibhav Hiremath <hvaibhav@ti.com>

Added ioctl support for query std, set std, enum input,
get input, set input, enum output, get output and set output.

For sensor kind of slave drivers v4l2-int-device.h provides
necessary ioctl support, but the ioctls required to interface
with decoders and encoders are missing. Most of the decoders
and encoders supports multiple inputs and outputs, like
S-Video or Composite.

With these ioctl''s user can select the specific input/output.

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
		Hardik Shah <hardik.shah@ti.com>
		Manjunath Hadli <mrh@ti.com>
		R Sivaraj <sivaraj@ti.com>
		Vaibhav Hiremath <hvaibhav@ti.com>
		Karicheri Muralidharan <m-karicheri2@ti.com>
---
 include/media/v4l2-int-device.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index 9c2df41..d73a11b 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -183,6 +183,14 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_s_crop_num,
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
@@ -284,6 +292,14 @@ V4L2_INT_WRAPPER_1(g_crop, struct v4l2_crop, *);
 V4L2_INT_WRAPPER_1(s_crop, struct v4l2_crop, *);
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
