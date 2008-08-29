Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TNcje7027693
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:38:46 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TNcX8I002844
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:38:33 -0400
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7TNcRRC024998
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:38:32 -0500
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id m7TNcRkP020839
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:38:27 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 29 Aug 2008 18:38:21 -0500
Message-ID: <A24693684029E5489D1D202277BE89441191E33B@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 4/15] OMAP3 camera driver: V4L2: Add VIDIOC_G_PRIV_MEM
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

From: Sakari Ailus <sakari.ailus@nokia.com>
Subject: [PATCH] V4L: Add VIDIOC_G_PRIV_MEM

Some devices, for example image sensors, contain settings in their
EEPROM memory that are useful to userspace programs. VIDIOC_G_PRIV_MEM
can be used to read those settings.

This patch adds also the corresponding v4l2_int_device command.

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 include/linux/videodev2.h       |   10 +++++++++-
 include/media/v4l2-int-device.h |    3 +++
 2 files changed, 12 insertions(+), 1 deletion(-)

Index: linux-omap-2.6/include/linux/videodev2.h
===================================================================
--- linux-omap-2.6.orig/include/linux/videodev2.h	2008-08-25 12:19:22.000000000 -0500
+++ linux-omap-2.6/include/linux/videodev2.h	2008-08-25 12:19:24.000000000 -0500
@@ -1352,6 +1352,13 @@
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
@@ -1423,8 +1430,9 @@
 #define	VIDIOC_DBG_G_REGISTER 	_IOWR('V', 80, struct v4l2_register)
 
 #define VIDIOC_G_CHIP_IDENT     _IOWR('V', 81, struct v4l2_chip_ident)
+#define VIDIOC_G_PRIV_MEM       _IOWR('V', 82, struct v4l2_priv_mem)
 #endif
-#define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
+#define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 83, struct v4l2_hw_freq_seek)
 
 #ifdef __OLD_VIDIOC_
 /* for compatibility, will go away some day */
Index: linux-omap-2.6/include/media/v4l2-int-device.h
===================================================================
--- linux-omap-2.6.orig/include/media/v4l2-int-device.h	2008-08-25 12:19:10.000000000 -0500
+++ linux-omap-2.6/include/media/v4l2-int-device.h	2008-08-25 12:19:24.000000000 -0500
@@ -208,6 +208,8 @@
 	vidioc_int_init_num,
 	/* VIDIOC_INT_G_CHIP_IDENT */
 	vidioc_int_g_chip_ident_num,
+	/* VIDIOC_INT_G_PRIV_MEM */
+	vidioc_int_g_priv_mem_num,
 
 	/*
 	 *
@@ -285,5 +287,6 @@
 V4L2_INT_WRAPPER_0(reset);
 V4L2_INT_WRAPPER_0(init);
 V4L2_INT_WRAPPER_1(g_chip_ident, int, *);
+V4L2_INT_WRAPPER_1(g_priv_mem, struct v4l2_priv_mem, *);
 
 #endif

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
