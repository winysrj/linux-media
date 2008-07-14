Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6EJL6lY009984
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 15:21:06 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6EJKn3E023817
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 15:20:50 -0400
Received: by ug-out-1314.google.com with SMTP id s2so293025uge.6
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 12:20:49 -0700 (PDT)
Date: Mon, 14 Jul 2008 21:21:02 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Message-ID: <20080714192102.GA1487@ska.dandreoli.com>
References: <200807101914.10174.mb@bu3sch.de> <200807141558.29582.mb@bu3sch.de>
	<20080714152550.GA32470@ska.dandreoli.com>
	<200807141951.39810.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807141951.39810.mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
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

On Mon, Jul 14, 2008 at 07:51:39PM +0200, Michael Buesch wrote:
> On Monday 14 July 2008 17:25:50 Domenico Andreoli wrote:
> > On Mon, Jul 14, 2008 at 03:58:29PM +0200, Michael Buesch wrote:
> > > On Monday 14 July 2008 09:27:33 Domenico Andreoli wrote:
> > > > +static u32 nr_to_mask(struct bttv_gpiolib_device *dev, unsigned nr)
> > > > +{
> > > > +	u32 io_mask = dev->in_mask | dev->out_mask;
> > > > +	int shift = 0;
> > > > +
> > > > +	while(io_mask && nr) {
> > > > +		nr -= io_mask & 1;
> > > > +		io_mask >>= 1;
> > > > +		shift++;
> > > > +	}
> > > > +
> > > > +	return 1 << shift;
> > > > +}
> > > 
> > > This loop is really really weird.
> > > What the hell are you doing here?
> > > You ususally convert GPIO numbers to masks by doing (1 << nr), only.
> > 
> > gpiolib does not allow holes in the number space of gpios. once you
> > set chip.ngpio, you get a contiguous slice.
> > 
> > should the board have some of its gpio connected to something private,
> > they are not to be exported to gpiolib and to the user.
> > 
> > indeed once, as a user, I know to have a board which has n inputs and
> > m output and z in/out, that's all, I do not want to know how many GPIOs
> > actually are on the board and how are connected.
> > 
> > nr_to_mask() hides those holes to the user, it maps a pin iff it is
> > available for gpiolib fiddling.
> 
> Ok, I see. However, I'd suggest to implement this with a lookup table
> rather than this weird loop.

yes, of course. it was never meant to be definitive, all the patch was
a prototype. thanks for the support.

cheers,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
