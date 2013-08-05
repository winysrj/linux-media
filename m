Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49264 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab3HEINv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Aug 2013 04:13:51 -0400
Message-ID: <51FF5EB4.8090007@ti.com>
Date: Mon, 5 Aug 2013 11:13:40 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<dagriego@biglakesoftware.com>, <dale@farnsworth.org>,
	<pawel@osciak.com>, <m.szyprowski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/6] v4l: ti-vpe: Create a vpdma helper library
References: <1375452223-30524-1-git-send-email-archit@ti.com> <1375452223-30524-2-git-send-email-archit@ti.com>
In-Reply-To: <1375452223-30524-2-git-send-email-archit@ti.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="K1spFsIeMBEIGn0cDmXurTREiLifVKnCe"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--K1spFsIeMBEIGn0cDmXurTREiLifVKnCe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 02/08/13 17:03, Archit Taneja wrote:

> +struct vpdma_data_format vpdma_yuv_fmts[] =3D {
> +	[VPDMA_DATA_FMT_Y444] =3D {
> +		.data_type	=3D DATA_TYPE_Y444,
> +		.depth		=3D 8,
> +	},

This, and all the other tables, should probably be consts?

> +static void insert_field(u32 *valp, u32 field, u32 mask, int shift)
> +{
> +	u32 val =3D *valp;
> +
> +	val &=3D ~(mask << shift);
> +	val |=3D (field & mask) << shift;
> +	*valp =3D val;
> +}

I think "insert" normally means, well, inserting a thing in between
something. What you do here is overwriting.

Why not just call it "write_field"?

> + * Allocate a DMA buffer
> + */
> +int vpdma_buf_alloc(struct vpdma_buf *buf, size_t size)
> +{
> +	buf->size =3D size;
> +	buf->mapped =3D 0;

Maybe true/false is clearer here that 0/1.

> +/*
> + * submit a list of DMA descriptors to the VPE VPDMA, do not wait for =
completion
> + */
> +int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_lis=
t *list)
> +{
> +	/* we always use the first list */
> +	int list_num =3D 0;
> +	int list_size;
> +
> +	if (vpdma_list_busy(vpdma, list_num))
> +		return -EBUSY;
> +
> +	/* 16-byte granularity */
> +	list_size =3D (list->next - list->buf.addr) >> 4;
> +
> +	write_reg(vpdma, VPDMA_LIST_ADDR, (u32) list->buf.dma_addr);
> +	wmb();

What is the wmb() for?

> +	write_reg(vpdma, VPDMA_LIST_ATTR,
> +			(list_num << VPDMA_LIST_NUM_SHFT) |
> +			(list->type << VPDMA_LIST_TYPE_SHFT) |
> +			list_size);
> +
> +	return 0;
> +}

> +static void vpdma_firmware_cb(const struct firmware *f, void *context)=

> +{
> +	struct vpdma_data *vpdma =3D context;
> +	struct vpdma_buf fw_dma_buf;
> +	int i, r;
> +
> +	dev_dbg(&vpdma->pdev->dev, "firmware callback\n");
> +
> +	if (!f || !f->data) {
> +		dev_err(&vpdma->pdev->dev, "couldn't get firmware\n");
> +		return;
> +	}
> +
> +	/* already initialized */
> +	if (get_field_reg(vpdma, VPDMA_LIST_ATTR, VPDMA_LIST_RDY_MASK,
> +			VPDMA_LIST_RDY_SHFT)) {
> +		vpdma->ready =3D true;
> +		return;
> +	}
> +
> +	r =3D vpdma_buf_alloc(&fw_dma_buf, f->size);
> +	if (r) {
> +		dev_err(&vpdma->pdev->dev,
> +			"failed to allocate dma buffer for firmware\n");
> +		goto rel_fw;
> +	}
> +
> +	memcpy(fw_dma_buf.addr, f->data, f->size);
> +
> +	vpdma_buf_map(vpdma, &fw_dma_buf);
> +
> +	write_reg(vpdma, VPDMA_LIST_ADDR, (u32) fw_dma_buf.dma_addr);
> +
> +	for (i =3D 0; i < 100; i++) {		/* max 1 second */
> +		msleep_interruptible(10);

You call interruptible version here, but you don't handle the
interrupted case. I believe the loop will just continue looping, even if
the user interrupted.

> +		if (get_field_reg(vpdma, VPDMA_LIST_ATTR, VPDMA_LIST_RDY_MASK,
> +				VPDMA_LIST_RDY_SHFT))
> +			break;
> +	}
> +
> +	if (i =3D=3D 100) {
> +		dev_err(&vpdma->pdev->dev, "firmware upload failed\n");
> +		goto free_buf;
> +	}
> +
> +	vpdma->ready =3D true;
> +
> +free_buf:
> +	vpdma_buf_unmap(vpdma, &fw_dma_buf);
> +
> +	vpdma_buf_free(&fw_dma_buf);
> +rel_fw:
> +	release_firmware(f);
> +}

 Tomi



--K1spFsIeMBEIGn0cDmXurTREiLifVKnCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR/160AAoJEPo9qoy8lh71vFUQAKXy1ffTyfQ2Pa4wyFHOQWh9
LFQBt5s2Yh38LYV2ucRSfwC2EiXV0k2N0Cp36iiNAufWejbZuyacKW9pjuDXi7ow
jM030JnWGQ/SkrSuXUid9zqoAZKzgIkoMo/MqhipBIVV1Rg5iDtGtxaxmeF72pJY
X9D1gcxrmMXRZ9nChfN5M7igzvu9AFdv3WFYX2su0uS+7g3Jd7cdP9Ik9+QISyTY
lxb6eRxe3afAu54kqWTux+OBuwyBP+y00bTgDgeghZPg5Cac8yitEolb8kiL2mVr
8EruSdnoQdFUtQhuBUOMTiJxWa+RqovgwntgMOV84INEMlG2b3sN3vfA4wd0RrJD
fXG+/Mlm0cVs8EcY7R3rzLZWYNt2PHY7KQ3tmJ1fN1jSFkcJfCeQpBgGQ2ft0yP2
PzlCVB+4igFt4kCrxWgmFAXalt0qeNUb/7JEYhPO1I0FSZTlFYKnhRAWea7WoMHA
UZpGaDFMiQHI5MpTNXEJU+Jh+66Cm3ZC9miUxdA9UYmbFguNHXWZozpzeb2ckcHH
MlVr3dktcQAa/vv5vpFsX5IRnYCcP8s+zhE0NHnCJaCpf4MXrcZ6PKigLPmBfm1u
QoYtMYXVX27k+RdjNhN0gfRw+Z1E7KnX5+LB9r/CqjtvPVIXJZ4qrbSIqoKn3feB
ae85BuTnIFLvHCbnzktE
=micU
-----END PGP SIGNATURE-----

--K1spFsIeMBEIGn0cDmXurTREiLifVKnCe--
