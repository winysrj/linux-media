Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m69MSxQP002559
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 18:28:59 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m69MSV1t001324
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 18:28:46 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1720401fga.7
	for <video4linux-list@redhat.com>; Wed, 09 Jul 2008 15:28:31 -0700 (PDT)
Message-ID: <30353c3d0807091528o23cbe458ma057b265fe8e5dd4@mail.gmail.com>
Date: Wed, 9 Jul 2008 18:28:30 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <200807092221.42262.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0807081923o6ba66d34oac44d5bb98fd0e3a@mail.gmail.com>
	<48744036.506@hhs.nl> <200807092146.09826.laurent.pinchart@skynet.be>
	<200807092221.42262.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] videodev: fix kobj ref count
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

On Wed, Jul 9, 2008 at 4:21 PM, Laurent Pinchart
<laurent.pinchart@skynet.be> wrote:
> On Wednesday 09 July 2008, Laurent Pinchart wrote:
>> Hi Hans,
>>
>> On Wednesday 09 July 2008, Hans de Goede wrote:
>> > David Ellingsworth wrote:
>> > > Mauro,
>> > >
>> > > If Laurent approves, please apply the following patch to the devel
>> > > branch. I've been using it locally for the past five days or so
>> > > without issue.
>> > >
>> > > This patch increments the kobject reference count during video_open
>> > > and decrements it during video_close. Doing so allows
>> > > video_unregister_device to be called during the disconnect callback of
>> > > usb and pci devices. It also ensures that the video_device struct is
>> > > not freed while it is still in use and that the kobject release
>> > > callback occurs at the appropriate time. With this patch, the
>> > > following sequence is now possible and no longer results in a crash.
>> > >
>> > > video_open
>> > >   disconnect
>> > >     video_unregister_device
>> > >       video_ioctl2 (crash was here)
>> > >         video_close
>> > >           video_release
>> >
>> > I like this patch, I really do, as currently this refcounting needs to
>> > be done in all v4l devices seperately, and an video_ioctl2 wrapper needs
>> > to be used to stop the crash (check if device was disconnected and thus
>> > video_unregister_device was called and ifso don't call video_ioctl2).
>>
>> I like it as well, as there is currently no way for video drivers to avoid
>> both race conditions and deadlocks. As you stated, refcounting currently
>> needs to be done in the device drivers. To avoid race conditions between
>> open() and disconnect(), device drivers need a global lock that will
>> prevent open() to reference driver-specific structures that just got freed
>> through disconnect(). That lock must be taken in the driver open() handler,
>> already protected by the videodev_lock, and in the driver disconnect()
>> handler, that calls video_unregister_device() that will in turn take the
>> videodev_lock. This results in a AB-BA deadlock.
>
> I spoke too soon. Device drivers don't need to protect
> video_unregister_device() with the driver lock. video_unregister_device()
> will wait until video_open() releases the videodev_lock
>
Correct, but the current implementation of video_unregister_device
when called always causes the kobject release callback to occur which
frees the video_device struct and makes video_ioctl2 unusable. Thus
drivers either must avoid calling video_unregister device while the
device is still open or use a wrapper around video_ioctl2 to prevent
it from being called after video_device_unregister has been called. In
my opinion, video_unregister_device should always be called during
disconnect handler to prevent future calls to open. In doing so it
should not cause the video_device struct to be freed unless it is no
longer in use.

> All a driver has to do is ensure open() will not complete successfully if
> video_unregister_device() is about to be called or to proceed (waiting on
> videodev_lock). This can easily be achieved by setting a flag in the
> disconnect() handler and checking that flag in the open() handler.
>
Agreed, a flag is still necessary as a call to open() may still occur
after the disconnect() handler. However, in my opinion drivers should
not have to delay the call to video_unregister_device nor maintain a
reference count in order to determine when it's safe for it to be
called (like the example below). Always being able to call
video_device_unregister during the disconnect() handler reduces the
number of failed calls to open while the device is waiting for the
final close to occur.

> To avoid race conditions, setting the flag must be protected by the device
> lock.
>
> disconnect()                           | open()
>                                       |
> lock driver                            |
> set disconnected flag                  |
> unlock driver                          |
>                                       | lock driver
>                                       | return error if disconnected flag set
>                                       | initialise
>                                       | increment the reference count
>                                       | unlock driver
> decrement reference count              |
> if (reference count reached 0)         |
>        uvc_unregister_device()        |
>                                       |
>
> The disconnected flag will either be set before open() proceeds, in which case
> it will return an error, or after open() is done, in which case the reference
> count will not reach 0 in disconnect().
>

With this patch the above sequence could be simplified as follows:

disconnect()			| open()
				|
lock driver			|
set disconnect flag		|
unlock driver			|
video_unregister_device()	|
				| lock driver
				| return error if disconnect flag set
				| initialize
				| unlock driver

Note, no reference count is required. Freeing of all internal objects
can occur during the kobject release handler. In the example above, if
video_unregister_device() obtains the videodev_lock before open() and
decrements the kobject reference count to 0, the call to open will
fail long before it reaches the the driver specified implementation of
open() and the bottom half of the above will not even occur. The only
conditions under which the above would occur is if the device is
already open (decrementing the kobject reference count in
video_unregister_device did not cause it to go to 0), or open()
obtained the videodev_lock before video_unregister_device(). In either
case, video_unregister_device has been called and no more opens may
occur thereafter.

>> In short, reference counting in the videodev layer is required.
>
> Maybe not required, but still desirable. Getting complex locking right is
> tricky and very error-prone, so let's put all locking bugs in videodev :-)
>
>> > So I've taken a good look and this, and I cannot find any issues.
>>
>> I'm currently reviewing David's patch (sorry for the delay). I'll post a
>> go/no go (hopefully the former :-)) very soon.
>

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
