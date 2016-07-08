Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0.mattleach.net ([176.58.118.143]:49296 "EHLO
	mx0.mattleach.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbcGHMLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 08:11:07 -0400
From: Matthew Leach <matthew@mattleach.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Peter Sutton <foxxy@foxdogstudios.com>,
	Matthew Leach <matthew@mattleach.net>, stable@vger.kernel.org
Subject: [PATCH] media: usbtv: prevent access to free'd resources
Date: Fri,  8 Jul 2016 13:04:27 +0100
Message-Id: <20160708120427.29581-1-matthew@mattleach.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When disconnecting the usbtv device, the sound card is unregistered
from ALSA and the snd member of the usbtv struct is set to NULL.  If
the usbtv snd_trigger work is running, this can cause a race condition
where the kernel will attempt to access free'd resources, shown in
[1].

This patch fixes the disconnection code by cancelling any snd_trigger
work before unregistering the sound card from ALSA and checking that
the snd member still exists in the work function.

[1]:
 usb 3-1.2: USB disconnect, device number 6
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
 IP: [<ffffffff81093850>] process_one_work+0x30/0x480
 PGD 405bbf067 PUD 405bbe067 PMD 0
 Call Trace:
  [<ffffffff81093ce8>] worker_thread+0x48/0x4e0
  [<ffffffff81093ca0>] ? process_one_work+0x480/0x480
  [<ffffffff81093ca0>] ? process_one_work+0x480/0x480
  [<ffffffff81099998>] kthread+0xd8/0xf0
  [<ffffffff815c73c2>] ret_from_fork+0x22/0x40
  [<ffffffff810998c0>] ? kthread_worker_fn+0x170/0x170
 ---[ end trace 0f3dac5c1a38e610 ]---

Signed-off-by: Matthew Leach <matthew@mattleach.net>
Tested-by: Peter Sutton <foxxy@foxdogstudios.com>
Cc: stable@vger.kernel.org
---
 drivers/media/usb/usbtv/usbtv-audio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/usbtv/usbtv-audio.c b/drivers/media/usb/usbtv/usbtv-audio.c
index 78c12d2..5dab024 100644
--- a/drivers/media/usb/usbtv/usbtv-audio.c
+++ b/drivers/media/usb/usbtv/usbtv-audio.c
@@ -278,6 +278,9 @@ static void snd_usbtv_trigger(struct work_struct *work)
 {
 	struct usbtv *chip = container_of(work, struct usbtv, snd_trigger);
 
+	if (!chip->snd)
+		return;
+
 	if (atomic_read(&chip->snd_stream))
 		usbtv_audio_start(chip);
 	else
@@ -378,6 +381,8 @@ err:
 
 void usbtv_audio_free(struct usbtv *usbtv)
 {
+	cancel_work_sync(&usbtv->snd_trigger);
+
 	if (usbtv->snd && usbtv->udev) {
 		snd_card_free(usbtv->snd);
 		usbtv->snd = NULL;
-- 
2.9.0

