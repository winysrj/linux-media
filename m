Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:38721 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaDDXeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 19:34:50 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so4084532wes.2
        for <linux-media@vger.kernel.org>; Fri, 04 Apr 2014 16:34:49 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 1/3] rc-core: do not change 32bit NEC scancode format for now
Date: Sat, 05 Apr 2014 00:34:35 +0100
Message-ID: <1485396.bT76pgnf8H@radagast>
In-Reply-To: <20140404220556.5068.67187.stgit@zeus.muc.hardeman.nu>
References: <20140404220404.5068.3669.stgit@zeus.muc.hardeman.nu> <20140404220556.5068.67187.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart11000027.lLOK4uHEP4"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart11000027.lLOK4uHEP4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Saturday 05 April 2014 00:05:56 David H=E4rdeman wrote:
> This reverts 18bc17448147e93f31cc9b1a83be49f1224657b2
>=20
> The patch ignores the fact that NEC32 scancodes are generated not onl=
y in
> the NEC raw decoder but also directly in some drivers. Whichever appr=
oach
> is chosen it should be consistent across drivers and this patch needs=
 more
> discussion.
>=20
> Furthermore, I'm convinced that we have to stop playing games trying =
to
> decipher the "meaning" of NEC scancodes (what's the customer/vendor/a=
ddress,
> which byte is the MSB, etc).
>=20
> This patch is in preparation for the next few patches in this series.=

>=20
> v2: make sure img-ir scancodes are bitrev8():ed as well
>=20
> v3: update comments
>=20
> Signed-off-by: David H=E4rdeman <david@hardeman.nu>

Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

> ---
>  drivers/media/rc/img-ir/img-ir-nec.c |   27 ++++++-----
>  drivers/media/rc/ir-nec-decoder.c    |    5 --
>  drivers/media/rc/keymaps/rc-tivo.c   |   86
> +++++++++++++++++----------------- 3 files changed, 59 insertions(+),=
 59
