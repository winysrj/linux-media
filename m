Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:60442 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbcCVEEK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 00:04:10 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	inki.dae@samsung.com, nenggun.kim@samsung.com,
	jh1009.sung@samsung.com, chehabrafael@gmail.com, tiwai@suse.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 fix au0828_v4l2_close() dev_state race condition
Date: Mon, 21 Mar 2016 22:04:05 -0600
Message-Id: <1458619445-9483-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

au0828_v4l2_close() check for dev_state == DEV_DISCONNECTED will fail to
detect the device disconnected state correctly, if au0828_v4l2_open() runs
to set the DEV_INITIALIZED bit. A loop test of bind/unbind found this bug
by increasing the likelihood of au0828_v4l2_open() occurring while unbind
is in progress. When au0828_v4l2_close() fails to detect that the device
is in disconnect state, it attempts to power down the device and fails with
the following general protection fault:

[  260.992962] Call Trace:
[  260.993008]  [<ffffffffa0f80f0f>] ? xc5000_sleep+0x8f/0xd0 [xc5000]
[  260.993095]  [<ffffffffa0f6803c>] ? fe_standby+0x3c/0x50 [tuner]
[  260.993186]  [<ffffffffa0ef541c>] au0828_v4l2_close+0x53c/0x620 [au0828]
[  260.993298]  [<ffffffffa0d08ec0>] v4l2_release+0xf0/0x210 [videodev]
[  260.993382]  [<ffffffff81570f9c>] __fput+0x1fc/0x6c0
[  260.993449]  [<ffffffff815714ce>] ____fput+0xe/0x10
[  260.993519]  [<ffffffff8116eb83>] task_work_run+0x133/0x1f0
[  260.993602]  [<ffffffff810035d0>] exit_to_usermode_loop+0x140/0x170
[  260.993681]  [<ffffffff810061ca>] syscall_return_slowpath+0x16a/0x1a0
[  260.993754]  [<ffffffff82835fb3>] entry_SYSCALL_64_fastpath+0xa6/0xa8

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 13f6dab..88dcc6e 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1075,7 +1075,7 @@ static int au0828_v4l2_close(struct file *filp)
 		del_timer_sync(&dev->vbi_timeout);
 	}
 
-	if (dev->dev_state == DEV_DISCONNECTED)
+	if (dev->dev_state & DEV_DISCONNECTED)
 		goto end;
 
 	if (dev->users == 1) {
-- 
2.5.0

