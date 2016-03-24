Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40243 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbcCXWWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 18:22:46 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 0/2] media: Revert broken locking changes
Date: Fri, 25 Mar 2016 00:22:42 +0200
Message-Id: <1458858164-1066-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit c38077d39c7e ("[media] media-device: get rid of the spinlock")
introduced a deadlock in the MEDIA_IOC_ENUM_LINKS ioctl handler.

Revert the broken commit as well as another that has been merged on top, and
let's implement a proper fix instead of half-baked hacks this time.

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


Laurent Pinchart (2):
  Revert "[media] media-device: use kref for media_device instance"
  Revert "[media] media-device: get rid of the spinlock"

 drivers/media/media-device.c           | 143 ++++++++++-----------------------
 drivers/media/media-entity.c           |  16 ++--
 drivers/media/usb/au0828/au0828-core.c |   3 +-
 include/media/media-device.h           |  34 ++------
 sound/usb/media.c                      |   3 +-
 5 files changed, 61 insertions(+), 138 deletions(-)

-- 
Regards,

Laurent Pinchart

