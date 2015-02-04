Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:53801 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965563AbbBDNVt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 08:21:49 -0500
Message-ID: <54D21CEB.1090506@butterbrot.org>
Date: Wed, 04 Feb 2015 14:21:47 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <54D1F2CA.9020201@xs4all.nl> <54D1FAFA.3070506@butterbrot.org> <10701805.dDfTQCs2MO@avalon> <54D204F2.3040006@xs4all.nl>
In-Reply-To: <54D204F2.3040006@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="okEsiP7JVDFVIjQ6WICdtRdWHwdx4VeDO"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--okEsiP7JVDFVIjQ6WICdtRdWHwdx4VeDO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello everyone,

On 04.02.2015 12:39, Hans Verkuil wrote:
> On 02/04/15 12:34, Laurent Pinchart wrote:
>> On Wednesday 04 February 2015 11:56:58 Florian Echtler wrote:
>>> That's what I assumed, however, I'm running into the same problem as
>>> with dma-sg when I switch to vmalloc...?
>>
>> I don't expect vmalloc to work, as you can't DMA to vmalloc memory dir=
ectly=20
>> without any IOMMU in the general case (the allocated memory being phys=
ically=20
>> fragmented).
>>
>> dma-sg should work though, but you won't be able to use usb_bulk_msg()=
=2E You=20
>> need to create the URBs manually, set their sg and num_sgs fields and =
submit=20
>> them.
Can I also use usb_sg_init/_wait for this? I can't find any other driver
which uses USB in conjunction with dma-sg, can you suggest one I could
use as an example?

> Anyway Florian, based on Laurent's explanation I think trying to make
> dma-sg work seems to be the best solution. And I've learned something
> new :-)
Thanks for the clarification, please ignore the v2 patch submission for
now :-)

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--okEsiP7JVDFVIjQ6WICdtRdWHwdx4VeDO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlTSHOsACgkQ7CzyshGvatinlgCgotk+2kJQDeDmYBOUqzCY46D3
+NgAoKkQ8ndwNwPKBYbYQj+U9tqriHQt
=N6jX
-----END PGP SIGNATURE-----

--okEsiP7JVDFVIjQ6WICdtRdWHwdx4VeDO--
