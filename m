Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F29FC282C2
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 10:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA932218B0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 10:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbfAYKKE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:10:04 -0500
Received: from mail.bootlin.com ([62.4.15.54]:43524 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728917AbfAYKKE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 05:10:04 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id D4F8A20798; Fri, 25 Jan 2019 11:10:01 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id A49B9206A6;
        Fri, 25 Jan 2019 11:10:01 +0100 (CET)
Date:   Fri, 25 Jan 2019 11:10:02 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 2/2] media: cedrus: Add HEVC/H.265 decoding support
Message-ID: <20190125101002.z5ftls5xo7izygvy@flea>
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com>
 <20181123130209.11696-3-paul.kocialkowski@bootlin.com>
 <20181127082119.xdemdwgclai7kj3r@flea>
 <4f25de5bbcb7bf196fe4925f54e3335b50670bd2.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="z6zsvccsx3aejq2d"
Content-Disposition: inline
In-Reply-To: <4f25de5bbcb7bf196fe4925f54e3335b50670bd2.camel@bootlin.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--z6zsvccsx3aejq2d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 24, 2019 at 02:10:25PM +0100, Paul Kocialkowski wrote:
> On Tue, 2018-11-27 at 09:21 +0100, Maxime Ripard wrote:
> > Hi!
> >=20
> > On Fri, Nov 23, 2018 at 02:02:09PM +0100, Paul Kocialkowski wrote:
> > > This introduces support for HEVC/H.265 to the Cedrus VPU driver, with
> > > both uni-directional and bi-directional prediction modes supported.
> > >=20
> > > Field-coded (interlaced) pictures, custom quantization matrices and
> > > 10-bit output are not supported at this point.
> > >=20
> > > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> >=20
> > Output from checkpatch:
> > total: 0 errors, 68 warnings, 14 checks, 999 lines checked
>=20
> Looks like many of the "line over 80 chars" are due to macros. I don't
> think it would be a good idea to break them down or to change the
> macros names since they are directly inherited from the bitstream
> elements.
>=20
> What do you think?

Yeah, the 80-chars limit can be ignored. But there's more warnings and
checks that should be addressed.

> > > +	/* Output frame. */
> > > +
> > > +	output_pic_list_index =3D V4L2_HEVC_DPB_ENTRIES_NUM_MAX;
> > > +	pic_order_cnt[0] =3D pic_order_cnt[1] =3D slice_params->slice_pic_o=
rder_cnt;
> > > +	mv_col_buf_addr[0] =3D cedrus_h265_frame_info_mv_col_buf_addr(ctx,
> > > +		run->dst->vb2_buf.index, 0) - PHYS_OFFSET;
> > > +	mv_col_buf_addr[1] =3D cedrus_h265_frame_info_mv_col_buf_addr(ctx,
> > > +		run->dst->vb2_buf.index, 1) - PHYS_OFFSET;
> > > +	dst_luma_addr =3D cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index,=
 0) -
> > > +			PHYS_OFFSET;
> > > +	dst_chroma_addr =3D cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.inde=
x, 1) -
> > > +			PHYS_OFFSET;
> > > +
> > > +	cedrus_h265_frame_info_write_single(dev, output_pic_list_index,
> > > +					    slice_params->pic_struct !=3D 0,
> > > +					    pic_order_cnt, mv_col_buf_addr,
> > > +					    dst_luma_addr, dst_chroma_addr);
> >=20
> > You can only pass the run and slice_params pointers to that function.
>=20
> The point is to make it independent from the context, so that the same
> function can be called with either the slice_params or the dpb info.
> I don't think making two variants or even two wrappers would bring any
> significant benefit.

Then you can still pass directly the vb2 buffer pointer, that would
remove the mv_col_buf_addr, dst_luma_addr and dst_chroma_addr. The
idea here is that the less arguments you have in your function, the
easier it is to understand.

> > > +
> > > +	cedrus_write(dev, VE_DEC_H265_OUTPUT_FRAME_IDX, output_pic_list_ind=
ex);
> > > +
> > > +	/* Reference picture list 0 (for P/B frames). */
> > > +	if (slice_params->slice_type !=3D V4L2_HEVC_SLICE_TYPE_I) {
> > > +		cedrus_h265_ref_pic_list_write(dev, slice_params->ref_idx_l0,
> > > +			slice_params->num_ref_idx_l0_active_minus1 + 1,
> > > +			slice_params->dpb, slice_params->num_active_dpb_entries,
> > > +			VE_DEC_H265_SRAM_OFFSET_REF_PIC_LIST0);
> > > +
> >=20
> > slice_params is enough.
>=20
> The rationale is similar to the one above: being able to use the same
> helper with either L0 or L1, which implies passing the relevant
> elements directly.

The DPB and num_active_dpb_entries will not change from one run to the
other though. And having intermediate functions if that allows to be
clearer is fine as well.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--z6zsvccsx3aejq2d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXErgegAKCRDj7w1vZxhR
xRsaAQC2ViWDkwRbE+VzfnvT6IM2IOggLnD2AO3axObHgVowZwEAsoum8jkX4cu3
0xmBF8qYXaO9qf+KUl0tIhsEPcj2dQA=
=H23o
-----END PGP SIGNATURE-----

--z6zsvccsx3aejq2d--
