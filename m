Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565BAC282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23EEC20879
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:25:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dEEFCyxr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfAVIZx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 03:25:53 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37522 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfAVIZx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 03:25:53 -0500
Received: by mail-ot1-f65.google.com with SMTP id s13so22918696otq.4
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 00:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e8yrVWYsJdctJ97rGJyUpzzNa0v8dkbbCNdmkxPFP2M=;
        b=dEEFCyxrAuT0f8t0EBWJmZvcEIJ6LMw6NgJxy1jvRxjb2lo1q7wFhwv8QLAwkH9oej
         ls8One2BlkMKyJqIcQnLXvDOAYGq3Vcgj5ie0qkW0Xx71eBHBjEFpHNm5n5NyMbELRvB
         WQBOHYGE/ULZtbgReIMn1hKNu1swlmHv6jn6c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e8yrVWYsJdctJ97rGJyUpzzNa0v8dkbbCNdmkxPFP2M=;
        b=X3DgHf/UxeGlNkR7Ulhb0way6MnW5X9/p2AVcgdLl7hcD7dawlR0oMnNKLXOlgl4Ar
         huWJUSMV+2wyw8xXBfmRjm7zIwDrjM07PnZqe54YBqdtIGxXEVl8kjutNrBfD5WHYwKf
         cgpYwW7a33abYVzxemVB0f1dhzsn0rDpLyCcU1lU3ve3u5dg+O7jBrRHfMYeyUrk1dRL
         9KJB9MR6lYrGp04b8024RYNM35oFzm1pLG5XeiXrAszG8LSYXemmsdwEYEYH6tZ1D41U
         cQcT19Qzmb9HmYEmH3HbVS2fJ5+onZHItGHm8NUJIsWNFa69Ggk/YB9fkVSPrzfyJqNV
         diOA==
X-Gm-Message-State: AJcUukfuzpXuMgSP7jXzIiGAVc1xJO7RAXAa+DTZz6IxE4OuDEMGRGiL
        m/jLYE5wiWUsnBVW/nitMhksQd7Sb+iheQ==
X-Google-Smtp-Source: ALg8bN4wl807O1rnQolJgWRWdkLfyL4dsFIWZS7fH165iQkOXCZK4sqlie3MibluDKv8qcf0tSzRzw==
X-Received: by 2002:a9d:2ae2:: with SMTP id e89mr22301952otb.290.1548145552022;
        Tue, 22 Jan 2019 00:25:52 -0800 (PST)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id n3sm8330108oia.3.2019.01.22.00.25.51
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 00:25:51 -0800 (PST)
Received: by mail-ot1-f42.google.com with SMTP id e12so22898190otl.5
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 00:25:51 -0800 (PST)
X-Received: by 2002:a9d:1d65:: with SMTP id m92mr11972217otm.65.1548145550896;
 Tue, 22 Jan 2019 00:25:50 -0800 (PST)
MIME-Version: 1.0
References: <20190122062616.164838-1-acourbot@chromium.org>
 <9c6ceddc-62c4-e4e7-9e27-b8213d8adb42@xs4all.nl> <CAPBb6MVSJ1jfGXknJMFFkYjCy1z_mJ_MLOKB=kW1tYg33cppmg@mail.gmail.com>
In-Reply-To: <CAPBb6MVSJ1jfGXknJMFFkYjCy1z_mJ_MLOKB=kW1tYg33cppmg@mail.gmail.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 22 Jan 2019 17:25:40 +0900
X-Gmail-Original-Message-ID: <CAAFQd5A_GaxqDkwZdbfm0E=pK7CE11t=u6GT137e21V_wRPOVA@mail.gmail.com>
Message-ID: <CAAFQd5A_GaxqDkwZdbfm0E=pK7CE11t=u6GT137e21V_wRPOVA@mail.gmail.com>
Subject: Re: [PATCH v2] media: docs-rst: Document m2m stateless video decoder interface
To:     Alexandre Courbot <acourbot@chromium.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 22, 2019 at 5:19 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>
> On Tue, Jan 22, 2019 at 5:06 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > On 01/22/2019 07:26 AM, Alexandre Courbot wrote:
> > > Documents the protocol that user-space should follow when
> > > communicating with stateless video decoders.
> > >
> > > The stateless video decoding API makes use of the new request and tags
> > > APIs. While it has been implemented with the Cedrus driver so far, it
> > > should probably still be considered staging for a short while.
> > >
> > > Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> > > ---
> > > Changes since v1:
> > >
> > > * Use timestamps instead of tags to reference frames,
> > > * Applied Paul's suggestions to not require one frame worth of data per OUTPUT
> > >   buffer
> > >
> > > One of the effects of requiring sub-frame units to be submitted per request is
> > > that the stateless decoders are not exactly "stateless" anymore: if a frame is
> > > made of several slices, then the decoder must keep track of the buffer in which
> > > the current frame is being decoded between requests, and all the slices for the
> > > current frame must be submitted before we can consider decoding the next one.
> > >
> > > Also if we decide to force clients to submit one slice per request, then doesn't
> > > some of the H.264 controls need to change? For instance, in the current v2
> > > there is still a v4l2_ctrl_h264_decode_param::num_slices member. It is used in
> > > Chromium to specify the number of slices given to the
> > > V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS control, but is apparently ignored by the
> > > Cedrus driver. Maxime, can you comment on this?
> > >
> > >  Documentation/media/uapi/v4l/dev-codec.rst    |   5 +
> > >  .../media/uapi/v4l/dev-stateless-decoder.rst  | 378 ++++++++++++++++++
> > >  2 files changed, 383 insertions(+)
> > >  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > >
> >
> > Thank you! I have uploaded a version of the V4L2 spec with this and the two older
> > stateful codec patches applied:
> >
> > https://hverkuil.home.xs4all.nl/codec-api/uapi/v4l/dev-codec.html
>
> Thanks! A v3 will likely be necessary (and I'll likely be more
> reactive producing it) because of that one-slice-per-request
> requirement. After discussing with Tomasz we think it would be
> safer/simpler to require one frame per request in a first time, as we
> initially agreed.
>
> Anyway, we can discuss the details once Tomasz chimes in.

I've replied in the v1 thread, in reply to Paul's email.

Best regards,
Tomasz
