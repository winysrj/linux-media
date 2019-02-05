Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C333C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16E1B2145D
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:26:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="joRlu2vo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfBEG0l (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 01:26:41 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44312 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfBEG0k (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 01:26:40 -0500
Received: by mail-ot1-f68.google.com with SMTP id g16so3929230otg.11
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 22:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xTgE6Zy5ugBz/NPyWIctakVD0BivYTMJdPDR+3PquOs=;
        b=joRlu2volXvgpqsLpqJ1QjmvDPftUW0J5sJiytpQcrmZoV/iaTN72uH/tQ0EMwMOzO
         eQAWQ5RCHFlgnevqFbVeDNhEl3n5zS/+j1AKgVqzW5LWRTpX2z0QXOaJi7WbILSiLCRn
         lgI/EH5Bo1cmNd6WPpTjhrrwHjM7+ESQB+VUo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xTgE6Zy5ugBz/NPyWIctakVD0BivYTMJdPDR+3PquOs=;
        b=ZJru2MmzGUAEeEbpjqs4Aj3gCVBNNKAAdfpv0v3bO/oxJ5QpeTHaV5R7x9KTeLJT8B
         7CovLzTv5e/shsnS9/a958HxGQKpa1uMMnO69CNQmfMN6+RhNJ7NXabpvu0A0scxLm7F
         +FrGYSSveEs7TJzBZkPIkxWoDjhLiqaC6i9Xjd42s7b0oCfSfMnQAJenNMidr7k0ODHo
         1a1s+rn2hulxz7l5dCB8K3yTVtciw8KQltr+CLxaNTaaXnj8Dbm/mUfZCpwQYaFcdGW2
         8PGFnLfP2sB5p6RPMQyPoMPMhyfjtAZ4rA6+Jwxg22AxzM/wCtmw6P30O25bt3fihglj
         Fr9w==
X-Gm-Message-State: AHQUAubFLW5yiVygqAj/191wO6/aqpgQubqeo2F7Zh1jrN/2uVT4ZCWL
        2boQT8nKGAoDMEB0wRHx26lv7xW/b+U=
X-Google-Smtp-Source: AHgI3IaIKpBrmspCoV5iLy6vwQn0D7p93WX5ZXIOkR1vF6pb2gXhDTverM5Df+AAF+aEuG3D+SuVVw==
X-Received: by 2002:a9d:6552:: with SMTP id q18mr1806171otl.128.1549347999812;
        Mon, 04 Feb 2019 22:26:39 -0800 (PST)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com. [209.85.210.48])
        by smtp.gmail.com with ESMTPSA id b23sm7544755otq.5.2019.02.04.22.26.38
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 22:26:38 -0800 (PST)
Received: by mail-ot1-f48.google.com with SMTP id u16so3957497otk.8
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 22:26:38 -0800 (PST)
X-Received: by 2002:a9d:1d65:: with SMTP id m92mr1789110otm.65.1549347998164;
 Mon, 04 Feb 2019 22:26:38 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-11-stanimir.varbanov@linaro.org> <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
 <28069a44-b188-6b89-2687-542fa762c00e@linaro.org> <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
 <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
 <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com>
 <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
 <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
 <57419418d377f32d0e6978f4e4171c0da7357cbb.camel@ndufresne.ca>
 <1548938556.4585.1.camel@pengutronix.de> <CAAFQd5Aih7cWu-cfwBvNdwhHHYEaMF0SFebrYfdNXD9qKu8fxw@mail.gmail.com>
 <1f8485785a21c0b0e071a3a766ed2cbc727e47f6.camel@ndufresne.ca>
In-Reply-To: <1f8485785a21c0b0e071a3a766ed2cbc727e47f6.camel@ndufresne.ca>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 5 Feb 2019 15:26:26 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CPKm1ES8c9Lab63Lr8ZfWRckHmJ99SVRYi6Hpe7hzy+g@mail.gmail.com>
Message-ID: <CAAFQd5CPKm1ES8c9Lab63Lr8ZfWRckHmJ99SVRYi6Hpe7hzy+g@mail.gmail.com>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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

