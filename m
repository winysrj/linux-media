Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45594 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaHOTS3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Aug 2014 15:18:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] usbtv: Make it dependent on ALSA
Date: Fri, 15 Aug 2014 16:18:20 -0300
Message-Id: <1408130300-16506-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that alsa code is part of the driver, it can be compiled
only if alsa is enabled.

   drivers/built-in.o: In function `snd_usbtv_hw_free':
>> usbtv-audio.c:(.text+0x21eb55): undefined reference to `snd_pcm_lib_free_pages'
   drivers/built-in.o: In function `snd_usbtv_hw_params':
>> usbtv-audio.c:(.text+0x21eb72): undefined reference to `snd_pcm_lib_malloc_pages'
   drivers/built-in.o: In function `usbtv_audio_urb_received':
>> usbtv-audio.c:(.text+0x21ed66): undefined reference to `snd_pcm_link_rwlock'
>> usbtv-audio.c:(.text+0x21ed9f): undefined reference to `snd_pcm_link_rwlock'
>> usbtv-audio.c:(.text+0x21edf5): undefined reference to `snd_pcm_period_elapsed'
   drivers/built-in.o: In function `usbtv_audio_init':
>> (.text+0x21f00a): undefined reference to `snd_card_new'
   drivers/built-in.o: In function `usbtv_audio_init':
>> (.text+0x21f0a2): undefined reference to `snd_pcm_new'
   drivers/built-in.o: In function `usbtv_audio_init':
>> (.text+0x21f0e5): undefined reference to `snd_pcm_set_ops'
   drivers/built-in.o: In function `usbtv_audio_init':
>> (.text+0x21f103): undefined reference to `snd_pcm_lib_preallocate_pages_for_all'
   drivers/built-in.o: In function `usbtv_audio_init':
>> (.text+0x21f10c): undefined reference to `snd_card_register'
   drivers/built-in.o: In function `usbtv_audio_init':
>> (.text+0x21f12a): undefined reference to `snd_card_free'
   drivers/built-in.o: In function `usbtv_audio_free':
>> (.text+0x21f15c): undefined reference to `snd_card_free'
>> drivers/built-in.o:(.data+0x43250): undefined reference to `snd_pcm_lib_ioctl'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/usbtv/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbtv/Kconfig b/drivers/media/usb/usbtv/Kconfig
index 7c5b86006ee6..b833c5b9094e 100644
--- a/drivers/media/usb/usbtv/Kconfig
+++ b/drivers/media/usb/usbtv/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_USBTV
         tristate "USBTV007 video capture support"
-        depends on VIDEO_V4L2
+        depends on VIDEO_V4L2 && SND
+        select SND_PCM
         select VIDEOBUF2_VMALLOC
 
         ---help---
-- 
1.9.3

