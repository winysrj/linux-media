Return-path: <video4linux-list-bounces@redhat.com>
Date: Mon, 26 May 2008 18:10:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alan Cox <alan@redhat.com>
Message-ID: <20080526181027.1ff9c758@gaivota>
In-Reply-To: <20080526202317.GA12793@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core> <20080526135951.7989516d@gaivota>
	<20080526202317.GA12793@devserv.devel.redhat.com>
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

On Mon, 26 May 2008 16:23:17 -0400
Alan Cox <alan@redhat.com> wrote:

>  The next step can be to add the obvious locks inside video_ioctl2_unlocked(). Like, for
> > example, locking the VIDIOC_S calls, if someone is calling the corresponding
> > VIDIOC_G or VIDIOC_TRY ones.  
> 
> Concentrate on the dats structures not the code - its one of those oft
> quoted and very true rules - "lock data not code"

True. I'm thinking on locking the data that is being GET/SET by VIDIOC_foo ioctls.

I can see a few strategies for removing KBL.

The hardest and optimal scenario is to look inside all drivers, fix the locks
(and pray for a further patch to not break them). I'm afraid that this is a long
term strategy.

There are also other strategies that will also produce non-optimal results, but
may avoid the usage of BKL.

For example, a very simple scenario would simply replace BKL by one mutex.
This way, just one ioctl could be handled at the same time. This is something
dumb, but will free the machine to do other tasks while an ioctl is being
executed. I bet this would work with all (or almost all) drivers. I don't see
any big drawback of this scenario, from the userspace POV.

Smarter scenarios can be designed if you use different mutexes for different
groups of data, at video_ioctl2 level.

Of course, at video_ioctl2 level, you don't see the real data. However, you'll
see data blocks. For example, if you're calling a VIDIOC_S_CROP, you're
certainly changing whatever data structures you have that changes crop window.
A concurrent call to VIDIOC_G_CROP needs to be blocked, otherwise the get will
return a data that is being changing. IMO, such trivial dependencies can be
safely handled at vidioc_ioctl2.

We may try to group VIDIOC functions into some mutexes to avoid bad usages. For
example, one mutex for ioctl's that touches on video buffers. This will lock on
calls for iocls like VIDIOC_DBUF, VIDIOC_REQBUF, etc.

We take some care with ioctls that would affect all groups of data,
like VIDIOC_S_STD. This ioctl will likely change several data structures that
affects other get operations, like changing resolution. It may also need to
stop and/or return -EBUSY, if video buffers are mmapped.

Such scenarios wouldn't avoid the need of implementing a few locks at the
drivers, but will make driver's live simpler.
 
> I'll tidy these up later in the week as I get time and merge them against
> a current linux-next tree in bits with the rework done.

Seems fine to me ;)

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
