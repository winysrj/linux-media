Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB2FZrQo031025
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 10:35:53 -0500
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mB2FZbcs019534
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 10:35:37 -0500
From: hvaibhav@ti.com
To: video4linux-list@redhat.com
Date: Tue,  2 Dec 2008 21:05:19 +0530
Message-Id: <1228232119-10750-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Cc: davinci-linux-open-source-bounces@linux.davincidsp.com,
	Karicheri Muralidharan <m-karicheri2@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH 1/2] Addition of set/get Routing ioctl support[V4]
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

Fixed Community review comments:

s/g_input:
    Removed input/output related ioctl, and made
    use of s/g_routing ioctl. Added entry for the
    same to the v4l2-int framework.

s/g_input:
    Since from decoder point of view we really don't
    care about output, and anyway we can tie this
    feature with s/g_routing. So removed s/g_output
    ioctl.
    This was added for completeness in the previous patch.

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Hardik Shah <hardik.shah@ti.com>
Signed-off-by: Manjunath Hadli <mrh@ti.com>
Signed-off-by: R Sivaraj <sivaraj@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Karicheri Muralidharan <m-karicheri2@ti.com>
---
 include/media/v4l2-int-device.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 include/media/v4l2-int-device.h

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
old mode 100644
new mode 100755
index 9c2df41..5e3e193
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -183,6 +183,10 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_s_crop_num,
 	vidioc_int_g_parm_num,
 	vidioc_int_s_parm_num,
+	vidioc_int_querystd_num,
+	vidioc_int_s_std_num,
+	vidioc_int_g_video_routing_num,
+	vidioc_int_s_video_routing_num,

 	/*
 	 *
@@ -284,6 +288,10 @@ V4L2_INT_WRAPPER_1(g_crop, struct v4l2_crop, *);
 V4L2_INT_WRAPPER_1(s_crop, struct v4l2_crop, *);
 V4L2_INT_WRAPPER_1(g_parm, struct v4l2_streamparm, *);
 V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
+V4L2_INT_WRAPPER_1(querystd, v4l2_std_id, *);
+V4L2_INT_WRAPPER_1(s_std, v4l2_std_id, *);
+V4L2_INT_WRAPPER_1(g_video_routing, int, *);
+V4L2_INT_WRAPPER_1(s_video_routing, int, );

 V4L2_INT_WRAPPER_0(dev_init);
 V4L2_INT_WRAPPER_0(dev_exit);
--
1.5.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
