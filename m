Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59827 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599AbcC2Jbi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 05:31:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 1/2] [media] media-device: Fix mutex handling code for ioctl
Date: Tue, 29 Mar 2016 06:31:27 -0300
Message-Id: <fef855a4cd482eb02cff982b01511c893ea6e75d.1459243882.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove two nested mutex left-overs at find_entity and make sure
that the code won't suffer race conditions if the device is
being removed while ioctl is being handled nor the topology changes,
by protecting all ioctls with a mutex at media_device_ioctl().

As reported by Laurent, commit c38077d39c7e ("[media] media-device:
get rid of the spinlock") introduced a deadlock in the
MEDIA_IOC_ENUM_LINKS ioctl handler:

[ 2760.127749] INFO: task media-ctl:954 blocked for more than 120 seconds.
[ 2760.131867]       Not tainted 4.5.0+ #357
[ 2760.134622] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2760.139310] media-ctl       D ffffffc000086bcc     0   954    671 0x00000001
[ 2760.143618] Call trace:
[ 2760.145601] [<ffffffc000086bcc>] __switch_to+0x90/0xa4
[ 2760.148941] [<ffffffc0004e6ef0>] __schedule+0x188/0x5b0
[ 2760.152309] [<ffffffc0004e7354>] schedule+0x3c/0xa0
[ 2760.155495] [<ffffffc0004e7768>] schedule_preempt_disabled+0x20/0x38
[ 2760.159423] [<ffffffc0004e8d28>] __mutex_lock_slowpath+0xc4/0x148
[ 2760.163217] [<ffffffc0004e8df0>] mutex_lock+0x44/0x5c
[ 2760.166483] [<ffffffc0003e87d4>] find_entity+0x2c/0xac
[ 2760.169773] [<ffffffc0003e8d34>] __media_device_enum_links+0x20/0x1dc
[ 2760.173711] [<ffffffc0003e9718>] media_device_ioctl+0x214/0x33c
[ 2760.177384] [<ffffffc0003e9eec>] media_ioctl+0x24/0x3c
[ 2760.180671] [<ffffffc0001bee64>] do_vfs_ioctl+0xac/0x758
[ 2760.184026] [<ffffffc0001bf594>] SyS_ioctl+0x84/0x98
[ 2760.187196] [<ffffffc000085d30>] el0_svc_naked+0x24/0x28

That's because find_entity() holds the graph_mutex, but both
MEDIA_IOC_ENUM_LINKS and MEDIA_IOC_SETUP_LINK logic also take
the mutex.

Reported-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7bfb2b24f644..6af5e6932271 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -90,18 +90,13 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
 
 	id &= ~MEDIA_ENT_ID_FLAG_NEXT;
 
-	mutex_lock(&mdev->graph_mutex);
-
 	media_device_for_each_entity(entity, mdev) {
 		if (((media_entity_id(entity) == id) && !next) ||
 		    ((media_entity_id(entity) > id) && next)) {
-			mutex_unlock(&mdev->graph_mutex);
 			return entity;
 		}
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
-
 	return NULL;
 }
 
@@ -431,6 +426,7 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 	struct media_device *dev = devnode->media_dev;
 	long ret;
 
+	mutex_lock(&dev->graph_mutex);
 	switch (cmd) {
 	case MEDIA_IOC_DEVICE_INFO:
 		ret = media_device_get_info(dev,
@@ -443,29 +439,24 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case MEDIA_IOC_ENUM_LINKS:
-		mutex_lock(&dev->graph_mutex);
 		ret = media_device_enum_links(dev,
 				(struct media_links_enum __user *)arg);
-		mutex_unlock(&dev->graph_mutex);
 		break;
 
 	case MEDIA_IOC_SETUP_LINK:
-		mutex_lock(&dev->graph_mutex);
 		ret = media_device_setup_link(dev,
 				(struct media_link_desc __user *)arg);
-		mutex_unlock(&dev->graph_mutex);
 		break;
 
 	case MEDIA_IOC_G_TOPOLOGY:
-		mutex_lock(&dev->graph_mutex);
 		ret = media_device_get_topology(dev,
 				(struct media_v2_topology __user *)arg);
-		mutex_unlock(&dev->graph_mutex);
 		break;
 
 	default:
 		ret = -ENOIOCTLCMD;
 	}
+	mutex_unlock(&dev->graph_mutex);
 
 	return ret;
 }
-- 
2.5.5

