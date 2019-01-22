Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00A5C282C4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B318020861
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PngEKGY9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfAVITp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 03:19:45 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:44466 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbfAVITm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 03:19:42 -0500
Received: by mail-oi1-f171.google.com with SMTP id m6so16686197oig.11
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 00:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=flLZvB78DwXtSH1+mFWCoN/M9S4PPYEMAJHVIXh4lZw=;
        b=PngEKGY9Fuc8eQS1fo9NdT1JWYZQX1VeUnkUe839bJLiXi+BUQSt2CTvjLxvRdSm5K
         3wumfKoTamjm4XHYna0D/V3LfcKuxo5jafCc9mC7aX3TQoKz55BI1fY1LBdAPW7+viHl
         c0beAc0BUTdRwR7ConsXITbZD6mJJBvNwwqLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=flLZvB78DwXtSH1+mFWCoN/M9S4PPYEMAJHVIXh4lZw=;
        b=rl+dVUxhPZmVw58lUW4uP6gA14ag/iD/6goCnYgG4FkXl7VmWbKZOtxfDnYTc7xjxI
         lSZ8F8Cxch6g+tfZBvnz6UnYg13oyRnP+1QHtD8GGqeAANA6GPYCN6oGE6xdSnAkzkK7
         fogpE4JRS1n1z7M+vqxR2IXxAHjXxOdf70+fopA/NE3+Ixnss2QD+nwGcVFGcI6F5B0x
         RHOVhIQbm9gy8mLMWJeM3cIeXlVBayhDN6AUR/tFHa06bKAlbk4ZLBYnxgqt//EqXxRO
         weKYUeXDpqgAxMbssiP5kbfE29lrWV18wt7YJGIcxQorg5jR564OI6WA7J1foWqMD09d
         GNRA==
X-Gm-Message-State: AJcUukcklbnWH7Aa9eFqc/nFaLz7Ap3BgRPicBBALo4iwk674erS2elz
        MGEscO4lraGe9vSMaSPnUqGCanfkPnQ1hA==
X-Google-Smtp-Source: ALg8bN4RIA/+K933VXf6yZHWD+setTD552jz/Vri9ETMwV5Ppvj7dX4I+ID+wucoKWAthHClmpIdlQ==
X-Received: by 2002:aca:5b88:: with SMTP id p130mr7348264oib.96.1548145181184;
        Tue, 22 Jan 2019 00:19:41 -0800 (PST)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com. [209.85.167.169])
        by smtp.gmail.com with ESMTPSA id a15sm6669700otd.66.2019.01.22.00.19.40
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 00:19:40 -0800 (PST)
Received: by mail-oi1-f169.google.com with SMTP id m6so16686158oig.11
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 00:19:40 -0800 (PST)
X-Received: by 2002:a54:4486:: with SMTP id v6mr7923636oiv.233.1548145180322;
 Tue, 22 Jan 2019 00:19:40 -0800 (PST)
MIME-Version: 1.0
References: <20190122062616.164838-1-acourbot@chromium.org> <9c6ceddc-62c4-e4e7-9e27-b8213d8adb42@xs4all.nl>
In-Reply-To: <9c6ceddc-62c4-e4e7-9e27-b8213d8adb42@xs4all.nl>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Tue, 22 Jan 2019 17:19:28 +0900
X-Gmail-Original-Message-ID: <CAPBb6MVSJ1jfGXknJMFFkYjCy1z_mJ_MLOKB=kW1tYg33cppmg@mail.gmail.com>
Message-ID: <CAPBb6MVSJ1jfGXknJMFFkYjCy1z_mJ_MLOKB=kW1tYg33cppmg@mail.gmail.com>
Subject: Re: [PATCH v2] media: docs-rst: Document m2m stateless video decoder interface
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Tomasz Figa <tfiga@chromium.org>,
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

On Tue, Jan 22, 2019 at 5:06 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 01/22/2019 07:26 AM, Alexandre Courbot wrote:
> > Documents the protocol that user-space should follow when
> > communicating with stateless video decoders.
> >
> > The stateless video decoding API makes use of the new request and tags
> > APIs. While it has been implemented with the Cedrus driver so far, it
> > should probably still be considered staging for a short while.
> >
> > Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> > ---
> > Changes since v1:
> >
> > * Use timestamps instead of tags to reference frames,
> > * Applied Paul's suggestions to not require one frame worth of data per OUTPUT
> >   buffer
> >
> > One of the effects of requiring sub-frame units to be submitted per request is
> > that the stateless decoders are not exactly "stateless" anymore: if a frame is
> > made of several slices, then the decoder must keep track of the buffer in which
> > the current frame is being decoded between requests, and all the slices for the
> > current frame must be submitted before we can consider decoding the next one.
> >
> > Also if we decide to force clients to submit one slice per request, then doesn't
> > some of the H.264 controls need to change? For instance, in the current v2
> > there is still a v4l2_ctrl_h264_decode_param::num_slices member. It is used in
> > Chromium to specify the number of slices given to the
> > V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS control, but is apparently ignored by the
> > Cedrus driver. Maxime, can you comment on this?
> >
> >  Documentation/media/uapi/v4l/dev-codec.rst    |   5 +
> >  .../media/uapi/v4l/dev-stateless-decoder.rst  | 378 ++++++++++++++++++
> >  2 files changed, 383 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> >
>
> Thank you! I have uploaded a version of the V4L2 spec with this and the two older
> stateful codec patches applied:
>
> https://hverkuil.home.xs4all.nl/codec-api/uapi/v4l/dev-codec.html

Thanks! A v3 will likely be necessary (and I'll likely be more
reactive producing it) because of that one-slice-per-request
requirement. After discussing with Tomasz we think it would be
safer/simpler to require one frame per request in a first time, as we
initially agreed.

Anyway, we can discuss the details once Tomasz chimes in.
