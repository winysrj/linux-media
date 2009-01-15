Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FHDhpt004066
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 12:13:44 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0FHAWMd032132
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 12:11:40 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so1345242ewy.3
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 09:11:40 -0800 (PST)
Message-ID: <b24e53350901150911l4e90e2d8s52e6d357968bb129@mail.gmail.com>
Date: Thu, 15 Jan 2009 12:11:40 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: video4linux-list@redhat.com
In-Reply-To: <b24e53350901150637q5f02d2c5t6d4a9ed5d298934b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b24e53350901150637q5f02d2c5t6d4a9ed5d298934b@mail.gmail.com>
Subject: [PATCH 1/4] em28xx: Fix audio URB transfer buffer memory leak and
	race condition/corruption of capture pointer
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

em28xx: Fix audio URB transfer buffer memory leak and race
condition/corruption of capture pointer

From: Robert Krakora <rob.krakora@messagenetsystems.com>

Fix audio URB transfer buffer memory leak and race
condition/corruption of capture pointer

Padraig found this leak previously so his fix is utilized in this
patch instead of mine.  Many thanks to him for aiding this "newbie".

Priority: normal

Signed-off-by: Robert Krakora <rob.krakora@messagenetsystems.com>

diff -r 6896782d783d linux/drivers/media/video/em28xx/em28xx-audio.c
--- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Jan 14
10:06:12 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Jan 14
12:47:00 2009 -0500
@@ -62,11 +62,20 @@
      int i;

      dprintk("Stopping isoc\n");
-       for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
-               usb_unlink_urb(dev->adev.urb[i]);
-               usb_free_urb(dev->adev.urb[i]);
-               dev->adev.urb[i] = NULL;
-       }
+        for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
+               usb_unlink_urb(dev->adev.urb[i]);
+               usb_free_urb(dev->adev.urb[i]);
+               dev->adev.urb[i] = NULL;
+
+               kfree(dev->adev.transfer_buffer[i]);
+               dev->adev.transfer_buffer[i] = NULL;
+        }

      return 0;
 }
@@ -458,11 +467,15 @@
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



-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
