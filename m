Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F8AC282D4
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 06:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C6932175B
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 06:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HlYComox"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbfA3GSB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 01:18:01 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45988 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfA3GSB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 01:18:01 -0500
Received: by mail-ot1-f68.google.com with SMTP id 32so20144049ota.12
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 22:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GfCCtscXzLcTgBfRtd84na+8CHfmvOKBgex8G5OBlQU=;
        b=HlYComox3+pCn2czVeA91Mt70maiWPhR92XarngZ15ztgKD9tzMUbwAzZb2Gmwmnnp
         XuFBC9Pob6HZymPD5s5gSJX1K+aXG4wO6o6GrxDX/zsKR60h5Nk50BKKiTsMDIVkmdk6
         TKIduGAvBOuE3RtHP+AEtfD9b/rcSPNZMqpic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GfCCtscXzLcTgBfRtd84na+8CHfmvOKBgex8G5OBlQU=;
        b=ts3Pmqd/CF+q4M/REvtrBiQ1jNx9AO/QeEt7YxVstSEAN4Ny1DgAtHPoP3jYczvptN
         FkxuRa1FdwFMbaG6vNsj8E2t6jmSLQhMQqGLCq6tsKSTJcrI2PFjEx/LE5fItXcF1y0a
         fqOla4e3xoUJYdQAr5WcdNRGBJktHWMU0n+jmS0Uo/iQGKXaTY0bjtVxro+n0lGLviTu
         n8jLlrnoehPF3ZLq/EqJ86fiz8L93pfV4oGQ3iO7d5XdGHUi1CClPDrKi8B4LZONtD04
         zXvvTBbZSPFtLJ5fFU2W3fEHBkCiXeklgouoZpKx0aXJ1Rk8GZk28wjg8qWFykIQBD6b
         seeQ==
X-Gm-Message-State: AJcUukc8/ccn/Scio46Rt0JW6go8K8gcNwU8yuc8/QjoD6iDpnI70r7U
        yFzE9i0scku2LWBbGlhCEDmZqQiWRxs=
X-Google-Smtp-Source: ALg8bN7Z88Vvg5Ludse8Eu1QwuUG8j7+XY1MDq/TRqirAamWXt8N2boe4giupPlVTTWeHlPpoCePjg==
X-Received: by 2002:a9d:58cb:: with SMTP id s11mr21461654oth.161.1548829079749;
        Tue, 29 Jan 2019 22:17:59 -0800 (PST)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com. [209.85.210.51])
        by smtp.gmail.com with ESMTPSA id v20sm269364otp.10.2019.01.29.22.17.58
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 22:17:58 -0800 (PST)
Received: by mail-ot1-f51.google.com with SMTP id w25so20148715otm.13
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 22:17:58 -0800 (PST)
X-Received: by 2002:a9d:6546:: with SMTP id q6mr22782709otl.288.1548829077886;
 Tue, 29 Jan 2019 22:17:57 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-11-stanimir.varbanov@linaro.org> <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
 <28069a44-b188-6b89-2687-542fa762c00e@linaro.org> <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
 <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
 <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com> <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
In-Reply-To: <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 30 Jan 2019 15:17:46 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
Message-ID: <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 30, 2019 at 1:21 PM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le mercredi 30 janvier 2019 =C3=A0 12:38 +0900, Tomasz Figa a =C3=A9crit =
:
> > > Yes, unfortunately, GStreamer still rely on G_FMT waiting a minimal
> > > amount of time of the headers to be processed. This was how things wa=
s
> > > created back in 2011, I could not program GStreamer for the future. I=
f
> > > we stop doing this, we do break GStreamer as a valid userspace
> > > application.
> >
> > Does it? Didn't you say earlier that you end up setting the OUTPUT
> > format with the stream resolution as parsed on your own? If so, that
> > would actually expose a matching framebuffer format on the CAPTURE
> > queue, so there is no need to wait for the real parsing to happen.
>
> I don't remember saying that, maybe I meant to say there might be a
> workaround ?
>
> For the fact, here we queue the headers (or first frame):
>
> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys=
/v4l2/gstv4l2videodec.c#L624
>
> Then few line below this helper does G_FMT internally:
>
> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys=
/v4l2/gstv4l2videodec.c#L634
> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys=
/v4l2/gstv4l2object.c#L3907
>
> And just plainly fails if G_FMT returns an error of any type. This was
> how Kamil designed it initially for MFC driver. There was no other
> alternative back then (no EAGAIN yet either).

Hmm, was that ffmpeg then?

So would it just set the OUTPUT width and height to 0? Does it mean
that gstreamer doesn't work with coda and mtk-vcodec, which don't have
such wait in their g_fmt implementations?

>
> Nicolas
>
> p.s. it's still in my todo's to implement source change event as I
> believe it is a better mechanism (specially if you header happened to
> be corrupted, then the driver can consume the stream until it finds a
> sync). So these sleep or normally wait exist all over to support this
> legacy thing. It is unfortunate, the question is do you want to break
> userspace now ? Without having first placed a patch that would maybe
> warn or something for a while ?
>

I don't want and my understanding was that we could workaround it by
the propagation of format from OUTPUT to CAPTURE. Also see above.

Best regards,
Tomasz
