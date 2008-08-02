Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m724YPfu028455
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 00:34:25 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.183])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m724YCth028476
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 00:34:12 -0400
Received: by py-out-1112.google.com with SMTP id a29so640752pyi.0
	for <video4linux-list@redhat.com>; Fri, 01 Aug 2008 21:34:11 -0700 (PDT)
Message-ID: <4893E3AE.4000204@gmail.com>
Date: Sat, 02 Aug 2008 00:33:50 -0400
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <200807302324.15221.hverkuil@xs4all.nl>
In-Reply-To: <200807302324.15221.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
From: David Ellingsworth <david@identd.dyndns.org>
Cc: v4l <video4linux-list@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: V4L2 & request_module("char-major-...")
Reply-To: david@identd.dyndns.org
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

Hans Verkuil wrote:
> Hi all,
>
> I'm in the process of converting v4l2-dev.c (2.6.27, in earlier kernels 
> it was called videodev.c) from using register_chrdev() to using 
> register_chrdev_region() and cdev_add().
>
> The problem I have is that register_chrdev provides a file_operations 
> struct. The video_open() function in there performs this piece of code 
> when a video device is opened:
>
>         vfl = video_device[minor];
>         if (vfl == NULL) {
>                 mutex_unlock(&videodev_lock);
>                 request_module("char-major-%d-%d", VIDEO_MAJOR, minor);
>                 mutex_lock(&videodev_lock);
>                 vfl = video_device[minor];
>                 if (vfl == NULL) {
>                         mutex_unlock(&videodev_lock);
>                         unlock_kernel();
>                         return -ENODEV;
>                 }
>         }
>
> It checks if a V4L2 driver registered this particular minor, if not then 
> it tries to load the appropriate module with a char-major-x-x alias. If 
> still no luck, then we bail out.
>
> Now, as I understand it this can only happen if someone used mknod to 
> create device nodes and is not using udev. It's not clear to me however 
> how this can ever work: the char-major alias relies on the fact that 
> someone has to link the minor number with an actual V4L driver, but you 
> do not generally know what minor number will be used by a specific 
> driver (depends on load order, etc). Or am I missing something?
>
> My questions are:
>
> 1) is this code still relevant?
>   
The code is relevant as long as v4l2-dev allocs and associates a block 
of minor number with it's fops.
> 2) if so, how can I replace this code when I switch to cdev since in 
> that case there is no longer a video_open() that can be used for this.
>   
It's interesting that you mention this, I've examined this same problem. 
Essentially, if v4l2-dev only calls cdev_add on minor numbers which have 
been used, there is no need to keep the request_module call in 
video_open. Since v4l2-dev currently calls register_chrdev in 
videodev_init, cdev_add is always called on the entire block. If 
register_chrdev_region is used instead, cdev_add can be called during 
video_register_device_index and the call to request_module can be removed.
> 3) I also saw after some googling this proposed patch: 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2003-09/2925.html
> It adds a MODULE_ALIAS_CHARDEV_MAJOR line for videodev.c. Either this 
> patch was never applied or quickly removed in videodev.c since it's not 
> there. I'm not sure how this relates to the request_module in the 
> current code and whether it should be added after all or not.
>   
I haven't reviewed this patch, but converting v4l2-dev to use 
register_chrdev_region is rather trivial. However, removing video_open 
can't be done without a) patching char_dev or b) reference counting the 
video_device struct. v4l2-dev currently uses a static fops which 
references video_open. The dependency on v4l2-dev's fops can be removed 
if the cdev struct passed to cdev_add is initialized with the the fops 
provided by drivers which use v4l2-dev. This means a cdev struct would 
be needed for every video_device struct created. Embedding the cdev 
struct in the video_device struct and using cdev_init would surely solve 
this problem, but it exposes another problem.

The problem results from how the cdev struct is reference counted. 
Taking a close look at char_dev you'll see that the reference count of 
the kobject in the cdev struct is initialized during cdev_init or 
cdev_alloc, incremented during cdev_open, and decremented during 
cdev_del and __fputs(file_table.c) using cdev_get and cdev_put. Once 
cdev's kobject reference count reaches 0, cdev_default_release or 
cdev_dynamic_release will be called to cleanup or free the struct 
depending on how it was initialized. Unfortunately, cdev_default_release 
nor cdev_dynamic_release provide a way to synchronize freeing of the 
containing struct. Thus, if a cdev struct is embedded into the 
video_device struct, the video_device struct must be reference counted 
in the same way which essentially ensures keeping video_open and the 
addition of video_close. The alternative is to add an optional release 
callback to the cdev struct and call that function during 
cdev_default_release and cdev_dynamic_release so that the containing 
video_device struct may be freed properly.

In addition to the above problem, there is the issue of sysfs. The 
video_device struct has a release callback, but it's use is far from 
correct. Currently this callback _always_ occurs in 
video_unregister_device when unregister_device is called. If a cdev 
struct is embedded in the video_device struct, this would certainly 
result in the freeing of the cdev struct at an inappropriate time. Some 
thought will have to be given about how to handle this properly. 
Personally, I believe the kobject callback (video_release) should only 
free sysfs related structures and not the entire video_device struct, 
like soo many drivers currently do.

I have some patches which address all of the above issues, but I have 
not had time to thoroughly test them and have therefore not yet 
submitted them. I'd be willing to send them to you if you're interested.

Regards,

David Ellingsworth
> I had a hard time finding any useful information about this, so I hope 
> someone can shed some light on this. It's the last piece of the puzzle 
> that I need before I can drag the old and venerable v4l2-dev.c formerly 
> known as videodev.c into the 21st century :-)
>
> Regards,
>
> 	Hans
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
