Return-path: <linux-media-owner@vger.kernel.org>
Received: from rupert.bearstech.com ([193.84.18.54]:47041 "EHLO
	rupert.bearstech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZBUMJt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 07:09:49 -0500
Received: from localhost (localhost [127.0.0.1])
	by rupert.bearstech.com (Postfix) with ESMTP id 3FB8610000C
	for <linux-media@vger.kernel.org>; Sat, 21 Feb 2009 13:09:47 +0100 (CET)
Received: from rupert.bearstech.com ([127.0.0.1])
	by localhost (rupert.bearstech.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ovfepZP6Qfbk for <linux-media@vger.kernel.org>;
	Sat, 21 Feb 2009 13:09:47 +0100 (CET)
Received: from [192.168.0.24] (beavis.scaryflop.com [82.67.15.220])
	by rupert.bearstech.com (Postfix) with ESMTP id C8D2C10000A
	for <linux-media@vger.kernel.org>; Sat, 21 Feb 2009 13:09:46 +0100 (CET)
Message-ID: <499FEF0A.2070001@bearstech.com>
Date: Sat, 21 Feb 2009 13:09:46 +0100
From: Laurent Haond <lhaond@bearstech.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Can I use AVerTV Volar Black HD (A850) with Linux
 ?
References: <499F5452.6050205@bearstech.com> <7a3c9e3d0902210108w77e440e2u6d688f3614ccf972@mail.gmail.com>
In-Reply-To: <7a3c9e3d0902210108w77e440e2u6d688f3614ccf972@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig770BA8EE581BB6237FA5F339"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig770BA8EE581BB6237FA5F339
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I enabled debug on dvb-usb, here you can find my dmesg output :


usb 4-3: new high speed USB device using ehci_hcd and address 12
usb 4-3: configuration #1 chosen from 1 choice
af9015_usb_probe: interface:0
af9015_read_config: IR mode:0
af9015_read_config: TS mode:1
af9015_read_config: [0] xtal:2 set adc_clock:28000
af9015_read_config: [0] IF1:36125
af9015_read_config: [0] MT2060 IF1:0
af9015_read_config: [0] tuner id:13
af9015_read_config: [1] xtal:2 set adc_clock:28000
af9015_read_config: [1] IF1:36125
af9015_read_config: [1] MT2060 IF1:1220
af9015_read_config: [1] tuner id:130
af9015_identify_state: reply:01
dvb-usb: found a 'AVerMedia A850' in cold state, will try to load a firmw=
are
firmware: requesting dvb-usb-af9015.fw
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
af9015_download_firmware:
dvb-usb: found a 'AVerMedia A850' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (AVerMedia A850)
af9015_af9013_frontend_attach: init I2C
af9015_i2c_init:
00: 2c 85 a3 0b 00 00 00 00 ca 07 0a 85 01 01 01 02
10: 03 80 00 fa fa 10 40 ef 00 30 31 30 31 30 37 30
20: 33 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff
30: 01 01 38 01 00 08 02 01 1d 8d 00 00 0d ff ff ff
40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
50: ff ff ff ff ff 26 00 00 04 03 09 04 14 03 41 00
60: 56 00 65 00 72 00 4d 00 65 00 64 00 69 00 61 00
70: 14 03 41 00 38 00 35 00 30 00 20 00 44 00 56 00
80: 42 00 54 00 20 03 33 00 30 00 31 00 34 00 37 00
90: 35 00 33 00 30 00 31 00 32 00 34 00 30 00 30 00
a0: 30 00 30 00 00 ff ff ff ff ff ff ff ff ff ff ff
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
af9013: firmware version:4.95.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
af9015_tuner_attach:
MXL5005S: Attached at address 0xc6
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (AVerMedia A850)
af9015_copy_firmware:
af9015: command failed:2
af9015: firmware copy to 2nd frontend failed, will disable it
dvb-usb: no frontend was attached by 'AVerMedia A850'
dvb-usb: AVerMedia A850 successfully initialized and connected.
af9015_init:
af9015_init_endpoint: USB speed:3
af9015_download_ir_table:


dvbscan fails with this error : Unable to query frontend status
and sometimes (not everytimes) dmesg shows :
af9015: recv bulk message failed:-110
af9013: I2C read failed reg:d417


Tried Kaffeine, did not work either...


Laurent


--------------enig770BA8EE581BB6237FA5F339
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmf7woACgkQ2KAAfsBqikPEGwCgppYVVdDRVFIWt/3+B1QbgkOj
UywAnRX87nOGZX9u6yvWjtoebjKByEQa
=3ARB
-----END PGP SIGNATURE-----

--------------enig770BA8EE581BB6237FA5F339--
