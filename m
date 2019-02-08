Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D0FC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 21:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A636218DA
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 21:23:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="gbEJ4ccA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfBHVX1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 16:23:27 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:36288 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfBHVX1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 16:23:27 -0500
Received: by mail-wm1-f50.google.com with SMTP id p6so5526237wmc.1
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 13:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CWKL1D/k8zJCADycAqdORfkW1FO7xa1KtnvAF+w7rEY=;
        b=gbEJ4ccABNZHVX55Hxpxe2npO3gPPp5sj/95e2LPzgXwMMZVPZx3Tzwhd3lw1FWE+H
         TaYi77sSTZS0KP3iwD8t2FVUSnADJHwdbdYZMO3RJvYQYmL8ySRzWy83VVxIwln0NT9u
         /06uPLKZJCPpDTZl4t/jEWkXeQYJMvnxZSeCvxo5412UD/xMjDTHe2LynvDEc//aFy1p
         FB88XN1l6dXWeAEnwlFL2wYNpwoBG1DMBUkVfQXoXIpTIDdDwVXC8i071CVztNEmdEnM
         Rr/T26DFxgvegOVvoQnE2GVhWO4+Is0W1mNogur2LYTMTI3lds165ZoiIknUiFJaa/6v
         AvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CWKL1D/k8zJCADycAqdORfkW1FO7xa1KtnvAF+w7rEY=;
        b=HH3s6TsfIHebelF5Bel9iMs+U3XI5+mGd5sa2//ZlDC9oTQlnBA6KSTXkNYxoDg9ON
         zfBT6NqIJmy+rgYNY+AQ3tKecJ7YQ2n7KrPvF32lIvPSjPfXkZkro1937mzucISAfSX5
         x7vpxBJNs8D3pdNBc6K3ozWpePxJHldXEV0RaKbWoHGjsfXVtdemThm9RNcMeflJbUvH
         O/d6tMR9+yWy9zGnV2nT/vijUEotKz5dx+e6aMlKdfUjoZ2wV5j1nhJ2ohKsaCaRLnyf
         yBYkd6ql+fMbjpVEzQZrr3aSLLQkxt2aARrdq3bGo++nSRHhz4NHlXyPaZukB+4040kx
         jUZQ==
X-Gm-Message-State: AHQUAuaz+5vZ2BbnOpEervsb4hUojwYIRPOGZG74I7a+bMcpE1VpXHj4
        u642/FDMSoqJB8wrzshfJFhJpfFKiW1IoctpUcHHW4nj6+s=
X-Google-Smtp-Source: AHgI3IbFU9CqDtJDf8bQE9aFbIU1d6Y9cQz68Vb7qQinc4hwuRH3WLxo+/YZhJYI8rGk5TCnOHc5G6f8wXiqz23mvRQ=
X-Received: by 2002:adf:ef0d:: with SMTP id e13mr17919355wro.29.1549661005319;
 Fri, 08 Feb 2019 13:23:25 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com> <CAJ+vNU0YQeiPaE8tapJnihoj3DtewCPTj05BZv5cJ65YkE9MeQ@mail.gmail.com>
 <db70e0f7-0ad4-62f5-e64c-49c04c089dd6@gmail.com> <CAJ+vNU3X6ywgobcV+wQxEupkNeNmiWaT85xUOtKF_U44OAfskg@mail.gmail.com>
 <7cfe3570-64e5-d5e3-aeaf-35253c0fa918@gmail.com> <CAJ+vNU2VebBg83vsiGmsx+0PuD=qr4w3fc9a7-bvgji=iyPDyQ@mail.gmail.com>
 <b97bf10a-f4dc-840b-9ffe-b311fdeee374@gmail.com> <CAJ+vNU0_-Ti1bAfEo=3kg79hYFSE4ZFx9C4HswqUWXB463yXXA@mail.gmail.com>
 <CAJ+vNU3HpW=K_3ub9iX33GnjaZuHUAqbto=saV13DaC=ZSO2aQ@mail.gmail.com> <3414560a-0aa0-9c51-28eb-7d3ded0af86e@gmail.com>
In-Reply-To: <3414560a-0aa0-9c51-28eb-7d3ded0af86e@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 8 Feb 2019 13:23:13 -0800
Message-ID: <CAJ+vNU0xzyi0-mm7aOjdvmdAWLFdK8m_i88yF29wtmhtXdDEAQ@mail.gmail.com>
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 7, 2019 at 5:54 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
>
<snip>
> >>
> > Ok there is definitely something wrong when using the IC with
> > UYVY8_1X16 (passthrough) which works with UYVY8_2X8. It looks to me
> > like the ipu1_ic_prp isn't negotiating its format properly. You can't
> > re-create this because you don't have any UYVY8_1X16 (passthrough)
> > sensors right?
>
> Sorry, maybe I didn't mention this, but passthrough cannot go though the
> IPU, you can only send passthrough pixels out the CSI directly to
> /dev/videoN interface (the ipu_csi:2 pad).
>

crud... this has been my issue all along with that set of UYVY8_1X16
pipelines then. So this means the mem2mem driver also won't be able to
handle 16bit pixel formats as well. So while I can downscale this by
multiples of 2 (independent width/height), CSC convert it from
srgb/bt.601 to yuv/bt.709, and even pixel reorder it within YUV  via
the ipu_csi entitty I'll never be able to deinterlace, scale with
flexibility, flip/rotate or do a RGB->YUV CSC on it as those are all
features of the IC path.

I'm still struggling with what mbus format to configure the
sensor<->csi interconnect in the device-tree. I was leaning towards
16bit but now that I realize that can't be used with the IPU I'm
thinking the bt656 is more flexible (accept it has the limitation of
not being able to do 1080p60 due to pixel clock and also can't handle
interlaced due bt656 codes). If I end up wanting to switch between
tda1997x sensor bus formats I'm not even sure the best way to deal
with that (two dts I suppose and allowing user to select which one
they use).

Tim
