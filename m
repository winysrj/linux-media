Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35874 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbcCNTTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 15:19:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v2] [media] media-device: Don't call notify callbacks holding a spinlock
Date: Mon, 14 Mar 2016 16:19:16 -0300
Message-Id: <f57f83d55d7e1bc526370c697db014cec51bd909.1457983075.git.mchehab@osg.samsung.com>
In-Reply-To: <31ecc9d6d2f29b0bd76c03c516d12aa7d0be2f66.1457982982.git.mchehab@osg.samsung.com>
References: <31ecc9d6d2f29b0bd76c03c516d12aa7d0be2f66.1457982982.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The notify routines may sleep. So, they can't be called in spinlock
context. Also, they may want to call other media routines that might
be spinning the spinlock, like creating a link.

This fixes the following bug:

[ 1839.510587] BUG: sleeping function called from invalid context at mm/slub.c:1289
[ 1839.510881] in_atomic(): 1, irqs_disabled(): 0, pid: 3479, name: modprobe
[ 1839.511157] 4 locks held by modprobe/3479:
[ 1839.511415]  #0:  (&dev->mutex){......}, at: [<ffffffff81ce8933>] __driver_attach+0xa3/0x160
[ 1839.512381]  #1:  (&dev->mutex){......}, at: [<ffffffff81ce8941>] __driver_attach+0xb1/0x160
[ 1839.512388]  #2:  (register_mutex#5){+.+.+.}, at: [<ffffffffa10596c7>] usb_audio_probe+0x257/0x1c90 [snd_usb_audio]
[ 1839.512401]  #3:  (&(&mdev->lock)->rlock){+.+.+.}, at: [<ffffffffa0e6051b>] media_device_register_entity+0x1cb/0x700 [media]
[ 1839.512412] CPU: 2 PID: 3479 Comm: modprobe Not tainted 4.5.0-rc3+ #49
[ 1839.512415] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
[ 1839.512417]  0000000000000000 ffff8803b3f6f288 ffffffff81933901 ffff8803c4bae000
[ 1839.512422]  ffff8803c4bae5c8 ffff8803b3f6f2b0 ffffffff811c6af5 ffff8803c4bae000
[ 1839.512427]  ffffffff8285d7f6 0000000000000509 ffff8803b3f6f2f0 ffffffff811c6ce5
[ 1839.512432] Call Trace:
[ 1839.512436]  [<ffffffff81933901>] dump_stack+0x85/0xc4
[ 1839.512440]  [<ffffffff811c6af5>] ___might_sleep+0x245/0x3a0
[ 1839.512443]  [<ffffffff811c6ce5>] __might_sleep+0x95/0x1a0
[ 1839.512446]  [<ffffffff8155aade>] kmem_cache_alloc_trace+0x20e/0x300
[ 1839.512451]  [<ffffffffa0e66e3d>] ? media_add_link+0x4d/0x140 [media]
[ 1839.512455]  [<ffffffffa0e66e3d>] media_add_link+0x4d/0x140 [media]
[ 1839.512459]  [<ffffffffa0e69931>] media_create_pad_link+0xa1/0x600 [media]
[ 1839.512463]  [<ffffffffa0fe11b3>] au0828_media_graph_notify+0x173/0x360 [au0828]
[ 1839.512467]  [<ffffffffa0e68a6a>] ? media_gobj_create+0x1ba/0x480 [media]
[ 1839.512471]  [<ffffffffa0e606fb>] media_device_register_entity+0x3ab/0x700 [media]

Tested with an HVR-950Q, under the following testcases:

1) load au0828 driver first, and then snd-usb-audio;
2) load snd-usb-audio driver first, and then au0828;
3) loading both drivers, and then connecting the device.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---

Please disconsider verison 1. It got amended with an experimental patch.

 drivers/media/media-device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6ba6e8f982fc..fc3c199e5500 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -587,14 +587,15 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 		media_gobj_create(mdev, MEDIA_GRAPH_PAD,
 			       &entity->pads[i].graph_obj);
 
+	spin_unlock(&mdev->lock);
+
 	/* invoke entity_notify callbacks */
 	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
 		(notify)->notify(entity, notify->notify_data);
 	}
 
-	spin_unlock(&mdev->lock);
-
 	mutex_lock(&mdev->graph_mutex);
+
 	if (mdev->entity_internal_idx_max
 	    >= mdev->pm_count_walk.ent_enum.idx_max) {
 		struct media_entity_graph new = { .top = 0 };
-- 
2.5.0


