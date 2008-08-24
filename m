Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7ONTYoq032111
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 19:29:34 -0400
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7ONSrPZ022135
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 19:28:53 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>
In-Reply-To: <d9def9db0808240708p7fa3c012q57408d09db090a13@mail.gmail.com>
References: <20080824152931.hbojr7or58oggosc@webmail.versatel.nl>
	<d9def9db0808240708p7fa3c012q57408d09db090a13@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 01:27:50 +0200
Message-Id: <1219620470.11522.38.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Low profile TV card
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

Hi,

Am Sonntag, den 24.08.2008, 16:08 +0200 schrieb Markus Rechberger:
> On Sun, Aug 24, 2008 at 3:29 PM,  <hansfong@zonnet.nl> wrote:
> > I'm building a new system with a barebone AOpen/Intel Atom PC.  Problem is
> > that is can only fit one low profile PCI card. My 8 year old Pinnacle PCTV
> > pro doesn't fit, so....
> >
> 
> ever thought about USB solutions? My impression is since they aren't
> directly connected with the motherboard and not influenced by the
> electronic fields in the PC the quality is usually better with a lower
> signal strength. I have an Asus DigiMatrix with Saa7134 and clearly
> notice that a stronger signal is required.
> 
> Do you mean PCI or miniPCI with low profile PCI card?
> 
> Markus
> 
> > - what low profile PCI TV cards are out there that work well with Linux? I
> > need a simple analog card with composite and s-video inputs. Alternatively a
> > video capture card will fit the bill too.
> > - the latest line of Pinnacle cards seem low profile, but... I can't find
> > any info on a) if they are really low profile cards and come with the
> > appropriate bracket, b) the chipset they use . Does anyone know?
> >
> > Cheers,
> >
> > Hans
> >

latest lines of PCI cards are all low profile,

but we still don't even get a rule for not to top post implemented, or
do it the other way round ... (how many posts about USB disconnects
during the last years ?)

For what I remember from hacking them, the miniature LG tuners on the
Asus DigiMatrix are for sure no reference for the saa713x and that stuff
is really old now, but was very new once ...

It makes also a difference if you are using a recent machine or some
older stuff concerning internal interferences.

But much bigger is what you see with different tuner types and after
that still of what is caused by the PCB layout/shielding.

The cheaper tuners around use years old European and American chips and
they try also with there own SAW Filters, but are not there yet.

On a low profile card you will have silicon tuners and demodulators
anyway, so can't even fall back to latest known good can tuners.

The Philips tda8275a can compete with them, if on the right card.

Since you need only Composite and S-Video (how that thes days ;) buy the
cheapest used and oldest Asus low profile PCI card you can get on some
auction and you should be fine, might even have a remote.

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
