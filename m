Return-path: <linux-media-owner@vger.kernel.org>
Received: from rupert.bearstech.com ([193.84.18.54]:46954 "EHLO
	rupert.bearstech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbZBUBeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 20:34:17 -0500
Received: from localhost (localhost [127.0.0.1])
	by rupert.bearstech.com (Postfix) with ESMTP id 4CE61100013
	for <linux-media@vger.kernel.org>; Sat, 21 Feb 2009 02:09:39 +0100 (CET)
Received: from rupert.bearstech.com ([127.0.0.1])
	by localhost (rupert.bearstech.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id qZY-2f+Hj+4e for <linux-media@vger.kernel.org>;
	Sat, 21 Feb 2009 02:09:39 +0100 (CET)
Received: from [192.168.0.24] (beavis.scaryflop.com [82.67.15.220])
	by rupert.bearstech.com (Postfix) with ESMTP id 0F09F10000A
	for <linux-media@vger.kernel.org>; Sat, 21 Feb 2009 02:09:39 +0100 (CET)
Message-ID: <499F5452.6050205@bearstech.com>
Date: Sat, 21 Feb 2009 02:09:38 +0100
From: Laurent Haond <lhaond@bearstech.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Can I use AVerTV Volar Black HD (A850) with Linux
 ?
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2F9BFABD2E36674D58D61A46"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2F9BFABD2E36674D58D61A46
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,
I bought an AverMedia Volar Black HD too.
I opened it, i can confirm the device contains a AF9015N1 chip and a
MXL5003S tuner.


I think there was something missing your diff Antti :
@@ -1404,7 +1405,7 @@

                .i2c_algo =3D &af9015_i2c_algo,

-               .num_device_descs =3D 7,
+               .num_device_descs =3D 8,
                .devices =3D {
                        {
                                .name =3D "Xtensions XD-380",

After patching af9015.c file, when i plug it, modules are loading but it
seems that the tuner did not work :

Module                  Size  Used by
mxl5005s               32388  1
af9013                 18756  1
dvb_usb_af9015         27184  0
dvb_usb                19916  1 dvb_usb_af9015
dvb_core               88676  1 dvb_usb


$ dmesg
usb 4-1: configuration #1 chosen from 1 choice
dvb-usb: found a 'AVerMedia A850' in cold state, will try to load a firmw=
are
firmware: requesting dvb-usb-af9015.fw
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
dvb-usb: found a 'AVerMedia A850' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (AVerMedia A850)
af9013: firmware version:4.95.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
MXL5005S: Attached at address 0xc6
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (AVerMedia A850)
af9015: command failed:2
af9015: firmware copy to 2nd frontend failed, will disable it
dvb-usb: no frontend was attached by 'AVerMedia A850'
dvb-usb: AVerMedia A850 successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_af9015

$ dvbscan /usr/share/dvb/dvb-t/fr-Lyon-Fourviere
Unable to query frontend status

$ dmesg
af9015: recv bulk message failed:-110
af9013: I2C read failed reg:d417


Anything else we can try Antti ?

Thanks


--------------enig2F9BFABD2E36674D58D61A46
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmfVFIACgkQ2KAAfsBqikPHAwCfblGSMgfb3fEaAPjl9KEOZml6
xS4AoK2XCFS5ZfbYh82fzAfgQFwgHaHt
=d47P
-----END PGP SIGNATURE-----

--------------enig2F9BFABD2E36674D58D61A46--
