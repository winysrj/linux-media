Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m97GIlq9023415
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 12:18:47 -0400
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m97GIaaD021738
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 12:18:36 -0400
From: Sakari Ailus <sakari.ailus@nokia.com>
To: hverkuil@xs4all.nl, video4linux-list@redhat.com
Date: Tue,  7 Oct 2008 19:18:15 +0300
Message-Id: <12233962962976-git-send-email-sakari.ailus@nokia.com>
In-Reply-To: <12233962962059-git-send-email-sakari.ailus@nokia.com>
References: <48EB8BAC.90706@nokia.com>
	<12233962961256-git-send-email-sakari.ailus@nokia.com>
	<1223396296101-git-send-email-sakari.ailus@nokia.com>
	<12233962962104-git-send-email-sakari.ailus@nokia.com>
	<12233962962059-git-send-email-sakari.ailus@nokia.com>
Cc: vimarsh.zutshi@nokia.com, tuukka.o.toivonen@nokia.com, hnagalla@ti.com
Subject: [PATCH 5/6] V4L: Int if: Export more interfaces to modules
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

Export v4l2_int_device_try_attach_all. This allows initiating the
initialisation of int if device after the drivers have been registered.

Also allow drivers to call ioctls if v4l2-int-if was compiled as
module.

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 drivers/media/video/v4l2-int-device.c |    5 ++++-
 include/media/v4l2-int-device.h       |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-int-device.c b/drivers/media/video/v4l2-int-device.c
index 0e45499..a935bae 100644
--- a/drivers/media/video/v4l2-int-device.c
+++ b/drivers/media/video/v4l2-int-device.c
@@ -32,7 +32,7 @@
 static DEFINE_MUTEX(mutex);
 static LIST_HEAD(int_list);
 
-static void v4l2_int_device_try_attach_all(void)
+void v4l2_int_device_try_attach_all(void)
 {
 	struct v4l2_int_device *m, *s;
 
@@ -66,6 +66,7 @@ static void v4l2_int_device_try_attach_all(void)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(v4l2_int_device_try_attach_all);
 
 static int ioctl_sort_cmp(const void *a, const void *b)
 {
@@ -144,6 +145,7 @@ int v4l2_int_ioctl_0(struct v4l2_int_device *d, int cmd)
 		find_ioctl(d->u.slave, cmd,
 			   (v4l2_int_ioctl_func *)no_such_ioctl_0))(d);
 }
+EXPORT_SYMBOL_GPL(v4l2_int_ioctl_0);
 
 static int no_such_ioctl_1(struct v4l2_int_device *d, void *arg)
 {
@@ -156,5 +158,6 @@ int v4l2_int_ioctl_1(struct v4l2_int_device *d, int cmd, void *arg)
 		find_ioctl(d->u.slave, cmd,
 			   (v4l2_int_ioctl_func *)no_such_ioctl_1))(d, arg);
 }
+EXPORT_SYMBOL_GPL(v4l2_int_ioctl_1);
 
 MODULE_LICENSE("GPL");
diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index 3351dcf..b5cee89 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -84,6 +84,8 @@ struct v4l2_int_device {
 	void *priv;
 };
 
+void v4l2_int_device_try_attach_all(void);
+
 int v4l2_int_device_register(struct v4l2_int_device *d);
 void v4l2_int_device_unregister(struct v4l2_int_device *d);
 
-- 
1.5.0.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
