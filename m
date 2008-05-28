Return-path: <video4linux-list-bounces@redhat.com>
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0805271947h23f71911vb8f13c76ffb7c6d2@mail.gmail.com>
References: <20080522223700.2f103a14@core>
	<20080527094144.1189826a@bike.lwn.net>
	<20080527133100.6a9302fb@gaivota>
	<20080527103755.1fd67ec1@bike.lwn.net>
	<20080527155942.7693c360@gaivota>
	<412bdbff0805271226t41fe55b0jd0b8e3c737f34734@mail.gmail.com>
	<20080527180048.6a27dbf7@gaivota>
	<1211932138.3197.29.camel@palomino.walls.org>
	<412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com>
	<1211942221.3197.154.camel@palomino.walls.org>
	<412bdbff0805271947h23f71911vb8f13c76ffb7c6d2@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 28 May 2008 19:30:08 -0400
Message-Id: <1212017408.4428.37.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
	Jonathan Corbet <corbet@lwn.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Tue, 2008-05-27 at 22:47 -0400, Devin Heitmueller wrote:
> > Maybe return an EBUSY or E-something else for these cases when Myth
> > tries to open() the second device node, when there's an underlying
> > factor that requires things to be mutually exclusive.  Allowing things
> > like read() to allow hardware mode switching between analog and digital
> > seems like it could result in really weird behaviors at the application.
> 
> Pardon me for not being clear.  I wasn't suggesting having a mutex for
> on the open call itself. 

Devin,

My apologies, I didn't quite understand what you meant.


>  The mutex we have in the em28xx driver is
> only in place when we are *switching* between modes. 

I took a look at the em28xx driver, and I see what you mean.


>  The thinking was
> to have open return EBUSY if the device is already in use in the other
> mode, but we weren't sure if that would cause problems with MythTV
> (since the open call would fail)  If MythTV can gracefully handle that
> scenario, then that would be the ideal solution from a driver
> perspective.

MythTV's backend can handle it, but the user experience with the
frontend is "suboptimal".  


What follows probably belongs on a MythTV list really, but it may help
you make design and specification decisions.

In the case where the cx18 driver normally allows the two sides of the
card to be treated independently, we had a bug actually enforcing mutual
exclusion upon an ioctl(), if the DVB side of the card was opened before
the analog side.  Here's what showed up in the mythbackend log (noting
that MythTV was told the analog side of the cx18 supported HVR-1600 was
an ivtv supported PVR-xx0 card) :


2008-05-12 14:21:16.358 TVRec(5): Changing from None to WatchingLiveTV
2008-05-12 14:21:16.361 TVRec(5): HW Tuner: 5->5
2008-05-12 14:21:17.586 

Not ivtv driver??


2008-05-12 14:21:17.592 AutoExpire: CalcParams(): Max required Free Space: 31.0 GB w/freq: 15 min
2008-05-12 14:21:17.600 MPEGRec(/dev/video1) Error: Error setting format
                        eno: Device or resource busy (16)
2008-05-12 14:21:36.656 AutoExpire: CalcParams(): Max required Free Space: 31.0 GB w/freq: 15 min
2008-05-12 14:22:04.112 TVRec(5): Changing from WatchingLiveTV to None

  
MythTV saw the EBUSY and then proceeded to hang around for about 30
seconds before giving up.  The user experience is a fairly
non-responsive black screen on the MythTV frontend with no error
indications, returning to the main menu when the 30 second timeout
finally occurs.


So even if MythTV isn't informed about mutually exclusive conditions, it
will try to operate and then give up. But MythTV won't crash or cease to
try and run scheduled events.

I have noticed that MythTV never holds the V4L2 device nodes open,
unless it's actively trying to capture something.

I have also noticed that MythTV will hold the DVB frontend0 node open
for quite a long while when nothing else is going on.  I suspect this is
due to:

a. me configuring MythTV to use the DVB side of the card to pull EPG
data from the broadcasts even when no MythTV frontend nor scheduled
capture is running, and

b. no lock or EPG data is available from some channel


So MythTV is robust enough to handle EBUSY returns, but could use some
improvement on the MythTV frontend application.  Also, MythTV could
stand to have some settings for the user to indicate mutually exclusive
actions due to underlying hardware.

I think a bad thing for a driver to do is to not return an error code,
and let MythTV go into it's event loop, giving the user a "black screen
forever" and a log file full of select() timeout messages because no
data is available for read().  (We had a cx18 driver bug that gave us
those symptoms too!)


I hope that helps.

-Andy



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
