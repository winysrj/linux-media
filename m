Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JMl1n-0008Ri-W9
	for linux-dvb@linuxtv.org; Wed, 06 Feb 2008 15:13:32 +0100
Date: Wed, 6 Feb 2008 15:12:55 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: hermann pitton <hermann-pitton@arcor.de>
In-Reply-To: <1202288256.3442.20.camel@pc08.localdom.local>
Message-ID: <Pine.LNX.4.64.0802061512050.15673@pub6.ifh.de>
References: <Pine.LNX.4.64.0801271922040.21518@pub2.ifh.de>
	<479D1632.4010006@t-online.de>
	<Pine.LNX.4.64.0801292211380.23532@pub2.ifh.de>
	<479FB52A.6010401@t-online.de>
	<Pine.LNX.4.64.0801300047520.23532@pub2.ifh.de>
	<47A6438B.3060606@t-online.de> <47A96D0E.1070509@web.de>
	<1202288256.3442.20.camel@pc08.localdom.local>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="579696143-1258326216-1202307175=:15673"
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TDA10086 with Pinnacle 400e tuning broken
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--579696143-1258326216-1202307175=:15673
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by znsun1.ifh.de id m16ECtKY029587

Seeing all that, the fix is easy:

make the 22khz tone generation a field in the tda10086-config-struct and=20
enable it for the 400e and disable it for other (default).

Patrick.

On Wed, 6 Feb 2008, hermann pitton wrote:

> Am Mittwoch, den 06.02.2008, 09:17 +0100 schrieb Andr=E9 Weidemann:
> > Hartmut Hackmann wrote:
> >=20
> > > Are you sure that it is a lnbp21 on your board?
> > > What kind of satellite equipment do you have?
> > > - a single LNB, so the 22kHz tone is enough.
> > > - a Multiswitch?
> > >   if yes, which commands does it need / understand?
> > >   - nothing but the tone?
> > >   - a tone burst to switch between satellites and the tone?
> > >   - full diseqc (2?) serial messages?
> > >=20
> > > I got a board with tda10086 and lnbp21 let and started measuring.
> > > voltage switching and static tone work fine with the current
> > > configuration.
> >=20
> > Hi Hartmut,
> > I got the same tuning problems as Patrick. After your patch the Pinna=
cle=20
> > 400e is not working anymore. I can get a signal, but no lock at all.
> > I took a look at the PCB and there is definitely an LNBP21PD soldered=
=20
> > onto it.
> > Your patch disables the modulation of the 22kHz signal inside the dem=
od=20
> > as fas as I understood, but then the LNBP21PD was supposed to generat=
e it.
> >=20
> > Unfortunately this is not possible with the Pinnacle 400e. I took a l=
ook=20
> > at the LNBP21PD datasheet which states, that DSQIN is supposed to be=20
> > connected to GND if you don't want the 22kHz signal to be generated b=
y=20
> > the LNBP21 itself. Guess what?! Pin 14(DSQIN) is connected to GND.
> >=20
> > For the time being I reverted your patch on my local system and the=20
> > Pinnacle 400e is working flawlessly again.
> >=20
> >   Andr=E9
> >=20
>=20
>=20
> Hi,
>=20
> we should try to get this sorted.
>=20
> With the prior state, working for Andre and others, it does not work on
> the LifeView Trio (PCI and cardbus) and the saa7134 driver. Three guys =
I
> think reported it and Hartmut did wait with the patch for long and
> allowed about half a year for testing ...
>=20
> So, if we can't fix it soon, prior state of course counts and those
> later will have to use the patches further. Such a "fix" can always be
> committed prior to 2.6.25 release.
>=20
> Hermann
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>=20
--579696143-1258326216-1202307175=:15673
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--579696143-1258326216-1202307175=:15673--
