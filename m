Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:34652 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753454AbeBGIdH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 03:33:07 -0500
Subject: Re: [PATCH 5/5] add module parameters for default values
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
References: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
 <1517950905-5015-6-git-send-email-floe@butterbrot.org>
 <c64ae317-d393-1784-1184-4a24a2907112@xs4all.nl>
From: Florian Echtler <floe@butterbrot.org>
Message-ID: <039aaa61-4150-ebde-5f9e-a0ffc8888cfb@butterbrot.org>
Date: Wed, 7 Feb 2018 09:33:05 +0100
MIME-Version: 1.0
In-Reply-To: <c64ae317-d393-1784-1184-4a24a2907112@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gzgaKotpDcjeVqV1kflh7qO0M4NUhojcr"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gzgaKotpDcjeVqV1kflh7qO0M4NUhojcr
Content-Type: multipart/mixed; boundary="eeXsxodfpvHtaXO1HB4PKdj32PqS8Hxj5";
 protected-headers="v1"
From: Florian Echtler <floe@butterbrot.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
Message-ID: <039aaa61-4150-ebde-5f9e-a0ffc8888cfb@butterbrot.org>
Subject: Re: [PATCH 5/5] add module parameters for default values
References: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
 <1517950905-5015-6-git-send-email-floe@butterbrot.org>
 <c64ae317-d393-1784-1184-4a24a2907112@xs4all.nl>
In-Reply-To: <c64ae317-d393-1784-1184-4a24a2907112@xs4all.nl>

--eeXsxodfpvHtaXO1HB4PKdj32PqS8Hxj5
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 06.02.2018 22:31, Hans Verkuil wrote:
> On 02/06/2018 10:01 PM, Florian Echtler wrote:
>> To allow setting custom parameters for the sensor directly at startup,=
 the
>> three primary controls are exposed as module parameters in this patch.=

>>
>> +/* module parameters */
>> +static uint brightness =3D SUR40_BRIGHTNESS_DEF;
>> +module_param(brightness, uint, 0644);
>> +MODULE_PARM_DESC(brightness, "set default brightness");
>> +static uint contrast =3D SUR40_CONTRAST_DEF;
>> +module_param(contrast, uint, 0644);
>> +MODULE_PARM_DESC(contrast, "set default contrast");
>> +static uint gain =3D SUR40_GAIN_DEF;
>> +module_param(gain, uint, 0644);
>> +MODULE_PARM_DESC(contrast, "set default gain");
>
> contrast -> gain

Ah, typo. Thanks, will fix that.

> Isn't 'initial gain' better than 'default gain'?

Probably correct, yes.

> If I load this module with gain=3DX, will the gain control also
> start off at X? I didn't see any code for that.

This reminds me: how can I get/set the control from inside the driver?
Should I use something like the following:

struct v4l2_ctrl *ctrl =3D v4l2_ctrl_find(&sur40->ctrls, V4L2_CID_BRIGHTN=
ESS);
int val =3D v4l2_ctrl_g_ctrl(ctrl);
// modify val...
v4l2_ctrl_s_ctrl(ctrl, val);

> It might be useful to add the allowed range in the description.
> E.g.: "set initial gain, range=3D0-255". Perhaps mention even the
> default value, but I'm not sure if that's really needed.

Good point, though - right now the code directly sets the registers witho=
ut any
clamping, I guess it would be better to call the control framework as men=
tioned
above?

Best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--eeXsxodfpvHtaXO1HB4PKdj32PqS8Hxj5--

--gzgaKotpDcjeVqV1kflh7qO0M4NUhojcr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlp6ucEACgkQ7CzyshGvatj44gCffEoL0yfYDKEuCn4zEHpb1ZSF
S+IAn1tui7qi8kmZaSGOOO9t3e6Wb4Ff
=CMDU
-----END PGP SIGNATURE-----

--gzgaKotpDcjeVqV1kflh7qO0M4NUhojcr--
