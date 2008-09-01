Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m81NEl5H010179
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 19:14:48 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m81NEYTP001499
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 19:14:34 -0400
From: Andy Walls <awalls@radix.net>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
In-Reply-To: <1217987207.5252.21.camel@morgan.walls.org>
References: <1217712326.2699.84.camel@morgan.walls.org>
	<489501BB.3070309@hauppauge.com>
	<1217987207.5252.21.camel@morgan.walls.org>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 19:08:48 -0400
Message-Id: <1220310528.2737.49.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: "ivtv-users@ivtvdriver.org" <ivtv-users@ivtvdriver.org>,
	"linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
	"ivtv-devel@ivtvdriver.org" <ivtv-devel@ivtvdriver.org>
Subject: cx18: Testers needed for patch to solve non-working CX23418 cards
	under linux (Re: cx18: Possible causal realtionship for HVR-1600 I2C
	errors)
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

On Tue, 2008-08-05 at 21:47 -0400, Andy Walls wrote:
> > Andy Walls wrote:
> > > Quite a few HVR-1600 users have reported cx18 driver I2C related
> > > problems usually with the following errors present:
> > >
> > >    tveeprom 1-0050: Huh, no eeprom present (err=-121)?
> > >    tveeprom 1-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.
> > >
> > >    s5h1409_readreg: readreg error (ret == -121)
> > >    cx18: frontend initialization failed
> > >    cx18-0: DVB failed to register
> > >
> > > and an unusable HVR-1600/CX23418 under linux.
> > >
> > >
> > > On the surface the problem appeared to be related to the devices on the
> > > I2C buses of the HVR-1600. [...] The I2C bus errors appear to be
> > > just a symptom of a larger underlying problem.


To all the users of CX23418 based cards that currently don't seem to
work, showing some of the above symptoms, please test my latest changes
at:

http://linuxtv.org/hg/~awalls/v4l-dvb

If your card still doesn't work with the default module options, then
try upping the "mmio_ndelay" module parameter by multiples of about 30.3
ns until the card does work:

For example, if the default "mmio_ndelay=31" doesn't work for you, then
use:

# /sbin/modprobe cx18 mmio_ndelay=61

or 91, or 121, or 152, etc. until your card does work.

If you have multiple cx18 cards, and the default doesn't work, then you
will have to specify a value for each card.  For example:

# /sbin/modprobe cx18 mmio_ndelay=61,61,61

for a three card setup.

As always feedback is appreciated.  In this case, I'd especially like to
hear about digital captures, simultaneous analog & digital capture, and
the (in)correctness of the cx18_memcpy_fromio() and cx18_memset_io()
routines.



This patch works for me to get my HVR-1600 and my Raptor PAL/SECAM card
working in my older machine with an Intel 82810E Northbridge and 82801AA
Southbridge.  I have only been able to test analog capture from the
analog tuner and composite 1 input in this setup using 'cat /dev/video0
>foo.mpg' and playing the mpg file on another machine.  (The machine has
no keyboard nor monitor nor apps like mplayer and mythtv).   Things
appear to be working properly.


> To all the cx18 users who
> have patiently provided data at my request on this problem so far, thank
> you.

Thanks, again for helping me resolve this problem.

<hypothesis>
The underlying cause appears to be that the CX23418 can't handle very
rapid memory mapped IO accesses to differing locations under certain
(unknown) conditions.  In the Linux cx18 driver, these rapid MMIO
accesses apparently happened quite often.  In certain modern motherboard
configurations, the PCI bridges apparently were slowing things down or
adding retries so that the CX23418 would actually work for some people.
</hypothesis>

These patches work by adding a short delay (a 10's of ns busy wait)
after *every* access to CX23418 mmio addresses.  If your card already
works fine and these busy waits bother you, then you can get
approximately the previous behavior by setting "mmio_ndelay=0" which
will skip all the calls to ndelay().

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
