Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0EIIYK8024383
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 13:18:39 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0EI4x5H032202
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 13:05:17 -0500
Received: by ey-out-2122.google.com with SMTP id 4so72604eyf.39
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 10:04:58 -0800 (PST)
Message-ID: <b24e53350901141004v6a2ed7d7nb6765fa1d112f7ef@mail.gmail.com>
Date: Wed, 14 Jan 2009 13:04:58 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: [PATCH 2.6.27.8 1/1] em28xx: Fix audio URB transfer buffer memory
	leak and race condition/corruption of capture pointer
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

Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

        (d) I understand and agree that this project and the contribution
            are public and that a record of the contribution (including all
            personal information I submit with it, including my sign-off) is
            maintained indefinitely and may be redistributed consistent with
            this project or the open source license(s) involved.

Signed-off-by: Robert V. Krakora <rob.krakora@messagenetsystems.com>

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
+               if (dev->adev.urb[i]) {
+                       usb_unlink_urb(dev->adev.urb[i]);
+                       usb_free_urb(dev->adev.urb[i]);
+                       dev->adev.urb[i] = NULL;
+               }
+                if (dev->adev.transfer_buffer) {
+                       kfree(dev->adev.transfer_buffer[i]);
+                       dev->adev.transfer_buffer[i] = NULL;
+               }
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
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
