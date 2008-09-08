Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m88GmWu1014119
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 12:48:32 -0400
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m88GmLp4021787
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 12:48:21 -0400
From: Sakari Ailus <sakari.ailus@nokia.com>
To: video4linux-list@redhat.com
Date: Mon,  8 Sep 2008 19:48:10 +0300
Message-Id: <12208924933079-git-send-email-sakari.ailus@nokia.com>
In-Reply-To: <12208924933015-git-send-email-sakari.ailus@nokia.com>
References: <48C55737.4080804@nokia.com>
	<12208924933529-git-send-email-sakari.ailus@nokia.com>
	<12208924931107-git-send-email-sakari.ailus@nokia.com>
	<12208924933015-git-send-email-sakari.ailus@nokia.com>
Cc: tuukka.o.toivonen@nokia.com, vherkuil@xs4all.nl, vimarsh.zutshi@nokia.com
Subject: [PATCH 4/7] V4L: Add VIDIOC_G_PRIV_MEM ioctl
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
index 79187c6..78167dc 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1357,6 +1357,13 @@ struct v4l2_chip_ident {
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
@@ -1430,6 +1437,7 @@ struct v4l2_chip_ident {
 #define VIDIOC_G_CHIP_IDENT     _IOWR('V', 81, struct v4l2_chip_ident)
 #endif
 #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
+#define VIDIOC_G_PRIV_MEM       _IOWR('V', 83, struct v4l2_priv_mem)
 
 #ifdef __OLD_VIDIOC_
 /* for compatibility, will go away some day */
diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index cee941c..161b236 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -208,6 +208,8 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_init_num,
 	/* VIDIOC_INT_G_CHIP_IDENT */
 	vidioc_int_g_chip_ident_num,
+	/* VIDIOC_INT_G_PRIV_MEM */
+	vidioc_int_g_priv_mem_num,
 
 	/*
 	 *
@@ -285,5 +287,6 @@ V4L2_INT_WRAPPER_1(g_needs_reset, void, *);
 V4L2_INT_WRAPPER_0(reset);
 V4L2_INT_WRAPPER_0(init);
 V4L2_INT_WRAPPER_1(g_chip_ident, int, *);
+V4L2_INT_WRAPPER_1(g_priv_mem, struct v4l2_priv_mem, *);
 
 #endif
-- 
1.5.0.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
