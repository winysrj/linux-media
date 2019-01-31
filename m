Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C69BC169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 13:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D7BB2085B
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 13:35:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IaPFpBs0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfAaNfE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 08:35:04 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43450 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfAaNfE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 08:35:04 -0500
Received: by mail-ot1-f68.google.com with SMTP id a11so2764253otr.10
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2019 05:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lFxNUjF9ZotFZkVE8oj7F5v9LPfzCUd9sZdzlfBUMOM=;
        b=IaPFpBs0xqbJdXPNibQPCujedS7zvucCOlQKywnAWw/ERJmi4vUotu69KjZBhBo+Mi
         KowPfNLrJ6LRfz40UMedI7PlwqapoGS68sIym7tvPFoNO/ICv8Y7xCSxzJtPETbTqX82
         AjKCTB/rZvdp6NHGBum9M8XJcoJVbJnCGnGvs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lFxNUjF9ZotFZkVE8oj7F5v9LPfzCUd9sZdzlfBUMOM=;
        b=PYySFg85G1FFXprdKkvlIqsBkWfbR/K6mC90wAsV4Eh9mtGKDfwUgvxkt1+8qxDqNO
         MXOPIEn+1HnwsmoalVj5+GUdvXi/m64tan41yHBmC5kMdOAK6BRg/MBq8yWzf7aXUVPX
         3p4u+Xdz8l8WIOrCnml9yn0RGEPYHfvQfxol35mPUiHDgmjxVCyuxJoJbHrIp06grdLn
         9kOLomMbWsZgf/HkQPcRKBejDBuPBjpq21/NU9LH9BQVMdZuZl416QOeAztj6rvBiubo
         FPjKR3ccojG76667OaGAvBneCYIAuPqpUw4CcHOzOZByoT/wxOuFAgMEIv60Ty1xOLFL
         wt/g==
X-Gm-Message-State: AJcUukdLjvJD0JGPVlV0NJKoRPr2sDbBc6p1v9B344fHVGCPq5ElIMCn
        OlU0BQnSryxp9OSudoEORnLNHE/q24I=
X-Google-Smtp-Source: ALg8bN7uhuyyT3GI/JZw7sU8LLHVl766vAve3ZsK/yLqyNLn2KrKfh1hEJs/X87jxBpfl9+twt1fyQ==
X-Received: by 2002:a9d:a72:: with SMTP id 105mr26644372otg.359.1548941703025;
        Thu, 31 Jan 2019 05:35:03 -0800 (PST)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com. [209.85.210.46])
        by smtp.gmail.com with ESMTPSA id n185sm2096378oih.18.2019.01.31.05.35.01
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Jan 2019 05:35:01 -0800 (PST)
Received: by mail-ot1-f46.google.com with SMTP id g16so2748280otg.11
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2019 05:35:01 -0800 (PST)
X-Received: by 2002:a9d:1b67:: with SMTP id l94mr24133458otl.147.1548941700630;
 Thu, 31 Jan 2019 05:35:00 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-11-stanimir.varbanov@linaro.org> <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
 <28069a44-b188-6b89-2687-542fa762c00e@linaro.org> <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
 <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
 <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com>
 <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
 <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
 <57419418d377f32d0e6978f4e4171c0da7357cbb.camel@ndufresne.ca> <1548938556.4585.1.camel@pengutronix.de>
In-Reply-To: <1548938556.4585.1.camel@pengutronix.de>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 31 Jan 2019 22:34:48 +0900
X-Gmail-Original-Message-ID: <CAAFQd5Aih7cWu-cfwBvNdwhHHYEaMF0SFebrYfdNXD9qKu8fxw@mail.gmail.com>
Message-ID: <CAAFQd5Aih7cWu-cfwBvNdwhHHYEaMF0SFebrYfdNXD9qKu8fxw@mail.gmail.com>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
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

On Thu, Jan 31, 2019 at 9:42 PM Philipp Zabel <p.zabel@pengutronix.de> wrot=
e:
>
> Hi Nicolas,
>
> On Wed, 2019-01-30 at 10:32 -0500, Nicolas Dufresne wrote:
> > Le mercredi 30 janvier 2019 =C3=A0 15:17 +0900, Tomasz Figa a =C3=A9cri=
t :
> > > > I don't remember saying that, maybe I meant to say there might be a
> > > > workaround ?
> > > >
> > > > For the fact, here we queue the headers (or first frame):
> > > >
> > > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/mast=
er/sys/v4l2/gstv4l2videodec.c#L624
> > > >
> > > > Then few line below this helper does G_FMT internally:
> > > >
> > > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/mast=
er/sys/v4l2/gstv4l2videodec.c#L634
> > > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/mast=
er/sys/v4l2/gstv4l2object.c#L3907
> > > >
> > > > And just plainly fails if G_FMT returns an error of any type. This =
was
> > > > how Kamil designed it initially for MFC driver. There was no other
> > > > alternative back then (no EAGAIN yet either).
> > >
> > > Hmm, was that ffmpeg then?
> > >
> > > So would it just set the OUTPUT width and height to 0? Does it mean
> > > that gstreamer doesn't work with coda and mtk-vcodec, which don't hav=
e
> > > such wait in their g_fmt implementations?
> >
> > I don't know for MTK, I don't have the hardware and didn't integrate
> > their vendor pixel format. For the CODA, I know it works, if there is
> > no wait in the G_FMT, then I suppose we are being really lucky with the
> > timing (it would be that the drivers process the SPS/PPS synchronously,
> > and a simple lock in the G_FMT call is enough to wait). Adding Philipp
> > in CC, he could explain how this works, I know they use GStreamer in
> > production, and he would have fixed GStreamer already if that was
> > causing important issue.
>
> CODA predates the width/height=3D0 rule on the coded/OUTPUT queue.
> It currently behaves more like a traditional mem2mem device.

The rule in the latest spec is that if width/height is 0 then CAPTURE
format is determined only after the stream is parsed. Otherwise it's
instantly deduced from the OUTPUT resolution.

>
> When width/height is set via S_FMT(OUT) or output crop selection, the
> driver will believe it and set the same (rounded up to macroblock
> alignment) on the capture queue without ever having seen the SPS.

That's why I asked whether gstreamer sets width and height of OUTPUT
to non-zero values. If so, there is no regression, as the specs mimic
the coda behavior.

>
> The source change event after SPS parsing that the spec requires isn't
> even implemented yet.
>
> regards
> Philipp
