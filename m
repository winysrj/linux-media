Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHDbvw5022420
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 08:37:57 -0500
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBHDbdf9002994
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 08:37:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Greg KH <greg@kroah.com>
Date: Wed, 17 Dec 2008 14:37:33 +0100
References: <200812082156.26522.hverkuil@xs4all.nl>
	<200812170023.41936.hverkuil@xs4all.nl>
	<20081216233039.GA20338@kroah.com>
In-Reply-To: <20081216233039.GA20338@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200812171437.33695.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] cdev_put() race condition
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

On Wednesday 17 December 2008 00:30:39 Greg KH wrote:
> On Wed, Dec 17, 2008 at 12:23:41AM +0100, Hans Verkuil wrote:
> > On Tuesday 16 December 2008 22:21:50 Greg KH wrote:
> > > On Tue, Dec 16, 2008 at 10:00:51PM +0100, Hans Verkuil wrote:
> > > > On Tuesday 16 December 2008 21:22:48 Greg KH wrote:
> > > > > On Mon, Dec 08, 2008 at 09:56:26PM +0100, Hans Verkuil wrote:
> > > > > > Hi Greg,
> > > > > >
> > > > > > Laurent found a race condition in the uvc driver that we traced
> > > > > > to the way chrdev_open and cdev_put/get work.
> > > > > >
> > > > > > You need the following ingredients to reproduce it:
> > > > > >
> > > > > > 1) a hot-pluggable char device like an USB webcam.
> > > > > > 2) a manually created device node for such a webcam instead of
> > > > > > relying on udev.
> > > > > >
> > > > > > In order to easily force this situation you would also need to
> > > > > > add a delay to the char device's release() function. For
> > > > > > webcams that would be at the top of v4l2_chardev_release() in
> > > > > > drivers/media/video/v4l2-dev.c. But adding a delay to e.g.
> > > > > > cdev_purge would have the same effect.
> > > > > >
> > > > > > The sequence of events in the case of a webcam is as follows:
> > > > > >
> > > > > > 1) The USB device is removed, causing a disconnect.
> > > > > >
> > > > > > 2) The webcam driver unregisters the video device which in turn
> > > > > > calls cdev_del().
> > > > > >
> > > > > > 3) When the last application using the device is closed, the
> > > > > > cdev is released when the kref of the cdev's kobject goes to 0.
> > > > > >
> > > > > > 4) If the kref's release() call takes a while due to e.g. extra
> > > > > > cleanup in the case of a webcam, then another application can
> > > > > > try to open the video device. Note that this requires a device
> > > > > > node created with mknod, otherwise the device nodes would
> > > > > > already have been removed by udev.
> > > > > >
> > > > > > 5) chrdev_open checks inode->i_cdev. If this is NULL (i.e. this
> > > > > > device node was never accessed before), then all is fine since
> > > > > > kobj_lookup will fail because cdev_del() has been called
> > > > > > earlier. However, if this device node was used earlier, then
> > > > > > the else part is called: cdev_get(p). This 'p' is the cdev that
> > > > > > is being released. Since the kref count is 0 you will get a
> > > > > > WARN message from kref_get, but the code continues on, the
> > > > > > f_op->open will (hopefully) return more-or-less gracefully with
> > > > > > an error and the cdev_put at the end will cause the refcount to
> > > > > > go to 0 again, which results in a SECOND call to the kref's
> > > > > > release function!
> > > > > >
> > > > > > See this link for the original discussion on the v4l list
> > > > > > containing stack traces an a patch that you need if you want to
> > > > > > (and can) test this with the uvc driver:
> > > > > >
> > > > > > http://www.spinics.net/lists/vfl/msg39967.html
> > > > >
> > > > > The second sentence in that message shows your problem here:
> > > > > 	To avoid the need of a reference count in every v4l2 driver,
> > > > > 	v4l2 moved to cdev which includes its own reference counting
> > > > > 	infrastructure based on kobject.
> > > > >
> > > > > cdev is not ment to handle the reference counting of any object
> > > > > outside of itself, and should never be embedded within anything.
> > > > > I've been thinking of taking the real "kobject" out of that
> > > > > structure for a long time now, incase someone did something
> > > > > foolish like this.
> > > > >
> > > > > Seems I was too late :(
> > > > >
> > > > > So, to solve this, just remove the reliance on struct cdev in
> > > > > your own structures, you don't want to do this for the very
> > > > > reason you have now found (and for others, like the fact that
> > > > > this isn't a "real" struct kobject in play here, just a fake
> > > > > one.)
> > > > >
> > > > > Ick, what a mess.
> > > >
> > > > Sorry, but this makes no sense. First of all the race condition
> > > > exists regardless of how v4l uses it. Other drivers using cdev with
> > > > a hot-pluggable device in combination with a manually created
> > > > device node should show the same problem.
> > >
> > > I don't see how this would be, unless this problem has always existed
> > > in the cdev code, it was created back before dynamic device nodes
> > > with udev existed :)
> > >
> > > > It's just that we found it with v4l because the release callback
> > > > takes longer than usual, thus increasing the chances of hitting the
> > > > race.
> > >
> > > The release callback for the cdev itself?
> >
> > Yes, although we override the release kobj_type.
>
> Hahaha, yeah, I'm really afraid to say it, but you deserve the oops if
> you do that :)
>
> > I noticed that a patch to do this through a cdev function was recently
> > posted (and possibly already merged).
>
> No, it was rejected as it was not needed.
>
> > > > The core problem is simply that it is possible to call cdev_get
> > > > while in cdev_put! That should never happen.
> > >
> > > True, and cdev_put is only called from __fput() which has the proper
> > > locking to handle the call to cdev_get() if a char device is opened,
> > > right?
> >
> > cdev_put is also called through cdev_del, and that's where the problem
> > resides. The cdev_del() call has no locking to prevent a call from
> > cdev_get(), and it can be called asynchronously as well in response to
> > a USB disconnect.
> >
> > > > Secondly, why shouldn't struct cdev be embedded in anything? It's
> > > > used in lots of drivers that way. I really don't see what's unusual
> > > > or messy about v4l in that respect.
> > >
> > > I don't see it embedded in any other structures at the moment, and
> > > used to reference count the structure, do you have pointers to where
> > > it is?
> >
> > Hmm, I took a closer look and it looks like v4l is indeed the first to
> > use cdev for refcounting. Others either don't need it or do their own
> > refcounting. It's definitely embedded in several structs, though. (grep
> > for cdev_init)
>
> Yes, embedding it is fine, just don't use it for reference counting as
> it is using it's own reference counting for something other than what
> you want to use it for.
>
> Overriding the release function should have given you the hint that this
> is not the structure that you should be using for this kind of
> operation.
>
> > However, I don't see how any amount of refcounting in drivers can
> > prevent this race. At some point cdev_del() is called and (if nobody is
> > using the chardev) cdev's kref goes to 0 triggering the release, and at
> > that moment chrdev_open() can be called and the driver has no chance to
> > prevent that, only cdev can do that.
>
> Again, don't use cdev's reference counting for your own object
> lifecycle, it is different and will cause problems, like you have found
> out.

