Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:52103 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751201AbcKNJ21 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 04:28:27 -0500
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Mike Krinkin <krinkin.m.u@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH] usb: core: urb make use of usb_endpoint_maxp_mult
In-Reply-To: <20161114092121.GA31797@kroah.com>
References: <1479033076-2995-1-git-send-email-krinkin.m.u@gmail.com> <20161114092121.GA31797@kroah.com>
Date: Mon, 14 Nov 2016 11:27:48 +0200
Message-ID: <87r36ewgvf.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Greg KH <gregkh@linuxfoundation.org> writes:
> On Sun, Nov 13, 2016 at 01:31:16PM +0300, Mike Krinkin wrote:
>> Since usb_endpoint_maxp now returns only lower 11 bits mult
>> calculation here isn't correct anymore and that breaks webcam
>> for me. Patch make use of usb_endpoint_maxp_mult instead of
>> direct calculation.
>>=20
>> Fixes: abb621844f6a ("usb: ch9: make usb_endpoint_maxp() return
>>        only packet size")
>>=20
>> Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
>> ---
>>  drivers/usb/core/urb.c | 7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
>> index 0be49a1..d75cb8c 100644
>> --- a/drivers/usb/core/urb.c
>> +++ b/drivers/usb/core/urb.c
>> @@ -412,11 +412,8 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
>>  		}
>>=20=20
>>  		/* "high bandwidth" mode, 1-3 packets/uframe? */
>> -		if (dev->speed =3D=3D USB_SPEED_HIGH) {
>> -			int	mult =3D 1 + ((max >> 11) & 0x03);
>> -			max &=3D 0x07ff;
>> -			max *=3D mult;
>> -		}
>> +		if (dev->speed =3D=3D USB_SPEED_HIGH)
>> +			max *=3D usb_endpoint_maxp_mult(&ep->desc);
>>=20=20
>>  		if (urb->number_of_packets <=3D 0)
>>  			return -EINVAL;
>
> Felipe, this looks like it belongs in your tree...

Right, I've queued it up :-)

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAlgpg5QACgkQzL64meEa
mQY4Jg//WSt6Xf6iqrwZqGQk7/+cd0wNEooYRww9WiVXoSULN/+71DtrMVFvnuWw
i4jGvFsEhOoNhnICUPy7UTLt8L9yLPCQW7F6mbmlLYMIbU7NUSC05nuFOsDDzvAZ
Y9EJRORPLtjK0BBIVlH/Y1KuRNl4kXjqpg6Qn7BXp16uDf/FPIBz4H+jZIlL5YPk
X27d03xI4sIYbT4VtUyRD22uSyXkUEaM4918/2aWP9hG3gjSPseM0NJGkRX1BNDo
RomWcwiHu6inYOngKFBqFCHUTNIF7JvSm+ufY4l3DhXIjrX2KbbUns1yKqj8IayI
zEeU3HE8O2iGoHjewayjzUZz392WmZ1mm+pJY+GrWZ1+zLosyiHbLDyJQnpFAvff
IuQnUkvfuPBs855Nhm5W5a7a31sh3ytEqxZ1LyUh7or9gnLSwQSq29MtY4PLY2fE
0wAayuKK2VbLRNVuhCH6mV8TPHt8PpwkjXAaKd0GTvI2Mu31un/2/26aKXVM7NlL
tdFmBB6DWVEikIi/HJNhqHTtZNrJyaKSi8tPHvNEm18t9ekPFwWouzeX1bf5wA3G
HQ6zAdqakZtWu2w1u/Zi3G+S6SLSRQhsk+yXRgqgaix/Xg28FA2iuyGiXlRgTznz
EqGJMe9ivEWUGu2OAF+LrvFw5v/vWrf1AplVEWbS/rbf9YuHXtc=
=jWXy
-----END PGP SIGNATURE-----
--=-=-=--
