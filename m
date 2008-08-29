Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TNf0Go028284
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:41:00 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TNeled004293
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:40:48 -0400
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7TNegV9007826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:40:47 -0500
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id m7TNeg04021664
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:40:42 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 29 Aug 2008 18:40:41 -0500
Message-ID: <A24693684029E5489D1D202277BE89441191E33F@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 8/15] OMAP3 camera driver: V4L2: Int if: Add enumeration
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

Index: linux-omap-2.6/include/media/v4l2-int-device.h
===================================================================
--- linux-omap-2.6.orig/include/media/v4l2-int-device.h	2008-08-28 19:37:11.000000000 -0500
+++ linux-omap-2.6/include/media/v4l2-int-device.h	2008-08-28 19:38:29.000000000 -0500
@@ -205,6 +205,8 @@
 	vidioc_int_g_ifparm_num,
 	/* Does the slave need to be reset after VIDIOC_DQBUF? */
 	vidioc_int_g_needs_reset_num,
+	vidioc_int_enum_framesizes_num,
+	vidioc_int_enum_frameintervals_num,
 
 	/*
 	 *
@@ -292,6 +294,8 @@
 V4L2_INT_WRAPPER_1(g_priv, void, *);
 V4L2_INT_WRAPPER_1(g_ifparm, struct v4l2_ifparm, *);
 V4L2_INT_WRAPPER_1(g_needs_reset, void, *);
+V4L2_INT_WRAPPER_1(enum_framesizes, struct v4l2_frmsizeenum, *);
+V4L2_INT_WRAPPER_1(enum_frameintervals, struct v4l2_frmivalenum, *);
 
 V4L2_INT_WRAPPER_0(reset);
 V4L2_INT_WRAPPER_0(init);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
