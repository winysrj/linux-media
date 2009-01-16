Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:32983 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935779AbZAPOX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 09:23:27 -0500
Received: by ewy10 with SMTP id 10so1919356ewy.13
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2009 06:23:25 -0800 (PST)
Message-ID: <b24e53350901160623u3595502eq73b1421aeb08b82a@mail.gmail.com>
Date: Fri, 16 Jan 2009 09:23:25 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] em28xx: Fix audio URB transfer buffer memory leak and race condition/corruption of capture pointer
In-Reply-To: <b24e53350901151431y5f067f3dt75570768431282f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <b24e53350901141004v6a2ed7d7nb6765fa1d112f7ef@mail.gmail.com>
	 <b24e53350901141031w66c4784cqc07eae9ae42202f0@mail.gmail.com>
	 <b24e53350901141044u69f5258cjb86a820802c4a89a@mail.gmail.com>
	 <b24e53350901141055j4d2562d0gdae11a83272500f6@mail.gmail.com>
	 <b24e53350901141202j59828561g3dbb7b9fe389b9ae@mail.gmail.com>
	 <b24e53350901151431y5f067f3dt75570768431282f0@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx: Fix audio URB transfer buffer memory leak and race
condition/corruption of capture pointer

From: Robert Krakora <rob.krakora@messagenetsystems.com>

Fix audio URB transfer buffer memory leak and race
condition/corruption of capture pointer

Leak fix kindly contributed by Pádraig Brady.

Priority: normal

Signed-off-by: Robert Krakora <rob.krakora@messagenetsystems.com>

diff -r 7981bdd4e25a linux/drivers/media/video/em28xx/em28xx-audio.c
--- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Mon Jan 12
00:18:04 2009 +0000
+++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Thu Jan 15
17:27:27 2009 -0500
@@ -66,6 +66,9 @@
               usb_unlink_urb(dev->adev.urb[i]);
               usb_free_urb(dev->adev.urb[i]);
               dev->adev.urb[i] = NULL;
+
+               kfree(dev->adev.transfer_buffer[i]);
+               dev->adev.transfer_buffer[i] = NULL;
       }

       return 0;
@@ -458,11 +461,15 @@
                                                   *substream)
 #endif
 {
+       unsigned long flags;
+
       struct em28xx *dev;
-
       snd_pcm_uframes_t hwptr_done;
+
       dev = snd_pcm_substream_chip(substream);
+       spin_lock_irqsave(&dev->adev.slock, flags);
       hwptr_done = dev->adev.hwptr_done_capture;
+       spin_unlock_irqrestore(&dev->adev.slock, flags);

       return hwptr_done;
 }
