Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AD6C282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 17:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AD97222C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 17:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qgKoLKFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbfBLRqn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:46:43 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40152 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfBLRqm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 12:46:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id q21so3967877wmc.5;
        Tue, 12 Feb 2019 09:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w4gEFxIxyax5TlhbyybnDHgnUurqHD/qF92buHHcIR8=;
        b=qgKoLKFmkAuxh1Ar6DdvgYrww1WOQersJ5ep5UCiUi0J+9yhwEkFpUCCy8yfQmKs0F
         O7B2p6q6/iq8xSEYfuJ9SJhl04BwUhPNSCVqmEr314+Ig1yj83cG1TfXkNst80XutOIO
         n7t9JWJS9XIJ/ZWr3kpfo3/Vv8XuhMUgXopwcOD4Wh9PMgI93mxVtXzZL7DrGjYZtH4+
         bM0uXg6iSpjZRPDC14l9NsVSZDYB3O/6vyny+N9pGx9VUWCGPrxevcUNZWO/Iqh5C3x2
         xb1WqgwKxQ7vVRK6zYMmr5wcMsMOhQrKdBYl4VJ6btXG/C9iO7iamMf3Og/asoc4uVUr
         d+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4gEFxIxyax5TlhbyybnDHgnUurqHD/qF92buHHcIR8=;
        b=PeQxv5PwrrPsWjnrE2sTXseFb8iGifO3/J1apWoreRwy08iFawfFyf7lxqI63GcVp8
         LHzXSUMEjVUpN4j1y5LyyRWX+FV2M+2zUf7p5/tq4b0sPSBuwf0IeeVOQ7mHmK/2zAXP
         b5NE+0fH+rIDuUHFVFVI6JjwvB+coqcg5IUtzNEjspq6Jip0idBwMp5V6NLFwpg/s47L
         SUPlgusvMnS94r504Uv2OjUaZgWv9wqEA3IUnT8S69/+pA5FSvjP0aLJvj5polYT6ltw
         PGnLOnMNCMfTiSyX9ysm0VOUMKCwBb420rBpKP/kmZKx4pQ1ZcDPfjOucwu8+IhHnvmP
         2C7g==
X-Gm-Message-State: AHQUAuaQr5Kk1Gg/ZRndyv6/z3+ZB53aR/jsiz3DrARC0FGup11yw/+k
        cEwcdkqYu4PKxO6SDl1Tdzo=
X-Google-Smtp-Source: AHgI3Iayj8bfyM5tDVPZR2hBc8CMXzT1/nAImWh/xGu6k4WGUoqn2o87bSsiO+4IN7cxta26eUGwTw==
X-Received: by 2002:a1c:e10a:: with SMTP id y10mr9289wmg.73.1549993601070;
        Tue, 12 Feb 2019 09:46:41 -0800 (PST)
Received: from jernej-laptop.localnet (APN-123-243-40-gprs.simobil.net. [46.123.243.40])
        by smtp.gmail.com with ESMTPSA id q9sm9102303wrv.26.2019.02.12.09.46.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Feb 2019 09:46:40 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     linux-sunxi@googlegroups.com, maxime.ripard@bootlin.com
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jonas@kwiboo.se, ezequiel@collabora.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v3 2/2] media: cedrus: Add H264 decoding support
Date:   Tue, 12 Feb 2019 18:46:38 +0100
Message-ID: <3572175.7W1cnfb8sa@jernej-laptop>
In-Reply-To: <20190212104314.slytpbufwhf5ujv7@flea>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com> <12916702.RFRCeC2GgE@jernej-laptop> <20190212104314.slytpbufwhf5ujv7@flea>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dne torek, 12. februar 2019 ob 11:43:14 CET je Maxime Ripard napisal(a):
> Hi,
>=20
> On Mon, Feb 11, 2019 at 08:21:31PM +0100, Jernej =C5=A0krabec wrote:
> > > +	reg =3D 0;
> > > +	/*
> > > +	 * FIXME: This bit tells the video engine to use the default
> > > +	 * quantization matrices. This will obviously need to be
> > > +	 * changed to support the profiles supporting custom
> > > +	 * quantization matrices.
> > > +	 */
> > > +	reg |=3D VE_H264_SHS_QP_SCALING_MATRIX_DEFAULT;
> >=20
> > This flag should not be needed anymore. From what I see, you correctly =
set
> > scaling matrix every time.
>=20
> The scaling matrix control is optional, so I guess we should protect
> that by a check on whether that control has been set or not. What do
> you think?

Is it? Consider following snippet from your patch:

<snip>
{
	.id	=3D V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX,
	.elem_size	=3D sizeof(struct v4l2_ctrl_h264_scaling_matrix),
	.codec	=3D CEDRUS_CODEC_H264,
	.required	=3D true,
},
<snip>

Doesn't "required =3D true" mean that it's mandatory? But yes, if it's opti=
onal,=20
then you should add a check.

Best regards,
Jernej



