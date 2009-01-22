Return-path: <video4linux-list-bounces@redhat.com>
MIME-Version: 1.0
Date: Thu, 22 Jan 2009 10:02:01 -0500
Message-ID: <b24e53350901220702k42a9b3b7uefdc50fdcdbcd28d@mail.gmail.com>
From: Robert Krakora <rob.krakora@messagenetsystems.com>
To: video4linux-list@redhat.com,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [PATCH 1/1] em28xx: Fix for fail to submit URB with IRQs and
	Pre-emption Disabled
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

em28xx: Fix for fail to submit URB with IRQs and Pre-emption Disabled

From: Robert Krakora <rob.krakora@messagenetsystems.com>

Trace:  (Provided by Douglas)

BUG: sleeping function called from invalid context at drivers/usb/core/urb.c:558

in_atomic():0, irqs_disabled():1

Pid: 4918, comm: sox Not tainted 2.6.27.5 #1

 [<c04246d8>] __might_sleep+0xc6/0xcb

 [<c058c8b0>] usb_kill_urb+0x1a/0xd8

 [<c0488e68>] ? __kmalloc+0x9b/0xfc

 [<c0488e85>] ? __kmalloc+0xb8/0xfc

 [<c058cd5a>] ? usb_alloc_urb+0xf/0x31

 [<f8dd638c>] em28xx_isoc_audio_deinit+0x2f/0x6c [em28xx_alsa]

 [<f8dd6573>] em28xx_cmd+0x1aa/0x1c5 [em28xx_alsa]

 [<f8dd65e1>] snd_em28xx_capture_trigger+0x53/0x68 [em28xx_alsa]

 [<f8aa8674>] snd_pcm_do_start+0x1c/0x23 [snd_pcm]

 [<f8aa85d7>] snd_pcm_action_single+0x25/0x4b [snd_pcm]

 [<f8aa9833>] snd_pcm_action+0x6a/0x76 [snd_pcm]

 [<f8aa98f5>] snd_pcm_start+0x14/0x16 [snd_pcm]

 [<f8aae10e>] snd_pcm_lib_read1+0x66/0x273 [snd_pcm]

 [<f8aac5a3>] ? snd_pcm_kernel_ioctl+0x46/0x5f [snd_pcm]

 [<f8aae4a7>] snd_pcm_lib_read+0xbf/0xcd [snd_pcm]

 [<f8aad774>] ? snd_pcm_lib_read_transfer+0x0/0xaf [snd_pcm]

 [<f89feeb6>] snd_pcm_oss_read3+0x99/0xdc [snd_pcm_oss]

 [<f89fef9c>] snd_pcm_oss_read2+0xa3/0xbf [snd_pcm_oss]

 [<c064169d>] ? _cond_resched+0x8/0x32

 [<f89ff0be>] snd_pcm_oss_read+0x106/0x150 [snd_pcm_oss]

 [<f89fefb8>] ? snd_pcm_oss_read+0x0/0x150 [snd_pcm_oss]

 [<c048c6e2>] vfs_read+0x81/0xdc

 [<c048c7d6>] sys_read+0x3b/0x60

 [<c04039bf>] sysenter_do_call+0x12/0x34

 =======================

The culprit in the trace is snd_pcm_action() which invokes a spin lock
which disables pre-emption which disables an IRQ which causes the
__might_sleep() function to fail the irqs_disabled() test.  Since
pre-emption is enabled then it is safe to de-allocate the memory if
you first unlink each URB.  In this instance you are safe since
pre-emption is disabled.  If pre-emption and irqs are not disabled then
call usb_kill_urb(), else call usb_unlink_urb().

Thanks to Douglas for tracking down this bug originally!!!

Priority: normal

Signed-off-by: Robert Krakora <rob.krakora@messagenetsystems.com>

diff -r f4d7d0b84940 linux/drivers/media/video/em28xx/em28xx-audio.c
--- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Sun Jan 18
10:55:38 2009 +0000
+++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Thu Jan 22
09:50:03 2009 -0500
@@ -63,12 +63,17 @@

        dprintk("Stopping isoc\n");
        for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
-               usb_kill_urb(dev->adev.urb[i]);
+               if (!irqs_disabled()) {
+                       usb_kill_urb(dev->adev.urb[i]);
+               }
+               else {
+                       usb_unlink_urb(dev->adev.urb[i]);
+               }
                usb_free_urb(dev->adev.urb[i]);
                dev->adev.urb[i] = NULL;

-              kfree(dev->adev.transfer_buffer[i]);
-              dev->adev.transfer_buffer[i] = NULL;
+               kfree(dev->adev.transfer_buffer[i]);
+               dev->adev.transfer_buffer[i] = NULL;
        }

        return 0;
diff -r f4d7d0b84940 linux/drivers/media/video/em28xx/em28xx-core.c
--- a/linux/drivers/media/video/em28xx/em28xx-core.c    Sun Jan 18
10:55:38 2009 +0000
+++ b/linux/drivers/media/video/em28xx/em28xx-core.c    Thu Jan 22
09:50:03 2009 -0500
@@ -869,8 +869,12 @@
        for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
                urb = dev->isoc_ctl.urb[i];
                if (urb) {
-                       usb_kill_urb(urb);
-                       usb_unlink_urb(urb);
+                       if (!irqs_disabled()) {
+                               usb_kill_urb(urb);
+                       }
+                       else {
+                               usb_unlink_urb(urb);
+                       }
                        if (dev->isoc_ctl.transfer_buffer[i]) {
                                usb_buffer_free(dev->udev,
                                        urb->transfer_buffer_length,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
