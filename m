Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7RM33ic002333
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 18:03:03 -0400
Received: from smtp5.pp.htv.fi (smtp5.pp.htv.fi [213.243.153.39])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7RM2o8Y002033
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 18:02:51 -0400
Date: Thu, 28 Aug 2008 01:01:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Carl Karsten <carl@personnelware.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l-dvb-maintainer@linuxtv.org
Message-ID: <20080827220157.GJ11734@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: [2.6 patch] vivi_release(): fix use-after-free
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

video_device_release() does kfree(), which made the following printk() 
doing a use-after-free.

printk() first and release then.

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
c2fc2b28db99432313aab1f86937f204f8bd4c9b 
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 3518af0..35ffd28 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1021,13 +1021,13 @@ static int vivi_release(void)
 		dev = list_entry(list, struct vivi_dev, vivi_devlist);
 
 		if (-1 != dev->vfd->minor) {
-			video_unregister_device(dev->vfd);
-			printk(KERN_INFO "%s: /dev/video%d unregistered.\n",
+			printk(KERN_INFO "%s: unregistering /dev/video%d\n",
 				VIVI_MODULE_NAME, dev->vfd->minor);
+			video_unregister_device(dev->vfd);
 		} else {
-			video_device_release(dev->vfd);
-			printk(KERN_INFO "%s: /dev/video%d released.\n",
+			printk(KERN_INFO "%s: releasing /dev/video%d\n",
 				VIVI_MODULE_NAME, dev->vfd->minor);
+			video_device_release(dev->vfd);
 		}
 
 		kfree(dev);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
