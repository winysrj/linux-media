Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:46665 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756305Ab0FDU4o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 16:56:44 -0400
Message-ID: <4C09686E.5090601@arcor.de>
Date: Fri, 04 Jun 2010 22:56:14 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: tm6000 autio isoc blocks
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hi Mauro,

I have check the windows usb log and if I have audio block it's say 0
byte, but the data is complete 180 bytes until next block header. So I
think it's good if that audio block (cmd=2) resize from 0 to 180
(actual read 0 without resize it).
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQEcBAEBAgAGBQJMCWhtAAoJEAWtPFjxMvFGgyAH/jCgxFhc6pA7umakxaYAwfnf
Yrg/V+JDEPUGzGVmvl4a7jzHkzn1hrZ3Pn3YCgNP7CIGeaoaiWgx+4ptLpKSyuH3
noG36DXQBX19g35Dhch4vpCrhVlCE4M+fD6gsBRgcCFEmAdWojsHDpyhOBoPnxrS
t9xkh59SEcYSPKvleB3HGVP9/tKggbGXoeRh7Ag7lBtzKAraqQMA/C0REwT4OHmc
/IL2+z1D1fb/vR2MU5uYHLgANI3WdiRbdr9yHzBdpOJ57IrytsoVRL8WdhbmuFI8
/PH2NXYfOAoyi/boFbVidmu0MSj7+OA0XrHUORjKPnmrgleOahbitDYZAxh6Jfo=
=CRkV
-----END PGP SIGNATURE-----

