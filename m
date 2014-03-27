Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60293 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbaC0XWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Mar 2014 19:22:07 -0400
Received: by mail-wi0-f176.google.com with SMTP id r20so132211wiv.15
        for <linux-media@vger.kernel.org>; Thu, 27 Mar 2014 16:22:05 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH] rc-core: do not change 32bit NEC scancode format for now
Date: Thu, 27 Mar 2014 23:21:23 +0000
Message-ID: <7983411.lVWEDlBWc6@radagast>
In-Reply-To: <20140327210037.20406.93136.stgit@zeus.muc.hardeman.nu>
References: <20140327210037.20406.93136.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3122470.cljZWlUVbo"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart3122470.cljZWlUVbo
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi David,

On Thursday 27 March 2014 22:00:37 David H=E4rdeman wrote:
> This reverts 18bc17448147e93f31cc9b1a83be49f1224657b2
>=20
> The patch ignores the fact that NEC32 scancodes are generated not onl=
y in
> the NEC raw decoder but also directly in some drivers. Whichever appr=
oach
> is chosen it should be consistent across drivers and this patch needs=
 more
> discussion.

Fair enough. For reference which drivers are you referring to?

> Furthermore, I'm convinced that we have to stop playing games trying =
to
> decipher the "meaning" of NEC scancodes (what's the customer/vendor/a=
ddress,
> which byte is the MSB, etc).

Well when all the buttons on a remote have the same address, and the nu=
meric
buttons are sequential commands only in a certain bit/byte order, then =
I think
the word "decipher" is probably a bit of a stretch.

Nevertheless I don't have any attachment to 32-bit NEC. If it's likely =
to
change again I'd prefer img-ir-nec just not support it for now, so plea=
se
could you add the following hunks to your patch (or if the original pat=
ch is
to be dropped this could be squashed into the img-ir-nec patch):

diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/im=
g-ir/img-ir-nec.c
index e7a731b..419d087 100644
=2D-- a/drivers/media/rc/img-ir/img-ir-nec.c
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -21,12 +21,7 @@ static int img_ir_nec_scancode(int len, u64 raw, int=
 *scancode, u64 protocols)
 =09data     =3D (raw >> 16) & 0xff;
 =09data_inv =3D (raw >> 24) & 0xff;
 =09if ((data_inv ^ data) !=3D 0xff) {
=2D=09=09/* 32-bit NEC (used by Apple and TiVo remotes) */
=2D=09=09/* scan encoding: aaAAddDD */
=2D=09=09*scancode =3D addr_inv << 24 |
=2D=09=09=09    addr     << 16 |
=2D=09=09=09    data_inv <<  8 |
=2D=09=09=09    data;
+=09=09return -EINVAL;
 =09} else if ((addr_inv ^ addr) !=3D 0xff) {
 =09=09/* Extended NEC */
 =09=09/* scan encoding: AAaaDD */
@@ -53,14 +48,7 @@ static int img_ir_nec_filter(const struct rc_scancod=
e_filter *in,
 =09data_m     =3D in->mask & 0xff;
=20
 =09if ((in->data | in->mask) & 0xff000000) {
=2D=09=09/* 32-bit NEC (used by Apple and TiVo remotes) */
=2D=09=09/* scan encoding: aaAAddDD */
=2D=09=09addr_inv   =3D (in->data >> 24) & 0xff;
=2D=09=09addr_inv_m =3D (in->mask >> 24) & 0xff;
=2D=09=09addr       =3D (in->data >> 16) & 0xff;
=2D=09=09addr_m     =3D (in->mask >> 16) & 0xff;
=2D=09=09data_inv   =3D (in->data >>  8) & 0xff;
=2D=09=09data_inv_m =3D (in->mask >>  8) & 0xff;
+=09=09return -EINVAL;
 =09} else if ((in->data | in->mask) & 0x00ff0000) {
 =09=09/* Extended NEC */
 =09=09/* scan encoding AAaaDD */


>=20
> I'll post separate proposals to that effect later.

Great, please do Cc me

(I have a work in progress branch to unify NEC scancodes, but I'm not s=
ure
I'd have time to complete it any time soon anyway)

Thanks
James

>=20
> Signed-off-by: David H=E4rdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/ir-nec-decoder.c  |    5 --
>  drivers/media/rc/keymaps/rc-tivo.c |   86
> ++++++++++++++++++------------------ 2 files changed, 44 insertions(+=
), 47
> deletions(-)
>=20
> diff --git a/drivers/media/rc/ir-nec-decoder.c
> b/drivers/media/rc/ir-nec-decoder.c index 735a509..c4333d5 100644
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

--nextPart3122470.cljZWlUVbo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTNLKaAAoJEKHZs+irPybfnckP/ilvtN8m7llh/1OUN9BaiS4a
5LHUjSoFMPJ9HMzNkAk9d21nIW/MjfMpiQqRpFqSzLURTfJKA3UKu4civTIbJpHB
c7nqWQRmfuCbwyi3k1VxqCz6GKIVEMx+3Tbf84UedbPNHlQOSoR++NhGqrOfCaO2
c/dvx5YYU2ZojS6b0zzD14KteHGAu43+UgPqNnnRTzMNJOA68vwWstUgT0AwLCmr
LfLI9YkUwivTUnDMsZAGWDSJaPD/EjQqZrOU0HJmZfuNCf/CcA+BT2XuT/2CFCiS
Z2UjQ1ZkUAZLAjQqjgpxUiy4BGDA2CV84CvMJpq9y0VgXQ8gOzTSqAjBwQqmWvfx
mgBUfaU4zm1l+iY381594dn6etFdJ00udyGt+ap05iAz3YTDxRBcIHbIvIABipN1
V5c/mubiDW/zkNl1POaGaCaTxaAxnD+10RyUbjDKDb+Qc62UduEnwRy7v7lmHZsR
GCet5zhy8Poffq5JD6y+2Kb9nJEG1sRQN+FpFXhXZQ+cJCcV7Fgoq36d/PCTSK0z
C3/18fWPCtkeYVU+JqVlMiQi2jFkSNslv7lXJYUWAFTwUnh/xMuRfp+lqsUa2vrI
8J9fvn2IcDQDoSuQK6FSyaEw4AnwKCILSC91IMQN78ubIIq44pp+N50xByR+CCAm
G3EeXgpJQyQxVdn9GUn+
=svNc
-----END PGP SIGNATURE-----

--nextPart3122470.cljZWlUVbo--

