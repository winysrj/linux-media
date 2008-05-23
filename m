Return-path: <video4linux-list-bounces@redhat.com>
Date: Fri, 23 May 2008 05:09:19 -0400
From: Alan Cox <alan@redhat.com>
To: Andy Walls <awalls@radix.net>
Message-ID: <20080523090919.GA31575@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core>
	<1211508484.3273.86.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211508484.3273.86.camel@palomino.walls.org>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
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

On Thu, May 22, 2008 at 10:08:04PM -0400, Andy Walls wrote:
> Could someone give me a brief education as to what elements of
> cx18/ivtv_v4l2_do_ioctl() would be forcing the use of the BKL for these
> drivers' ioctls?   I'm assuming it's not the
> mutex_un/lock(&....->serialize_lock) and that the answer's not in the
> diff.

As it stood previous for historical reasons the kernel called the driver
ioctl method already holding the big kernel lock. That lock effectively
serialized a lot of ioctl processing and also serializes against module
loading and registration/open for the most part. If all the resources you
are working on within the ioctl handler are driver owned as is likely with
a video capture driver, and you have sufficient locking of your own you can
drop the lock.

video_usercopy currently also uses the BKL so you might want to copy a
version to video_usercopy_unlocked() without that.

A small number of other things still depend on the BKL but probably don't
affect a capture driver: Setting file flags and using the deprecated
sleep_on and interruptible_sleep_on. Other things like memory allocators
wait_event, wake_up and the like all do their own locking internally and
that is a model we want to end up at - whether everything has "proper" locking.

You may also find a driver depends on other things (eg video on i2c and you
can't yet prove the i2c (or don't know) is locked entirely privately in
which cases I've ended up leaving the drivers I worked on with

	lock_kernel();
	ret = subsys_some_foo(bar);
	unlock_kernel();

which makes it clear what the remaining problem points are so they can be
revisited.

For a lot of ioctl conversions the big issue is "two ioctls at once in parallel"
which can happen even on a single opener device. The other tends be stuff like
"ioctl versus unplug" although for PCI and many other subsystems the resources
are ref-counted so a pci_dev won't vanish on you without warning.

Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
