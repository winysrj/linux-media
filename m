Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.andi.de1.cc ([85.214.239.24]:50633 "EHLO
        h2641619.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbdCNG0g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 02:26:36 -0400
Date: Tue, 14 Mar 2017 07:26:21 +0100
From: Andreas Kemnade <andreas@kemnade.info>
To: Andreas Kemnade <andreas@kemnade.info>,
        linux-media@vger.kernel.org, mchehab@kernel.org
Subject: Re: [PATCH RFC] dvb: af9035.c: Logilink vg0022a to device id table
Message-ID: <20170314072621.2b81c73f@aktux>
In-Reply-To: <1489078274-24227-1-git-send-email-andreas@kemnade.info>
References: <1489078274-24227-1-git-send-email-andreas@kemnade.info>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qasgztqo0F5eR/I4ElM4bo6"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/qasgztqo0F5eR/I4ElM4bo6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu,  9 Mar 2017 17:51:14 +0100
Andreas Kemnade <andreas@kemnade.info> wrote:

> Ths adds the logilink VG00022a dvb-t dongle to the device table.
> The dongle contains (checked by removing the case)
> IT9303
> SI2168
>   214730
>=20
> The result is in cold state:
>=20
>  usb 1-6: new high-speed USB device number 15 using xhci_hcd
>  usb 1-6: New USB device found, idVendor=3D1d19, idProduct=3D0100
>  usb 1-6: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
>  usb 1-6: Product: TS Aggregator
>  usb 1-6: Manufacturer: ITE Tech., Inc.
>  usb 1-6: SerialNumber: XXXXXXXXXXXX
>  dvb_usb_af9035 1-6:1.0: prechip_version=3D83 chip_version=3D01 chip_type=
=3D9306
>  dvb_usb_af9035 1-6:1.0: ts mode=3D5 not supported, defaulting to single =
tuner mode!
>  usb 1-6: dvb_usb_v2: found a 'Logilink VG0022A' in cold state
>  usb 1-6: dvb_usb_v2: downloading firmware from file 'dvb-usb-it9303-01.f=
w'
>  dvb_usb_af9035 1-6:1.0: firmware version=3D1.4.0.0
>  usb 1-6: dvb_usb_v2: found a 'Logilink VG0022A' in warm state
>  usb 1-6: dvb_usb_v2: will pass the complete MPEG2 transport stream to th=
e software demuxer
>  dvbdev: DVB: registering new adapter (Logilink VG0022A)
>  si2168: probe of 6-0067 failed with error -5
>=20
> when warmed up by connecing it via  a powered usb hub to win7 and
> then attaching the same usb hub to a linux machine:
>=20
with some fixes in af9035.c I already get the same state as with warm
up by win7. I just need to find out which changes are really necessary
and convert it into a clean patch.

> so firmware uploading to the si2168 somehow messes things up
>=20
I experimented a lot here and I found this:
If 0101 is not sent to the si2168 you can get answers from the
Si2147-A30.=20
After the 0101 is sent to the si2147-A30 it will still execute
commands but you will not get the answer back through the si2168.
You just get ff.

After moving the chip id readout from si2157_init to si2157_probe,
scanning for stations works. So the si2147-A30 seems to react on
commands.=20

Regards,
Andreas Kemnade

--Sig_/qasgztqo0F5eR/I4ElM4bo6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJYx40QAAoJEInxNTv1CwY0m58P/jLd+XaVKNf0C0bUiWY8NWFH
keTyRwdb/ZBAH5xwRqgDftrLIuxjMGwYjMg8FpAfM0MEU3+jSjE+d9wpBeBo+3Kk
Y1CPjFfmv0+loVZ5iAPuvGADIccqfZjvEsXOEefxqSWwoh+X/JGFBlziPcOa9ypW
Vqv3kT+UIg6q5u0TDup/hlA6Td9HJ3dgfKhXRhmINjt3o8LBKAxlm9yqqxpmXAzR
cU4iyu0TqLTVVkzbQO/6bTeOaZmvs6/DTt/kr3UF78JO0FbhII1X/rnKDfXb951z
GWbVWPnE2qS+KBi+vB8Fx/z+IFN+nAH6q4KN00R13XGvKxzRtsI54a7iSOGvFegx
k3lB4Hj8SmIJPud4LO2YXzJZ7RSonQGqNiyJNTkO4UexH7F7dWLTN8IPrfZBKW2T
loliXF5SC5T/XsOPUVArUm858boapMrkrYiq7MuyCmSdmo3ed4fIOfMFZJsoptxh
8pVC93II6mkqq72aqPi21y+EIeO/h1oFfCj0LcPtgryZJLKEGMTBNWMb26+Gtu7+
ncVLLJOb7aVTLrZTQpF8S0JF0sa9O2zdhJVFm4fJauBE+9IP0gM193ZR+YEmORGs
FEHgVvLdogQTD/jPqq387E0PLAEd0BVmArSjkfTLAQdCIEr6nuizHrPGpl25+3Vi
TZFuzAOxiDaTpbnoit//
=PVnR
-----END PGP SIGNATURE-----

--Sig_/qasgztqo0F5eR/I4ElM4bo6--