> deletions(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-nec.c
> b/drivers/media/rc/img-ir/img-ir-nec.c index e7a731b..751d9d9 100644
> --- a/drivers/media/rc/img-ir/img-ir-nec.c
> +++ b/drivers/media/rc/img-ir/img-ir-nec.c
> @@ -5,6 +5,7 @@
>   */
>=20
>  #include "img-ir-hw.h"
> +#include <linux/bitrev.h>
>=20
>  /* Convert NEC data to a scancode */
>  static int img_ir_nec_scancode(int len, u64 raw, int *scancode, u64
> protocols) @@ -22,11 +23,11 @@ static int img_ir_nec_scancode(int len=
, u64
> raw, int *scancode, u64 protocols) data_inv =3D (raw >> 24) & 0xff;
>  =09if ((data_inv ^ data) !=3D 0xff) {
>  =09=09/* 32-bit NEC (used by Apple and TiVo remotes) */
> -=09=09/* scan encoding: aaAAddDD */
> -=09=09*scancode =3D addr_inv << 24 |
> -=09=09=09    addr     << 16 |
> -=09=09=09    data_inv <<  8 |
> -=09=09=09    data;
> +=09=09/* scan encoding: as transmitted, MSBit =3D first received bit=
 */
> +=09=09*scancode =3D bitrev8(addr)     << 24 |
> +=09=09=09    bitrev8(addr_inv) << 16 |
> +=09=09=09    bitrev8(data)     <<  8 |
> +=09=09=09    bitrev8(data_inv);
>  =09} else if ((addr_inv ^ addr) !=3D 0xff) {
>  =09=09/* Extended NEC */
>  =09=09/* scan encoding: AAaaDD */
> @@ -54,13 +55,15 @@ static int img_ir_nec_filter(const struct
> rc_scancode_filter *in,
>=20
>  =09if ((in->data | in->mask) & 0xff000000) {
>  =09=09/* 32-bit NEC (used by Apple and TiVo remotes) */
> -=09=09/* scan encoding: aaAAddDD */
> -=09=09addr_inv   =3D (in->data >> 24) & 0xff;
> -=09=09addr_inv_m =3D (in->mask >> 24) & 0xff;
> -=09=09addr       =3D (in->data >> 16) & 0xff;
> -=09=09addr_m     =3D (in->mask >> 16) & 0xff;
> -=09=09data_inv   =3D (in->data >>  8) & 0xff;
> -=09=09data_inv_m =3D (in->mask >>  8) & 0xff;
> +=09=09/* scan encoding: as transmitted, MSBit =3D first received bit=
 */
> +=09=09addr       =3D bitrev8(in->data >> 24);
> +=09=09addr_m     =3D bitrev8(in->mask >> 24);
> +=09=09addr_inv   =3D bitrev8(in->data >> 16);
> +=09=09addr_inv_m =3D bitrev8(in->mask >> 16);
> +=09=09data       =3D bitrev8(in->data >>  8);
> +=09=09data_m     =3D bitrev8(in->mask >>  8);
> +=09=09data_inv   =3D bitrev8(in->data >>  0);
> +=09=09data_inv_m =3D bitrev8(in->mask >>  0);
>  =09} else if ((in->data | in->mask) & 0x00ff0000) {
>  =09=09/* Extended NEC */
>  =09=09/* scan encoding AAaaDD */
> diff --git a/drivers/media/rc/ir-nec-decoder.c
> b/drivers/media/rc/ir-nec-decoder.c index 9de1791..35c42e5 100644
> --- a/drivers/media/rc/ir-nec-decoder.c
> +++ b/drivers/media/rc/ir-nec-decoder.c
> @@ -172,10 +172,7 @@ static int ir_nec_decode(struct rc_dev *dev, str=
uct
> ir_raw_event ev) if (send_32bits) {
>  =09=09=09/* NEC transport, but modified protocol, used by at
>  =09=09=09 * least Apple and TiVo remotes */
> -=09=09=09scancode =3D not_address << 24 |
> -=09=09=09=09   address     << 16 |
> -=09=09=09=09   not_command <<  8 |
> -=09=09=09=09   command;
> +=09=09=09scancode =3D data->bits;
>  =09=09=09IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode)=
;
>  =09=09} else if ((address ^ not_address) !=3D 0xff) {
>  =09=09=09/* Extended NEC */
> diff --git a/drivers/media/rc/keymaps/rc-tivo.c
> b/drivers/media/rc/keymaps/rc-tivo.c index 5cc1b45..454e062 100644
> --- a/drivers/media/rc/keymaps/rc-tivo.c
> +++ b/drivers/media/rc/keymaps/rc-tivo.c
> @@ -15,62 +15,62 @@
>   * Initial mapping is for the TiVo remote included in the Nero Liqui=
dTV
> bundle, * which also ships with a TiVo-branded IR transceiver, suppor=
ted by
> the mceusb * driver. Note that the remote uses an NEC-ish protocol, b=
ut
> instead of having - * a command/not_command pair, it has a vendor ID =
of
> 0x3085, but some keys, the + * a command/not_command pair, it has a v=
endor
> ID of 0xa10c, but some keys, the * NEC extended checksums do pass, so=
 the
> table presently has the intended * values and the checksum-passed ver=
sions
> for those keys.
>   */
>  static struct rc_map_table tivo[] =3D {
> -=09{ 0x3085f009, KEY_MEDIA },=09/* TiVo Button */
> -=09{ 0x3085e010, KEY_POWER2 },=09/* TV Power */
> -=09{ 0x3085e011, KEY_TV },=09=09/* Live TV/Swap */
> -=09{ 0x3085c034, KEY_VIDEO_NEXT },=09/* TV Input */
> -=09{ 0x3085e013, KEY_INFO },
> -=09{ 0x3085a05f, KEY_CYCLEWINDOWS }, /* Window */
> +=09{ 0xa10c900f, KEY_MEDIA },=09/* TiVo Button */
> +=09{ 0xa10c0807, KEY_POWER2 },=09/* TV Power */
> +=09{ 0xa10c8807, KEY_TV },=09=09/* Live TV/Swap */
> +=09{ 0xa10c2c03, KEY_VIDEO_NEXT },=09/* TV Input */
> +=09{ 0xa10cc807, KEY_INFO },
> +=09{ 0xa10cfa05, KEY_CYCLEWINDOWS }, /* Window */
>  =09{ 0x0085305f, KEY_CYCLEWINDOWS },
> -=09{ 0x3085c036, KEY_EPG },=09/* Guide */
> +=09{ 0xa10c6c03, KEY_EPG },=09/* Guide */
>=20
> -=09{ 0x3085e014, KEY_UP },
> -=09{ 0x3085e016, KEY_DOWN },
> -=09{ 0x3085e017, KEY_LEFT },
> -=09{ 0x3085e015, KEY_RIGHT },
> +=09{ 0xa10c2807, KEY_UP },
> +=09{ 0xa10c6807, KEY_DOWN },
> +=09{ 0xa10ce807, KEY_LEFT },
> +=09{ 0xa10ca807, KEY_RIGHT },
>=20
> -=09{ 0x3085e018, KEY_SCROLLDOWN },=09/* Red Thumbs Down */
> -=09{ 0x3085e019, KEY_SELECT },
> -=09{ 0x3085e01a, KEY_SCROLLUP },=09/* Green Thumbs Up */
> +=09{ 0xa10c1807, KEY_SCROLLDOWN },=09/* Red Thumbs Down */
> +=09{ 0xa10c9807, KEY_SELECT },
> +=09{ 0xa10c5807, KEY_SCROLLUP },=09/* Green Thumbs Up */
>=20
> -=09{ 0x3085e01c, KEY_VOLUMEUP },
> -=09{ 0x3085e01d, KEY_VOLUMEDOWN },
> -=09{ 0x3085e01b, KEY_MUTE },
> -=09{ 0x3085d020, KEY_RECORD },
> -=09{ 0x3085e01e, KEY_CHANNELUP },
> -=09{ 0x3085e01f, KEY_CHANNELDOWN },
> +=09{ 0xa10c3807, KEY_VOLUMEUP },
> +=09{ 0xa10cb807, KEY_VOLUMEDOWN },
> +=09{ 0xa10cd807, KEY_MUTE },
> +=09{ 0xa10c040b, KEY_RECORD },
> +=09{ 0xa10c7807, KEY_CHANNELUP },
> +=09{ 0xa10cf807, KEY_CHANNELDOWN },
>  =09{ 0x0085301f, KEY_CHANNELDOWN },
>=20
> -=09{ 0x3085d021, KEY_PLAY },
> -=09{ 0x3085d023, KEY_PAUSE },
> -=09{ 0x3085d025, KEY_SLOW },
> -=09{ 0x3085d022, KEY_REWIND },
> -=09{ 0x3085d024, KEY_FASTFORWARD },
> -=09{ 0x3085d026, KEY_PREVIOUS },
> -=09{ 0x3085d027, KEY_NEXT },=09/* ->| */
> +=09{ 0xa10c840b, KEY_PLAY },
> +=09{ 0xa10cc40b, KEY_PAUSE },
> +=09{ 0xa10ca40b, KEY_SLOW },
> +=09{ 0xa10c440b, KEY_REWIND },
> +=09{ 0xa10c240b, KEY_FASTFORWARD },
> +=09{ 0xa10c640b, KEY_PREVIOUS },
> +=09{ 0xa10ce40b, KEY_NEXT },=09/* ->| */
>=20
> -=09{ 0x3085b044, KEY_ZOOM },=09/* Aspect */
> -=09{ 0x3085b048, KEY_STOP },
> -=09{ 0x3085b04a, KEY_DVD },=09/* DVD Menu */
> +=09{ 0xa10c220d, KEY_ZOOM },=09/* Aspect */
> +=09{ 0xa10c120d, KEY_STOP },
> +=09{ 0xa10c520d, KEY_DVD },=09/* DVD Menu */
>=20
> -=09{ 0x3085d028, KEY_NUMERIC_1 },
> -=09{ 0x3085d029, KEY_NUMERIC_2 },
> -=09{ 0x3085d02a, KEY_NUMERIC_3 },
> -=09{ 0x3085d02b, KEY_NUMERIC_4 },
> -=09{ 0x3085d02c, KEY_NUMERIC_5 },
> -=09{ 0x3085d02d, KEY_NUMERIC_6 },
> -=09{ 0x3085d02e, KEY_NUMERIC_7 },
> -=09{ 0x3085d02f, KEY_NUMERIC_8 },
> +=09{ 0xa10c140b, KEY_NUMERIC_1 },
> +=09{ 0xa10c940b, KEY_NUMERIC_2 },
> +=09{ 0xa10c540b, KEY_NUMERIC_3 },
> +=09{ 0xa10cd40b, KEY_NUMERIC_4 },
> +=09{ 0xa10c340b, KEY_NUMERIC_5 },
> +=09{ 0xa10cb40b, KEY_NUMERIC_6 },
> +=09{ 0xa10c740b, KEY_NUMERIC_7 },
> +=09{ 0xa10cf40b, KEY_NUMERIC_8 },
>  =09{ 0x0085302f, KEY_NUMERIC_8 },
> -=09{ 0x3085c030, KEY_NUMERIC_9 },
> -=09{ 0x3085c031, KEY_NUMERIC_0 },
> -=09{ 0x3085c033, KEY_ENTER },
> -=09{ 0x3085c032, KEY_CLEAR },
> +=09{ 0xa10c0c03, KEY_NUMERIC_9 },
> +=09{ 0xa10c8c03, KEY_NUMERIC_0 },
> +=09{ 0xa10ccc03, KEY_ENTER },
> +=09{ 0xa10c4c03, KEY_CLEAR },
>  };
>=20
>  static struct rc_map_list tivo_map =3D {
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nextPart11000027.lLOK4uHEP4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTP0GSAAoJEKHZs+irPybfm84P/AnCPqY4/PGJiF0JYzGr3Xm1
/4CZx9DSs+oIuC2YDftIZjztX3Fb7WNNa/hhRppTdtjM3omuNIv/oJ3mJukKifIp
RQLftYQZ+UnQGD1D3oJyfS2c5MVQPKFn+ntRwErh5hqcSgMs6Tag2ekH8E/RcXTH
NTSMDoC7LhH9hkrosSFK71xjoqBjVgK4JJ7mBKUpWVDF6OkdLo/oqo8R/amvH3tc
pEEV+DR77nsR84kP57ngOH6G9AtWm1fDQaY207A3QP1RAgs0iTRZNgjpnjqj2MI/
A+U79X3//G0Xj50V72HC0heNr7WH+oELsvxxmUCeOIs8OwgWlwvpkMFL7ZPjlJsK
pKlYLdgSi9MjzRA3MQGt0D8hrK994Afoq7xV2KC+VyxMM9IOHIRQjw2EY6LCu57Q
kMWxLch1QeASIyiB3MFp3iyaUUDI1+AtDkHmOzdf2d02X7/2dr2+cygTcTF4Cb7o
H51rYMDzgv1OAUCltzir7Z1kqkV+ox5s7zEjla4GN3DHvUZ80ivktNAtpNnKTWjH
Uk6idNDnKgz7LNEyxOmKuh5w6dv7mPaIt6/rGqqaJdTVC0XKlckNchudJ4R2a6Od
7lfl7aO808/RihngqvVtSKjY6+QVWFc3k3AHeo1m8UGBqglVkPFIN2MXsyaT5TU4
Glde7cbnEL1rrFecyTai
=dDPr
-----END PGP SIGNATURE-----

--nextPart11000027.lLOK4uHEP4--

