Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:35952 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752918AbeFHVh4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 17:37:56 -0400
Subject: Re: [PATCH] media: i2c: adv748x: csi2: set entity function to video
 interface bridge
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
References: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>
 <011af984-e447-8640-4173-4bf20919905b@ideasonboard.com>
 <273d89f9-511b-0a30-836c-74a8c08ec19b@mentor.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <ca7f36a4-209a-5882-3757-918dc35518ac@ideasonboard.com>
Date: Fri, 8 Jun 2018 22:37:51 +0100
MIME-Version: 1.0
In-Reply-To: <273d89f9-511b-0a30-836c-74a8c08ec19b@mentor.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="N2D6Vv61UvqF3VVakJYeCVmBlAdqBKvUW"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N2D6Vv61UvqF3VVakJYeCVmBlAdqBKvUW
Content-Type: multipart/mixed; boundary="VecxwG0QHKyqaiO401ZZ6X0yMGxeAj22Y";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
 Steve Longerbeam <slongerbeam@gmail.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Message-ID: <ca7f36a4-209a-5882-3757-918dc35518ac@ideasonboard.com>
Subject: Re: [PATCH] media: i2c: adv748x: csi2: set entity function to video
 interface bridge
References: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>
 <011af984-e447-8640-4173-4bf20919905b@ideasonboard.com>
 <273d89f9-511b-0a30-836c-74a8c08ec19b@mentor.com>
In-Reply-To: <273d89f9-511b-0a30-836c-74a8c08ec19b@mentor.com>

--VecxwG0QHKyqaiO401ZZ6X0yMGxeAj22Y
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On 08/06/18 22:34, Steve Longerbeam wrote:
> Hi Kieran,
>=20
>=20
> On 06/08/2018 02:29 PM, Kieran Bingham wrote:
>> Hi Steve,
>>
>> Thankyou for the patch.
>>
>> On 08/06/18 18:43, Steve Longerbeam wrote:
>>> The ADV748x CSI-2 subdevices are HMDI/AFE to MIPI CSI-2 bridges.
>>>
>> Reading the documentation for MEDIA_ENT_F_VID_IF_BRIDGE, this seems re=
asonable.
>>
>> Out of interest, have you stumbled across this as part of your other w=
ork on
>> CSI2 drivers - or have you been looking to test the ADV748x with your =
CSI2
>> receiver? I'd love to know if the driver works with other (non-renesas=
)
>> platforms!
>=20
> This isn't really related to my other work on the i.MX CSI2 receiver dr=
iver
> in imx-media. I've only tested this on Renesas (Salvator-X).

No problem. I was just curious :D
And this will get rid of that annoying warning message that I've been ign=
oring!

Regards

Kieran

>=20
> Steve
>=20
>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>>
>>> ---
>>> =C2=A0 drivers/media/i2c/adv748x/adv748x-csi2.c | 2 +-
>>> =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c
>>> b/drivers/media/i2c/adv748x/adv748x-csi2.c
>>> index 820b44e..469be87 100644
>>> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
>>> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
>>> @@ -284,7 +284,7 @@ int adv748x_csi2_init(struct adv748x_state *state=
, struct
>>> adv748x_csi2 *tx)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 adv748x_csi2_set_virtual_channel(tx, 0=
);
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 adv748x_subdev_init(&tx->sd, st=
ate, &adv748x_csi2_ops,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 MEDIA_ENT_F_UNKNOWN,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 MEDIA_ENT_F_VID_IF_BRIDGE,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 is_txa(tx) ? "txa" : "txb");
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Ensure that matching is base=
d upon the endpoint fwnodes */
>>>
>=20


--VecxwG0QHKyqaiO401ZZ6X0yMGxeAj22Y--

--N2D6Vv61UvqF3VVakJYeCVmBlAdqBKvUW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlsa9y8ACgkQoR5GchCk
Yf2RHRAAqafwfYwmqhHGQOf/bpfsHZ2MT/Y0NXqOwt68B32v9T0A0wKKS7TNBLai
CqMkxyonHESLLZ/HZe48WdEa8RWwg1SJRPNC2xShLhcxUx/OOSfJkARJfUO9ga23
105SGHjAuAZEUJnEC0f+7XK9fXUkBF+JMqqWiToU0sdWpQcJ0FOhvrA9o6MoJDMP
sK8/Fg1DkrgA5OY0j9whH0Puucgf30DIs4RgjZt4xngsSQBWLzLQj6sUkVt9Ric/
E8iVeLnf7v0ANE6UPmT1QKNiJYzLHXFu53N+Fojfq3ThMsSrfawdPs2DaGfHXYqD
fHR3UXQUB3wPWMtASouUWZLQRJe91e8gQLeLQWuM5ROwEcoFjU7SZ4PgOr3gas1y
3GfTVnvx58shGC66VTtMV+y9t87Lj+9J9YqjL1qTxSWUulEMunQx+eoTIBLjqccP
jb2rRW6fIsAnYqF2mUdwLUTFmeCExw/N5WqhF1LNCAWt/ihfOxrcAQQygMPHkcPe
KvTHbrpwJNXgYfgf4HMjs8/AsS1ZH9ZZhRWT7yWyHvLsG6I3xzK4Lel737SaMDWd
kuxQ9fql1G0xM96xkk9obDVuCXlyvwwWTojIAgGpq50ffpQwmTeG9OMAhH3PmvnQ
ajLORVdRoTdrg1ZGkWe7kpahfQg3Lo/p7WGVOMVR3zMIZhBaSJY=
=GGJl
-----END PGP SIGNATURE-----

--N2D6Vv61UvqF3VVakJYeCVmBlAdqBKvUW--
