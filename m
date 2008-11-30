Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nskntmtas06p.mx.bigpond.com ([61.9.168.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhhummel@bigpond.com>) id 1L6cUh-0008GB-10
	for linux-dvb@linuxtv.org; Sun, 30 Nov 2008 03:57:13 +0100
From: Jonathan <jhhummel@bigpond.com>
To: Mirek =?iso-8859-2?q?Sluge=F2?= <thunder.m@email.cz>
Date: Sun, 30 Nov 2008 13:56:33 +1100
References: <4675AD3E.3090608@email.cz>
	<200811292353.00677.jhhummel@bigpond.com>
	<493151F9.2040904@email.cz>
In-Reply-To: <493151F9.2040904@email.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811301356.33461.jhhummel@bigpond.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Patch for Leadtek DTV1800H, DTV2000H (rev I, J),
	and (not working yet) DTV2000H Plus
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Yea I did, I even checked it by plugging the cable into the cd, and then =

recording within the radio programme, successfully. Which basically narrowe=
d =

it down to the TV card in some capacity. The last update to this card didn'=
t =

support PAL terribly well.

cheers

Jon


On Sun, 30 Nov 2008 01:30:17 am Mirek Sluge=F2 wrote:
> Hi, you should connect internal cable from your TV card to your sound
> card, or use "arecord -D hw:1 -f dat 2>/dev/null | aplay -f dat
> 2>/dev/null"
>
> Mirek
>
> Jonathan napsal(a):
> > On Fri, 28 Nov 2008 10:45:44 pm Mirek Sluge=F2 wrote:
> >> Hi, all 3 patches are in one file, they depend on each other.
> >>
> >> All GPIOs spoted from Windows with original APs
> >>
> >> DTV1800H - there is patch pending in this thread from Miroslav Sustek,
> >> this is only modification of his patch, difference should be only in
> >> GPIOs (I think it is better to use GPIOs from Windows).
> >>
> >> DTV2000H (rev. I) - Only renamed from original old DTV2000H
> >>
> >> DTV2000H (rev. J) - Almost everything is working, I have problem only
> >> with FM radio (no sound).
> >>
> >> DTV2000H Plus - added pci id, GPIOs, sadly Tuner is XC4000, so it is n=
ot
> >> working yet.
> >>
> >> Mirek Slugen
> >
> > Hi Mirek,
> >
> > Nice work with the patch!
> >
> > I gave it a go and found that I still can't get sound for analogue TV a=
nd
> > radio.
> > I have a DTV2000H rev J
> > Tried:
> >  - KdeTV
> >  - TVtime
> >  - Gnome radio
> >
> > I'm in Australia with PAL format TV
> >
> > Attached is the dmesg output
> >
> > What ya think?
> >
> > Jon
> >
> >
> > ------------------------------------------------------------------------
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
