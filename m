Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:48710 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbcCQC6K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 22:58:10 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, perex@perex.cz
Cc: Shuah Khan <shuahkh@osg.samsung.com>, alsa-devel@alsa-project.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound/usb: Fix memory leak in media_snd_stream_delete() during unbind
Date: Wed, 16 Mar 2016 20:58:06 -0600
Message-Id: <1458183486-8113-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media_snd_stream_delete() fails to release resources during unbind. This
leads to use-after-free in media_gobj_create() on a subsequent bind.

[ 1445.086410] BUG: KASAN: use-after-free in media_gobj_create+0x3a1/0x470 [media] at addr ffff8801ead49998

[ 1445.086771] Call Trace:
[ 1445.086779]  [<ffffffff81ade373>] dump_stack+0x67/0x94
[ 1445.086785]  [<ffffffff81523c29>] print_trailer+0xf9/0x150
[ 1445.086790]  [<ffffffff81529644>] object_err+0x34/0x40
[ 1445.086796]  [<ffffffff8152b9e1>] kasan_report_error+0x221/0x530
[ 1445.086803]  [<ffffffff8152bfb3>] __asan_report_store8_noabort+0x43/0x50
[ 1445.086813]  [<ffffffffa0a79341>] ? media_gobj_create+0x3a1/0x470 [media]
[ 1445.086822]  [<ffffffffa0a79341>] media_gobj_create+0x3a1/0x470 [media]
[ 1445.086831]  [<ffffffffa0a705a9>] media_device_register_entity+0x259/0x6f0 [media]
[ 1445.086841]  [<ffffffffa0a70350>] ? media_device_unregister_entity_notify+0x100/0x100 [media]
[ 1445.086846]  [<ffffffff81526232>] ? ___slab_alloc+0x172/0x500
[ 1445.086854]  [<ffffffff81203548>] ? mark_held_locks+0xc8/0x120
[ 1445.086859]  [<ffffffff81526610>] ? __slab_alloc+0x50/0x70
[ 1445.086878]  [<ffffffffa0fe711c>] ? media_snd_mixer_init+0x16c/0x500 [snd_usb_audio]
[ 1445.086884]  [<ffffffff8152b086>] ? kasan_unpoison_shadow+0x36/0x50
[ 1445.086890]  [<ffffffff8152b086>] ? kasan_unpoison_shadow+0x36/0x50
[ 1445.086895]  [<ffffffff8152b0fe>] ? kasan_kmalloc+0x5e/0x70

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 sound/usb/media.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/media.c b/sound/usb/media.c
index 44a5de9..0d03773 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -135,7 +135,7 @@ void media_snd_stream_delete(struct snd_usb_substream *subs)
 	if (mctl && mctl->media_dev) {
 		struct media_device *mdev;
 
-		mdev = subs->stream->chip->media_dev;
+		mdev = mctl->media_dev;
 		if (mdev && media_devnode_is_registered(&mdev->devnode)) {
 			media_devnode_remove(mctl->intf_devnode);
 			media_device_unregister_entity(&mctl->media_entity);
-- 
2.5.0

