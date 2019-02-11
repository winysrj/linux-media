Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BFCC169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 17:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F9BD2082F
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 17:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="tjByylpS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfBKRNc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:13:32 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:51427 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfBKRNc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 12:13:32 -0500
Received: by mail-wm1-f52.google.com with SMTP id b11so7163wmj.1
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2019 09:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IEIN71kcflhmmjaMX/z3l6FTQEPwvygNOH1tcOfqfcY=;
        b=tjByylpSqUsMpkgCAfqRg3OyoUjvpfJ7WtJlnJL9pcggPnoLbYbVe3jT7icvaTyRia
         hdsBxXaP8yNUTao/K4nur9pYQzG3OpoSgG3I9jiITojIx7D3M3029IJr+6qOY+8WzD6g
         tZxIzBP5qT8lphJNBRa1BHZTZkdQwau3C2LYquhLoxCg34iT1J7n0halOpjrBnYiQqj2
         XpVXiRjbN+YIo03b0S0w0SdtxzIYdsMfbzMgW9g4D6APPojnBotDpuJg7uKEiJLP5VQi
         g54Tw20JpKNfbyd5j7CTYoI70mkF6a9cfd8h/VuxC4zHDCLMuaGbodQHlPmrXw/QmXsw
         MK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IEIN71kcflhmmjaMX/z3l6FTQEPwvygNOH1tcOfqfcY=;
        b=XHLf0che82JqdIA7rDjBZovkE2VZz5Nrpzqx6YwkUzeoMrlNm+aYduzFyv22pdMXzP
         09b7BOaSctu0w3kM2mqQ3BYjwPVU0Qa+gVjhJLZKxwjWfefY6gKXh0L6gfPOOMR5YXXQ
         8rRQVrN2tI/RyE4x3wWRMgJG7ipcmSBEw9JyUZaQUOPlweX1vv4EP6UTrwKJG/AZakTA
         zoUqy4qeRsVZ6m0FVeqz8YQRizXh5quTlyk5A7cOXyn2eW2cWxJ1fkS+9HfNIG8fSmLX
         dPoLa1kJz6vmdcImelDAXIKfpl/Qj41mox1Bb8W3OI8gsSFuzq9H83q/DQhh81lGRTKD
         MeXw==
X-Gm-Message-State: AHQUAuYx36kzp+V5pQCiP3tWESif98xg5dhxRxqqNpzxCW4Kus3Wy/3Q
        xYjnzI2rGh/woNrWo7veyqnr+bRgI06rfRf+lyCSZbAX
X-Google-Smtp-Source: AHgI3IZWndNOpmMYUqmBze2WTZnj1mbWAW3aysYwzPYuHiU9MGjXn/wjCTWR7lmXL6BPHuOOrYXUSsJMewu7sdul8ec=
X-Received: by 2002:a1c:b70b:: with SMTP id h11mr425119wmf.72.1549905209959;
 Mon, 11 Feb 2019 09:13:29 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com> <CAJ+vNU0YQeiPaE8tapJnihoj3DtewCPTj05BZv5cJ65YkE9MeQ@mail.gmail.com>
 <db70e0f7-0ad4-62f5-e64c-49c04c089dd6@gmail.com> <CAJ+vNU3X6ywgobcV+wQxEupkNeNmiWaT85xUOtKF_U44OAfskg@mail.gmail.com>
 <7cfe3570-64e5-d5e3-aeaf-35253c0fa918@gmail.com> <CAJ+vNU2VebBg83vsiGmsx+0PuD=qr4w3fc9a7-bvgji=iyPDyQ@mail.gmail.com>
 <b97bf10a-f4dc-840b-9ffe-b311fdeee374@gmail.com> <CAJ+vNU0_-Ti1bAfEo=3kg79hYFSE4ZFx9C4HswqUWXB463yXXA@mail.gmail.com>
 <CAJ+vNU3HpW=K_3ub9iX33GnjaZuHUAqbto=saV13DaC=ZSO2aQ@mail.gmail.com>
 <3414560a-0aa0-9c51-28eb-7d3ded0af86e@gmail.com> <CAJ+vNU0xzyi0-mm7aOjdvmdAWLFdK8m_i88yF29wtmhtXdDEAQ@mail.gmail.com>
 <1a9ac03b-5fd3-a27d-7818-129d64bbe5f6@gmail.com>
In-Reply-To: <1a9ac03b-5fd3-a27d-7818-129d64bbe5f6@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 11 Feb 2019 09:13:18 -0800
Message-ID: <CAJ+vNU21HK1+pNnei-v5B8gKiXhOcfi42Y7niu+va7phODA0Jw@mail.gmail.com>
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Feb 8, 2019 at 3:22 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
>
>
> On 2/8/19 1:23 PM, Tim Harvey wrote:
> > On Thu, Feb 7, 2019 at 5:54 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
> >>
> > <snip>
> >>> Ok there is definitely something wrong when using the IC with
> >>> UYVY8_1X16 (passthrough) which works with UYVY8_2X8. It looks to me
> >>> like the ipu1_ic_prp isn't negotiating its format properly. You can't
> >>> re-create this because you don't have any UYVY8_1X16 (passthrough)
> >>> sensors right?
> >> Sorry, maybe I didn't mention this, but passthrough cannot go though the
> >> IPU, you can only send passthrough pixels out the CSI directly to
> >> /dev/videoN interface (the ipu_csi:2 pad).
> >>
> > crud... this has been my issue all along with that set of UYVY8_1X16
> > pipelines then. So this means the mem2mem driver also won't be able to
> > handle 16bit pixel formats as well.
>
> Ugh, let me rephrase. UYVY8_1X16 incoming on a parallel bus (not MIPI
> CSI-2) to the CSI cannot be sent through the IPU, those pixels must be
> sent directly to the ipu_csi:2 pad to /dev/videoN. At least according
> the the imx6 register manual.
>
> But that's not a limitation of the mem2mem driver because the pixels are
> coming from a memory buffer and not a 16-bi parallel bus via the CSI
> (and in any case mem2mem does not deal in media bus codes, it speaks
> V4L2_PIX_FMT_* which contains no bus info). So yes, you can receive
> UYVY8_1X16 on the CSI parallel bus, routed to ipu_csi:2 pad to
> /dev/videoN, and then pipe that to mem2mem v4l2convertN element in a
> gstreamer pipeline.
>
>
>
> >   So while I can downscale this by
> > multiples of 2 (independent width/height), CSC convert it from
> > srgb/bt.601 to yuv/bt.709, and even pixel reorder it within YUV  via
> > the ipu_csi entitty I'll never be able to deinterlace,
>
> that's true, currently you can't use the VDIC to do motion compensated
> de-interlacing, but you can still make use of the IDMAC interweave
> feature to deinterlace without motion compensation.
>
> >   scale with
> > flexibility, flip/rotate or do a RGB->YUV CSC on it as those are all
> > features of the IC path.
>
> mem2mem v4l2convertN element will do those for you (flexible up/down
> scaling, flip/rotate, and CSC).
>

ah... ok right using mem2mem is precisely that 'mem to mem' and not
direct CSI to IPU.

Ok so i experimented with some pipelines and perhaps am setting them
up wrong. I'll respond to the imx-media mem2mem patch with my
observations and expiriments.

Thanks,

Tim
