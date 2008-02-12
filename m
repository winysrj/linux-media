Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp20.orange.fr ([193.252.22.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.bercot@wanadoo.fr>) id 1JOubP-0004es-FJ
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 13:51:11 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2023.orange.fr (SMTP Server) with ESMTP id C31341C00092
	for <linux-dvb@linuxtv.org>; Tue, 12 Feb 2008 13:50:40 +0100 (CET)
Received: from localhost (ANantes-252-1-1-185.w82-126.abo.wanadoo.fr
	[82.126.0.185])
	by mwinf2023.orange.fr (SMTP Server) with ESMTP id 6AD8C1C0008D
	for <linux-dvb@linuxtv.org>; Tue, 12 Feb 2008 13:50:40 +0100 (CET)
Date: Tue, 12 Feb 2008 13:50:37 +0100
From: David BERCOT <david.bercot@wanadoo.fr>
To: linux-dvb@linuxtv.org
Message-ID: <20080212135037.2dde5349@wanadoo.fr>
In-Reply-To: <A33C77E06C9E924F8E6D796CA3D635D102396F@w2k3sbs.glcdomain.local>
References: <A33C77E06C9E924F8E6D796CA3D635D102396F@w2k3sbs.glcdomain.local>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Has anyone got multiproto and TT3200 to work
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0781219735=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0781219735==
Content-Type: multipart/signed; boundary="Sig_/2HZmAUBsbo8LRzXYqvIMWhV";
 protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/2HZmAUBsbo8LRzXYqvIMWhV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le Mon, 11 Feb 2008 20:27:24 -0000,
"Michael Curtis" <michael.curtis@glcweb.co.uk> a =C3=A9crit :
> If so please let me know because I am having serious issues and really
> do not know how to proceed

I'm probably more beginner than you, but, if I can help...

So, I've wrote a little documentation for me (including errors) :
DRIVER
# mkdir /opt/dvb
# cd /opt/dvb
# apt-get install mercurial
# hg clone http://jusst.de/hg/multiproto
# cd multiproto
# make
# make install
# modprobe stb6100
# modprobe stb0899
# modprobe lnbp21
# modprobe budget-ci

MAJ DU DRIVER
# modprobe -r budget-ci
# modprobe -r lnbp21
# modprobe -r stb0899
# modprobe -r stb6100
# cd /opt/dvb/multiproto
# hg pull -u http://jusst.de/hg/multiproto
# make distclean
# make
# make install
# modprobe stb6100
# modprobe stb0899
# modprobe lnbp21
# modprobe budget-ci

DMESG
# dmesg
saa7146: register extension 'budget_ci dvb'.
ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 22 (level, low) -> IRQ 22
saa7146: found saa7146 @ mem ffffc20001598c00 (revision 1, irq 22)
(0x13c2,0x1019).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget S2-3200 PCI)
adapter has MAC addr =3D 00:d0:5c:0b:a5:8b
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9
budget_ci: CI interface initialised
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
ID=3D[DMD1], Version=3D[1] _stb0899_read_s2reg Device=3D[0xfafc], Base
address=3D[0x00000800], Offset=3D[0xfa2c], Data=3D[0x46454331]
_stb0899_read_s2reg Device=3D[0xfafc], Base address=3D[0x00000800],
Offset=3D[0xfa34], Data=3D[0x00000001] stb0899_get_dev_id: FEC Core
ID=3D[FEC1], Version=3D[1] stb0899_attach: Attaching STB0899
stb6100_attach: Attaching STB6100 DVB: registering frontend 0 (STB0899
Multistandard)... dvb_ca adaptor 0: PC card did not respond :(

As you can see, I have one error left, and it seems to come from my CI
module. If you have a different method, may be we can exchange ;-)))

I'll try soon to scan...

Hope it helps !!!

Regards.

David.

--Sig_/2HZmAUBsbo8LRzXYqvIMWhV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsZYdvSnthbGI8ygRAh5nAJ9lpiT1legA2KZcJFtjcy4W/yNwawCfWDpz
aAVKVsvMBsGi9Typ8bm8gtA=
=qBI3
-----END PGP SIGNATURE-----

--Sig_/2HZmAUBsbo8LRzXYqvIMWhV--



--===============0781219735==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0781219735==--
