Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:36641 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab3HEM0k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Aug 2013 08:26:40 -0400
Message-ID: <51FF99F5.6060509@ti.com>
Date: Mon, 5 Aug 2013 15:26:29 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<dagriego@biglakesoftware.com>, <dale@farnsworth.org>,
	<pawel@osciak.com>, <m.szyprowski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/6] v4l: ti-vpe: Create a vpdma helper library
References: <1375452223-30524-1-git-send-email-archit@ti.com> <1375452223-30524-2-git-send-email-archit@ti.com> <51FF5EB4.8090007@ti.com> <51FF8BF6.3060900@ti.com>
In-Reply-To: <51FF8BF6.3060900@ti.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="55g68llJ0KsxvediU4Jfbafig9VJPa5jx"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--55g68llJ0KsxvediU4Jfbafig9VJPa5jx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/08/13 14:26, Archit Taneja wrote:
> On Monday 05 August 2013 01:43 PM, Tomi Valkeinen wrote:

>>> +/*
>>> + * submit a list of DMA descriptors to the VPE VPDMA, do not wait
>>> for completion
>>> + */
>>> +int vpdma_submit_descs(struct vpdma_data *vpdma, struct
>>> vpdma_desc_list *list)
>>> +{
>>> +    /* we always use the first list */
>>> +    int list_num =3D 0;
>>> +    int list_size;
>>> +
>>> +    if (vpdma_list_busy(vpdma, list_num))
>>> +        return -EBUSY;
>>> +
>>> +    /* 16-byte granularity */
>>> +    list_size =3D (list->next - list->buf.addr) >> 4;
>>> +
>>> +    write_reg(vpdma, VPDMA_LIST_ADDR, (u32) list->buf.dma_addr);
>>> +    wmb();
>>
>> What is the wmb() for?
>=20
> VPDMA_LIST_ADDR needs to be written before VPDMA_LIST_ATTR, otherwise
> VPDMA doesn't work. wmb() ensures the ordering.

Are you sure it's needed? Here's an interesting thread about writing and
reading to registers: http://marc.info/?t=3D130588594900002&r=3D1&w=3D2

>>> +
>>> +    for (i =3D 0; i < 100; i++) {        /* max 1 second */
>>> +        msleep_interruptible(10);
>>
>> You call interruptible version here, but you don't handle the
>> interrupted case. I believe the loop will just continue looping, even =
if
>> the user interrupted.
>=20
> Okay. I think I don't understand the interruptible version correctly. W=
e
> don't need to msleep_interruptible here, we aren't waiting on any wake
> up event, we just want to wait till a bit gets set.

Well, I think the interruptible versions should be used when the user
(wel, userspace program) initiates the action. The user should have the
option to interrupt a possibly long running operation, which is what
msleep_interruptible() makes possible.

 Tomi



--55g68llJ0KsxvediU4Jfbafig9VJPa5jx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR/5n1AAoJEPo9qoy8lh71E2YP/2fGVCZX+aqzOrxbsUwOpBdp
9fsr3Lbtwgsg6M60rcMl6nd0XgNhCZ/5VdiK1g8IisCcx4YxSHMwwbfWzTsMwQrb
oTpJ58Tr/K/P959wj7afxx2/EB04T1rCsB3NdVNJ8nsi4H0R44/n1IAC3Nnudcfu
qiEioNPXAN9wFWndbNWtK9P2VmTFWAcse2I7R2gec2v5QbI/p/1d233k42fCxRNc
Sk2AFvXoprejb23HRp/XFirGsgCavH+Q4CUnkwKgorFuDvwtYJaWuI1ed0rWv6Bl
iBsYNmudh1GaQI7Sf3hbR1shihG9Wv9PIqsH+rKcRMlYPzIgJuGYxY/FuPb8YY4e
NYux03imXFi4XMpHNfTXzP21w1o2s3Aune/TqjXVJufUbHHT2qh51X2K3yZemuac
m8TfLXXl/dIXzarSIydZ9jyLOF3uf/BEDIE/oWqQmFL4zVhzkQxGrhbjYaaeT9kk
7JJJw0iu/2g8oIRYnADoT4i5MS9cFTl5lWi9oj7aBiyAqqsBCMMtXtfEz53+s53B
n6HmXyBQKWxoexYk6sLDdUNIV1TMd2h3CyEOZp7d3jzlrcQoSYahxZkvKAafnahK
J3SyXe1Nx13azWP4dOUFk6o9LZPTj20kjIrsAXdYUNYeg3yjZyzrLse6rekb2PZA
2ri5QytywH4ax44tTHrN
=6Tgt
-----END PGP SIGNATURE-----

--55g68llJ0KsxvediU4Jfbafig9VJPa5jx--
