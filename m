Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7R2KjCQ001098
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 22:20:45 -0400
Received: from mail8.sea5.speakeasy.net (mail8.sea5.speakeasy.net
	[69.17.117.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7R2KXgM024717
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 22:20:33 -0400
Date: Tue, 26 Aug 2008 19:20:27 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
In-Reply-To: <20080826232913.GA2145@daniel.bse>
Message-ID: <Pine.LNX.4.58.0808261911000.2423@shell2.speakeasy.net>
References: <200808251445.22005.jdelvare@suse.de>
	<1219711251.2796.47.camel@morgan.walls.org>
	<20080826232913.GA2145@daniel.bse>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Jean Delvare <jdelvare@suse.de>
Subject: Re: [v4l-dvb-maintainer] bttv driver questions
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

On Wed, 27 Aug 2008, Daniel [iso-8859-1] Glöckner wrote:
> On Mon, Aug 25, 2008 at 08:40:51PM -0400, Andy Walls wrote:
> > On Mon, 2008-08-25 at 14:45 +0200, Jean Delvare wrote:
> > > * Does the bttv driver have anything special to do for full
> > >   resolution frames, that it doesn't have to do for half resolution
> > >   ones? In particular, I wonder if the BT878 DMA engine knows how to
> > >   interlace fields when writing to the memory, or if the bttv driver
> > >   must take care of reordering the fields properly afterwards. I
> > >   suspect the latter.
>
> The driver fills buffers with instructions for the DMA engine, one buffer
> for the top field and one for the bottom field. These instructions tell
> the engine where to write a specific pixel. For interlaced video the
> instructions for the top field write to line 0, 2, 4, ... in memory and for
> the bottom field to line 1, 3, 5, ... .

Keep in mind that _either_ field can be transmitted first.  I.e., in some
cases one first writes lines 1,3,5 then lines 0,2,4.  I'm not sure if bttv
supports both field dominances or not, but I think it does.

> > So with a BT878 latency timer of 32 cycles, a 128 byte burst could be
> > sent as 2 transactions, assuming a maximum target setup time for the
> > host bridge, with a transfer that doesn't hit a modified cache line,
> > assuming transparent arbitration:
> >
> I think worst case for slow targets is more like
>
> 1 addr cycle
> 15 setup cycles (unsure if initial latency includes addr cycle...)
> 1 data cycle
> 7 setup cycles
> 1 data cycle
> 7 setup cycles <-- latency timer of 32 expires, assuming GNT# is deasserted

Isn't the latency timer in units of 250 ns, not PCI cycles?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
