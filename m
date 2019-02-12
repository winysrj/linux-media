Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867A1C282CA
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 17:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AAF5222C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 17:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ICqcvFON"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbfBLRlC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:41:02 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45666 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfBLRlC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 12:41:02 -0500
Received: by mail-wr1-f67.google.com with SMTP id w17so3633492wrn.12;
        Tue, 12 Feb 2019 09:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YnLvRw9RaPoLOPBbxQEcuTU7gQILlzbwqlFbkMK1C88=;
        b=ICqcvFONieXI2ZLIoXDHhIcT3PG9fvgk4FuDKh3u/SksAtBFPX9XMjtpf+6hErRVzY
         5VOW6jU7ZnNH3Lty8qx2/u+r1iKkq4Y0PT56K3A/nbGsgWMofURHRc5roA3DHR2mn78E
         tTiUXFCd4swRe6UGgEQgFiBBc77ALFbjEmw7TrrtqOm4R3fQcj5nCBAMlcdXEU6Gh/A7
         T306LxUQKJ2zk7CvcBwyvhXip9mBXYQcFL1K50KVsdJpsOUrEKAsovy08crLSUopNtOO
         F/DSwDyk6KG0GneMZ9+UcgeonlvdULlIR5HT/fu8biHan1u6qkJzKLPLQ13WdpHyuOqC
         eH4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YnLvRw9RaPoLOPBbxQEcuTU7gQILlzbwqlFbkMK1C88=;
        b=HgZJjnrcUs4U9B6ygM+649iC6asglHNrylc/1fSJbu35lIV3LztceAuLCHI8M5rSh6
         Owc+UPsja9KGThIREXNfE3hvFhTQ2DX9/yU2mZGfQ06d5Od1KAFUgB0zw0Lru+YhVnkT
         UUxDtqk7F2DQObRvpdhWr1ukNIKn5bwTK7ZEvaHT004zQJ/hVRBAlkg/BvSDD0bQncGC
         zg75RA1jjxhQz2yzBK8lXiTgOCVRW8QfN0eGBRhF9A+Z9nmpnGmhR6liDehftepaqAno
         dX8uF9jiX7jnlSOIG101dp21j9lqXdec+AnDpD54i9wMjL4H+6zVv3pHB+dOwQ+1qeqF
         3eXw==
X-Gm-Message-State: AHQUAuZ8JQ5Ziup+jXJ7/yox48Sxc5J5Te2D0iW096NxuAcNcc44PhDl
        edP0g0pzZm2nrCDzqDKZNB4=
X-Google-Smtp-Source: AHgI3IbemB+UWRIpSc6wfWKk7HsFQ0oBbyp61ZnT0K5v6cbCYLYTTROj5FmV7J5NYQoBP0BtI0Avfw==
X-Received: by 2002:adf:ba8d:: with SMTP id p13mr3977217wrg.53.1549993259789;
        Tue, 12 Feb 2019 09:40:59 -0800 (PST)
Received: from jernej-laptop.localnet (APN-123-243-40-gprs.simobil.net. [46.123.243.40])
        by smtp.gmail.com with ESMTPSA id n3sm3578193wmf.46.2019.02.12.09.40.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Feb 2019 09:40:58 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Ezequiel Garcia <ezequiel@collabora.com>, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jonas@kwiboo.se, linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v3 2/2] media: cedrus: Add H264 decoding support
Date:   Tue, 12 Feb 2019 18:40:56 +0100
Message-ID: <3363003.VFAkYA4tHV@jernej-laptop>
In-Reply-To: <20190212124713.cqms5jofw433nx6m@flea>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com> <5a31f5596c04390d76bf34fdb8b71b6a96306943.camel@collabora.com> <20190212124713.cqms5jofw433nx6m@flea>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dne torek, 12. februar 2019 ob 13:47:13 CET je Maxime Ripard napisal(a):
> On Mon, Feb 11, 2019 at 04:48:17PM -0300, Ezequiel Garcia wrote:
> > On Mon, 2019-02-11 at 15:39 +0100, Maxime Ripard wrote:
> > > Introduce some basic H264 decoding support in cedrus. So far, only the
> > > baseline profile videos have been tested, and some more advanced
> > > features
> > > used in higher profiles are not even implemented.
> > >=20
> > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> >=20
> > [..]
> >=20
> > > +static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
> > > +				   struct cedrus_run *run,
> > > +				   const u8 *ref_list, u8=20
num_ref,
> > > +				   enum cedrus_h264_sram_off sram)
> > > +{
> > > +	const struct v4l2_ctrl_h264_decode_param *decode =3D
> > > run->h264.decode_param; +	struct vb2_queue *cap_q =3D
> > > &ctx->fh.m2m_ctx->cap_q_ctx.q;
> > > +	const struct vb2_buffer *dst_buf =3D &run->dst->vb2_buf;
> > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > +	u8 sram_array[CEDRUS_MAX_REF_IDX];
> > > +	unsigned int size, i;
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
> > > +		if (dst_buf->timestamp =3D=3D dpb->timestamp)
> > > +			buf_idx =3D dst_buf->index;
> > > +		else
> > > +			buf_idx =3D vb2_find_timestamp(cap_q, dpb-
>timestamp, 0);
> > > +
> > > +		if (buf_idx < 0)
> > > +			continue;
> > > +
> > > +		ref_buf =3D to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> > > +		cedrus_buf =3D vb2_v4l2_to_cedrus_buffer(ref_buf);
> > > +		position =3D cedrus_buf->codec.h264.position;
> > > +
> > > +		sram_array[i] |=3D position << 1;
> > > +		if (ref_buf->field =3D=3D V4L2_FIELD_BOTTOM)
> > > +			sram_array[i] |=3D BIT(0);
> > > +	}
> > > +
> > > +	size =3D min((unsigned int)ALIGN(num_ref, 4), sizeof(sram_array));
> >=20
> > Perhaps s/unsigned int/size_t, so the arguments to min() have the same
> > type?
> >=20
> > Otherwise, I got this warning:
> >=20
> > /home/zeta/repos/linux/media_tree/drivers/staging/media/sunxi/cedrus/ce=
dru
> > s_h264.c: In function =E2=80=98_cedrus_write_ref_list=E2=80=99:
> > /home/zeta/repos/linux/media_tree/include/linux/kernel.h:846:29: warnin=
g:
> > comparison of distinct pointer types lacks a cast>=20
> >    (!!(sizeof((typeof(x) *)1 =3D=3D (typeof(y) *)1)))
>=20
> Strange, I didn't notice any warning. I'll make sure to fix it.

I guess this is one of those warnings which pops out only on 64-bit platfor=
ms.

Best regards,
Jernej



