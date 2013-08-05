Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54128 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab3HEJS0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Aug 2013 05:18:26 -0400
Message-ID: <51FF6DD8.8080302@ti.com>
Date: Mon, 5 Aug 2013 12:18:16 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<dagriego@biglakesoftware.com>, <dale@farnsworth.org>,
	<pawel@osciak.com>, <m.szyprowski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 3/6] v4l: ti-vpe: Add VPE mem to mem driver
References: <1375452223-30524-1-git-send-email-archit@ti.com> <1375452223-30524-4-git-send-email-archit@ti.com>
In-Reply-To: <1375452223-30524-4-git-send-email-archit@ti.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="VaaBvmspi8tXWQsBRp6uEgFdP4igd0h3A"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--VaaBvmspi8tXWQsBRp6uEgFdP4igd0h3A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/08/13 17:03, Archit Taneja wrote:
> VPE is a block which consists of a single memory to memory path which c=
an
> perform chrominance up/down sampling, de-interlacing, scaling, and colo=
r space
> conversion of raster or tiled YUV420 coplanar, YUV422 coplanar or YUV42=
2
> interleaved video formats.
>=20
> We create a mem2mem driver based primarily on the mem2mem-testdev examp=
le.
> The de-interlacer, scaler and color space converter are all bypassed fo=
r now
> to keep the driver simple. Chroma up/down sampler blocks are implemente=
d, so
> conversion beteen different YUV formats is possible.
>=20
> Each mem2mem context allocates a buffer for VPE MMR values which it wil=
l use
> when it gets access to the VPE HW via the mem2mem queue, it also alloca=
tes
> a VPDMA descriptor list to which configuration and data descriptors are=
 added.
>=20
> Based on the information received via v4l2 ioctls for the source and
> destination queues, the driver configures the values for the MMRs, and =
stores
> them in the buffer. There are also some VPDMA parameters like frame sta=
rt and
> line mode which needs to be configured, these are configured by direct =
register
> writes via the VPDMA helper functions.
>=20
> The driver's device_run() mem2mem op will add each descriptor based on =
how the
> source and destination queues are set up for the given ctx, once the li=
st is
> prepared, it's submitted to VPDMA, these descriptors when parsed by VPD=
MA will
> upload MMR registers, start DMA of video buffers on the various input a=
nd output
> clients/ports.
>=20
> When the list is parsed completely(and the DMAs on all the output ports=
 done),
> an interrupt is generated which we use to notify that the source and de=
stination
> buffers are done.
>=20
> The rest of the driver is quite similar to other mem2mem drivers, we us=
e the
> multiplane v4l2 ioctls as the HW support coplanar formats.
>=20
> Signed-off-by: Archit Taneja <archit@ti.com>
> ---
>  drivers/media/platform/Kconfig           |   10 +
>  drivers/media/platform/Makefile          |    2 +
>  drivers/media/platform/ti-vpe/vpe.c      | 1763 ++++++++++++++++++++++=
++++++++
>  drivers/media/platform/ti-vpe/vpe_regs.h |  496 +++++++++
>  4 files changed, 2271 insertions(+)
>  create mode 100644 drivers/media/platform/ti-vpe/vpe.c
>  create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h

Just two quick comments, the same as to an earlier patch: consts for
tables, and "write" instead of "insert".

 Tomi



--VaaBvmspi8tXWQsBRp6uEgFdP4igd0h3A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR/23YAAoJEPo9qoy8lh71ToAP/jBuFdiNZaFZgCipB/v8vf1+
EFH24P58ZesyJ/bV1wCwy6UynkLHNkIcLEeoNDtpLsJE/FIoFpvrMaOeUynC6c/t
YW/b0Vc0/LvUAhfVLdcy7loh4yrZkM34CeqcN8D3a/2uTrHmggx7Ft2KHc4ytt9Y
VbSSeqkS04GLRMteDUxdu4uK2OjkiOXpfF4Ttb8cQNOL9M+qla/lkv6+MZpj8pcU
n16hua3OJTN7o3I/KP586qCQIjj/J/0JKSNJkK7dHX73y/cKlwKomzcSKUu3rkyk
gs9F2+R/zIbHh7gceM9XN0BFtqlUQc56otV6csPgBuMY+KyztVDeJdYfSasFm3o+
uYvIDGjVuUkfCMhZUgYlQvYIRRXowLmXXLCs5C5rl3HPWCJcIeZEZhyQjCx14B1O
CfRWFP2RUY/1AFNPqYdE1UuMMbBPSHiE3jpztmq+DNJJGRiw/GnTIlvKxqtHtOjC
DeB7SrzWp37O60/lY6w4sG+VGJwjKDUb5NAsP0VMyLJmwUFG27zbgpSRvTrgg6m7
prAWLnslvo6a0AUlqnG7CxC83QJdg5O0P6snx+TKq5H+ymf0NtN3D2aTMsV+44F/
vqxdyLdr1xjYShXGVNadh8BX/zYe2NdLOgHYnS5kbUGuq7cAsCvx1VoqT7Xz96VF
zsvj95xtDNTQaF35mzeE
=e5hE
-----END PGP SIGNATURE-----

--VaaBvmspi8tXWQsBRp6uEgFdP4igd0h3A--
