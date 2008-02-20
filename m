Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp23.orange.fr ([80.12.242.97])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.bercot@wanadoo.fr>) id 1JRrqr-0004tb-UF
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 17:31:22 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2361.orange.fr (SMTP Server) with ESMTP id 2ADD870000A5
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 17:30:48 +0100 (CET)
Received: from localhost (ANantes-252-1-77-76.w86-195.abo.wanadoo.fr
	[86.195.216.76])
	by mwinf2361.orange.fr (SMTP Server) with ESMTP id 85497700009A
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 17:30:47 +0100 (CET)
Date: Wed, 20 Feb 2008 17:30:45 +0100
From: David BERCOT <david.bercot@wanadoo.fr>
To: linux-dvb@linuxtv.org
Message-ID: <20080220173045.0cd4a51d@wanadoo.fr>
Mime-Version: 1.0
Subject: [linux-dvb] Any idea about my CI error ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2070575201=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2070575201==
Content-Type: multipart/signed; boundary="Sig_/.VLhbTk=pgxHG+tMeNnRGRv";
 protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/.VLhbTk=pgxHG+tMeNnRGRv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

For my S2-3200, I've done :
# modprobe dvb-core cam_debug=3D255 [thank you Manu ;-)]
# modprobe stb6100
# modprobe stb0899
# modprobe lnbp21
# modprobe budget-c

and I have some more information about my CI :
saa7146: register extension 'budget_ci dvb'.
ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 22 (level, low) -> IRQ 22
saa7146: found saa7146 @ mem ffffc20001046c00 (revision 1, irq 22)
(0x13c2,0x1019). saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget S2-3200 PCI)
adapter has MAC addr =3D 00:d0:5c:0b:a5:8b
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9
dvb_ca_en50221_init
budget_ci: CI interface initialised
CAMCHANGE IRQ slot:0 change_type:1
dvb_ca_en50221_thread_wakeup
dvb_ca_en50221_thread
stb0899_write_regs [0xf1b6]: 02
stb0899_write_regs [0xf1c2]: 00
stb0899_write_regs [0xf1c3]: 00
_stb0899_read_reg: Reg=3D[0xf000], data=3D81
stb0899_get_dev_id: ID reg=3D[0x81]
stb0899_get_dev_id: Device ID=3D[8], Release=3D[1]
_stb0899_read_s2reg Device=3D[0xf3fc], Base address=3D[0x00000400],
Offset=3D[0xf334], Data=3D[0x444d4431]
_stb0899_read_s2reg Device=3D[0xf3fc], Base address=3D[0x00000400],
Offset=3D[0xf33c], Data=3D[0x00000001] stb0899_get_dev_id: Demodulator Core
ID=3D[DMD1], Version=3D[1]
_stb0899_read_s2reg Device=3D[0xfafc], Base address=3D[0x00000800],
Offset=3D[0xfa2c], Data=3D[0x46454331]
_stb0899_read_s2reg Device=3D[0xfafc], Base address=3D[0x00000800],
Offset=3D[0xfa34], Data=3D[0x00000001] stb0899_get_dev_id: FEC Core
ID=3D[FEC1], Version=3D[1]
stb0899_attach: Attaching STB0899
stb6100_attach: Attaching STB6100
DVB: registering frontend 0 (STB0899 Multistandard)...
dvb_ca adaptor 0: PC card did not respond :(

Does anyone have an idea about this error ?

Thank you.

David.

--Sig_/.VLhbTk=pgxHG+tMeNnRGRv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvFW1vSnthbGI8ygRAqENAJ9PIGz+N1AY+JA00SwiN/ZF7CZqFgCdGWHJ
wp4uVYOVxDA0LvAy34Bu4WQ=
=ta/J
-----END PGP SIGNATURE-----

--Sig_/.VLhbTk=pgxHG+tMeNnRGRv--



--===============2070575201==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2070575201==--