Sigh. It has nothing to do with how v4l uses it. And to demonstrate this, 
here is how you reproduce it with the sg module (tested it with my USB 
harddisk).

1) apply this patch to char_dev.c:

--- char_dev.c.orig	2008-12-17 13:30:22.000000000 +0100
+++ char_dev.c	2008-12-17 08:50:23.000000000 +0100
@@ -412,6 +412,9 @@
 
 static void cdev_purge(struct cdev *cdev)
 {
+	printk("delayin\n");
+	mdelay(2000);
+	printk("delayout\n");
 	spin_lock(&cdev_lock);
 	while (!list_empty(&cdev->list)) {
 		struct inode *inode;


2) connect your harddisk and make note of the sgX device that's created.
3) use mknod to create an sgX device manually for that harddisk.
4) open and close it (cat ./sgX >/dev/null followed by ctrl-C is sufficient)
5) disconnect the harddisk
6) when 'delayin' appears in the log, run cat ./sgX >/dev/null again
7) sit back and enjoy this lovely race condition:

usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
scsi 6:0:0:0: Direct-Access     WD       5000BEV External 1.05 PQ: 0 ANSI: 4
sd 6:0:0:0: [sdg] 976773168 512-byte hardware sectors (500108 MB)
sd 6:0:0:0: [sdg] Write Protect is off
sd 6:0:0:0: [sdg] Mode Sense: 21 00 00 00
sd 6:0:0:0: [sdg] Assuming drive cache: write through
sd 6:0:0:0: [sdg] 976773168 512-byte hardware sectors (500108 MB)
sd 6:0:0:0: [sdg] Write Protect is off
sd 6:0:0:0: [sdg] Mode Sense: 21 00 00 00
sd 6:0:0:0: [sdg] Assuming drive cache: write through
sdg: sdg1
sd 6:0:0:0: [sdg] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg8 type 0
usb-storage: device scan complete
usb 2-4.1: USB disconnect, address 6
delayin
------------[ cut here ]------------
WARNING: at lib/kref.c:43 kref_get+0x17/0x1c()
Modules linked in: sg
Pid: 1491, comm: cat Not tainted 2.6.26-durdane-test #3
[<c0134ad4>] warn_on_slowpath+0x40/0x79
[<c0160ff8>] __do_fault+0x2e4/0x334
[<c017e0c7>] __d_lookup+0xce/0x115
[<c0175393>] do_lookup+0x53/0x145
[<c017d523>] dput+0x16/0xdc
[<c0176d53>] __link_path_walk+0xb36/0xc30
[<c0181d44>] mntput_no_expire+0x18/0xef
[<c02225fb>] kref_get+0x17/0x1c
[<c0221be2>] kobject_get+0xf/0x13
[<c01710b1>] cdev_get+0x55/0x69
[<c01712ce>] chrdev_open+0xc2/0x184
[<c017120c>] chrdev_open+0x0/0x184
[<c016dd3b>] __dentry_open+0x127/0x210
[<c016dea1>] nameidata_to_filp+0x1c/0x2c
[<c01780c4>] do_filp_open+0x33d/0x6d5
[<c016daee>] get_unused_fd_flags+0xb8/0xc2
[<c016db35>] do_sys_open+0x3d/0xb6
[<c016dbf2>] sys_open+0x1e/0x23
[<c01188a9>] sysenter_past_esp+0x6a/0x91
=======================
---[ end trace c8225d49e3c03b85 ]---
delayin
delayout
delayout

