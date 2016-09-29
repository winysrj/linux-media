Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24199 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752029AbcI2Jou (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Sep 2016 05:44:50 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux USB <linux-usb@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH 14/45] media: usb: uvc: make use of new usb_endpoint_maxp_mult()
In-Reply-To: <2520132.9qLLxPy19B@avalon>
References: <20160928130554.29790-1-felipe.balbi@linux.intel.com> <20160928130554.29790-15-felipe.balbi@linux.intel.com> <2520132.9qLLxPy19B@avalon>
Date: Thu, 29 Sep 2016 12:44:29 +0300
Message-ID: <87d1jnoxaa.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Laurent Pinchart <laurent.pinchart@ideasonboard.com> writes:
> Hi Felipe,
>
> Thanks for the patch.
>
> On Wednesday 28 Sep 2016 16:05:23 Felipe Balbi wrote:
>> We have introduced a helper to calculate multiplier
>> value from wMaxPacketSize. Start using it.
>>=20
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: <linux-media@vger.kernel.org>
>> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
>> ---
>>  drivers/media/usb/uvc/uvc_video.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/media/usb/uvc/uvc_video.c
>> b/drivers/media/usb/uvc/uvc_video.c index b5589d5f5da4..11e0e5f4e1c2 100=
644
>> --- a/drivers/media/usb/uvc/uvc_video.c
>> +++ b/drivers/media/usb/uvc/uvc_video.c
>> @@ -1467,6 +1467,7 @@ static unsigned int uvc_endpoint_max_bpi(struct
>> usb_device *dev, struct usb_host_endpoint *ep)
>>  {
>>  	u16 psize;
>> +	u16 mult;
>>=20
>>  	switch (dev->speed) {
>>  	case USB_SPEED_SUPER:
>> @@ -1474,7 +1475,8 @@ static unsigned int uvc_endpoint_max_bpi(struct
>> usb_device *dev, return le16_to_cpu(ep->ss_ep_comp.wBytesPerInterval);
>>  	case USB_SPEED_HIGH:
>>  		psize =3D usb_endpoint_maxp(&ep->desc);
>> -		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
>> +		mult =3D usb_endpoint_maxp_mult(&ep->desc);
>> +		return (psize & 0x07ff) * mult;
>
> I believe you can remove the & 0x07ff here after patch 28/45.
>
> This being said, wouldn't it be useful to introduce a helper function tha=
t=20
> performs the full computation instead of requiring usage of two helpers t=
hat=20
> both call __le16_to_cpu() on the same field ? Or possibly turn the whole=
=20
> uvc_endpoint_max_bpi() function into a core helper ? I haven't checked wh=
ether=20
> it can be useful to other drivers though.

it's probably not useful for many other drivers. The multiplier is only
valid for High-speed Isochronous and Interrupt endpoints. If it's not
High speed, we don't care. If it's not Isoc or Int, we don't care.

If we have a single helper, we are likely gonna be doing extra
computation for no reason. Moreover, this is only called once during
probe(), there's really nothing to optimize here.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX7OJ9AAoJEMy+uJnhGpkGbRUQAICjFslDGoMkO8RmKYYbZcWH
1UXGRLLAdy3hIa0Igcgs9yo3R19/bWwKNnTa1pkaJ7GRHvmJ3uOnAs3Ntt/xWN35
zAfDFQXuJuMo1TLOU+Bp4oPcy0MAM921DY0DU5xXeLMI0TwTusV9FR/cvfL91k5a
bpSLXz1W3jjg2xBP6uE/yg3z0uYhdIqniota9LOhX9cfYeo9kLUIdqoMAKHI6kE9
4Mfr2aZKRf2g4yItstTSse2RpCS/iJGCW/ior4OjHrq0FZ6lhlGoIGrf6Nma4ibF
vREX7melTaQ7PNXyRcjZ6OB+DXVOHdLXo6Z5cjGKf3EkyJg1KrIA5On6E1Ij1nOy
qUBBDArDR1VhoDIU1FjFdpX7PvYfob361R2UAy9imrZEjNDW16kTsA0wBx+WKkYM
WVqsqkJaPQQ4pt6E2nIS3zlDV67TZkZ9x56vSryrQ7A26mp9e4tq/ljvUapEYxLa
5n3KnYlTI8Npx/vZ7JBK8RSVKSI1Av/o1038FLTEWU4pwZf/d3mpPqcmTnDKPsow
f4/fFIh0p8ikS6+QIwNITJNJODIMO8sjx2gD29iiFQEQXYWR0DpLOuwIzjZCpPeR
aUbYWaJgUbfJpUadnllfQiVdVOOsTv8dyrzsMoF5E9q9t4BFyt5czbkSLKsDzoln
nhQ2wrWMcLbuD+LBIpzL
=w2U1
-----END PGP SIGNATURE-----
--=-=-=--
