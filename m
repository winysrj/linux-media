Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp27.orange.fr ([80.12.242.96])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1Kexsi-0002gE-MD
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 22:07:42 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2716.orange.fr (SMTP Server) with ESMTP id 44AD01C0008C
	for <linux-dvb@linuxtv.org>; Sun, 14 Sep 2008 22:07:07 +0200 (CEST)
Received: from stratocaster.lan (ANantes-256-1-171-44.w90-25.abo.wanadoo.fr
	[90.25.242.44])
	by mwinf2716.orange.fr (SMTP Server) with ESMTP id 023C61C000A6
	for <linux-dvb@linuxtv.org>; Sun, 14 Sep 2008 22:07:07 +0200 (CEST)
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Sun, 14 Sep 2008 22:08:04 +0200
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48CD43C1.2090902@linuxtv.org> <48CD5D19.1070700@gmail.com>
In-Reply-To: <48CD5D19.1070700@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809142208.04494.hftom@free.fr>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le Sunday 14 September 2008 20:51:05 Manu Abraham, vous avez =E9crit=A0:
> Steven Toth wrote:
> > Markus Rechberger wrote:
> >> On Sun, Sep 14, 2008 at 1:31 AM, Manu Abraham <abraham.manu@gmail.com>
> >>
> >> wrote:
> >>> Markus Rechberger wrote:
> >>>> On Sun, Sep 14, 2008 at 12:46 AM, Manu Abraham
> >>>>
> >>>> <abraham.manu@gmail.com> wrote:
> >>>>> Markus Rechberger wrote:
> >>>>>> How many devices are currently supported by the multiproto API
> >>>>>> compared with the s2 tree?
> >>>>>
> >>>>> The initial set of DVB-S2 multistandard devices supported by the
> >>>>> multiproto tree is follows. This is just the stb0899 based dvb-s2
> >>>>> driver
> >>>>> alone. There are more additions by 2 more modules (not devices),
> >>>>> but for
> >>>>> the simple comparison here is the quick list of them, for which
> >>>>> some of
> >>>>> the manufacturers have shown support in some way. (There has been
> >>>>> quite
> >>>>> some contributions from the community as well.):
> >>>>>
> >>>>> (Also to be noted is that, some BSD chaps also have shown interest =
in
> >>>>> the same)
> >>>>
> >>>> they're heavy into moving the whole framework over as far as I've se=
en
> >>>> yes, also including yet unmerged drivers.
> >>>
> >>> Using the same interface, the same applications will work there as we=
ll
> >>> which is a bonus, but isn't the existing user interface GPL ? (A bit
> >>> confused on that aspect)
> >>>
> >>>>> * STB0899 based
> >>>>>
> >>>>> Anubis
> >>>>> Typhoon DVB-S2 PCI
> >>>>>
> >>>>> Azurewave/Twinhan
> >>>>> VP-1041
> >>>>> VP-7050
> >>>>>
> >>>>> Digital Now
> >>>>> AD SP400
> >>>>> AD SB300
> >>>>>
> >>>>> KNC1
> >>>>> TV Station DVB-S2
> >>>>> TV Station DVB-S2 Plus
> >>>>>
> >>>>> Pinnacle
> >>>>> PCTV Sat HDTV Pro USB 452e
> >>>>>
> >>>>> Satelco
> >>>>> TV Station DVB-S2
> >>>>> Easywatch HDTV USB CI
> >>>>> Easywatch HDTV PCI
> >>>>>
> >>>>> Technisat
> >>>>> Skystar HD
> >>>>> Skystar HD2
> >>>>> Skystar USB2 HDCI
> >>>>>
> >>>>> Technotrend
> >>>>> TT S2 3200
> >>>>> TT S2 3600
> >>>>> TT S2 3650
> >>>>>
> >>>>> Terratec
> >>>>> Cinergy S2 PCI HD
> >>>>> Cinergy S2 PCI HDCI
> >>>>
> >>>> those are pullable now against the current tree?
> >>>
> >>> These devices, depend upon the DVB API update without which it wouldn=
't
> >>> work as they depend heavily on the DVB API framework. Without the
> >>> updated framework, it doesn't make any sense to pull them: they won't
> >>> even compile. The last but not least reason is that, the stb0899 driv=
er
> >>> is a DVB-S2 multistandard device which requires DVB-S2/DSS support
> >>> additionally.
> >>
> >> so the framework is available, and the drivers could be pushed in
> >> right afterwards, I wonder
> >> who is willing to port those drivers to the other API (including
> >> testing).
> >
> > Me. I'll port the 3200 cards and their derivatives, including the 6100
> > and the 0899. I've already said I'd do that.... but it's manu's code and
> > he retains all rights. He gets to decide first.
>
> The STB0899 based devices are much different from the crappy handicapped
> Hauppauge S2 cards and hence the API that you work upon is quite limited
> to what you see with regards to the Hauppauge (CX24116 based) cards.
>
> Even the bare specifications from Conexant point to a handicapped DVB-S2
> demodulator.
>
> Attempts to do so, will break those devices at least for most of the
> features and more yet to come. The DVB-S2 transport is a bit more
> advanced delivery system than what your API based on the CX24116
> demodulator.
>
> At least it will be great for Hauppauge as you can point to people that
> Hauppauge hardware is much better, for the marketing aspects as you have
> done in the past on IRC lists.
>
> Very good marketing strategy, Steven keep it up, you have earned more
> sales for the Hauppauge cards ...
> <claps hands>
>
> >> It's not going to happen any time soon I guess, if there's not an
> >> agreement with Manu's
> >> work. Dumping this code would show another step of ignorance and
> >> selfishness against the
> >> people who worked on it.
> >
> > The demod/tuners drivers would be merged with S2API within a few days. I
> > have a TT-3200 here. I'd have to re-write various things, and change the
> > demod API a little. but I'm prepared to do that.
>
> Just having a TT 3200 won't help working on the STB0899. Almost everyone
> who has a STB0899 based knows that, except you.
>
> No need for you to break the compliant devices in favour of your
> mediocre cards. As i wrote just above, the STB0899 is not the only one
> device using the said features. Also i can guarantee that the CX24116
> (HVR4000) is the most handicapped DVB-S2 device that you are basing the
> DVB-S2 API on: and i can guarantee that what you do will be just be
> broken as you have done for other devices in the past.
>
> Also i do not understand, why you have to make a lot of noise to port
> the STB0899 drivers to your crap, when all your cards work as expected
> by you with the multiproto tree. I don't see any reason why the STB0899
> has to be ported to the handicapped API of yours, handicapping the
> STB0899 based devices.

Sounds like Sarah "pitbull" Palin's sentences :)


-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
