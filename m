Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:35076 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756144AbeDXI27 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 04:28:59 -0400
Subject: Re: [PATCH v2] [media] uvcvideo: Refactor teardown of uvc on USB
 disconnect
To: Hans Verkuil <hverkuil@xs4all.nl>, Li Li <aawlbt@gmail.com>,
        linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <CAJXMgdov1mLojsRTU5ea4Whf9i-g8fwCX97fueH6dHt8qmC_1Q@mail.gmail.com>
 <c9813acf-ee0e-4dc8-6902-965504ac0707@xs4all.nl>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <f36b9180-9c5b-9482-ebe0-c7cc48a721f6@ideasonboard.com>
Date: Tue, 24 Apr 2018 09:28:44 +0100
MIME-Version: 1.0
In-Reply-To: <c9813acf-ee0e-4dc8-6902-965504ac0707@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="gL069C6AJ1DTs2maoP76g0FGjAiVJAYuw"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gL069C6AJ1DTs2maoP76g0FGjAiVJAYuw
Content-Type: multipart/mixed; boundary="GADvQDrl40SD9dxzwjLpgh4CcbKeXUZEi";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, Li Li <aawlbt@gmail.com>,
 linux-media@vger.kernel.org,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <f36b9180-9c5b-9482-ebe0-c7cc48a721f6@ideasonboard.com>
Subject: Re: [PATCH v2] [media] uvcvideo: Refactor teardown of uvc on USB
 disconnect
References: <CAJXMgdov1mLojsRTU5ea4Whf9i-g8fwCX97fueH6dHt8qmC_1Q@mail.gmail.com>
 <c9813acf-ee0e-4dc8-6902-965504ac0707@xs4all.nl>
In-Reply-To: <c9813acf-ee0e-4dc8-6902-965504ac0707@xs4all.nl>

--GADvQDrl40SD9dxzwjLpgh4CcbKeXUZEi
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On 23/04/18 20:12, Hans Verkuil wrote:
> Laurent, Kieran,
>=20
> Can one of you look at this?
>=20
> https://patchwork.linuxtv.org/patch/40941/

Looking through it now. Looks good so far - I'll try it against my Async =
UVC
work as well! It looks like there won't be conflicts though.

I now have a filter on my mailinglists so that I will see UVC related pat=
ches
posted to linux-media more prominently, but that's fairly recent. Perhaps=
 I
should add myself to the MAINTAINERS file for UVC so I get CC'd on releva=
nt
patches too.

> BTW, there are a *lot* of old patches delegated to you, Laurent. If nei=
ther
> you or Kieran have time to look at them, then please undelegate them an=
d I
> can take a bunch of them. I see quite a few simple bug fixes (e.g.
> https://patchwork.linuxtv.org/patch/42935/) that really should be merge=
d.

Is there anyway I can filter patchwork to see patches delegated to Lauren=
t
(without signing in as Laurent that is :D )

Regards

Kieran


> Regards,
>=20
> 	Hans
>=20
> On 04/23/2018 07:59 PM, Li Li wrote:
>> https://www.spinics.net/lists/linux-media/msg115062.html
>>
>> Thanks for Daniel to fix this old issue. I might overlooked it but I
>> didn't find it in the latest upstream kernel.
>>
>> Are we going to merge this missing patch? Thanks!
>>
>> Best,
>> Li
>>
>=20


--GADvQDrl40SD9dxzwjLpgh4CcbKeXUZEi--

--gL069C6AJ1DTs2maoP76g0FGjAiVJAYuw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlre6sYACgkQoR5GchCk
Yf1QXA/9FH4IVHHbTPOpYktVju/CZLGtaemjYKZH+VaVrKmf+l0uKHznRvtwag23
5pzsHkVG7E/BzM22Sbir48xfRtZGKZg4O0x+ROjNt8jD5RROMi42QA1ankIiYOgl
hb4yfW90p5DaIJ3zdzvzxgPh+jbuWmTcJ1rcSOmEwcjL2i0Jw/+qD7A9bv40/CMG
bgocg4KB3Ed8QKIqqslHkd81OgO76muqp05co5zWcimqezeXLvM6+I53KFmIkTO0
RQuPFX/hUeRtyDBWvizD/4SOFvma1vhy7/RyhdrPU1A9g74LOhyKr7/fk0mz5ZL1
nMfYm0mQ43jHCYtWi3QIYFMPTMwp2kgJsuHDMaNa4i/Hlaom67YQY42TedniKUae
+XwSMJtXfz61w8kRiCiYg03W1HSMJ4p1fOFjsI4hB3UIvapvseT3SiYBTXl1KNxP
2hHgsANODLHA5JLupcTveEmkzeYcVakZA+e7BArg8cBX7XTNUwDBRlriZCn+F1Xe
DWESBG1aK7g97aEhaqMRKNih4gWwBvx1oeU6l6dZfut/bY9OqcXJU8x6TavpOz1x
RQ5fBeJhapaOzwmraXvGhYJ0BNOnWqxqQNG/NBVvAdP63DYNxlNmwPgZLGX/GjBy
mx8aPPQr9eMmSZ8mxj8IXf5qUMDe72xjuOMvy2DGDOW8ghbQaJc=
=9FDa
-----END PGP SIGNATURE-----

--gL069C6AJ1DTs2maoP76g0FGjAiVJAYuw--
