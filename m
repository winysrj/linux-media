Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp28.orange.fr ([80.12.242.100])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.bercot@wanadoo.fr>) id 1JWB4m-0007g1-Po
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 14:51:35 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2813.orange.fr (SMTP Server) with ESMTP id 145CF70000B3
	for <linux-dvb@linuxtv.org>; Mon,  3 Mar 2008 14:50:59 +0100 (CET)
Received: from localhost (ANantes-252-1-38-218.w82-126.abo.wanadoo.fr
	[82.126.25.218])
	by mwinf2813.orange.fr (SMTP Server) with ESMTP id CF6967000097
	for <linux-dvb@linuxtv.org>; Mon,  3 Mar 2008 14:50:57 +0100 (CET)
Date: Mon, 3 Mar 2008 14:50:54 +0100
From: David BERCOT <david.bercot@wanadoo.fr>
To: linux-dvb@linuxtv.org
Message-ID: <20080303145054.1ecda583@wanadoo.fr>
Mime-Version: 1.0
Subject: [linux-dvb] Is my CI broken ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0459217407=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0459217407==
Content-Type: multipart/signed; boundary="Sig_/j7crR6bkbkD.VYkGmY7hMaR";
 protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/j7crR6bkbkD.VYkGmY7hMaR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

Before buying a new CI for my TT S2-3200, I'd like to know if it is
really broken...

After the installation of multiproto, I have this error :
saa7146: register extension 'budget_ci dvb'.
ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 22 (level, low) -> IRQ 22
saa7146: found saa7146 @ mem ffffc20001046c00 (revision 1, irq 22) (0x13c2,=
0x1019).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget S2-3200 PCI)
adapter has MAC addr =3D 00:d0:5c:0b:a5:8b
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9
dvb_ca_en50221_init
budget_ci: CI interface initialised
CAMCHANGE IRQ slot:0 change_type:1
dvb_ca_en50221_thread_wakeup
dvb_ca_en50221_thread
...stb0899...
stb0899_attach: Attaching STB0899
stb6100_attach: Attaching STB6100
DVB: registering frontend 0 (STB0899 Multistandard)...
dvb_ca adaptor 0: PC card did not respond :(

Do you think I have to change my CI or is it an installation error ?

Thank you very much.

David.

--Sig_/j7crR6bkbkD.VYkGmY7hMaR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzAI+vSnthbGI8ygRArT1AJ4l5sJg8G58zYT/sZJWexfIpgufiwCcCL06
rMxSPOHo4KK3EfggtKgcPqE=
=sGPL
-----END PGP SIGNATURE-----

--Sig_/j7crR6bkbkD.VYkGmY7hMaR--



--===============0459217407==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0459217407==--