On Fri, Feb 1, 2019 at 12:18 AM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le jeudi 31 janvier 2019 =C3=A0 22:34 +0900, Tomasz Figa a =C3=A9crit :
> > On Thu, Jan 31, 2019 at 9:42 PM Philipp Zabel <p.zabel@pengutronix.de> =
wrote:
> > > Hi Nicolas,
> > >
> > > On Wed, 2019-01-30 at 10:32 -0500, Nicolas Dufresne wrote:
> > > > Le mercredi 30 janvier 2019 =C3=A0 15:17 +0900, Tomasz Figa a =C3=
=A9crit :
> > > > > > I don't remember saying that, maybe I meant to say there might =
be a
> > > > > > workaround ?
> > > > > >
> > > > > > For the fact, here we queue the headers (or first frame):
> > > > > >
> > > > > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/=
master/sys/v4l2/gstv4l2videodec.c#L624
> > > > > >
> > > > > > Then few line below this helper does G_FMT internally:
> > > > > >
> > > > > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/=
master/sys/v4l2/gstv4l2videodec.c#L634
> > > > > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/=
master/sys/v4l2/gstv4l2object.c#L3907
> > > > > >
> > > > > > And just plainly fails if G_FMT returns an error of any type. T=
his was
> > > > > > how Kamil designed it initially for MFC driver. There was no ot=
her
> > > > > > alternative back then (no EAGAIN yet either).
> > > > >
> > > > > Hmm, was that ffmpeg then?
> > > > >
> > > > > So would it just set the OUTPUT width and height to 0? Does it me=
an
> > > > > that gstreamer doesn't work with coda and mtk-vcodec, which don't=
 have
> > > > > such wait in their g_fmt implementations?
> > > >
> > > > I don't know for MTK, I don't have the hardware and didn't integrat=
e
> > > > their vendor pixel format. For the CODA, I know it works, if there =
is
> > > > no wait in the G_FMT, then I suppose we are being really lucky with=
 the
> > > > timing (it would be that the drivers process the SPS/PPS synchronou=
sly,
> > > > and a simple lock in the G_FMT call is enough to wait). Adding Phil=
ipp
> > > > in CC, he could explain how this works, I know they use GStreamer i=
n
> > > > production, and he would have fixed GStreamer already if that was
> > > > causing important issue.
> > >
> > > CODA predates the width/height=3D0 rule on the coded/OUTPUT queue.
> > > It currently behaves more like a traditional mem2mem device.
> >
> > The rule in the latest spec is that if width/height is 0 then CAPTURE
> > format is determined only after the stream is parsed. Otherwise it's
> > instantly deduced from the OUTPUT resolution.
> >
> > > When width/height is set via S_FMT(OUT) or output crop selection, the
> > > driver will believe it and set the same (rounded up to macroblock
> > > alignment) on the capture queue without ever having seen the SPS.
> >
> > That's why I asked whether gstreamer sets width and height of OUTPUT
> > to non-zero values. If so, there is no regression, as the specs mimic
> > the coda behavior.
>
> I see, with Philipp's answer it explains why it works. Note that
> GStreamer sets the display size on the OUTPUT format (in fact we pass
> as much information as we have, because a) it's generic code and b) it
> will be needed someday when we enable pre-allocation (REQBUFS before
> SPS/PPS is passed, to avoid the setup delay introduce by allocation,
> mostly seen with CMA base decoder). In any case, the driver reported
> display size should always be ignored in GStreamer, the only
> information we look at is the G_SELECTION for the case the x/y or the
> cropping rectangle is non-zero.
>
> Note this can only work if the capture queue is not affected by the
> coded size, or if the round-up made by the driver is bigger or equal to
> that coded size. I believe CODA falls into the first category, since
> the decoding happens in a separate set of buffers and are then de-tiled
> into the capture buffers (if understood correctly).

Sounds like it would work only if coded size is equal to the visible
size (that GStreamer sets) rounded up to full macroblocks. Non-zero x
or y in the crop could be problematic too.

Hans, what's your view on this? Should we require G_FMT(CAPTURE) to
wait until a format becomes available or the OUTPUT queue runs out of
buffers?

>
> I would say, best is just to test the updated Venus driver, which is in
> my queue.

The updated Venus driver doesn't implement the behavior I referred to,
but rather the legacy wait in G_FMT(CAPTURE) as in s5p-mfc.
