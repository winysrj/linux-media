Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F12C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 05:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6E702084D
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 05:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JBmGOhHr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfBYFe7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 00:34:59 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44827 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfBYFe7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 00:34:59 -0500
Received: by mail-ot1-f66.google.com with SMTP id g1so6797854otj.11
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 21:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZzC4IgKXPXv0e3W2r2OLx/Odd7g0ovVQkhh9122hT4s=;
        b=JBmGOhHreDeAsbfdRM8CZz9pLXljKr6Dw/sSF6nWhdH7V4w44PGhMqW6bfNQOrGrHF
         vZQwl6TxwQzj22glV9NrQh4DKgA4ahjwdhWJWKOkHR/vXRUe2Fu0EwkLKahvoubkM6xp
         leFSkq096HArumrgAr/acbdzNv13U7C5t2tEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZzC4IgKXPXv0e3W2r2OLx/Odd7g0ovVQkhh9122hT4s=;
        b=m0ewdhR0XoXnJ97eIjb3rwN7DqUXqlB0DrgMUrx+JEP7Eab8VGJCFYM2cy4sZNvxYd
         79CWcIRPc9xSZhPDpb5gCmQRABLjdGOqQ4c61HCqWnK+Dtdhd/8FLtpwHqxnQ+oywCDo
         Oi8i325iMyJMEvtLGmSZAisq4JnRUx3hMverroofCFCOqdiGaZbA6qdQkUsaZuQqXv8i
         OsMEiUN+P+u7mDaAGtuIjOZeUfRSdDUrxc7GBMtxP6ust45iNqxarmdFpGrfQfGTdmL4
         z9RUOaMTzZ3cbbQZaFIRWFBCfYUzPliJgeddDVlYmFTDN3jLaZbe+MHm5C3gNqHIl2i2
         S7sA==
X-Gm-Message-State: AHQUAubCZzrkUwvweRUQqkgsBSq+XVCtZjESjdaoCuCbYMzcnAikcG6Y
        8bVWC7jQCl45poOhgtrtFKdMW9pQci4=
X-Google-Smtp-Source: AHgI3IYgtNi6nc98SZ/xSLu1HXhpOvY/iI3M/yVbk5aToZEbHt3g6yHzUBkJdnX5g5Y+zDARu/q7ag==
X-Received: by 2002:a05:6830:16cc:: with SMTP id l12mr10671049otr.58.1551072897823;
        Sun, 24 Feb 2019 21:34:57 -0800 (PST)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com. [209.85.167.178])
        by smtp.gmail.com with ESMTPSA id i9sm3664939oth.13.2019.02.24.21.34.56
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 21:34:56 -0800 (PST)
Received: by mail-oi1-f178.google.com with SMTP id j135so6289348oib.13
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 21:34:56 -0800 (PST)
X-Received: by 2002:aca:754b:: with SMTP id q72mr10204576oic.127.1551072896338;
 Sun, 24 Feb 2019 21:34:56 -0800 (PST)
MIME-Version: 1.0
References: <20190213211557.17696-1-ezequiel@collabora.com>
 <3507aedd6fd4be7ad66fa27a341faa36b4cef9dc.camel@collabora.com>
 <CAKQmDh_ZrwzxY6L2va1i0kumy1ipo2Hn7oeuR9BJMntKxLuYhQ@mail.gmail.com> <4812f69e53d1313678d0c54577793362e6d7ad2e.camel@collabora.com>
In-Reply-To: <4812f69e53d1313678d0c54577793362e6d7ad2e.camel@collabora.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Mon, 25 Feb 2019 14:34:45 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CQDy4+eWEDpMhdO=ySPN6y__WmTm3PAsVFukO7Sm-dXg@mail.gmail.com>
Message-ID: <CAAFQd5CQDy4+eWEDpMhdO=ySPN6y__WmTm3PAsVFukO7Sm-dXg@mail.gmail.com>
Subject: Re: [RFC] media: uapi: Add VP8 low-level decoder API compound controls.
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Alexandre Courbot <acourbot@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        DVB_Linux_Media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Feb 15, 2019 at 9:06 AM Ezequiel Garcia <ezequiel@collabora.com> wr=
ote:
>
> On Wed, 2019-02-13 at 21:35 -0500, Nicolas Dufresne wrote:
> > Le mer. 13 f=C3=A9vr. 2019 =C3=A0 16:23, Ezequiel Garcia
> > <ezequiel@collabora.com> a =C3=A9crit :
> > > Hi,
> > >
> > > On Wed, 2019-02-13 at 18:15 -0300, Ezequiel Garcia wrote:
[snip]
> > > > +     __u8 version;
> > > > +
> > > > +     /* Populated also if not a key frame */
> > > > +     __u16 width;
> > > > +     __u16 height;
> > > > +     __u8 horizontal_scale;
> > > > +     __u8 vertical_scale;
> > > > +
> > > > +     struct v4l2_vp8_segment_header segment_header;
> > > > +     struct v4l2_vp8_loopfilter_header lf_header;
> > > > +     struct v4l2_vp8_quantization_header quant_header;
> > > > +     struct v4l2_vp8_entropy_header entropy_header;
> > > > +
> > > > +     __u8 sign_bias_golden;
> > > > +     __u8 sign_bias_alternate;
> > > > +
> > > > +     __u8 prob_skip_false;
> > > > +     __u8 prob_intra;
> > > > +     __u8 prob_last;
> > > > +     __u8 prob_gf;
> > > > +
> > > > +     __u32 first_part_size;
> > > > +     __u32 first_part_offset; // this needed? it's always 3 + 7 * =
s->keyframe;
> > >
> > > As the comment says, it seems the first partition offset is always
> > > 3 + 7 * s->keyframe. Or am I wrong?
> >
> > I can't find it in VA API or GStreamer parsers. Ideally we need to
> > look in the spec, if it's calculated it does not belong here.
> >
>
> Looking into the spec, I don't think it's part of it.
>
> > https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/master/gs=
t-libs/gst/codecparsers/gstvp8parser.h#L255
> > https://github.com/intel/libva/blob/master/va/va_dec_vp8.h#L72
> >
> > Notice that VA splits this in two, the some part in the picture
> > parameter, and some parts as SliceParameters. I believe it's to avoid
> > having conditional field base on if key_frame =3D=3D 0.
> >
>
> That might make sense. Something to look into.

Yeah, sounds reasonable, although VAAPI naming is a bit off, since VP8
doesn't have a notion of slices...

Best regards,
Tomasz
