Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAUAr8ul009851
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 05:53:08 -0500
Received: from smtp-vbr4.xs4all.nl (smtp-vbr4.xs4all.nl [194.109.24.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAUAqtxG022899
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 05:52:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Date: Sun, 30 Nov 2008 11:52:50 +0100
References: <200811291852.41794.hverkuil@xs4all.nl>
	<200811300140.44322.hverkuil@xs4all.nl>
	<1228013385.4615.143.camel@palomino.walls.org>
In-Reply-To: <1228013385.4615.143.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811301152.50971.hverkuil@xs4all.nl>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] v4l2_device/v4l2_subdev: final (?) version
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

On Sunday 30 November 2008 03:49:45 Andy Walls wrote:
> On Sun, 2008-11-30 at 01:40 +0100, Hans Verkuil wrote:
> > On Sunday 30 November 2008 00:31:38 Andy Walls wrote:
> > > On Sat, 2008-11-29 at 18:52 +0100, Hans Verkuil wrote:
> > > > Hi all,
> > > >
> > > > This is hopefully the final version. All earlier comments have
> > > > been incorporated into this patch. I also made a new change:
> > > > the mutex has been replaced by a spinlock and I no longer lock
> > > > when walking the list of subdevs.
> > > >
> > > > So the assumption is that subdevs only added during
> > > > initialization of the device and removed during the destruction
> > > > of the device, and not in between. I cannot think of any reason
> > > > why this you would want to do this, but should this ever happen
> > > > then the list should be replaced by a klist. I consider this
> > > > overkill, esp. since walking the subdev list should be as fast
> > > > as possible.
> > >
> > > I don't have a problem with not locking during a list walk as
> > > long as you can ensure the register and unregister calls can't
> > > happen in the middle of a walk.  I haven't taken a hard look to
> > > see if this is the case.  I'd imagine a walk while registration
> > > is going on is the only case that has a remote chance of
> > > happening.
> >
> > A driver that would do register or unregister calls in the middle
> > of a walk is very badly written. I can't even imagine how that can
> > happen.
> >
> > That said, I'll add a comment in the header making it explicit that
> > no locking is taking place.
>
> Ah.
>
> > > Although I think I've just answered my own next question I'll ask
> > > anyway: why are register & unregister such time critical
> > > operations that we have to spin instead of risk sleeping in a
> > > mutex?  To greatly reduce the probability a walk happens while
> > > registering?  If that's the case it sounds like we're knowingly
> > > building in a race.
> >
> > In the register function it only needs to lock the list momentarily
> > in case two registrations happen at the same time. A mutex is
> > overkill for that. Perhaps having locking at all is overkill as
> > well for this, but for now I feel safer with the lock. In addition,
> > I might well change the way subdevices are registered. Right now
> > the bridge driver loads and registers a subdevice, but an
> > alternative approach would be that the i2c driver can register
> > itself with the bridge driver when loaded. There are actually some
> > advantages to that approach, but if I do that, then the lock is
> > definitely needed.
> >
> > > This comment kind of bugged me too:
> > > >/* Iterate over all subdevs. The next item is prefetched, so you
> > > > can +   delete the current item if necessary. */
> > > > +#define v4l2_device_for_each_subdev(sd, dev)
> > >
> > > It implies it's safe to remove things from the list that we're
> > > not locking.
> >
> > Oops, that was a bogus comment. Actually, the whole macro is a bit
> > bogus and can simply be replaced by this:
> >
> > /* Iterate over all subdevs. */
> > #define v4l2_device_for_each_subdev(sd, dev) \
> >         list_for_each_entry(sd, &(dev)->subdevs, list)
> >
> > > I can appreciate the desire for being able to walk the list and
> > > issue commands to various subdevs with high concurrency.  I know
> > > spinlocks are optimized for the common case of the lock being
> > > available (well at least the underlying __raw_spin_lock() is
> > > optimized, if preemption is enabled there's a little overhead
> > > added).  So they give the safety with a minor penalty at the
> > > micro level, but kill concurrency of common operations at the
> > > macro level.
> > >
> > > So how about a rwlock_t and using read_lock() and write_lock(),
> > > locks that provide safety and allow high concurrency at the macro
> > > level?  I don't know if there's an analog of a read/write mutex.
> >
> > Note that I can't use spinlocks while walking the subdevs list
> > since the subdev ops that you call can sleep which is not allowed
> > with spinlocks (as I very quickly found out when I tried it :-) ).
>
> Ah.
>
> > The only way to safely walk over it is to switch to a klist, but I
> > really like to keep __v4l2_device_call_subdevs as fast as possible.
> > Since the registration/unregistration of subdevs is fully
> > controlled by the driver it is trivial for the driver to ensure
> > that there are no (un)registrations while the subdev list is being
> > walked. There are no external events that can cause this to happen.
> >
> > In addition, there is also no point for a driver to begin issuing
> > commands to subdevs while some of them are not yet registered. So I
> > feel confident about my approach.
>
> Just playing a little more devil's advocate:
>
> I have a recollection that the lirc_pvr150 module calls an ivtv
> function directly to reset the IR blaster chip on PVR-150's.  I'd
> imagine in the future, the GPIO subdev in ivtv might implement some
> sort of reset_ops or ir_ops for a cleaner interface for an updated
> lirc_pvr150 module to call in on. There's my one contrived example,
> contingent on assumed changes, of a bridge chip driver not being
> strictly in control of when a subdev could be called.
>
> (It's moot in this case though as lirc_pvr150 would need ivtv to init
> i2c before gpio, which ivtv doesn't do, before lirc_pvr150 would
> attempt a reset of the IR blaster.)
>
> I think you're safe for now. :)

I think so too :-)  Anyway, it's highly debatable whether that reset 
thing for ivtv is still needed. I suspect it isn't.

> On a more philosophical note is GPIO really a single subdev or a
> collection of independent serial & discrete buses to a collection of
> subdevs?  In cx18 depending on the board, GPIO can reset chips,
> change audio mux paths, change the state of LED's, and in the future
> be used as a serial line (if I ever get that soft-UART to the IR
> blaster implemented).

Definitely a collection of subdevs. Usually each chip driven by GPIO 
would have its own subdev. So ivtv implements an audio muxer subdev, 
but it might also have additional subdevs for other chips connected to 
the GPIO lines. I haven't explored all the possibilities yet, but I 
suspect that this can be a quite powerful solution.

Regards,

	Hans

> > But if it turns out to be a problem after all in the future, then
> > it will be easy to replace the list with a klist.
>
> Well my one contrived example is between two modules who usage is
> tightly coupled at least in one direction, even if source code
> changes are not tightly coordinated.  In that case I'd predict
> problems will simply be avoided due to the tight coupling.
>
> Regards,
> Andy
>
> > > Did I totally miss the concept?
> >
> > Not at all, and once again thanks for the comments.
> >
> > I've updated my tree with the changes mentioned above.
> >
> > Regards,
> >
> >           Hans
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
