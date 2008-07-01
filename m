Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6144KmC029346
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:04:20 -0400
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61448Oh013943
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:04:08 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id m6143hSZ026949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:03:53 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id m6143gtT002172
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:03:42 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m6143gG19543
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:03:42 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m6143g4C012012
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:03:42 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m6143gBD011997
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 23:03:42 -0500
Date: Mon, 30 Jun 2008 23:03:42 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080701040342.GA11991@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 5/16] OMAP3 camera driver V4L2 g_priv_mem
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

>From 3f9a1f1c20fadcd9fcc4fdb95f70a02a85e0140d Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@nokia.com>
Date: Thu, 8 May 2008 19:28:18 +0300
Subject: [PATCH] V4L: Add VIDIOC_G_PRIV_MEM

Some devices, for example image sensors, contain settings in their
EEPROM memory that are useful to userspace programs. VIDIOC_G_PRIV_MEM
can be used to read those settings.

This patch adds also the corresponding v4l2_int_device command.

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 include/linux/videodev2.h       |    8 ++++++++
 include/media/v4l2-int-device.h |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 29a3e25..15c0f2b 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1370,6 +1370,13 @@ struct v4l2_chip_ident {
 	__u32 revision;    /* chip revision, chip specific */
 };
 
+/* VIDIOC_G_PRIV_MEM */
+struct v4l2_priv_mem {
+	__u32 offset;	/* offset to data */
+	__u32 length;	/* memory allocated to ptr or read length */
+	void *ptr;	/* pointer to allocated memory */
+};
+
 /*
  *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
  *
@@ -1441,6 +1448,7 @@ struct v4l2_chip_ident {
 #define	VIDIOC_DBG_G_REGISTER 	_IOWR ('V', 80, struct v4l2_register)
 
 #define VIDIOC_G_CHIP_IDENT     _IOWR ('V', 81, struct v4l2_chip_ident)
+#define VIDIOC_G_PRIV_MEM	_IOWR ('V', 82, struct v4l2_priv_mem)
 #endif
 
 #ifdef __OLD_VIDIOC_
diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index 0eda169..fc14264 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -309,6 +309,8 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_init_num,
 	/* VIDIOC_INT_G_CHIP_IDENT */
 	vidioc_int_g_chip_ident_num,
+	/* VIDIOC_INT_G_PRIV_MEM */
+	vidioc_int_g_priv_mem_num,
 
 	/*
 	 *
@@ -386,5 +388,6 @@ V4L2_INT_WRAPPER_1(g_needs_reset, void, *);
 V4L2_INT_WRAPPER_0(reset);
 V4L2_INT_WRAPPER_0(init);
 V4L2_INT_WRAPPER_1(g_chip_ident, int, *);
+V4L2_INT_WRAPPER_1(g_priv_mem, struct v4l2_priv_mem, *);
 
 #endif
-- 
1.5.5.1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
