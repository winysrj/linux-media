Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6N8w5OD010038
	for <video4linux-list@redhat.com>; Wed, 23 Jul 2008 04:58:05 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6N8vr0R028884
	for <video4linux-list@redhat.com>; Wed, 23 Jul 2008 04:57:53 -0400
Message-ID: <4886F47A.3090102@hhs.nl>
Date: Wed, 23 Jul 2008 11:06:02 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: fs/char_dev.c memory leak (broken reference counting)
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

Hi all,

First some background which is not necessary to understand the rest of this 
post: I encountered the below problem while looking into some videodev.c 
reference counting patches in combination with converting videodev.c from 
register_chrdev, to register_chrdev_region + cdev. I wanted to put links to 
relevant posts here, but for some reason the video4linux-list archive is 
private, I'll kick someone about that.

Now the problem, struct cdev contains a kobj for reference counting, which gets 
initialized either in cdev_alloc (for dynamically allocated cdev structs) or in 
cdev_init (for structs part of a larger struct). Thus setting the reference 
count to 1. When the device underlying the cdev is removed (usb disconnect for 
example) cdev_del gets called which does a kobject_put on the kobj, lowering 
the ref count to 0 causing it to be released.

However releasing the cdev struct, while some apps still has an open fd 
refering to the character device is not a good idea, so chrdev_open does a 
kobj_get on the cdev's kobj.

And here is the problem when the fd refering to the character device gets 
closed, no-one does a kobj_put. chrdev_open replace the file's f_op pointer 
with the device driver fops, so the only fops release which will get called is 
that of the device driver, cdev_put (which will call kobj_put on the kobj) is 
exported, so device driver release methods could and I guess should call 
cdev_put, but under drivers/char there is not a single driver calling cdev_put !!

So unless I'm missing something the kojb release callback never gets called.

I see 2 solutions here:

1) Fix all cdev users to call cdev_put on their cdev in their fops release
    method, adding a release method to do this where necessary, but this seems
    rather error prone

2) Add a private fops struct to cdev, which gets filled with the device drivers
    fops, except for release, which will point to a chrdev_release function
    which call cdev_put after calling the device driver fops release method if
    present, to me this seems the preferable solution.

###

While on this topic in case of an usb device whose driver exports an chardev to 
userspace, the device can be disconnected while the chardev is still open. 
Currently usb-chardev drivers need to do their own reference counting in their 
open / release fops to make sure their device structure stays around until the 
last user has closed the device.

If the reference counting in cdev is fixed, this would almost be an exact 
duplicate of the ref counting done in the device driver, thus I would like to 
propose to add a release function ptr to the cdev structs which if not NULL 
gets called from the cdev kobj release handler, then then device driver no 
longer has to duplicate the ref counting.

This esp seems to make sense in cases where the device driver uses cdev_init, 
as then the cdev structure could currently be freed by the device driver (in 
case of hot unplug) without it knowing for sure that there are no more users of 
the cdev structure. For example even when the device driver does its own ref 
counting in the open / release fops, there could still be some users in the 
form of open cdev sysfs files.

Regards,

Hans

p.s.

Please keep me in the CC, I'm not subscribed to the kernel mailinglist.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
