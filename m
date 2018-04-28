Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53202 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757745AbeD1Rcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 13:32:48 -0400
Subject: Re: [PATCH v2 2/8] v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad
 operation code
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <9839f231-f91c-ab54-fdba-f100a98a558d@ideasonboard.com>
 <13638427.AR7oG9JFQr@avalon> <1628120.9DFZQMBCSb@avalon>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <dc82b2a3-8a4a-ab86-e972-5c32d644329c@ideasonboard.com>
Date: Sat, 28 Apr 2018 18:32:43 +0100
MIME-Version: 1.0
In-Reply-To: <1628120.9DFZQMBCSb@avalon>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="tthlaFQiTKSdveU7JjxMt42YY4HTZmdHE"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tthlaFQiTKSdveU7JjxMt42YY4HTZmdHE
Content-Type: multipart/mixed; boundary="fWmBGNHJoWKX5rbfuZOAfVJdgxKhCIuYO";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-renesas-soc@vger.kernel.org
Message-ID: <dc82b2a3-8a4a-ab86-e972-5c32d644329c@ideasonboard.com>
Subject: Re: [PATCH v2 2/8] v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad
 operation code
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <9839f231-f91c-ab54-fdba-f100a98a558d@ideasonboard.com>
 <13638427.AR7oG9JFQr@avalon> <1628120.9DFZQMBCSb@avalon>
In-Reply-To: <1628120.9DFZQMBCSb@avalon>

--fWmBGNHJoWKX5rbfuZOAfVJdgxKhCIuYO
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 28/04/18 18:30, Laurent Pinchart wrote:
> Hi again,
>=20
> On Saturday, 28 April 2018 20:25:44 EEST Laurent Pinchart wrote:
>> On Saturday, 28 April 2018 20:16:11 EEST Kieran Bingham wrote:
>>> On 22/04/18 23:34, Laurent Pinchart wrote:
>>>> The implementation of the set_fmt pad operation is identical in the
>>>> three modules. Move it to a generic helper function.
>>>>
>>>> Signed-off-by: Laurent Pinchart
>>>> <laurent.pinchart+renesas@ideasonboard.com>
>>>
>>> Only a minor pair of comments below regarding source/sink pad
>>> descriptions.
>>>
>>> If it's not convenient/accurate to define these with an enum then don=
't
>>> worry about it.
>>
>> It's a good point. There are however other locations in vsp1_entity.c =
that
>> hardcode pad numbers, so I'll submit a patch on top of this series to =
fix
>> them all in one go.
>=20
> Actually I can compare the pad number to entity->source_pad, I'll updat=
e this=20
> patch accordingly in v3.

Perfect, that sounds more explicit, easier to read, and future proof agai=
nst
entities with multiple sinks, such as the BRx.

--
Kieran



--fWmBGNHJoWKX5rbfuZOAfVJdgxKhCIuYO--

--tthlaFQiTKSdveU7JjxMt42YY4HTZmdHE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlrksDsACgkQoR5GchCk
Yf09aA//dLSy2rUUTx+CpvarvWAzvnNQx+vPp/hOhGKhtRl7iD82LB5qR4sqvadr
GkWqzI+k7zcAqVP8b7/1CMcGLs/OE8izSTXu9ivekpYLQTb7zGBtqsq5Fv5LyCZ6
6E2PK8DfFrrdSk838GL8e/XEvhrK4QGIO9O0Es67PNBz1c8aSCIHXGJDOTd5tI13
Wud9mJwyahnRGYefN6IX8RUR0DZeVA9oQ9m/qOPusCaWdOHuze/2E44883JzDInD
gwu460UsbUWQQtGMufcDS/IMikATFsAHz4a/IBrdqIZhxoZLz6iVQXLnOkI4QIDi
c+pPeE9iCtvdumHh/5qzveJfPTcapY1DxBM7u7VKL56KCbPk6zFea5MdZMVJuX0o
hOv1amXFyKOghF8wb//TgtqjNA1VfJlJ6dlLkDqe/yTxfC6gDIERMs+/a5z/Lod3
+nLZT7nygc1pECHc3cDTV/inMFLIB+rnRyO6kXTDvNG2KtH5rWIVAz50Dwb31o7K
nclwng+WeIVo7ap669WlO6cD25Sx/U3JPDXUuynO/86WKnFn1PrTKqpQTgovfubv
kIcR2s1yekK3PMjlg40Yln+lD0g/+DHPNCVZ5bvmuzEE45wdT3hLHvFRLqjQN8Ek
LeuXAgEZq9xVsQ9ZyDNFMLX/gJS8HfgXaNiDPBg4ouYdygBGaz0=
=760i
-----END PGP SIGNATURE-----

--tthlaFQiTKSdveU7JjxMt42YY4HTZmdHE--
