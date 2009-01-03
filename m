Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <b24e53350901031059w53da1bb9j54c2e89a4bd0dfed@mail.gmail.com>
Date: Sat, 3 Jan 2009 12:59:57 -0600
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
In-Reply-To: <b24e53350812311623qbf8a501re86303fb0fd9ef5c@mail.gmail.com>
MIME-Version: 1.0
References: <b24e53350812311623qbf8a501re86303fb0fd9ef5c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: Jerry Geis <geisj@messagenetsystems.com>, video4linux-list@redhat.com
Subject: Fwd: em28xx-audio.c memory leak and kill URB function call missing?
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

[root@am2mm v4l-dvb]# hg diff
diff -r 6a189bc8f115 linux/drivers/media/video/em28xx/em28xx-audio.c
--- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Dec 31 15:26:57
2008 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Dec 31 19:22:38
2008 -0500
@@ -63,9 +63,12 @@

        dprintk("Stopping isoc\n");
        for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
+               usb_kill_urb(dev->adev.urb[i]);
                usb_unlink_urb(dev->adev.urb[i]);
                usb_free_urb(dev->adev.urb[i]);
                dev->adev.urb[i] = NULL;
+               kfree(dev->adev.transfer_buffer[i]);
+               dev->adev.transfer_buffer[i] = NULL;
        }

        return 0;
[root@am2mm v4l-dvb]#


-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax



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
