Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m616T2p6026449
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 02:29:02 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m616Rwog015051
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 02:27:58 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1128454fga.7
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:27:57 -0700 (PDT)
Message-ID: <30353c3d0806302327q234b2c06l629b9e42568ae940@mail.gmail.com>
Date: Tue, 1 Jul 2008 02:27:57 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <30353c3d0806300542r5ba585e3n304c33851051a028@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0806281807p7b78dcd2xe2a91d560ae6df12@mail.gmail.com>
	<200806300315.42610.laurent.pinchart@skynet.be>
	<30353c3d0806292009r5556afd6s5d5e271d1c7ff575@mail.gmail.com>
	<30353c3d0806292203p193ff610i866b938271391f81@mail.gmail.com>
	<30353c3d0806300542r5ba585e3n304c33851051a028@mail.gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] videodev: properly reference count video_device
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

[snip]
> One could argue that when the sysfs release callback of videodev is
> called, the associated release callback defined by
> video_device.release should be called as well. While I completely
> agree with this argument, the video_device.release callback has been
> advertised as the location where the video_device should be freed. To
> this regard even the article on LWN at http://lwn.net/Articles/203924/
> indicates taking this action. The proper thing for a subdriver to do
> in the video_device.release callback is to decrement the ref count on
> their internal structure. And once that ref count reaches 0 to free
> their structure as well as the video_device structure. The subdriver
> is after all the one that alloced the video_device structure to begin
> with. Given the number of drivers currently calling
> video_device_release from the video_device.release callback, it's
> currently unsafe for this callback to occur during the sysfs release
> callback in videodev unless the video_device structure is no longer in
> use. The patch I've provided currently handles this situation, however
> I think steps should be taken to correct drivers that directly call
> video_device_release via this callback as this is obviously incorrect.
>
[Correction]
After reviewing the char_dev driver, I now convinced that the LWN
article at http://lwn.net/Articles/36850/ is correct. However, this
article only applies to drivers which use the chrdev api. Drivers
based on char_dev, initialize the kobject reference count to 1 in
device_register, increment it in chrdev_open, and decremented it in
__fput(after the fops.release callback) and device_unregister. The
sysfs release callback referred to by the article will therefore not
be called until after device_unregister and the fops.release callback
have both been called.

Since the videodev driver does not use the chardev api, the kobject
reference is not incremented by an open and is not decremented after
the fops.release callback has been called. Thus, the call to
device_unregister in video_unregister_device will always cause the
sysfs release callback to occur regardless of whether or not the
fops.release callback has been called. Until videodev is converted to
the chrdev api this issue will continue to persist.

The patch I provided mimics the desired behavior that is lacking in
the videodev driver since it does not use the chrdev api. Once
videodev has been converted to the chrdev api, this patch should no
longer be necessary. At that time, video_open can mostly likely be
removed as well since chrdev_open closely mimics the desired
functionality.

Given I now know and understand the context in which the sysfs release
callback should occur, I should be able to remove the kref object
added by this patch and utilize the kobject reference count instead.
Doing so should remove much of the code this patch currently adds and
cause the sysfs release callback to occur at the appropriate time.

I will resubmit this patch once I have implemented it using the
kobject reference count instead.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
