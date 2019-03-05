Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4DAC4360F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 17:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77DE020842
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 17:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8VR/1ns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfCERFQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:05:16 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44899 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfCERFQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 12:05:16 -0500
Received: by mail-wr1-f67.google.com with SMTP id w2so10290449wrt.11;
        Tue, 05 Mar 2019 09:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0rIQ23b82KNvAjyy8VyUiujyHxPv2fKEUVNQ4h0FuCc=;
        b=W8VR/1nsWrFG64s9a45ixMkH0fk9/45AtRcyVK/MaQAJlKsSDY+ZKrOttg6aZFkMPq
         Q2G7Y389CdkTCf2kC7Z9XQfIJHNDk6SeRTII5Scj8lkj9G9h1MPZlq6VxHnQwoOt61J3
         sJyGpCnTP3lZLF39UWZarFLHCkiO+KM2sK01hZ1XGYq0n86l+9gunp4apYv41DQf7YHq
         0UJazzSmQO8kRDZkbCRJ1OyLlEgt7/VDqz+AujrEwxgN1ShMBEGDImS/378HkexACe2i
         D+NzVlZ7aXvoKao5GKCBpM1feIdH4EkCfzavOwVBnTyBrqWhxe/WUmopH5QtvZB14Occ
         1Pww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0rIQ23b82KNvAjyy8VyUiujyHxPv2fKEUVNQ4h0FuCc=;
        b=FnHp9XfsrOHR3L57cYxiH9TTunA+YEsNqKJpuQcPC8RmiRzmgGiSJMk1YHs89j18Tf
         uE2OVjGrXKKvKfbqW2uVuJPJE5woNz6GIJzgp2xYS8iBDqvcnvEXtuNit/qfy1yYHWd4
         P31URrn97Hc+gNoi+lTMxMruKxmWknGd/S7cCSszxu8+CMUWH2HiEG4HscJk/U2GRVWp
         8wl7c0pkmJwExCQMnt57iEreIC9lzGnwgIiGOLK/MX34oJ+jZo2r/iOtxvfCgL3/QeV3
         huJZxP6GqYOOsVnF9PvjF+fFz7APWZQAkshEhukE6xJulMVLblK/mCHqdXT3xZG76hXc
         Lsfw==
X-Gm-Message-State: APjAAAWwWlsFG5WclYaEsUwSQRYQGe7oOFHNzwYaU+UJO9mZZR0OVYJf
        5kwXy3c4j4YbW/wskqpKVFIgw02QGZA=
X-Google-Smtp-Source: APXvYqztpCzx0hB4CQVenURhy5bxwE6KafhcT2Sn+17CuzFvVShSFrokbdVH6mLRa+0p2edrv4QZeg==
X-Received: by 2002:a5d:458b:: with SMTP id p11mr17434123wrq.22.1551805513659;
        Tue, 05 Mar 2019 09:05:13 -0800 (PST)
Received: from jernej-laptop.localnet (cpe-86-58-52-202.static.triera.net. [86.58.52.202])
        by smtp.gmail.com with ESMTPSA id 2sm10112589wrg.89.2019.03.05.09.05.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Mar 2019 09:05:10 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
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
Date:   Tue, 05 Mar 2019 18:05:08 +0100
Message-ID: <7218484.YqF67YIo71@jernej-laptop>
In-Reply-To: <20190305101732.3eylxubiiboygjc5@flea>
References: <cover.1862a43851950ddee041d53669f8979aba863c38.1550672228.git-series.maxime.ripard@bootlin.com> <1717029.ugS2kBEt89@jernej-laptop> <20190305101732.3eylxubiiboygjc5@flea>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dne torek, 05. marec 2019 ob 11:17:32 CET je Maxime Ripard napisal(a):
> Hi Jernej,
>=20
> On Wed, Feb 20, 2019 at 06:50:54PM +0100, Jernej =C5=A0krabec wrote:
> > I really wanted to do another review on previous series but got distrac=
ted
> > by analyzing one particulary troublesome H264 sample. It still doesn't
> > work correctly, so I would ask you if you can test it with your stack (=
it
> > might be userspace issue):
> >=20
> > http://jernej.libreelec.tv/videos/problematic/test.mkv
> >=20
> > Please take a look at my comments below.
>=20
> I'd really prefer to focus on getting this merged at this point, and
> then fixing odd videos and / or setups we can find later
> on. Especially when new stacks are going to be developped on top of
> this, I'm sure we're going to have plenty of bugs to address :)

