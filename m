Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1LC1Ww-0007BB-TF
	for linux-dvb@linuxtv.org; Mon, 15 Dec 2008 01:41:51 +0100
Date: Mon, 15 Dec 2008 01:41:17 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <36739.62.178.208.71.1229299109.squirrel@webmail.dark-green.com>
Message-ID: <20081215004117.158530@gmx.net>
MIME-Version: 1.0
References: <4943A606.5060502@cadsoft.de>
	<200812141302.47851@orion.escape-edv.de>
	<52355.62.178.208.71.1229260499.squirrel@webmail.dark-green.com>
	<20081214232918.158520@gmx.net>
	<36739.62.178.208.71.1229299109.squirrel@webmail.dark-green.com>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy S2 PCI HD S2API ( Liplianin's tree
	)	fixes
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

> >> Hi,
> >>
> >> attached there are 2 patches. One which corrects MANTIS_VP_1041_DVB_S2
> >
> > No, MANTIS_VP_1041_DVB_S2 =3D 0x0031 was correct already for the Azurew=
ave
> > AD-SP400
> > so your first patch breaks the driver for that card. You need to create
> > another define for the
> > Terratec Cinergy S2 because it has a different subsystem id.
> >
> Hi,
> =

> sorry to break it. Attached is a corrected patch which adds support
> for the Terratec card and corrects MANTIS_VP_1041_DVB_S2.
> =

> cu
> =

> Edgar (gimli) Hucek

Thanks for the quick update. That's better -- I checked and it works again =
with
the Azurewave AD-SP400.
Hans
-- =

Release early, release often.

Sensationsangebot verl=E4ngert: GMX FreeDSL - Telefonanschluss + DSL =

f=FCr nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K1308T4569a

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
