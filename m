Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A2BC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 19:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23F0B21738
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 19:14:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="dRkeDp18"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfA1TOU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 14:14:20 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:40101 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfA1TOU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 14:14:20 -0500
Received: by mail-wm1-f54.google.com with SMTP id f188so15094160wmf.5
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2019 11:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s+GKx65+rD+7yF2PSsgcOOrIjEoRMGRemBdKxnXoebU=;
        b=dRkeDp18G4NmubFi4HaifwC6SkqpMw6IYaa4X9/lZXTiiTxus+OT9R9+8KYNYO395f
         JBkrU6Yj8bv8bkn3lVjEANRfmClKQlHOqMZyHcgP3+cvnC+CzbHExzxshqCvxZRt1Q4v
         M8DNeh+7Mdy3X9TL2U6DIbQeWQ4RN8GBzuTxsL06eO64SMJSP1M5RB5ka7kmw/7duvrY
         VCZUOZPqj2NkVzI+z8kt85q+cfeheo3nPj+vqI5BsM+ksUc7ZljV9lV0ujVBKDTRDI2q
         8x0Z1PRGexfSqm2B4QCu3WRJJgOgBZ5AGrLdayT2DmSLXVanGsNprvElxo1poACWFNw0
         LNMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s+GKx65+rD+7yF2PSsgcOOrIjEoRMGRemBdKxnXoebU=;
        b=NiRxjkZqAYL5qsy3EfvbfAnJucvQoKsWhf4qM/9iKJlQx7nfF8/U1jqVbq0VBOLXpg
         pIeGrK/YnVS3MU6rj3NPFZH/BjpG6U0xdcWtc1b5N0dR0SXDGwRWkzlUKA9rT/fRlvPg
         KIWP3lSdhRQdNGK6MNdkHmrrAqiqlP6Dg1Ai8OC9h7SsuDgeAtNhe0c0KvG4bbwc7hu8
         fCGQHBIEt1cC+EVzhMkD8GLRsgfIgrUX5IV0EwCfE8K0pjDUkAL/mTknmYZdcpWMBxgN
         vrxP8QIMExgsPKOLa2ZADfHotSGo+aMrhpJ+P21wW7NPe1dhs/I2eEkLO1jSbO61rh2i
         uWBA==
X-Gm-Message-State: AJcUukfgcEfWYCWVTwC/aeUqCVeIQxUqlFXIkLEezrxmcRd3YQHu5fh2
        dfj4nQyTKN76vo5u8xt8Qlw0Lqf6ZPmoL2Y+eO7SFj5D
X-Google-Smtp-Source: ALg8bN4IunRl1grgwcsaDbB7x4ZUp23ALpmzWdYDYnrviVgBX965whsaZxHqz9GJ7QM8E1Ra1xIA65UvRoyhqs/wd1o=
X-Received: by 2002:a1c:b70b:: with SMTP id h11mr18998319wmf.72.1548702858652;
 Mon, 28 Jan 2019 11:14:18 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com> <4b7b9a4f-f178-b5bb-1813-fba55d1f6749@gmail.com>
In-Reply-To: <4b7b9a4f-f178-b5bb-1813-fba55d1f6749@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 28 Jan 2019 11:14:07 -0800
Message-ID: <CAJ+vNU3LgMi1cLNeatR-Z71=4qMNsgxbmnG_Y5XYE9qD1PXDEA@mail.gmail.com>
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sun, Jan 27, 2019 at 2:36 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
> Hi Tim,
>
> On 1/25/19 3:57 PM, Steve Longerbeam wrote:
> <snip>
> >> Now lets go back to a 480p60 source but this time include the vdic
> >> (which isn't necessary but should still work right?)
> >
> > No. First, the CSI will only capture in bt.656 mode if it sees
> > interlaced fields (bt.656 interlaced sync codes). Well, let me
> > rephrase, the CSI does support progressive BT.656 but I have never
> > tested that myself.
>
> One more comment here. It would be great if you could test a progressive
> bt.656 sensor (example: imx6q-gw54xx tda19971 480p60Hz YUV via BT656
> IPU1_CSI0) since as I said I've never been able to test this myself.
>
> Since it is progressive there's no need for the VDIC, so try these
> pipelines:
>
> mode0: sensor -> mux -> csi -> /dev/videoN
> mode1: sensor -> mux -> csi -> ic_prp -> ic_prpenc -> /dev/videoN
>

Steve,

These both work fine in all cases for 480p60Hz YUV via BT656.

When I use 480p60Hz 'RGB' via BT656 mode0 works fine as the CSI does
the colorspace conversion needed for coda but for mode1 I end up with
the itu601 colorimetery issue from before that I'm still trying to
find a solution for.

Tim
