Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TNeKjC028182
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:40:21 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TNeIRP004061
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:40:18 -0400
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7TNeCeC007568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:40:17 -0500
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id m7TNeC5R021516
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:40:12 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 29 Aug 2008 18:40:11 -0500
Message-ID: <A24693684029E5489D1D202277BE89441191E33E@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 7/15] OMAP3 camera driver: V4L2: Export symbols to ease
 building as modules.
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
 drivers/media/video/v4l2-int-device.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-int-device.c b/drivers/media/video/v4l2-int-device.c
index 45086ea..a935bae 100644
--- a/drivers/media/video/v4l2-int-device.c
+++ b/drivers/media/video/v4l2-int-device.c
@@ -145,6 +145,7 @@ int v4l2_int_ioctl_0(struct v4l2_int_device *d, int cmd)
 		find_ioctl(d->u.slave, cmd,
 			   (v4l2_int_ioctl_func *)no_such_ioctl_0))(d);
 }
+EXPORT_SYMBOL_GPL(v4l2_int_ioctl_0);
 
 static int no_such_ioctl_1(struct v4l2_int_device *d, void *arg)
 {
@@ -157,5 +158,6 @@ int v4l2_int_ioctl_1(struct v4l2_int_device *d, int cmd, void *arg)
 		find_ioctl(d->u.slave, cmd,
 			   (v4l2_int_ioctl_func *)no_such_ioctl_1))(d, arg);
 }
+EXPORT_SYMBOL_GPL(v4l2_int_ioctl_1);
 
 MODULE_LICENSE("GPL");
-- 
1.5.0.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
