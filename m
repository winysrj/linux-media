Return-path: <video4linux-list-bounces@redhat.com>
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com>
References: <20080522223700.2f103a14@core>
	<20080526220154.GA15487@devserv.devel.redhat.com>
	<20080527101039.1c0a3804@gaivota>
	<20080527094144.1189826a@bike.lwn.net>
	<20080527133100.6a9302fb@gaivota>
	<20080527103755.1fd67ec1@bike.lwn.net>
	<20080527155942.7693c360@gaivota>
	<412bdbff0805271226t41fe55b0jd0b8e3c737f34734@mail.gmail.com>
	<20080527180048.6a27dbf7@gaivota>
	<1211932138.3197.29.camel@palomino.walls.org>
	<412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 27 May 2008 22:37:01 -0400
Message-Id: <1211942221.3197.154.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
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

On Tue, 2008-05-27 at 20:46 -0400, Devin Heitmueller wrote:
> Hello Andy,
> 
> On Tue, May 27, 2008 at 7:48 PM, Andy Walls <awalls@radix.net> wrote:
> > MythTV's mythbackend can open both sides of the card at the same time
> > and the cx18 driver supports it.  On my HVR-1600, MythTV may have the
> > digital side of the card open pulling EPG data off of the ATSC
> > broadcasts, when I open up the MythTV frontend and start watching live
> > TV on the analog side of the card.  MythTV also supports
> > Picture-in-Picture using both the analog and digital parts of the
> > HVR-1600.
> 
> In this case, what you see as a 'feature' in MythTV is actually a
> problem in our case.  While the HVR-1600 can support this scenario,
> the HVR-950 can only use one or the other (the em28xx chip uses GPIOs
> to enable the demodulator and presumably you should never have both
> demodulators enabled at the same time).  Because of this we need a
> lock.  If MythTV only opened one device or the other at a time, we
> could put the lock on the open() call, but since MythTV opens both
> simultaneously even though it may only be using one, we would need a
> much more granular lock.

I don't think a lock would be good for MythTV or any other app that
open()s multiple nodes at once.  How can an app know that it's
dead-locking or barring itself via the kernel driver?

Maybe return an EBUSY or E-something else for these cases when Myth
tries to open() the second device node, when there's an underlying
factor that requires things to be mutually exclusive.  Allowing things
like read() to allow hardware mode switching between analog and digital
seems like it could result in really weird behaviors at the application.

I'll cite a precedent:
ivtv returns EBUSY on open() when there's a conflict with it's various
analog devices nodes that depend on the same underlying hardware: MPG,
YUV, FM Radio, etc.

I note the man page for open() doesn't list EBUSY as a valid errno.
However, the V4L2 API Spec does list EBUSY as a valid errno for V4L2
open().


> Certainly I'm not blaming MythTV for this behavior, but it will make
> the locking much more complicated in some hybrid devices.

I like to blame MythTV for a lot of things. ;)

But in this case I can't.  The driver probably shouldn't hold a lock and
suspend an open() indefinitely (IMO).  It should say the device is BUSY
as that is the truth: an underlying hardware device or resource is busy.


Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
