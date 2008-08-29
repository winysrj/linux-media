Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TNdvan027746
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:39:57 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TNdQtJ003214
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:39:27 -0400
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7TNdLdu025723
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:39:26 -0500
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id m7TNdLiR021203
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:39:21 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 29 Aug 2008 18:39:20 -0500
Message-ID: <A24693684029E5489D1D202277BE89441191E33D@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 6/15] OMAP3 camera driver: V4L2: Allowing device
 initialization anywhere.
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
 drivers/media/video/v4l2-int-device.c |    3 ++-
 include/media/v4l2-int-device.h       |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-int-device.c b/drivers/media/video/v4l2-int-device.c
index 0e45499..45086ea 100644
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
diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index 6795b32..27d21b1 100644
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
