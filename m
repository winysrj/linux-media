Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2f.orange.fr ([80.12.242.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.bercot@wanadoo.fr>) id 1JWSPk-0004bn-5C
	for linux-dvb@linuxtv.org; Tue, 04 Mar 2008 09:22:20 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2f03.orange.fr (SMTP Server) with ESMTP id 77E29700008E
	for <linux-dvb@linuxtv.org>; Tue,  4 Mar 2008 09:21:46 +0100 (CET)
Received: from localhost (ANantes-252-1-38-218.w82-126.abo.wanadoo.fr
	[82.126.25.218])
	by mwinf2f03.orange.fr (SMTP Server) with ESMTP id B318E7000090
	for <linux-dvb@linuxtv.org>; Tue,  4 Mar 2008 09:21:45 +0100 (CET)
Date: Tue, 4 Mar 2008 09:21:36 +0100
From: David BERCOT <david.bercot@wanadoo.fr>
To: linux-dvb@linuxtv.org
Message-ID: <20080304092136.676f51bd@wanadoo.fr>
In-Reply-To: <47CC57A9.3060403@gmail.com>
References: <20080303145054.1ecda583@wanadoo.fr> <47CC57A9.3060403@gmail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Is my CI broken ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0331068575=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0331068575==
Content-Type: multipart/signed; boundary="Sig_/HRehRjx8gmGKyg.VeSWiqOp";
 protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/HRehRjx8gmGKyg.VeSWiqOp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Mon, 03 Mar 2008 23:55:21 +0400,
Manu Abraham <abraham.manu@gmail.com> a =C3=A9crit :
> David BERCOT wrote:
> > Hi,
> >=20
> > Before buying a new CI for my TT S2-3200, I'd like to know if it is
> > really broken...
> >=20
> > After the installation of multiproto, I have this error :
> > saa7146: register extension 'budget_ci dvb'.
> > ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 22 (level, low) -> IRQ 22
> > saa7146: found saa7146 @ mem ffffc20001046c00 (revision 1, irq 22)
> > (0x13c2,0x1019). saa7146 (0): dma buffer size 192512
> > DVB: registering new adapter (TT-Budget S2-3200 PCI)
> > adapter has MAC addr =3D 00:d0:5c:0b:a5:8b
> > input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9
> > dvb_ca_en50221_init
> > budget_ci: CI interface initialised
> > CAMCHANGE IRQ slot:0 change_type:1
> > dvb_ca_en50221_thread_wakeup
> > dvb_ca_en50221_thread
> > ...stb0899...
> > stb0899_attach: Attaching STB0899
> > stb6100_attach: Attaching STB6100
> > DVB: registering frontend 0 (STB0899 Multistandard)...
> > dvb_ca adaptor 0: PC card did not respond :(
> >=20
> > Do you think I have to change my CI or is it an installation error ?
>=20
> Just check whether it is the cable before going in for a new
> daughterboard.

Well, yesterday, I've removed the card and the CI from my computer,
I've looked at them and I've put them back : same result :-(
I'll do another try and remove the cable...

Thank you for your advice...

David.

--Sig_/HRehRjx8gmGKyg.VeSWiqOp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzQaXvSnthbGI8ygRAv3zAJ0Zbi6w/BTEdGiodRkz7o/dlCcgLwCdECxP
KKmE4XvmMWF00efrYVc0aQA=
=XknF
-----END PGP SIGNATURE-----

--Sig_/HRehRjx8gmGKyg.VeSWiqOp--



--===============0331068575==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0331068575==--
