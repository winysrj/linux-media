Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBBKcERg012631
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 15:38:15 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBBKbwB6020545
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 15:37:58 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Thu, 11 Dec 2008 14:37:49 -0600
Message-ID: <A24693684029E5489D1D202277BE894415E6E196@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: [REVIEW PATCH 02/14] v4l2-int-device: add support for
 VIDIOC_QUERYMENU
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

>From c955d61fe2481f0884f8f3406374cd70deef3b70 Mon Sep 17 00:00:00 2001
From: Sergio Aguirre <saaguirre@ti.com>
Date: Thu, 11 Dec 2008 13:35:51 -0600
Subject: [PATCH] v4l2-int-device: add support for VIDIOC_QUERYMENU

Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
---
 include/media/v4l2-int-device.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index 85a1834..052ffe0 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -178,6 +178,7 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_s_fmt_cap_num,
 	vidioc_int_try_fmt_cap_num,
 	vidioc_int_queryctrl_num,
+	vidioc_int_querymenu_num,
 	vidioc_int_g_ctrl_num,
 	vidioc_int_s_ctrl_num,
 	vidioc_int_cropcap_num,
@@ -279,6 +280,7 @@ V4L2_INT_WRAPPER_1(g_fmt_cap, struct v4l2_format, *);
 V4L2_INT_WRAPPER_1(s_fmt_cap, struct v4l2_format, *);
 V4L2_INT_WRAPPER_1(try_fmt_cap, struct v4l2_format, *);
 V4L2_INT_WRAPPER_1(queryctrl, struct v4l2_queryctrl, *);
+V4L2_INT_WRAPPER_1(querymenu, struct v4l2_querymenu, *);
 V4L2_INT_WRAPPER_1(g_ctrl, struct v4l2_control, *);
 V4L2_INT_WRAPPER_1(s_ctrl, struct v4l2_control, *);
 V4L2_INT_WRAPPER_1(cropcap, struct v4l2_cropcap, *);
-- 
1.5.6.5


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
