Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:53110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZJPQpG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 12:45:06 -0400
Message-ID: <4AD3962A.9010209@sagurna.de>
Date: Mon, 12 Oct 2009 22:48:42 +0200
From: Frank Sagurna <frank@sagurna.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Steven Toth <stoth@hauppauge.com>
Subject: Bug in HVR1300. Found part of a patch, if reverted bug seems to be
 gone
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi list,

there seems to be a bug in cx88 (HVR1300) that is responsible for not
switching channels, and not being able to scan.
Complete description can be found on launchpad:

https://bugs.launchpad.net/mythtv/+bug/439163 (starting from comment #16)

Anyway, i digged it down to this patch:
http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg02195.html

When reverting the following part of the patch it starts working again:

snip----------

diff -r 576096447a45 -r d2eedb425718
linux/drivers/media/video/cx88/cx88-dvb.c
- --- a/linux/drivers/media/video/cx88/cx88-dvb.c Thu Dec 18 07:28:18 2008
- -0200
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c Thu Dec 18 07:28:35 2008
- -0200
@@ -1135,40 +1135,44 @@ static int cx8802_dvb_advise_acquire(str
                 * on the bus. Take the bus from the cx23416 and enable the
                 * cx22702 demod
                 */
- - cx_set(MO_GP0_IO, 0x00000080); /* cx22702 out of reset and
enable */
+ /* Toggle reset on cx22702 leaving i2c active */
+ cx_set(MO_GP0_IO, 0x00000080);
+ udelay(1000);
+ cx_clear(MO_GP0_IO, 0x00000080);
+ udelay(50);
+ cx_set(MO_GP0_IO, 0x00000080);
+ udelay(1000);
+ /* enable the cx22702 pins */
                cx_clear(MO_GP0_IO, 0x00000004);
                udelay(1000);
                break;
- ---------snip

Regards

Frank Sagurna


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkrTliUACgkQrcfRHnkKaDb/SQCgg5g/dfWvESwwKPLM0Jy6j0gb
dx4AoIDDqZvHzZMaEp9Sml7lUDM9WirF
=ry/E
-----END PGP SIGNATURE-----
