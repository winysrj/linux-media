Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB7FZ3XV008917
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 10:35:03 -0500
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB7FYmKc018845
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 10:34:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Date: Sun, 7 Dec 2008 16:34:46 +0100
References: <200812071314.17267.laurent.pinchart@skynet.be>
In-Reply-To: <200812071314.17267.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_W0+OJNseGNGTkui"
Message-Id: <200812071634.46842.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: [BUG] Race condition between open and disconnect
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

--Boundary-00=_W0+OJNseGNGTkui
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Laurent,

On Sunday 07 December 2008 13:14:17 Laurent Pinchart wrote:
> Hi everybody,
>
> I'm afraid to report that the move to the cdev interface in 2.6.28
> has introduced a race condition between open and disconnect.
>
> To avoid the need of a reference count in every v4l2 driver, v4l2
> moved to cdev which includes its own reference counting
> infrastructure based on kobject.

It actually seems to be a cdev race condition that can happen with other 
char devices as well. However, there is also a bug in v4l2-dev that 
makes it worse.

Please try attached patch. You will still get the kref WARN, but 
otherwise it should work OK.

Did you get these WARN and BUG messages in a 'real-life' situation as 
well, or only when you put in an msleep?

Regards,

	Hans

> kobject_(get|put) calls on which the reference counting code relies
> (kobject_get being called by cdev_get in chrdev_open, and kobject_put
> being called by device_unregister in video_device_unregister) call
> use the embedded kref_(get|put). Unfortunately, while those calls use
> atomic operations to access the reference counter, they are not
> thread-safe. A call to kref_get can succeed even though a call to
> kref_put has released the last reference.
>
> I've modified the UVC driver to remove the thread-safe reference
> counting that was supposed not to be required anymore with the move
> to cdev and added an msleep(3000) at the beginning of
> v4l2_chardev_release to make the race condition easier to reproduce
> (patch against my hg tree attached).
>
> Steps to reproduce:
>
> - load the uvcvideo module
> - connect a UVC camera
> - start any video application
> - close the application
> - disconnect the camera
> - within 3 seconds of the disconnection, start the video application
> - check dmesg for the bug report and enjoy
>
>
> usb 2-1: USB disconnect, address 6
> ------------[ cut here ]------------
> WARNING: at lib/kref.c:43 kref_get+0x1c/0x20()
> Modules linked in: snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep
> uvcvideo videodev v4l2_compat_ioctl32 v4l1_compat radeon drm arc4 ecb
> ieee80211_crypt_tkip rfcomm l2cap hci_usb ipw2200 bluetooth ieee80211
> r8169 snd_intel8x0m ieee80211_crypt
> Pid: 19247, comm: luvcview Not tainted 2.6.27 #36
>  [<c011cd6f>] warn_on_slowpath+0x5f/0x90
>  [<c01192bf>] try_to_wake_up+0xaf/0xc0
>  [<c01806e7>] __d_lookup+0xf7/0x150
>  [<c01d70e0>] xattr_lookup_poison+0x0/0xa0
>  [<c01762c5>] do_lookup+0x65/0x1a0
>  [<c018005c>] dput+0x1c/0x160
>  [<c0178331>] __link_path_walk+0xb01/0xc90
>  [<c025e6ac>] kref_get+0x1c/0x20
>  [<c025d8ef>] kobject_get+0xf/0x20
>  [<c01710c2>] cdev_get+0x22/0x90
>  [<c01717c7>] chrdev_open+0x37/0x1e0
>  [<c0171790>] chrdev_open+0x0/0x1e0
>  [<c016ce24>] __dentry_open+0xd4/0x260the
>  [<c016cff5>] nameidata_to_filp+0x45/0x60
>  [<c0179617>] do_filp_open+0x187/0x720
>  [<c02a2488>] tty_write+0x1b8/0x1e0
>  [<c016cbfe>] do_sys_open+0x4e/0xe0
>  [<c016cd0c>] sys_open+0x2c/0x40
>  [<c0103119>] sysenter_do_call+0x12/0x21
>  [<c0440000>] pfkey_add+0x4f0/0x7f0
>  =======================
> ---[ end trace 32937b1bc9a02398 ]---
> ------------[ cut here ]------------
> kernel BUG at drivers/media/video/v4l2-dev.c:119!
> invalid opcode: 0000 [#1] PREEMPT
> Modules linked in: snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep
> uvcvideo videodev v4l2_compat_ioctl32 v4l1_compat radeon drm arc4 ecb
> ieee80211_crypt_tkip rfcomm l2cap hci_usb ipw2200 bluetooth ieee80211
> r8169 snd_intel8x0m ieee80211_crypt
>
> Pid: 19247, comm: luvcview Tainted: G        W (2.6.27 #36)
> EIP: 0060:[<f09d14e7>] EFLAGS: 00010202 CPU: 0
> EIP is at v4l2_chardev_release+0x37/0x80 [videodev]
> EAX: f09d8a90 EBX: ed069c00 ECX: 00000003 EDX: 00000000
> ESI: ed069d20 EDI: 00000000 EBP: d836968c ESP: e9005e6c
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process luvcview (pid: 19247, ti=e9004000 task=e90f31a0
> task.ti=e9004000) Stack: ed069d20 f09d8a9c c025d896 ed069d3c c025d860
> ffffffed c025e659 f0c0f500 00000001 c017121d ed069d20 c0171887
> ed2ddb40 00000006 ed2ddb40 d836968c 00000000 c0171790 c016ce24
> ef80d1c0 d7861760 ed2ddb40 e9005f10 00000026 Call Trace:
>  [<c025d896>] kobject_release+0x36/0x80
>  [<c025d860>] kobject_release+0x0/0x80
>  [<c025e659>] kref_put+0x29/0x60
>  [<c017121d>] cdev_put+0xd/0x20
>  [<c0171887>] chrdev_open+0xf7/0x1e0
>  [<c0171790>] chrdev_open+0x0/0x1e0
>  [<c016ce24>] __dentry_open+0xd4/0x260
>  [<c016cff5>] nameidata_to_filp+0x45/0x60
>  [<c0179617>] do_filp_open+0x187/0x720
>  [<c02a2488>] tty_write+0x1b8/0x1e0
>  [<c016cbfe>] do_sys_open+0x4e/0xe0
>  [<c016cd0c>] sys_open+0x2c/0x40
>  [<c0103119>] sysenter_do_call+0x12/0x21
>  [<c0440000>] pfkey_add+0x4f0/0x7f0
>  =======================
> Code: 0b 00 00 e8 cc 47 75 cf b8 90 8a 9d f0 e8 a2 8b a7 cf 8b 83 88
> 01 00 00 3b 1c 85 00 8d 9d f0 74 0e b8 90 8a 9d f0 e8 99 8b a7 cf
> <0f> 0b eb fe 31 c9 89 0c 85 00 8d 9d f0 8b 83 84 01 00 00 0f b7
> EIP: [<f09d14e7>] v4l2_chardev_release+0x37/0x80 [videodev] SS:ESP
> 0068:e9005e6c
> ---[ end trace 32937b1bc9a02398 ]---
>
> Best regards,
>
> Laurent Pinchart



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--Boundary-00=_W0+OJNseGNGTkui
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="v4l2-dev.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="v4l2-dev.c.diff"

diff -r 1dc46cdcf365 linux/drivers/media/video/v4l2-dev.c
--- a/linux/drivers/media/video/v4l2-dev.c	Sat Dec 06 11:29:33 2008 +0100
+++ b/linux/drivers/media/video/v4l2-dev.c	Sun Dec 07 16:28:47 2008 +0100
@@ -110,11 +110,23 @@
 static void v4l2_chardev_release(struct kobject *kobj)
 {
 	struct video_device *vfd = container_of(kobj, struct video_device, cdev.kobj);
+	
+	/* Release the character device, ensures that afterwards this
+	   chardev cannot be opened again. */
+	vfd->cdev_release(kobj);
+
+	/* If someone tried to open this chardev while we are still in the
+	   process of deleting it then the refcount will be non-zero. */
+	if (atomic_read(&kobj->kref.refcount)) {
+		/* Do nothing, the next time the refcount goes to zero
+		   we will be called again. */
+		return;
+	}
 
 	mutex_lock(&videodev_lock);
 	if (video_device[vfd->minor] != vfd) {
 		mutex_unlock(&videodev_lock);
-		BUG();
+		WARN(1, "Inconsistent vfd on minor %d!\n", vfd->minor);
 		return;
 	}
 
@@ -123,8 +135,6 @@
 	clear_bit(vfd->num, video_nums[vfd->vfl_type]);
 	mutex_unlock(&videodev_lock);
 
-	/* Release the character device */
-	vfd->cdev_release(kobj);
 	/* Release video_device and perform other
 	   cleanups as needed. */
 	if (vfd->release)

--Boundary-00=_W0+OJNseGNGTkui
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_W0+OJNseGNGTkui--
