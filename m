Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 27 May 2008 17:24:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Message-ID: <20080527172446.6f856f21@gaivota>
In-Reply-To: <20080527125041.0fc28fd4@infradead.org>
References: <20080522223700.2f103a14@core> <20080526135951.7989516d@gaivota>
	<20080526202317.GA12793@devserv.devel.redhat.com>
	<20080526181027.1ff9c758@gaivota>
	<20080526220154.GA15487@devserv.devel.redhat.com>
	<20080527101039.1c0a3804@gaivota>
	<20080527094144.1189826a@bike.lwn.net>
	<20080527133100.6a9302fb@gaivota>
	<20080527103755.1fd67ec1@bike.lwn.net>
	<20080527155942.7693c360@gaivota>
	<20080527125041.0fc28fd4@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jonathan Corbet <corbet@lwn.net>
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

On Tue, 27 May 2008 12:50:41 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 27 May 2008 15:59:42 -0300
> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
> > On Tue, 27 May 2008 10:37:55 -0600
> > Jonathan Corbet <corbet@lwn.net> wrote:
> > 
> > > On Tue, 27 May 2008 13:31:00 -0300
> > > Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > 
> > > > Since the other methods don't explicitly call BKL (and, AFAIK,
> > > > kernel open handler don't call it neither), if a program 1 is
> > > > opening a device and initializing some data, and a program 2
> > > > starts doing ioctl, interrupting program 1 execution in the
> > > > middle of a data initialization procedure, you may have a race
> > > > condition, since some devices initialize some device global data
> > > > during open [1].
> > > 
> > > In fact, 2.6.26 and prior kernels *do* acquire the BKL on open (for
> > > char devices) - that's the behavior that the bkl-removal tree is
> > > there to do away with.  So, for example, I've pushed that
> > > acquisition down into video_open() instead. 
> > > 
> > > So, for now, open() is serialized against ioctl() in video
> > > drivers.  As soon as you take the BKL out of ioctl(), though, that
> > > won't happen, unless the mutex you use is also acquired in the open
> > > path.
> > 
> > Ok.
> > 
> > A few drivers seem to be almost read to work without BKL. 
> > 
> > For example, em28xx has already a lock at the operations that change
> > values at "dev" struct, including open() method. However, since the
> > lock is not called at get operations, it needs to be fixed. I would
> > also change it from mutex to a read/write semaphore, since two (or
> > more) get operations can safely happen in parallel.
> > 
> \
> 
> please don't use rw/sems just because there MIGHT be parallel.
> THey're more expensive than mutexes by quite a bit and you get a lot
> less checking from lockdep. They make sense for very specific, very
> read biased, contended cases. But please don't use them "just
> because"...
> 
Good point. The nature of get operations on V4L are not worthy enough to justify
the loss of lockdep checking.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