I forgot to mention, you can add:
Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>

once you fix issues. Please take a look below for comments.

>=20
> > Dne sreda, 20. februar 2019 ob 15:17:34 CET je Maxime Ripard napisal(a):
> > > Introduce some basic H264 decoding support in cedrus. So far, only the
> > > baseline profile videos have been tested, and some more advanced
> > > features
> > > used in higher profiles are not even implemented.
> >=20
> > What is not yet implemented? Multi slice frame decoding, interlaced fra=
mes
> > and decoding frames with width > 2048. Anything else?
>=20
> Off the top of my head, nope.
>=20
> > > +static void cedrus_h264_write_sram(struct cedrus_dev *dev,
> > > +				   enum cedrus_h264_sram_off off,
> > > +				   const void *data, size_t len)
> > > +{
> > > +	const u32 *buffer =3D data;
> > > +	size_t count =3D DIV_ROUND_UP(len, 4);
> > > +
> > > +	cedrus_write(dev, VE_AVC_SRAM_PORT_OFFSET, off << 2);
> > > +
> > > +	do {
> > > +		cedrus_write(dev, VE_AVC_SRAM_PORT_DATA, *buffer++);
> > > +	} while (--count);
> >=20
> > Above loop will still write one word for count =3D 0. I propose followi=
ng:
> >=20
> > while (count--)
> >=20
> > 	cedrus_write(dev, VE_AVC_SRAM_PORT_DATA, *buffer++);
>=20
> Good catch, thanks!
>=20
> > > +	position =3D find_next_zero_bit(&used_dpbs, CEDRUS_H264_FRAME_NUM,
> > > +				      output);
> > > +	if (position >=3D CEDRUS_H264_FRAME_NUM)
> > > +		position =3D find_first_zero_bit(&used_dpbs,
> >=20
> > CEDRUS_H264_FRAME_NUM);
> >=20
> > I guess you didn't try any interlaced videos? Sometimes it happens that
> > buffer is reference and output at the same time. In such cases, above
> > code would make two entries, which doesn't work based on Kwiboo's and my
> > experiments.
> >=20
> > I guess decoding interlaced videos is out of scope at this time?
>=20
> Yep, and that should be pretty easy to fix.
>=20
> > > +
> > > +	output_buf =3D vb2_to_cedrus_buffer(&run->dst->vb2_buf);
> > > +	output_buf->codec.h264.position =3D position;
> > > +
> > > +	if (slice->flags & V4L2_H264_SLICE_FLAG_FIELD_PIC)
> > > +		output_buf->codec.h264.pic_type =3D
> >=20
> > CEDRUS_H264_PIC_TYPE_FIELD;
> >=20
> > > +	else if (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD)
> > > +		output_buf->codec.h264.pic_type =3D
> >=20
> > CEDRUS_H264_PIC_TYPE_MBAFF;
> >=20
> > > +	else
> > > +		output_buf->codec.h264.pic_type =3D
> >=20
> > CEDRUS_H264_PIC_TYPE_FRAME;
> >=20
> > > +
> > > +	cedrus_fill_ref_pic(ctx, output_buf,
> > > +			    dec_param->top_field_order_cnt,
> > > +			    dec_param->bottom_field_order_cnt,
> > > +			    &pic_list[position]);
> > > +
> > > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_FRAMEBUFFER_LIST,
> > > +			       pic_list, sizeof(pic_list));
> > > +
> > > +	cedrus_write(dev, VE_H264_OUTPUT_FRAME_IDX, position);
> > > +}
> > > +
> > > +#define CEDRUS_MAX_REF_IDX	32
> > > +
> > > +static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
> > > +				   struct cedrus_run *run,
> > > +				   const u8 *ref_list, u8=20
num_ref,
> > > +				   enum cedrus_h264_sram_off sram)
> > > +{
> > > +	const struct v4l2_ctrl_h264_decode_param *decode =3D run-
> > >
> > >h264.decode_param;
> > >
> > > +	struct vb2_queue *cap_q =3D &ctx->fh.m2m_ctx->cap_q_ctx.q;
> > > +	const struct vb2_buffer *dst_buf =3D &run->dst->vb2_buf;
> > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > +	u8 sram_array[CEDRUS_MAX_REF_IDX];
> > > +	unsigned int i;
> > > +	size_t size;
> > > +
> > > +	memset(sram_array, 0, sizeof(sram_array));
> > > +
> > > +	for (i =3D 0; i < num_ref; i++) {
> > > +		const struct v4l2_h264_dpb_entry *dpb;
> > > +		const struct cedrus_buffer *cedrus_buf;
> > > +		const struct vb2_v4l2_buffer *ref_buf;
> > > +		unsigned int position;
> > > +		int buf_idx;
> > > +		u8 dpb_idx;
> > > +
> > > +		dpb_idx =3D ref_list[i];
> > > +		dpb =3D &decode->dpb[dpb_idx];
> > > +
> > > +		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> > > +			continue;
> > > +
> > > +		buf_idx =3D vb2_find_timestamp(cap_q, dpb->timestamp, 0);
> > > +		if (buf_idx < 0)
> > > +			continue;
> > > +
> > > +		ref_buf =3D to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> > > +		cedrus_buf =3D vb2_v4l2_to_cedrus_buffer(ref_buf);
> > > +		position =3D cedrus_buf->codec.h264.position;
> > > +
> > > +		sram_array[i] |=3D position << 1;
> > > +		if (ref_buf->field =3D=3D V4L2_FIELD_BOTTOM)
> >=20
> > I'm still not convinced that checking buffer field is appropriate solut=
ion
> > here. IMO this bit defines top or bottom reference and same buffer could
> > be used for both.
> >=20
> > But I guess this belongs for follow up patch which will fix decoding
> > interlaced videos.
>=20
> And we can always change the API later on if we find that not adequate
>=20
> > > +static void cedrus_write_scaling_lists(struct cedrus_ctx *ctx,
> > > +				       struct cedrus_run *run)
> > > +{
> > > +	const struct v4l2_ctrl_h264_scaling_matrix *scaling =3D
> > > +		run->h264.scaling_matrix;
> > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > +
> > > +	if (!scaling)
> > > +		return;
> > > +
> > > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_8x8_0,
> > > +			       scaling->scaling_list_8x8[0],
> > > +			       sizeof(scaling-
>scaling_list_8x8[0]));
> > > +
> > > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_8x8_1,
> > > +			       scaling->scaling_list_8x8[1],
> > > +			       sizeof(scaling-
>scaling_list_8x8[1]));
> >=20
> > Index above should be 3. IIRC 1 and 3 are used by 4:2:0 chroma
> > subsampling,
> > but currently I'm unable to find reference to that in standard.
>=20
> Yep, indeed, I'll fix that, thanks!

As I said in previous e-mail, I made a mistake, it should be 0 and 3.

>=20
> > > +
> > > +	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_4x4,
> > > +			       scaling->scaling_list_4x4,
> > > +			       sizeof(scaling->scaling_list_4x4));
> > > +}
> > > +
> > > +static void cedrus_write_pred_weight_table(struct cedrus_ctx *ctx,
> > > +					   struct cedrus_run
> >=20
> > *run)
> >=20
> > > +{
> > > +	const struct v4l2_ctrl_h264_slice_param *slice =3D
> > > +		run->h264.slice_param;
> > > +	const struct v4l2_h264_pred_weight_table *pred_weight =3D
> > > +		&slice->pred_weight_table;
> > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > +	int i, j, k;
> > > +
> > > +	cedrus_write(dev, VE_H264_SHS_WP,
> > > +		     ((pred_weight->chroma_log2_weight_denom & 0xf) <<
> >=20
> > 4) |
> >=20
> > > +		     ((pred_weight->luma_log2_weight_denom & 0xf) <<
> >=20
> > 0));
> >=20
> > Denominators are only in range of 0-7, so mask should be 0x7. CedarX co=
de
> > also specify those two fields 3 bits wide.
>=20
> Indeed, I'll fix it.
>=20
> > > +
> > > +	cedrus_write(dev, VE_AVC_SRAM_PORT_OFFSET,
> > > +		     CEDRUS_SRAM_H264_PRED_WEIGHT_TABLE << 2);
> > > +
> > > +	for (i =3D 0; i < ARRAY_SIZE(pred_weight->weight_factors); i++) {
> > > +		const struct v4l2_h264_weight_factors *factors =3D
> > > +			&pred_weight->weight_factors[i];
> > > +
> > > +		for (j =3D 0; j < ARRAY_SIZE(factors->luma_weight); j++)=20
{
> > > +			u32 val;
> > > +
> > > +			val =3D ((factors->luma_offset[j] & 0x1ff) <<=20
16)
> > >=20
> > > +				(factors->luma_weight[j] & 0x1ff);
> > > +			cedrus_write(dev, VE_AVC_SRAM_PORT_DATA,
> >=20
> > val);
> >=20
> > You should cast offset varible to wider type. Currently some videos whi=
ch
> > use prediction weight table don't work for me, unless offset is casted =
to
> > u32 first. Shifting 8 bit variable for 16 places gives you 0 every time.
>=20
> I'll do it.
>=20
> > Luma offset and weight are defined as s8, so having wider mask doesn't
> > really make sense. However, I think weight should be s16 anyway, because
> > standard says that it's value could be 2^denominator for default value =
or
> > in range -128..127. Worst case would be 2^7 =3D 128 and -128. To cover =
both
> > values you need at least 9 bits.
>=20
> But if I understood the spec right, in that case you would just have
> the denominator set, and not the offset, while the offset is used if
> you don't use the default formula (and therefore remains in the -128
> 127 range which is covered by the s8), right?

Yeah, default offset is 0 and s8 is sufficient for that. I'm talking about=
=20
weight. Default weight is "1 << denominator", which might be 1 << 7 or 128.

We could also add a flag, which would signal default table. In that case we=
=20
could just set a bit to tell VPU to use default values. Even if some VPUs n=
eed=20
default table to be set explicitly, it's very easy to calculate values as=20
mentioned in previous paragraph.

Best regards,
Jernej

>=20
> > > +	reg =3D 0;
> > > +	if (!(scaling && (pps->flags &
> > > V4L2_H264_PPS_FLAG_PIC_SCALING_MATRIX_PRESENT))) +		reg |=3D
> > > VE_H264_SHS_QP_SCALING_MATRIX_DEFAULT;
> > > +	reg |=3D (pps->second_chroma_qp_index_offset & 0x3f) << 16;
> > > +	reg |=3D (pps->chroma_qp_index_offset & 0x3f) << 8;
> > > +	reg |=3D (pps->pic_init_qp_minus26 + 26 + slice->slice_qp_delta) &
> >=20
> > 0x3f;
> >=20
> > > +	cedrus_write(dev, VE_H264_SHS_QP, reg);
> > > +
> > > +	// clear status flags
> > > +	cedrus_write(dev, VE_H264_STATUS, cedrus_read(dev,
> >=20
> > VE_H264_STATUS));
> >=20
> > I'm not sure clearing status here is needed. Do you have any case where=
 it
> > is need? Maybe if some error happened before and cedrus_h264_irq_clear()
> > wasn't cleared. I'm fine either way.
>=20
> Yeah, it's just some extra precaution.
>=20
> > > +
> > > +	// enable int
> > > +	reg =3D cedrus_read(dev, VE_H264_CTRL);
> > > +	cedrus_write(dev, VE_H264_CTRL, reg |
> > > +		     VE_H264_CTRL_SLICE_DECODE_INT |
> > > +		     VE_H264_CTRL_DECODE_ERR_INT |
> > > +		     VE_H264_CTRL_VLD_DATA_REQ_INT);
> >=20
> > Since this is the only place where you set VE_H264_CTRL, I wouldn't
> > preserve previous content. This mode is also capable of decoding VP8 and
> > AVS. So in theory, if user would want to decode H264 and VP8 videos at
> > the same time, preserving content will probably corrupt your output. I
> > would just set all other bits to 0. What do you think? I tested this
> > without preservation and it works fine.
>=20
> I'll change it.
>=20
> > > +	/*
> > > +	 * FIXME: This is actually conditional to
> > > +	 * V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY not being set, we might
> > > +	 * have to rework this if memory efficiency ever is something
> > > +	 * we need to work on.
> > > +	 */
> > > +	field_size =3D field_size * 2;
> > > +	ctx->codec.h264.mv_col_buf_field_size =3D field_size;
> >=20
> > CedarX code aligns this buffer to 1024. Should we do it too just to be =
on
> > the safe side? I don't think it cost us anything due to
> > dma_alloc_coherent() alignments.
>=20
> dma_alloc_coherent will operate on pages, so it doesn't make any
> difference there.
>=20
> > Sorry again for a bit late in-depth review.
>=20
> Thanks a lot!
> Maxime