Note the duplicate 'delayin' messages. Also note that the cdev struct was 
allocated by sg.c, so the second cdev cleanup will likely poke into already 
freed memory.

I tried to reproduce it as well without the patched char_dev.c by using this 
little program:

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

main()
{
        int state = 0;

        while (1) {
                int fh = open("./sg8", O_RDONLY);
                if (fh >= 0) {
                        if (state == 0) {
                                printf("opened\n");
                                state = 1;
                        }
                        close(fh);
                }
                else {
                        if (state) {
                                printf("error\n");
                                state = 0;
                        }
                }
        }
}

Just run it and connect/disconnect the USB harddisk.

Unfortunately, I wasn't able to reproduce it because I always hit a bug in 
khelper first after only a few attempts:

sd 13:0:0:0: [sdg] Assuming drive cache: write through
sdg: sdg1
sd 13:0:0:0: [sdg] Attached SCSI disk
sd 13:0:0:0: Attached scsi generic sg8 type 0
usb-storage: device scan complete
usb 2-4.1: USB disconnect, address 13
VFS: Close: file count is 0
BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<c0409df2>] _spin_lock_irqsave+0x13/0x25
*pdpt = 000000002ebb5001 *pde = 0000000000000000
Oops: 0002 [#1] PREEMPT SMP
Modules linked in: nvidia(P)

Pid: 13662, comm: khelper Tainted: P          (2.6.26-durdane #1)
EIP: 0060:[<c0409df2>] EFLAGS: 00010002 CPU: 1
EIP is at _spin_lock_irqsave+0x13/0x25
EAX: 00000004 EBX: 00000000 ECX: 00000213 EDX: 00000100
ESI: 00000004 EDI: 00000000 EBP: 00000000 ESP: eeabffc8
DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process khelper (pid: 13662, ti=eeabe000 task=eeb280c0 task.ti=eeabe000)
Stack: c012e788 ee8fb300 00000000 00000000 c014144c 00000000 c01413ec 
c01194ab
ee8fb300 00000000 00000000 00000000 00000000 00000000
Call Trace:
[<c012e788>] complete+0xf/0x36
[<c014144c>] wait_for_helper+0x60/0x65
[<c01413ec>] wait_for_helper+0x0/0x65
[<c01194ab>] kernel_thread_helper+0x7/0x10
=======================
Code: 90 89 e2 81 e2 00 e0 ff ff ff 42 14 f0 83 28 01 79 05 e8 ae ff ff ff 
c3 9c 59 fa 89 e2 81 e2 00 e0 ff ff ff 42 14 ba 00 01 00 00 <f0> 66 0f c1 
10 38 f2 74 06 f3 90 8a 10 eb f6 89 c8 c3 fa 89 e2
EIP: [<c0409df2>] _spin_lock_irqsave+0x13/0x25 SS:ESP 0068:eeabffc8
---[ end trace f5d38a13beb6dc77 ]---
note: khelper[13662] exited with preempt_count 1

I tried the same on a 2.6.28-rc8 kernel and got the same khelper error. 
Lovely.

So, my conclusion remains that cdev has a race condition due to insufficient 
locking between cdev_del/put and cdev_get. And that khelper has it's own 
problems as well :-(

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
