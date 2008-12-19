Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJMdioa027365
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 17:39:44 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJMdVxq021336
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 17:39:31 -0500
Received: by fg-out-1718.google.com with SMTP id e21so482095fga.7
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 14:39:30 -0800 (PST)
Message-ID: <30353c3d0812191439v46fdd399u271cbee5aeeb0fe6@mail.gmail.com>
Date: Fri, 19 Dec 2008 17:39:30 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200812191502.59040.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812182356.24739.hverkuil@xs4all.nl>
	<200812191502.59040.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Please review V3 of v4l2-dev.c
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

On Fri, Dec 19, 2008 at 9:02 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Hans,
>
> I've taken your comments from the other thread and appended them below. That
> way it is clear that it relates to V3 of my patch.
>
> On Friday 19 December 2008 14:24:42 Hans de Goede wrote:
>> On Thursday 18 December 2008 23:56:24 Hans Verkuil wrote:
>> > OK, I think I finally got it right.
>> >
>> > The latest version is in my usual ~hverkuil/v4l-dvb hg tree. The diff
>> > is not useful, I recommend looking at the source itself.
>> >
>> > One big difference between this and the previous version is that
>> > v4l2-dev now overrides all file_operations (at least the ones used by
>> > the v4l2 drivers) rather than only open and release. It turned out that
>> > you cannot embed a file_operations struct inside video_device since
>> > after video_device is released and freed the kernel __fput function
>> > still uses a reference to it.

OK, I admit, I questioned this as well especially since the
file_operations struct of most (all?) v4l2 sub-drivers have a static
file_operations struct. As a result I considered making the
file_operations struct a parameter to video_register_device so it
could be passed to cdev_init without needing to store it in the
video_device struct.

>> >
>> > So now v4l2-dev has two const static file_operations structs: one for
>> > drivers using unlocked_ioctl and one for drivers using the normal
>> > ioctl. The kernel assumes only one of these is set, so I can't merge
>> > it.
>> >
>> > One useful property of using the release() callback of the device
>> > struct is that once the device is unregistered it is not possible to
>> > obtain a new reference to it since it is removed from all the internal
>> > data structs. So when the refcount finally goes to 0 there is no race
>> > condition anymore (like with cdev) where someone else can obtain a new
>> > reference while the kref's release() is called.

>From a technical standpoint, you've essentially identified a problem
in cdev with using the reference counting provided and have thus
reimplemented it in v4l2-dev. While I agree this is a possible
solution, I can't help but wonder if there isn't a better solution. I
remember someone indicating this might be an issue with _all_ cdev
drivers. If so, I feel this issue should be addressed by correcting
the behavior of cdev rather than working around it in v4l2-dev.

>> >
>> > For the same reason we do not need to lock when refcounting. The only
>> > tricky bit is to ensure that open() will fail if the device is

Correct, and this behavior should have been present in cdev.
Apparently though, it looks like cdev has it wrong.

>> > unregistered. Marking or testing the 'unregistered' flag and using or
>> > changing the global video_device array must all be done under the
>> > videodev_lock mutex, otherwise we cannot rely on a consistent state.
>> >
>> > Note that the file_operations overrides look a bit odd since each op
>> > uses a different return value when the driver doesn't support that op.
>> > I carefully checked which value the kernel uses in case a driver
>> > doesn't support the op and used that here as well.

Again, I have to go back to what I said before... If the bug in cdev
were fixed would we still need these overrides?

>> >
>> > The cdev field in video_device is now a pointer since after the
>> > video_device is freed the cdev might still be in use. By allocating it
>> > dynamically cdev will automatically free itself when its refcount goes
>> > to 0.

In the context you have used it, this appears to be right. Previously,
the cdev and video_device structs were essentially freed together.

>> >
>> > I haven't been able to break it and I think it is now really correct.

Does it work.. yes. Is it correct.. that's debatable. In my opinion
the correct thing to do would be to correct the underlying issue in
cdev that is ultimately the cause of the bug.

[snip]

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
