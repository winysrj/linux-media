Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:51438 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752328AbdGRWEJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 18:04:09 -0400
From: Eric Anholt <eric@anholt.net>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/4] drm/vc4: add HDMI CEC support
In-Reply-To: <e8289d89-bfd5-d964-2b9a-2d36394ce868@xs4all.nl>
References: <20170711112021.38525-1-hverkuil@xs4all.nl> <20170711112021.38525-5-hverkuil@xs4all.nl> <87d195h41b.fsf@eliezer.anholt.net> <c45868d2-50e5-987b-db1e-b8e76983cbb2@xs4all.nl> <e8289d89-bfd5-d964-2b9a-2d36394ce868@xs4all.nl>
Date: Tue, 18 Jul 2017 15:03:55 -0700
Message-ID: <87vampjtbo.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 12/07/17 21:43, Hans Verkuil wrote:
>> On 12/07/17 21:02, Eric Anholt wrote:
>>>> +static int vc4_hdmi_cec_adap_transmit(struct cec_adapter *adap, u8 at=
tempts,
>>>> +				      u32 signal_free_time, struct cec_msg *msg)
>>>> +{
>>>> +	struct vc4_dev *vc4 =3D cec_get_drvdata(adap);
>>>> +	u32 val;
>>>> +	unsigned int i;
>>>> +
>>>> +	for (i =3D 0; i < msg->len; i +=3D 4)
>>>> +		HDMI_WRITE(VC4_HDMI_CEC_TX_DATA_1 + i,
>>>> +			   (msg->msg[i]) |
>>>> +			   (msg->msg[i + 1] << 8) |
>>>> +			   (msg->msg[i + 2] << 16) |
>>>> +			   (msg->msg[i + 3] << 24));
>>>> +
>>>> +	val =3D HDMI_READ(VC4_HDMI_CEC_CNTRL_1);
>>>> +	val &=3D ~VC4_HDMI_CEC_START_XMIT_BEGIN;
>>>> +	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1, val);
>>>> +	val &=3D ~VC4_HDMI_CEC_MESSAGE_LENGTH_MASK;
>>>> +	val |=3D (msg->len - 1) << VC4_HDMI_CEC_MESSAGE_LENGTH_SHIFT;
>>>> +	val |=3D VC4_HDMI_CEC_START_XMIT_BEGIN;
>>>
>>> It doesn't look to me like len should have 1 subtracted from it.  The
>>> field has 4 bits for our up-to-16-byte length, and the firmware seems to
>>> be setting it to the same value as a memcpy for the message data uses.
>>=20
>> You need to subtract by one. The CEC protocol supports messages of 1-16
>> bytes in length. Since the message length mask is only 4 bits you need to
>> encode this in the value 0-15. Hence the '-1', otherwise you would never
>> be able to send 16 byte messages.
>>=20
>> I actually found this when debugging the messages it was transmitting: t=
hey
>> were one too long.
>>=20
>> This suggests that the firmware does this wrong. I don't have time tomor=
row,
>> but I'll see if I can do a quick test on Friday to verify that.
>
> I double-checked this and both the driver and the firmware do the right t=
hing.
> Just to be certain I also tried sending a message that uses the full 16 b=
yte
> payload and that too went well. So the code is definitely correct.

Great, I'll assume that I just missed the subtraction somewhere in the
layers of firmware code.  Thanks for checking!

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAlluhcsACgkQtdYpNtH8
nuhzrxAAkadhExKHeHtBjzk6sWwJfroAg/YX77Hpe9TXezA9Nd4N38IoZWDO5l0Y
33IDodgSFTdA7JtcxD6ElJ05VRydWNuwFcTSdDb+WX84N6V0qsTGNNW+XriKlxA3
HvlaQCioo3fkx7A5vmHFmmdUwX8eI6fxwxYL9Ec6hR5kfa1whe6XgMIhdYY/E7E6
BzU7OgYIUCgTe8/eqyMajmwYA47Cn1URVIV08z4yNxeKRE8570685DWntjPpfv5a
diGbqzEW8CqketPR6U99EebI9ZYSXTqhXLkJgOBSRiHDbmG4WJh1QI/kDXFlysfp
LoCD3VkRbpjsO0YIDXaYY1OOmIrvz71lQ8oGq72hJzl6UF8q0xJUCGTmWfRKPJl7
H00W4hM/DwQiJg0+jtdEfXf65ekxOvbHCc9rbPRadhPySGUB2F977bKDF+51f3R9
QELwcupSpitq4brI1YvPKrI5Avu1njqR4gFbNw8MMvf/65DipuSQbp22gbLs1ENB
oIX3GziwTFW4KiVenFCQq9MZ7CxUEjm6bwkqajy2YY/VxhWM0uxCJ3kOGG3rnL/2
l2I4cYqVwb94MzR72gGIZKa62tn1nzyYAXk6vXpXKkNL1/wmxVWisvLR6Tgv/kgt
ilOA8wftAdW16uE2MMWJ9hgUuYjtBi8uqS4vlYRBhksdVmQS7fs=
=L+6b
-----END PGP SIGNATURE-----
--=-=-=--
