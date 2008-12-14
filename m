Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1LC0PI-00024c-EX
	for linux-dvb@linuxtv.org; Mon, 15 Dec 2008 00:29:53 +0100
Date: Mon, 15 Dec 2008 00:29:18 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <52355.62.178.208.71.1229260499.squirrel@webmail.dark-green.com>
Message-ID: <20081214232918.158520@gmx.net>
MIME-Version: 1.0
References: <4943A606.5060502@cadsoft.de>
	<200812141302.47851@orion.escape-edv.de>
	<52355.62.178.208.71.1229260499.squirrel@webmail.dark-green.com>
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

> Hi,
> =

> attached there are 2 patches. One which corrects MANTIS_VP_1041_DVB_S2 =


No, MANTIS_VP_1041_DVB_S2 =3D 0x0031 was correct already for the Azurewave =
AD-SP400
so your first patch breaks the driver for that card. You need to create ano=
ther define for the
Terratec Cinergy S2 because it has a different subsystem id.

> and
> the second one solves the following bug :
> =

.....
> =

> Both patches are taken from Manu Abraham's multiproto mantis tree and just
> aplied to Igor Liplianin's S2API tree.

The second one only I think.

> =

> mfg
> =

> Edgar (gimli) Hucek

Hans
-- =

Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
