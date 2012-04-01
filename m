Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:42269 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab2DAMTu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 08:19:50 -0400
Date: Sun, 1 Apr 2012 14:19:40 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Daniel =?UTF-8?B?R2zDtmNrbmVy?= <daniel-gl@gmx.net>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T
 Stick [0ccd:0093]
Message-ID: <20120401141940.04e5220c@milhouse>
In-Reply-To: <20120401103315.1149d6bf@milhouse>
References: <4F75A7FE.8090405@iki.fi>
	<20120330234545.45f4e2e8@milhouse>
	<4F762CF5.9010303@iki.fi>
	<20120331001458.33f12d82@milhouse>
	<20120331160445.71cd1e78@milhouse>
	<4F771496.8080305@iki.fi>
	<20120331182925.3b85d2bc@milhouse>
	<4F77320F.8050009@iki.fi>
	<4F773562.6010008@iki.fi>
	<20120331185217.2c82c4ad@milhouse>
	<4F77DED5.2040103@iki.fi>
	<20120401103315.1149d6bf@milhouse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=j2tejfkT_gYhSACRjWlE6W"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/=j2tejfkT_gYhSACRjWlE6W
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Apr 2012 10:33:15 +0200
Michael B=C3=BCsch <m@bues.ch> wrote:

> On Sun, 01 Apr 2012 07:51:33 +0300
> Antti Palosaari <crope@iki.fi> wrote:
> > > I have no clue about the firmware format, so it will probably be easi=
er
> > > if you'd dive into that stuff as you already seem to know it.
> >=20
> > Done. I didn't have neither info, but there was good posting from Danie=
l=20
> > Gl=C3=B6ckner that documents it! Nice job Daniel, without that info I w=
as=20
> > surely implemented it differently and surely more wrong way.
> >=20
> > I pushed my experimental tree out, patches are welcome top of that.
> > http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035=
_experimental
> >=20
> > I extracted three firmwares from windows binaries I have. I will sent=20
> > those you, Michael, for testing. First, and oldest, is TUA9001, 2nd is=
=20
> > from FC0012 device and 3rd no idea.
>=20
> Great work. I'll rebase my tree on the new branch and check those firmwar=
e files asap.

Hm, none of these firmwares fix the problem. Maybe it's not a firmware
problem after all, but just incorrectly setup tuner-i2c.

Here's the dmesg log:

[  131.451556] usb 1-1.1: new high-speed USB device number 5 using ehci_hcd
[  131.550302] usb 1-1.1: New USB device found, idVendor=3D15a4, idProduct=
=3D9035
[  131.550315] usb 1-1.1: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[  131.674657] af9035_usb_probe: interface=3D0
[  131.675169] af9035_identify_state: reply=3D00 00 00 00
[  131.675185] dvb-usb: found a 'Afatech Technologies DVB-T stick' in cold =
state, will try to load a firmware
[  131.691605] dvb-usb: downloading firmware from file 'dvb-usb-af9035-02.f=
w'
[  131.691626] af9035_download_firmware: core=3D1 addr=3D4100 data_len=3D3 =
checksum=3Dfbbe
[  131.692696] af9035_download_firmware: data uploaded=3D10
[  131.692716] af9035_download_firmware: core=3D1 addr=3D4800 data_len=3D15=
014 checksum=3D587d
[  131.777793] af9035_download_firmware: data uploaded=3D15031
[  131.777807] af9035_download_firmware: core=3D1 addr=3D83e9 data_len=3D4 =
checksum=3D117c
[  131.778785] af9035_download_firmware: data uploaded=3D15042
[  131.778796] af9035_download_firmware: core=3D2 addr=3D4100 data_len=3D3 =
checksum=3Dfabe
[  131.779785] af9035_download_firmware: data uploaded=3D15052
[  131.779799] af9035_download_firmware: core=3D2 addr=3D4550 data_len=3D27=
252 checksum=3D3950
[  131.936162] af9035_download_firmware: data uploaded=3D42311
[  131.999412] af9035: firmware version=3D11.10.10.0
[  131.999443] dvb-usb: found a 'Afatech Technologies DVB-T stick' in warm =
state.
[  131.999790] dvb-usb: will pass the complete MPEG2 transport stream to th=
e software demuxer.
[  132.000122] DVB: registering new adapter (Afatech Technologies DVB-T sti=
ck)
[  132.000546] af9035_read_mac_address: dual mode=3D0
[  132.001027] af9035_read_mac_address: [0]tuner=3D28
[  132.002026] af9035_read_mac_address: [0]IF=3D36125
[  132.002413] dvb-usb: MAC address: 00:00:00:00:00:00
[  132.018549] af9033: firmware version: LINK=3D11.10.10.0 OFDM=3D5.33.10.0
[  132.018566] DVB: registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T=
))...
[  132.028370] i2c i2c-8: Fitipower FC0011 tuner attached
[  132.028388] dvb-usb: Afatech Technologies DVB-T stick successfully initi=
alized and connected.
[  132.028405] af9035_init: USB speed=3D3 frame_size=3D0ff9 packet_size=3D80
[  132.040019] usbcore: registered new interface driver dvb_usb_af9035
[  145.407991] af9035_ctrl_msg: command=3D03 failed fw error=3D2
[  145.408008] i2c i2c-8: I2C write reg failed, reg: 07, val: 0f

I also tried the other firmware. Same result.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/=j2tejfkT_gYhSACRjWlE6W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPeEfcAAoJEPUyvh2QjYsOo3AP/2h/bslWDipXnY5zOspD2XdA
DEyhYHI9BFQsG4uvquE6yHGfW2O40Vtb5rewGnd4D2CzEIr7mKGv8F+1in+RoGEX
IXH/3BxVbTyLJYnJF/LBEzjQwcYeWlL0h3ZKiRkXPaYe3SgBFjydWqQk7HomWzfP
+TuWKw3kqwc7wKZShK3hWq9/qkikTbyFuCNV38tcr/2XtZwmjXt405aY62RS/l6/
kR1LUKuc1lwZANx85GOW6oaUX98mmxy3eIq2ROnp+tRYNk+edPCOJO5fgjIG+Dmu
kr4YPmdJ5w/cYp/pIvFVX1sp5DyT/kuZAWz/2GjbT60pbat7NiexKYPElpwGoX2W
HVl0IqWauw/ceFe+y7+I23ceRBFZmXqAH9LsG7FtRakpCYtkKIoBaI9tz8Zq8xIx
EBmmmH1Mv9bMteOXfJDoU1+cPbwS29vxWE3BBfSGBoAqjfZEnQis0jA2w9QmKMfp
ztzD30FlkfdNw5MyIO2Qguy8RpCNNNL+FHEe53dIhTiwVJBtid2cx/npiLnfE534
7qjHiVhB8RsV0jtFI0l9Zkw20kIqaTUc7E2+Uhp2B2D95fHTQxXJco1i+SptlsPC
0Xwc1xfWuQMRQI23ssceAROFTg0lK3FxNAFooaE1BcM/djDhQEdVL/KnSMq3xv7R
amIFXmut0+Prp2ju12MZ
=WqhK
-----END PGP SIGNATURE-----

--Sig_/=j2tejfkT_gYhSACRjWlE6W--
