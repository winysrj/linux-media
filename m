Return-path: <video4linux-list-bounces@redhat.com>
Date: Wed, 28 May 2008 04:34:13 -0400
From: Alan Cox <alan@redhat.com>
To: Andy Walls <awalls@radix.net>
Message-ID: <20080528083413.GB30339@devserv.devel.redhat.com>
References: <20080527101039.1c0a3804@gaivota>
	<20080527094144.1189826a@bike.lwn.net>
	<20080527133100.6a9302fb@gaivota>
	<20080527103755.1fd67ec1@bike.lwn.net>
	<20080527155942.7693c360@gaivota>
	<412bdbff0805271226t41fe55b0jd0b8e3c737f34734@mail.gmail.com>
	<20080527180048.6a27dbf7@gaivota>
	<1211932138.3197.29.camel@palomino.walls.org>
	<412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com>
	<1211942221.3197.154.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211942221.3197.154.camel@palomino.walls.org>
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

On Tue, May 27, 2008 at 10:37:01PM -0400, Andy Walls wrote:
> I note the man page for open() doesn't list EBUSY as a valid errno.
> However, the V4L2 API Spec does list EBUSY as a valid errno for V4L2
> open().

The posix spec doesn't limit the errors returnable this way - it says if
the error is one of the ones listed it must return the error code stated so
EBUSY is just fine.

> But in this case I can't.  The driver probably shouldn't hold a lock and
> suspend an open() indefinitely (IMO).  It should say the device is BUSY

Agreed - especially if it is opened with O_NDELAY

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
