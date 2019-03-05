Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AB9C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 10:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEFFB20684
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 10:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfCEKRj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 05:17:39 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:59491 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfCEKRj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 05:17:39 -0500
X-Originating-IP: 90.88.147.150
Received: from localhost (aaubervilliers-681-1-27-150.w90-88.abo.wanadoo.fr [90.88.147.150])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 9E66B40003;
        Tue,  5 Mar 2019 10:17:32 +0000 (UTC)
Date:   Tue, 5 Mar 2019 11:17:32 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jonas@kwiboo.se, ezequiel@collabora.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v4 2/2] media: cedrus: Add H264 decoding support
Message-ID: <20190305101732.3eylxubiiboygjc5@flea>
References: <cover.1862a43851950ddee041d53669f8979aba863c38.1550672228.git-series.maxime.ripard@bootlin.com>
 <864825e62e758ea51b61228a7ff140050810b48d.1550672228.git-series.maxime.ripard@bootlin.com>
 <1717029.ugS2kBEt89@jernej-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pw4bd57r6anjhsnu"
Content-Disposition: inline
In-Reply-To: <1717029.ugS2kBEt89@jernej-laptop>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--pw4bd57r6anjhsnu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jernej,

On Wed, Feb 20, 2019 at 06:50:54PM +0100, Jernej =C5=A0krabec wrote:
> I really wanted to do another review on previous series but got distracte=
d by=20
> analyzing one particulary troublesome H264 sample. It still doesn't work=
=20
> correctly, so I would ask you if you can test it with your stack (it migh=
t be=20
> userspace issue):
>=20
> http://jernej.libreelec.tv/videos/problematic/test.mkv
>=20
> Please take a look at my comments below.

I'd really prefer to focus on getting this merged at this point, and
then fixing odd videos and / or setups we can find later
on. Especially when new stacks are going to be developped on top of
this, I'm sure we're going to have plenty of bugs to address :)

> Dne sreda, 20. februar 2019 ob 15:17:34 CET je Maxime Ripard napisal(a):
> > Introduce some basic H264 decoding support in cedrus. So far, only the
> > baseline profile videos have been tested, and some more advanced featur=
es
> > used in higher profiles are not even implemented.
>=20
> What is not yet implemented? Multi slice frame decoding, interlaced frame=
s and=20
> decoding frames with width > 2048. Anything else?

Off the top of my head, nope.

