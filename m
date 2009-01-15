Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FMVc0R032467
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 17:31:38 -0500
Received: from mail-gx0-f19.google.com (mail-gx0-f19.google.com
	[209.85.217.19])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0FMU5T9007944
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 17:31:15 -0500
Received: by mail-gx0-f19.google.com with SMTP id 12so1208875gxk.3
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 14:31:04 -0800 (PST)
Message-ID: <b24e53350901151431y5f067f3dt75570768431282f0@mail.gmail.com>
Date: Thu, 15 Jan 2009 17:31:04 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: video4linux-list@redhat.com,
	"=?ISO-8859-1?Q?P=E1draig_Brady?=" <P@draigbrady.com>
In-Reply-To: <b24e53350901141202j59828561g3dbb7b9fe389b9ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <b24e53350901141004v6a2ed7d7nb6765fa1d112f7ef@mail.gmail.com>
	<b24e53350901141031w66c4784cqc07eae9ae42202f0@mail.gmail.com>
	<b24e53350901141044u69f5258cjb86a820802c4a89a@mail.gmail.com>
	<b24e53350901141055j4d2562d0gdae11a83272500f6@mail.gmail.com>
	<b24e53350901141202j59828561g3dbb7b9fe389b9ae@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Cc: 
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

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
