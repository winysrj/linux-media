Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62064C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 06:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2628421773
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 06:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BKUQEgHQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbfBTGyH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 01:54:07 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46353 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730587AbfBTGyF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 01:54:05 -0500
Received: by mail-ot1-f65.google.com with SMTP id c18so16900641otl.13
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2019 22:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ReIxW8kqDC317MyXoTv3uMgTcKUFWDyKdKcxAnm+jr4=;
        b=BKUQEgHQj8ETyukLDSyGNP/E+b2G6bmIO0EcOY3WpQqgdHALwsygjzOi4gsCsNT+ZJ
         TViLXDChQJfXc2Qtyp2DaMwW1+p5BDm6w96uAahhqGSwe0wYsd08PAHEjfPgYh61z7dB
         gR3fkUpiE5wmRAPB9xGdiCAcPW4atpfsuL72U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ReIxW8kqDC317MyXoTv3uMgTcKUFWDyKdKcxAnm+jr4=;
        b=fbSyBW+Cbf9lyRv94YsQnf1L5FkjVYJ82y/bGDMomOgDc67RR5lZbFsYuALB5yFLQb
         MbrdhVVKGrFbwx35PF+7RBv+G8VD8ngIsu2BV74h9Q01WZm7BAFQHOw6NlFoYtMgYWdt
         Jgt6kslGEmlH55Wpk1fVoIUHDyEs6/pD+3OAale4ZE7VQpu0dPiHFHEOZSuUqZbBYWjs
         23QK3dwY/k8jlpG6hidhKlfPe1xdyokcgANy9tTFSQK/4qP7Em6hf6+0QMs+zwD5zLk3
         XWEDtkmGTZKAPyYyUZvx8iWSGEWKJkrY11Y9ylcZXDlQMKBH5NC1167btWcb6+FA2az+
         b1Dg==
X-Gm-Message-State: AHQUAubjWt3cBlKhpvH2FHDhRNySc6YsJm9O9rNrMsm2zBo96hC9eFv5
        GWoQjKDG5Xyu1PV05SCntLEr1FJmX5Y=
X-Google-Smtp-Source: AHgI3IbItACRH6afFftKo+vPfmAo1tndxA2gxIcoamabnRW0+NfzZaqkgkVoeBedn2WofIPlzd3vbQ==
X-Received: by 2002:a9d:2c5:: with SMTP id 63mr20333767otl.271.1550645643750;
        Tue, 19 Feb 2019 22:54:03 -0800 (PST)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com. [209.85.210.48])
        by smtp.gmail.com with ESMTPSA id 60sm2697812otw.50.2019.02.19.22.54.02
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 22:54:02 -0800 (PST)
Received: by mail-ot1-f48.google.com with SMTP id 98so38590443oty.1
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2019 22:54:02 -0800 (PST)
X-Received: by 2002:aca:754b:: with SMTP id q72mr5012598oic.127.1550645641559;
 Tue, 19 Feb 2019 22:54:01 -0800 (PST)
MIME-Version: 1.0
References: <20190205202417.16555-1-ezequiel@collabora.com>
 <20190205202417.16555-2-ezequiel@collabora.com> <79ad7cf7-90d5-9542-06ea-e28ddeb14e94@xs4all.nl>
 <85ff24016b4d4b55a1a02f1aee6b42dbbaf2279a.camel@collabora.com> <d1ea8698-e4c6-a826-0820-b8395c8c2a6f@xs4all.nl>
In-Reply-To: <d1ea8698-e4c6-a826-0820-b8395c8c2a6f@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 20 Feb 2019 15:53:50 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DLTOJ0kheFdxzTV7Hrtc5MpG4Utn00HgNh06d+h_qJfQ@mail.gmail.com>
Message-ID: <CAAFQd5DLTOJ0kheFdxzTV7Hrtc5MpG4Utn00HgNh06d+h_qJfQ@mail.gmail.com>
Subject: Re: [PATCH 01/10] media: Introduce helpers to fill pixel format structs
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 7, 2019 at 1:36 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 2/6/19 5:22 PM, Ezequiel Garcia wrote:
> > On Wed, 2019-02-06 at 11:43 +0100, Hans Verkuil wrote:
> >> Hi Ezequiel,
> >>
> >> A quick review below. This looks really useful, BTW.
> >>
> >> On 2/5/19 9:24 PM, Ezequiel Garcia wrote:

[snip]
> >>> +/**
> >>> + * struct v4l2_format_info - information about a V4L2 format
> >>> + * @format: 4CC format identifier (V4L2_PIX_FMT_*)
> >>> + * @header_size: Size of header, optional and used by compressed formats
> >>> + * @num_planes: Number of planes (1 to 3)
> >>
> >> This is actually 1-4 since there may be an alpha channel as well. Not that we have
> >> such formats since the only formats with an alpha channel are interleaved formats,
> >> but it is possible.

How about 1 to VIDEO_MAX_PLANES to be a bit more consistent?
Tbh. I'm not sure why we have that defined to 8, but if we have such
constant already, it could make sense to use it here as well.

[snip]
> >
> > Also, note that drm-fourcc deprecates cpp, to support tile formats.
> > Hopefully we don't need that here?
>
> We do have tile formats (V4L2_PIX_FMT_NV12MT_16X16), but it is up to the
> driver to align width/height accordingly.
>

I'd still make these helpers align to the constraints defined by the
format itself (e.g. 16x16), since it doesn't cost us anything, and
have the driver do any further alignment only if they need so.

> >
> >>> + * @hsub: Horizontal chroma subsampling factor
> >>> + * @vsub: Vertical chroma subsampling factor
> >>
> >> A bit too cryptic IMHO. I would prefer hdiv or hsubsampling. 'hsub' suggests
> >> subtraction :-)
> >>
> >
> > Ditto, this name follows drm-fourcc. I'm fine either way.
> >

I personally like hsub and vsub too, but maybe I just spent too much
time with DRM code. *subsampling would make the initializers super
wide, so if we decide that we don't like *sub, I'd go with *div.

> >>> + * @multiplanar: Is it a multiplanar variant format? (e.g. NV12M)
> >>
> >> This should, I think, be renamed to num_non_contig_planes to indicate how many
> >> non-contiguous planes there are in the format.
> >>
> >> So this value is 1 for NV12 and 2 for NV12M. For V4L2_PIX_FMT_YUV444M it is 3.
> >>
> >> You can stick this value directly into pixfmt_mp->num_planes.
> >>
> >
> > Fine by me, but I have to admit I don't see the value of adding the
> > number of non-contiguous planes. For multiplanar non-contiguous formats
> > the number of planes is equal to the number of planes.
>
> Hmm, that's true. Choose whatever gives you the shortest code :-)
>
> >
> > Although maybe it will be clear this way for readers?
> >
> >> As an aside: perhaps we should start calling the 'multiplanar API' the
> >> 'multiple non-contiguous planes API', at least in the documentation. It's the

To me, "multiple non-contiguous planes API" would suggest that the
planes themselves are non-contiguous.

Many drivers (especially Samsung ones) have a distinction between
"color planes" and "memory planes" internally, so maybe "Multiple
memory planes API" could make sense?

> >> first time that I found a description that actually covers the real meaning.
> >>
> >
> > Yes, indeed. In fact, my first version of this code had something like
> > "is_noncontiguous" instead of the "multiplanar" field.
>
> I'm fine with that. Add a comment after it like: /* aka multiplanar */
>

FWIW, some of the drivers have .num_cplanes and .num_mplanes in their
format descriptors.

Best regards,
Tomasz