> > +static void cedrus_h264_write_sram(struct cedrus_dev *dev,
> > +				   enum cedrus_h264_sram_off off,
> > +				   const void *data, size_t len)
> > +{
> > +	const u32 *buffer =3D data;
> > +	size_t count =3D DIV_ROUND_UP(len, 4);
> > +
> > +	cedrus_write(dev, VE_AVC_SRAM_PORT_OFFSET, off << 2);
> > +
> > +	do {
> > +		cedrus_write(dev, VE_AVC_SRAM_PORT_DATA, *buffer++);
> > +	} while (--count);
>=20
> Above loop will still write one word for count =3D 0. I propose following:
>=20
> while (count--)
> 	cedrus_write(dev, VE_AVC_SRAM_PORT_DATA, *buffer++);

Good catch, thanks!

> > +	position =3D find_next_zero_bit(&used_dpbs, CEDRUS_H264_FRAME_NUM,
> > +				      output);
> > +	if (position >=3D CEDRUS_H264_FRAME_NUM)
> > +		position =3D find_first_zero_bit(&used_dpbs,=20
> CEDRUS_H264_FRAME_NUM);
>=20
> I guess you didn't try any interlaced videos? Sometimes it happens that b=
uffer=20
> is reference and output at the same time. In such cases, above code would=
 make=20
> two entries, which doesn't work based on Kwiboo's and my experiments.
>=20
> I guess decoding interlaced videos is out of scope at this time?

Yep, and that should be pretty easy to fix.

> > +
> > +	output_buf =3D vb2_to_cedrus_buffer(&run->dst->vb2_buf);
> > +	output_buf->codec.h264.position =3D position;
> > +
> > +	if (slice->flags & V4L2_H264_SLICE_FLAG_FIELD_PIC)
> > +		output_buf->codec.h264.pic_type =3D=20
> CEDRUS_H264_PIC_TYPE_FIELD;
> > +	else if (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD)
> > +		output_buf->codec.h264.pic_type =3D=20
> CEDRUS_H264_PIC_TYPE_MBAFF;
> > +	else
> > +		output_buf->codec.h264.pic_type =3D=20
> CEDRUS_H264_PIC_TYPE_FRAME;
> > +
> > +	cedrus_fill_ref_pic(ctx, output_buf,
> > +			    dec_param->top_field_order_cnt,
> > +			    dec_param->bottom_field_order_cnt,
> > +			    &pic_list[position]);
> > +
> > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_FRAMEBUFFER_LIST,
> > +			       pic_list, sizeof(pic_list));
> > +
> > +	cedrus_write(dev, VE_H264_OUTPUT_FRAME_IDX, position);
> > +}
> > +
> > +#define CEDRUS_MAX_REF_IDX	32
> > +
> > +static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
> > +				   struct cedrus_run *run,
> > +				   const u8 *ref_list, u8 num_ref,
> > +				   enum cedrus_h264_sram_off sram)
> > +{
> > +	const struct v4l2_ctrl_h264_decode_param *decode =3D run-
> >h264.decode_param;
> > +	struct vb2_queue *cap_q =3D &ctx->fh.m2m_ctx->cap_q_ctx.q;
> > +	const struct vb2_buffer *dst_buf =3D &run->dst->vb2_buf;
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	u8 sram_array[CEDRUS_MAX_REF_IDX];
> > +	unsigned int i;
> > +	size_t size;
> > +
> > +	memset(sram_array, 0, sizeof(sram_array));
> > +
> > +	for (i =3D 0; i < num_ref; i++) {
> > +		const struct v4l2_h264_dpb_entry *dpb;
> > +		const struct cedrus_buffer *cedrus_buf;
> > +		const struct vb2_v4l2_buffer *ref_buf;
> > +		unsigned int position;
> > +		int buf_idx;
> > +		u8 dpb_idx;
> > +
> > +		dpb_idx =3D ref_list[i];
> > +		dpb =3D &decode->dpb[dpb_idx];
> > +
> > +		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> > +			continue;
> > +
> > +		buf_idx =3D vb2_find_timestamp(cap_q, dpb->timestamp, 0);
> > +		if (buf_idx < 0)
> > +			continue;
> > +
> > +		ref_buf =3D to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> > +		cedrus_buf =3D vb2_v4l2_to_cedrus_buffer(ref_buf);
> > +		position =3D cedrus_buf->codec.h264.position;
> > +
> > +		sram_array[i] |=3D position << 1;
> > +		if (ref_buf->field =3D=3D V4L2_FIELD_BOTTOM)
>=20
> I'm still not convinced that checking buffer field is appropriate solutio=
n here.=20
> IMO this bit defines top or bottom reference and same buffer could be use=
d for=20
> both.
>=20
> But I guess this belongs for follow up patch which will fix decoding inte=
rlaced=20
> videos.

And we can always change the API later on if we find that not adequate

> > +static void cedrus_write_scaling_lists(struct cedrus_ctx *ctx,
> > +				       struct cedrus_run *run)
> > +{
> > +	const struct v4l2_ctrl_h264_scaling_matrix *scaling =3D
> > +		run->h264.scaling_matrix;
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +	if (!scaling)
> > +		return;
> > +
> > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_8x8_0,
> > +			       scaling->scaling_list_8x8[0],
> > +			       sizeof(scaling->scaling_list_8x8[0]));
> > +
> > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_8x8_1,
> > +			       scaling->scaling_list_8x8[1],
> > +			       sizeof(scaling->scaling_list_8x8[1]));
>=20
> Index above should be 3. IIRC 1 and 3 are used by 4:2:0 chroma subsamplin=
g,=20
> but currently I'm unable to find reference to that in standard.

Yep, indeed, I'll fix that, thanks!

> > +
> > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_4x4,
> > +			       scaling->scaling_list_4x4,
> > +			       sizeof(scaling->scaling_list_4x4));
> > +}
> > +
> > +static void cedrus_write_pred_weight_table(struct cedrus_ctx *ctx,
> > +					   struct cedrus_run=20
> *run)
> > +{
> > +	const struct v4l2_ctrl_h264_slice_param *slice =3D
> > +		run->h264.slice_param;
> > +	const struct v4l2_h264_pred_weight_table *pred_weight =3D
> > +		&slice->pred_weight_table;
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	int i, j, k;
> > +
> > +	cedrus_write(dev, VE_H264_SHS_WP,
> > +		     ((pred_weight->chroma_log2_weight_denom & 0xf) <<=20
> 4) |
> > +		     ((pred_weight->luma_log2_weight_denom & 0xf) <<=20
> 0));
>=20
> Denominators are only in range of 0-7, so mask should be 0x7. CedarX code=
 also=20
> specify those two fields 3 bits wide.

Indeed, I'll fix it.

> > +
> > +	cedrus_write(dev, VE_AVC_SRAM_PORT_OFFSET,
> > +		     CEDRUS_SRAM_H264_PRED_WEIGHT_TABLE << 2);
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(pred_weight->weight_factors); i++) {
> > +		const struct v4l2_h264_weight_factors *factors =3D
> > +			&pred_weight->weight_factors[i];
> > +
> > +		for (j =3D 0; j < ARRAY_SIZE(factors->luma_weight); j++) {
> > +			u32 val;
> > +
> > +			val =3D ((factors->luma_offset[j] & 0x1ff) << 16)=20
> |
> > +				(factors->luma_weight[j] & 0x1ff);
> > +			cedrus_write(dev, VE_AVC_SRAM_PORT_DATA,=20
> val);
>=20
> You should cast offset varible to wider type. Currently some videos which=
 use=20
> prediction weight table don't work for me, unless offset is casted to u32=
 first.=20
> Shifting 8 bit variable for 16 places gives you 0 every time.

I'll do it.

> Luma offset and weight are defined as s8, so having wider mask doesn't re=
ally=20
> make sense. However, I think weight should be s16 anyway, because standar=
d=20
> says that it's value could be 2^denominator for default value or in range=
=20
> -128..127. Worst case would be 2^7 =3D 128 and -128. To cover both values=
 you=20
> need at least 9 bits.

But if I understood the spec right, in that case you would just have
the denominator set, and not the offset, while the offset is used if
you don't use the default formula (and therefore remains in the -128
127 range which is covered by the s8), right?

> > +	reg =3D 0;
> > +	if (!(scaling && (pps->flags &
> > V4L2_H264_PPS_FLAG_PIC_SCALING_MATRIX_PRESENT))) +		reg |=3D
> > VE_H264_SHS_QP_SCALING_MATRIX_DEFAULT;
> > +	reg |=3D (pps->second_chroma_qp_index_offset & 0x3f) << 16;
> > +	reg |=3D (pps->chroma_qp_index_offset & 0x3f) << 8;
> > +	reg |=3D (pps->pic_init_qp_minus26 + 26 + slice->slice_qp_delta) &=20
> 0x3f;
> > +	cedrus_write(dev, VE_H264_SHS_QP, reg);
> > +
> > +	// clear status flags
> > +	cedrus_write(dev, VE_H264_STATUS, cedrus_read(dev,=20
> VE_H264_STATUS));
>=20
> I'm not sure clearing status here is needed. Do you have any case where i=
t is=20
> need? Maybe if some error happened before and cedrus_h264_irq_clear() was=
n't=20
> cleared. I'm fine either way.=20

Yeah, it's just some extra precaution.

> > +
> > +	// enable int
> > +	reg =3D cedrus_read(dev, VE_H264_CTRL);
> > +	cedrus_write(dev, VE_H264_CTRL, reg |
> > +		     VE_H264_CTRL_SLICE_DECODE_INT |
> > +		     VE_H264_CTRL_DECODE_ERR_INT |
> > +		     VE_H264_CTRL_VLD_DATA_REQ_INT);
>=20
> Since this is the only place where you set VE_H264_CTRL, I wouldn't prese=
rve=20
> previous content. This mode is also capable of decoding VP8 and AVS. So i=
n=20
> theory, if user would want to decode H264 and VP8 videos at the same time=
,=20
> preserving content will probably corrupt your output. I would just set al=
l=20
> other bits to 0. What do you think? I tested this without preservation an=
d it=20
> works fine.

I'll change it.

> > +	/*
> > +	 * FIXME: This is actually conditional to
> > +	 * V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY not being set, we might
> > +	 * have to rework this if memory efficiency ever is something
> > +	 * we need to work on.
> > +	 */
> > +	field_size =3D field_size * 2;
> > +	ctx->codec.h264.mv_col_buf_field_size =3D field_size;
>=20
> CedarX code aligns this buffer to 1024. Should we do it too just to be on=
 the=20
> safe side? I don't think it cost us anything due to dma_alloc_coherent()=
=20
> alignments.

dma_alloc_coherent will operate on pages, so it doesn't make any
difference there.

> Sorry again for a bit late in-depth review.

Thanks a lot!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--pw4bd57r6anjhsnu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXH5MvAAKCRDj7w1vZxhR
xefqAQDiAcXfw66HqHpS3yW37QdnD3XBgheLiq30g3w+sEQhQgD8CfluL4q3Cm6b
dTyXmGJMg72/klo2rR7oD9w5WlroLQI=
=/tZl
-----END PGP SIGNATURE-----

--pw4bd57r6anjhsnu--
