Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 27 May 2008 10:10:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alan Cox <alan@redhat.com>
Message-ID: <20080527101039.1c0a3804@gaivota>
In-Reply-To: <20080526220154.GA15487@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core> <20080526135951.7989516d@gaivota>
	<20080526202317.GA12793@devserv.devel.redhat.com>
	<20080526181027.1ff9c758@gaivota>
	<20080526220154.GA15487@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

On Mon, 26 May 2008 18:01:54 -0400
Alan Cox <alan@redhat.com> wrote:

> On Mon, May 26, 2008 at 06:10:27PM -0300, Mauro Carvalho Chehab wrote:
> > The hardest and optimal scenario is to look inside all drivers, fix the locks
> > (and pray for a further patch to not break them). I'm afraid that this is a long
> > term strategy.
> 
> Ultimately that is where you end up.

Agreed.

> > For example, a very simple scenario would simply replace BKL by one mutex.
> > This way, just one ioctl could be handled at the same time. This is something
> 
> video2_ioctl_serialized() ?

Hmm... it maybe an interesting interim solution to create such function, and
moving the drivers to it.

What if we create 3 functions:

video_ioctl2_bkl()
video_ioctl2_serialized()
video_ioctl2_unlocked()

The first patch will point .ioctl_unlock to video_ioctl2_bkl. 

A next step would be to move the drivers to use the serialized one. I suspect
that this will work properly on all devices that are using video_ioctl2, if
the videobuf locks are now 100% ok. So, it is just a matter of doing some stress
tests. We may start with vivi, since we have a complete domain on what this
driver is doing (e.g. no hardware surprises).

After having all those drivers using the _serialized() one, we can remove the bkl.

Then, we can focus on properly fixing the locks inside the drivers, and moving
one by one to video_ioctl2_unlocked.

IMO, we need to create a multi-thread stress userspace tool for checking the
locks at the ioctls. There are a few testing utils at mercurial tree, under
v4l2-apps/test. This can be a starting point for this tool. Also, Brandon
improved one of those tools to work with multithread.

What do you think?

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
