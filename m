Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f208.google.com ([209.85.217.208]:54810 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZDNTRR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 15:17:17 -0400
Received: by gxk4 with SMTP id 4so5884269gxk.13
        for <linux-media@vger.kernel.org>; Tue, 14 Apr 2009 12:17:16 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 14 Apr 2009 15:17:16 -0400
Message-ID: <b24e53350904141217v474222e5ye042880075bef9c4@mail.gmail.com>
Subject: [PATCH 1/1] em28xx: Fix for Slow Memory Leak
From: Robert Krakora <rob.krakora@messagenetsystems.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx: Fix for Slow Memory Leak

From: Robert Krakora <rob.krakora@messagenetsystems.com>

Test Code:  (Provided by Douglas)

v4l-dvb/v4l2-apps/test/stress-buffer.c

The audio DMA area was never being freed and would slowly leak over
time as the v4l device was opened and closed by an application.

Thanks again to Douglas for generating the test code to help locate
memory leaks!!!

Priority: normal

Signed-off-by: Robert Krakora <rob.krakora@messagenetsystems.com>

diff -r 5567e82c34a0 linux/drivers/media/video/em28xx/em28xx-audio.c
--- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Tue Mar 31
07:24:14 2009 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Tue Apr 14
10:16:45 2009 -0400
@@ -278,6 +278,7 @@
 #endif

        dprintk("Allocating vbuffer\n");
+
        if (runtime->dma_area) {
                if (runtime->dma_bytes > size)
                        return 0;
@@ -385,6 +386,18 @@
        mutex_lock(&dev->lock);
        dev->adev.users--;
        em28xx_audio_analog_set(dev);
+       if (substream == dev->adev.capture_pcm_substream)
+       {
+               if (substream && substream->runtime &&
substream->runtime->dma_area) {
+                       dprintk("freeing\n");
+                       vfree(substream->runtime->dma_area);
+                       substream->runtime->dma_area = NULL;
+               }
+       }
+       else
+       {
+               em28xx_errdev("substream(%p) !=
dev->adev.capture_pcm_substream(%p)\n", substream,
dev->adev.capture_pcm_substream);
+       }
        mutex_unlock(&dev->lock);

        return 0;
