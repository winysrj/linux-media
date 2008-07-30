Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6ULOUXg013451
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 17:24:30 -0400
Received: from smtp-vbr6.xs4all.nl (smtp-vbr6.xs4all.nl [194.109.24.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6ULOGha022340
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 17:24:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Jul 2008 23:24:15 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807302324.15221.hverkuil@xs4all.nl>
Cc: 
Subject: V4L2 & request_module("char-major-...")
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

I'm in the process of converting v4l2-dev.c (2.6.27, in earlier kernels 
it was called videodev.c) from using register_chrdev() to using 
register_chrdev_region() and cdev_add().

The problem I have is that register_chrdev provides a file_operations 
struct. The video_open() function in there performs this piece of code 
when a video device is opened:

        vfl = video_device[minor];
        if (vfl == NULL) {
                mutex_unlock(&videodev_lock);
                request_module("char-major-%d-%d", VIDEO_MAJOR, minor);
                mutex_lock(&videodev_lock);
                vfl = video_device[minor];
                if (vfl == NULL) {
                        mutex_unlock(&videodev_lock);
                        unlock_kernel();
                        return -ENODEV;
                }
        }

It checks if a V4L2 driver registered this particular minor, if not then 
it tries to load the appropriate module with a char-major-x-x alias. If 
still no luck, then we bail out.

Now, as I understand it this can only happen if someone used mknod to 
create device nodes and is not using udev. It's not clear to me however 
how this can ever work: the char-major alias relies on the fact that 
someone has to link the minor number with an actual V4L driver, but you 
do not generally know what minor number will be used by a specific 
driver (depends on load order, etc). Or am I missing something?

My questions are:

1) is this code still relevant?

2) if so, how can I replace this code when I switch to cdev since in 
that case there is no longer a video_open() that can be used for this.

3) I also saw after some googling this proposed patch: 
http://linux.derkeiler.com/Mailing-Lists/Kernel/2003-09/2925.html
It adds a MODULE_ALIAS_CHARDEV_MAJOR line for videodev.c. Either this 
patch was never applied or quickly removed in videodev.c since it's not 
there. I'm not sure how this relates to the request_module in the 
current code and whether it should be added after all or not.

I had a hard time finding any useful information about this, so I hope 
someone can shed some light on this. It's the last piece of the puzzle 
that I need before I can drag the old and venerable v4l2-dev.c formerly 
known as videodev.c into the 21st century :-)

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
