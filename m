Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90830C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 23:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B3CF218DA
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 23:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xd4RIKX7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfBHXWw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 18:22:52 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:35805 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfBHXWw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 18:22:52 -0500
Received: by mail-wm1-f54.google.com with SMTP id t200so6026145wmt.0
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 15:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=me7LuBFT9SUOZQAcEzERdDDn3tETxJq2LAlKA55BFW0=;
        b=Xd4RIKX7ub7x1vDT2k1R0xHe9hgIascC6AvamyASuCJiDhDW4aEjgNFt4qM1PgVQBS
         GJE2kG6JQw/zxOWeTdCFyFpK+P8L2hKA2Wf0Da6ZrxJTLkFP1tRnbd4hJIunUBbvxE9o
         VkWlWCojrRBIg5jRa7oH3RP1P1M0bb4O9yk7/s27PSHrUU2N5qQdnU2lV3nN6PRTELvS
         17uwou91KjEpdd3Wd9D7HTnvPPsYSx3EZviuK6BT1gqr3+xo1IDpz71PREYN2hRxRLM5
         AH6kh+TPYvl/JuAb5g4udXSFvp+CuX7Up9iaCKgZ8VztPZ8BSBZaHcqqseA8rmk8AT8J
         XYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=me7LuBFT9SUOZQAcEzERdDDn3tETxJq2LAlKA55BFW0=;
        b=WWdJWG1dewRGAQSbAWv0MtULOpMbBCEvSDk+Qn5pkl0BoZj/+f1XWCz3jzZwcFSiRU
         QUgEAroU0ejJpSg7CzeEtVZsp6kwYnqbxKbt4sSMFGPaLfTOy1xxSPRaRH3Kyp0n92Qd
         aHQdISfUgJEUAQjlSH/ChiQUxMHTdXLEq0wlQxkKT063N6t7hzN1vHn4m/Im3bQJ/enB
         CepqLWWmGkrY4MoX0V215PIwmCKfq/bZcnOJveCMo0+GojLmtmsbHB/+T56pcKbygdyC
         mJv9EGO6TBeRTsKdLn9oWXN9DyweNWP0wAmAcxemU+D2/bUOYwlRH9bDCwgVScUHoD9Z
         BzYA==
X-Gm-Message-State: AHQUAubRWqbT1pPU7Fw+75uNx/PHjNwbKey57wCUwLR+VS+pDo0lBipG
        5gRtRzSQkw71lKQYsaD4HPKr5LQ/
X-Google-Smtp-Source: AHgI3IZ+TfCsM2P+jOijZgID4sL6Rfap5amrZ/cDrnBDC81SAFbVO5HdydPq2dnNVwQ2V34HzbHiQg==
X-Received: by 2002:adf:8506:: with SMTP id 6mr19402607wrh.128.1549668169455;
        Fri, 08 Feb 2019 15:22:49 -0800 (PST)
Received: from [172.30.89.46] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id 2sm7587747wrj.27.2019.02.08.15.22.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 15:22:48 -0800 (PST)
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com>
 <CAJ+vNU0YQeiPaE8tapJnihoj3DtewCPTj05BZv5cJ65YkE9MeQ@mail.gmail.com>
 <db70e0f7-0ad4-62f5-e64c-49c04c089dd6@gmail.com>
 <CAJ+vNU3X6ywgobcV+wQxEupkNeNmiWaT85xUOtKF_U44OAfskg@mail.gmail.com>
 <7cfe3570-64e5-d5e3-aeaf-35253c0fa918@gmail.com>
 <CAJ+vNU2VebBg83vsiGmsx+0PuD=qr4w3fc9a7-bvgji=iyPDyQ@mail.gmail.com>
 <b97bf10a-f4dc-840b-9ffe-b311fdeee374@gmail.com>
 <CAJ+vNU0_-Ti1bAfEo=3kg79hYFSE4ZFx9C4HswqUWXB463yXXA@mail.gmail.com>
 <CAJ+vNU3HpW=K_3ub9iX33GnjaZuHUAqbto=saV13DaC=ZSO2aQ@mail.gmail.com>
 <3414560a-0aa0-9c51-28eb-7d3ded0af86e@gmail.com>
 <CAJ+vNU0xzyi0-mm7aOjdvmdAWLFdK8m_i88yF29wtmhtXdDEAQ@mail.gmail.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1a9ac03b-5fd3-a27d-7818-129d64bbe5f6@gmail.com>
Date:   Fri, 8 Feb 2019 15:22:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU0xzyi0-mm7aOjdvmdAWLFdK8m_i88yF29wtmhtXdDEAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 2/8/19 1:23 PM, Tim Harvey wrote:
> On Thu, Feb 7, 2019 at 5:54 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>>
> <snip>
>>> Ok there is definitely something wrong when using the IC with
>>> UYVY8_1X16 (passthrough) which works with UYVY8_2X8. It looks to me
>>> like the ipu1_ic_prp isn't negotiating its format properly. You can't
>>> re-create this because you don't have any UYVY8_1X16 (passthrough)
>>> sensors right?
>> Sorry, maybe I didn't mention this, but passthrough cannot go though the
>> IPU, you can only send passthrough pixels out the CSI directly to
>> /dev/videoN interface (the ipu_csi:2 pad).
>>
> crud... this has been my issue all along with that set of UYVY8_1X16
> pipelines then. So this means the mem2mem driver also won't be able to
> handle 16bit pixel formats as well.

Ugh, let me rephrase. UYVY8_1X16 incoming on a parallel bus (not MIPI 
CSI-2) to the CSI cannot be sent through the IPU, those pixels must be 
sent directly to the ipu_csi:2 pad to /dev/videoN. At least according 
the the imx6 register manual.

But that's not a limitation of the mem2mem driver because the pixels are 
coming from a memory buffer and not a 16-bi parallel bus via the CSI 
(and in any case mem2mem does not deal in media bus codes, it speaks 
V4L2_PIX_FMT_* which contains no bus info). So yes, you can receive 
UYVY8_1X16 on the CSI parallel bus, routed to ipu_csi:2 pad to 
/dev/videoN, and then pipe that to mem2mem v4l2convertN element in a 
gstreamer pipeline.



>   So while I can downscale this by
> multiples of 2 (independent width/height), CSC convert it from
> srgb/bt.601 to yuv/bt.709, and even pixel reorder it within YUV  via
> the ipu_csi entitty I'll never be able to deinterlace,

that's true, currently you can't use the VDIC to do motion compensated 
de-interlacing, but you can still make use of the IDMAC interweave 
feature to deinterlace without motion compensation.

>   scale with
> flexibility, flip/rotate or do a RGB->YUV CSC on it as those are all
> features of the IC path.

mem2mem v4l2convertN element will do those for you (flexible up/down 
scaling, flip/rotate, and CSC).

Steve



>
> I'm still struggling with what mbus format to configure the
> sensor<->csi interconnect in the device-tree. I was leaning towards
> 16bit but now that I realize that can't be used with the IPU I'm
> thinking the bt656 is more flexible (accept it has the limitation of
> not being able to do 1080p60 due to pixel clock and also can't handle
> interlaced due bt656 codes). If I end up wanting to switch between
> tda1997x sensor bus formats I'm not even sure the best way to deal
> with that (two dts I suppose and allowing user to select which one
> they use).
>
> Tim

