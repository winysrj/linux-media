Return-path: <video4linux-list-bounces@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 19 Dec 2008 14:29:22 +0100
References: <200812180109.51813.hverkuil@xs4all.nl>
	<200812181231.41885.hverkuil@xs4all.nl>
	<494BA09A.2030006@redhat.com>
In-Reply-To: <494BA09A.2030006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812191429.22368.hverkuil@xs4all.nl>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Please test: using the device release() callback instead of the
	cdev release
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

On Friday 19 December 2008 14:24:42 Hans de Goede wrote:
> Hans Verkuil wrote:
> > On Thursday 18 December 2008 11:23:14 Hans de Goede wrote:
> >> <resend with reply to all>
> >>
> >> Hans Verkuil wrote:
> >>> Hi all,
> >>>
> >>> My tree http://linuxtv.org/hg/~hverkuil/v4l-dvb drops the cdev
> >>> release code in favor of using the refcounting and release callback
> >>> from the device struct. Based on the discussion on the kernel list
> >>> regarding the use of cdev refcounting it became clear that that was
> >>> not the right solution, hence this change.
> >>
> >> I haven't tested it, but I have reviewed it. In general it looks ok,
> >> but:
> >>
> >> I do not like the VFL_FL_REGISTERED trickery. Why not just hold the
> >> videodev_lock in video_register_device_index until completely done? It
> >> is not like these are functions which will get called many times a
> >> second. This will also lead to cleaner code.
> >
> > This flag is meant to handle the case where a USB device is
> > disconnected while an application is still using the video device. In
> > that case the disconnect routine unregisters the video device, but it
> > is still possible to open the device if the device node was made with
> > mknod instead of handled by udev. So it is still possible to call open.
> > Currently drivers need to check for this, but it is much easier to
> > catch this in the v4l core directly.
>
> I see, ok.
>
> > Note that eventually all the file_operations that v4l drivers use will
> > go through similar code as is now done for open and release. So all
> > those operations will do the same test and hopefully drivers don't need
> > to be bothered about it. There are some other neat things you can do if
> > all ops go through some standard function first (e.g. proper priority
> > handling), but that's for the future.
>
> +1
>
> <snip>
>
> > One change I made is that the video_device release() callback is now
> > called without holding the global mutex. Since the release() can take
> > some time depending on what it is doing it's much better not to hold
> > that lock. It takes a bit of extra code, but it's well worth it.
>
> +1 (also see my other mail)
>
>
> I do still have one issue with your new code, there still is a open /
> release(through unregister) race.

Hmm, I think I should have posted my latest changes as a reply to this 
thread, rather than starting a new one.

Please look at my posting with subject "[PATCH] Please review V3 of 
v4l2-dev.c".

The version you are looking at is wrong and will crash. But I have high 
hopes of the V3 version.

Regards,

	Hans

>
> Take the following:
>
> (the device is open 0 times)
> unregister gets called
> release gets called
> release gets done till the "mutex_unlock(&videodev_lock);"
> register gets called (camera replugged, usb glitch), problem:
> This new device will get the same minor as the just unregistered one!
> So cdev_add will get called for already used minor, cdev_add does not
> check for this! Then cdev_del will get called on the minor used for the
> new device.
>
> I believe this can be fixed by calling cdev_del inside the piece which
> has the videodev_lock.
>
> Regards,
>
> Hans



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
