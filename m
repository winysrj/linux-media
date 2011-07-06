Return-path: <mchehab@localhost>
Received: from server.oliverklee.com ([213.239.204.172]:58066 "EHLO
	server.oliverklee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab1GFIzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 04:55:55 -0400
Received: from bernhard by server.oliverklee.com with local (Exim 4.69)
	(envelope-from <bernhard@oliverklee.com>)
	id 1QeNAD-0007pd-TV
	for linux-media@vger.kernel.org; Wed, 06 Jul 2011 10:08:53 +0200
Date: Wed, 6 Jul 2011 10:08:53 +0200
From: Bernhard Guenther <bernhard@epgert.com>
To: linux-media@vger.kernel.org
Subject: DVB-T USB Devices to be added
Message-ID: <20110706080853.GA29972@epgert.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi there and sorry for the email,

it seems I am too dumb to edit the wiki and I am at work right now and
there is few time to figure it out.

Device to be added:

Terratec T Stick Dual RC=20

USB DVB-T Device

Product Page:=20

http://www.terratec.net/de/produkte/Cinergy_T_Stick_Dual_RC_102260.html

This one os similar to the TerraTec Cinergy T USB RC (mk II), but has
a different USB ID and a different Tuner:

Terratec T Stick Dual RC
0ccd:0099 USB2.0
Afatech AF9015A + mxl5007t (Tuner)
Firmware: dvb-usb-af9015.fw


On Ubuntu 11.04 64bit, Kernel 2.6.38  working out of the box.

dmesg:

[  380.391622] usb 1-1.6: new high speed USB device using ehci_hcd and
address 7
[  380.879599] dvb-usb: found a 'TerraTec Cinergy T Stick Dual RC' in
cold state, will try to load a firmware
[  380.881645] dvb-usb: downloading firmware from file
'dvb-usb-af9015.fw'
[  380.936424] dvb-usb: found a 'TerraTec Cinergy T Stick Dual RC' in
warm state.
[  380.936470] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[  380.936844] DVB: registering new adapter (TerraTec Cinergy T Stick
Dual RC)
[  380.943911] af9013: firmware version:4.65.0.0 [  380.946910] DVB:
registering adapter 0 frontend 0 (Afatech AF9013
DVB-T)...
[  380.949569] mxl5007t 8-00c0: creating new instance
[  380.951657] mxl5007t_get_chip_id: unknown rev (3f)
[  380.951660] mxl5007t_get_chip_id: MxL5007T detected @ 8-00c0
[  380.952278] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[  380.952675] DVB: registering new adapter (TerraTec Cinergy T Stick
Dual RC)
[  381.611221] af9013: found a 'Afatech AF9013 DVB-T' in warm state.
[  381.614687] af9013: firmware version:4.65.0.0
[  381.626018] DVB: registering adapter 1 frontend 0 (Afatech AF9013
DVB-T)...
[  381.626177] mxl5007t 9-00c0: creating new instance
[  381.628663] mxl5007t_get_chip_id: unknown rev (3f)
[  381.628667] mxl5007t_get_chip_id: MxL5007T detected @ 9-00c0
[  381.660243] Registered IR keymap rc-terratec-slim
[  381.660339] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/rc/rc0/input13
[  381.660402] rc0: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/rc/rc0
[  381.660405] dvb-usb: schedule remote query interval to 500 msecs.
[  381.660409] dvb-usb: TerraTec Cinergy T Stick Dual RC successfully
initialized and connected.
[  381.672566] input: Afatech DVB-T 2 as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.1/input/input14
[  381.672686] generic-usb 0003:0CCD:0099.000A: input,hidraw8: USB HID
v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:1a.0-1.6/input1




Nice Feature: It has 2 Tuners

Best Regards

Bernhard G=C3=BCnther

--=20
--------------------------------------------------------------------------
Bernhard Guenther               =20
<bernhard@guenther.pl>
<bernhard@epgert.com>
GnuPG-Key-ID: 1024D/1CD92189
Jabber(im): tiger@jabber.fsinf.de=20
Tel: +493065075259 , Cell: +491704931668, Fax: +493065076049
--------------------------------------------------------------------------


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFOFBgVngHnthzZIYkRAgQSAJ0WO3Fio69K8RImr/aso0Adepmz5gCgmSmh
UPwexM39dbsm/PihF6Dp8iM=
=mX6Y
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
