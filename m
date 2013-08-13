Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:39517 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3HMPEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Aug 2013 11:04:14 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] v4l2-dev: Fix race condition on __video_register_device
Date: Tue, 13 Aug 2013 17:04:06 +0200
Message-Id: <1376406247-18757-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When 2 devices are registered at the same time, in Part 2 both will get
the same minor number, making Part6 crash, because it cannot create a
create a device with a duplicated minor:

[    7.157648] ------------[ cut here ]------------
[    7.157666] WARNING: at fs/sysfs/dir.c:530 sysfs_add_one+0xbd/0xe0()
[    7.157669] sysfs: cannot create duplicate filename '/dev/char/81:1'
[    7.157672] Modules linked in: qtec_xform(+) qt5023_video(+) videobuf2_vmalloc videobuf2_dma_sg videobuf2_memops videobuf2_core gpio_xilinx(+) qtec_white qtec_cmosis(+) qtec_pcie qt5023
[    7.157694] CPU: 0 PID: 120 Comm: systemd-udevd Not tainted 3.10.0-qtec-standard #8
[    7.157698] Hardware name: QTechnology QT5022/QT5022, BIOS PM_2.1.0.309 X64 05/23/2013
[    7.157702]  0000000000000009 ffff8801788358e8 ffffffff8176c487 ffff880178835928
[    7.157707]  ffffffff8106f6f0 ffff880175759770 00000000ffffffef ffff880175759930
[    7.157712]  ffff8801788359e8 ffff880178bff000 ffff880175759930 ffff880178835988
[    7.157718] Call Trace:
[    7.157728]  [<ffffffff8176c487>] dump_stack+0x19/0x1b
[    7.157735]  [<ffffffff8106f6f0>] warn_slowpath_common+0x70/0xa0
[    7.157740]  [<ffffffff8106f7d6>] warn_slowpath_fmt+0x46/0x50
[    7.157746]  [<ffffffff81324b35>] ? strlcat+0x65/0x90
[    7.157750]  [<ffffffff811d516d>] sysfs_add_one+0xbd/0xe0
[    7.157755]  [<ffffffff811d5c6b>] sysfs_do_create_link_sd+0xdb/0x200
[    7.157760]  [<ffffffff811d5db1>] sysfs_create_link+0x21/0x40
[    7.157765]  [<ffffffff813e277b>] device_add+0x21b/0x6d0
[    7.157772]  [<ffffffff813f2985>] ? pm_runtime_init+0xe5/0xf0
[    7.157776]  [<ffffffff813e2c4e>] device_register+0x1e/0x30
[    7.157782]  [<ffffffff8153e8c3>] __video_register_device+0x313/0x610
[    7.157791]  [<ffffffffa00957c5>] qtec_xform_probe+0x465/0x7a4 [qtec_xform]
[    7.157797]  [<ffffffff813e7b13>] platform_drv_probe+0x43/0x80
[    7.157802]  [<ffffffff813e531a>] ? driver_sysfs_add+0x7a/0xb0
[    7.157807]  [<ffffffff813e584b>] driver_probe_device+0x8b/0x3a0
[    7.157812]  [<ffffffff813e5c0b>] __driver_attach+0xab/0xb0
[    7.157816]  [<ffffffff813e5b60>] ? driver_probe_device+0x3a0/0x3a0
[    7.157820]  [<ffffffff813e37fd>] bus_for_each_dev+0x5d/0xa0
[    7.157825]  [<ffffffff813e529e>] driver_attach+0x1e/0x20
[    7.157829]  [<ffffffff813e4d3e>] bus_add_driver+0x10e/0x280
[    7.157833]  [<ffffffffa0099000>] ? 0xffffffffa0098fff
[    7.157837]  [<ffffffffa0099000>] ? 0xffffffffa0098fff
[    7.157842]  [<ffffffff813e6317>] driver_register+0x77/0x170
[    7.157848]  [<ffffffff81151bcc>] ? __vunmap+0x9c/0x110
[    7.157852]  [<ffffffffa0099000>] ? 0xffffffffa0098fff
[    7.157857]  [<ffffffff813e7236>] platform_driver_register+0x46/0x50
[    7.157863]  [<ffffffffa0099010>] qtec_xform_plat_driver_init+0x10/0x12 [qtec_xform]
[    7.157869]  [<ffffffff810002ea>] do_one_initcall+0xea/0x1a0
[    7.157875]  [<ffffffff810cf1f1>] load_module+0x1a91/0x2630
[    7.157880]  [<ffffffff8133bee0>] ? ddebug_proc_show+0xe0/0xe0
[    7.157887]  [<ffffffff817760f2>] ? page_fault+0x22/0x30
[    7.157892]  [<ffffffff810cfe7a>] SyS_init_module+0xea/0x140
[    7.157898]  [<ffffffff8177e5b9>] tracesys+0xd0/0xd5
[    7.157902] ---[ end trace 660cc3a65a4bf01b ]---
[    7.157939] __video_register_device: device_register failed

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/v4l2-dev.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 5923c5d..3f75f99 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -873,6 +873,7 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 
 	/* Should not happen since we thought this minor was free */
 	WARN_ON(video_device[vdev->minor] != NULL);
+	video_device[vdev->minor] = vdev;
 	vdev->index = get_index(vdev);
 	mutex_unlock(&videodev_lock);
 
@@ -936,9 +937,6 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 #endif
 	/* Part 6: Activate this minor. The char device can now be used. */
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
-	mutex_lock(&videodev_lock);
-	video_device[vdev->minor] = vdev;
-	mutex_unlock(&videodev_lock);
 
 	return 0;
 
@@ -946,6 +944,7 @@ cleanup:
 	mutex_lock(&videodev_lock);
 	if (vdev->cdev)
 		cdev_del(vdev->cdev);
+	video_device[vdev->minor] = NULL;
 	devnode_clear(vdev);
 	mutex_unlock(&videodev_lock);
 	/* Mark this video device as never having been registered. */
-- 
1.7.10.4

