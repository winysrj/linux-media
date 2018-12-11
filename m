Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944BAC07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 16:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58AC320879
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 16:11:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="OILqvrq0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58AC320879
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amarulasolutions.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbeLKQLW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 11:11:22 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:39359 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729378AbeLKPux (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:50:53 -0500
Received: by mail-it1-f194.google.com with SMTP id a6so4542254itl.4
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2018 07:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=buhmTM0IOM9w1CVo9f0D+FK2hv5Q2ihC95BTHKVk+CM=;
        b=OILqvrq0DNpN1vlBUSHb/zLGMGmRnRpAG5smli+3AnBDdZNgidTpFyf6CPwwza7jdA
         /wm9kGIc2lpX1VjkaAo+kEGhCqBARLu9SAGLPdoGHmgshhlta5OuQs69/871fFwcx1G7
         BWviVDJDwRqTXD1buykZ+fsVIanjqEXAtB5xY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=buhmTM0IOM9w1CVo9f0D+FK2hv5Q2ihC95BTHKVk+CM=;
        b=OKUl1iyOeAjauZ+JoGFrkM2JaH56As6HJTgUdbP/afZl2+HlkKirZsPg9H/27L9MUo
         YNC7gprTbmCg4ZEkeGI0+26i3BWTtGukdUJ2QBGYJOQysv8quMLyhZ7UW9QEfa0T4ACJ
         UT4NUeAfDZxvCT+Swk/BPkqxaq2ExmyBFkpDIEl4vyJanBr7HI+BNyxFUkueoJd6hg9P
         hbZez90Tg3UbVnCrMW7IMMus0W5R3+uF+Mzh6hxjIv3yD3jEhCHVhoIYhE4trNBEVj/d
         0Xj9HPt0oq8JxkhVOvsXgshHnu6KHSc2J0Lcgv9ohIDWbbBPVFTgZ3Kw9GGLxuverdRv
         0S4g==
X-Gm-Message-State: AA+aEWZo829CTEccWACq/LS9H9W1DbfBJkYvb/K33WrE+dZMV46rDFQf
        v6X4pyF1coXurJvbZbv5IE5o3PrDjKOOh9qAl5hj0w==
X-Google-Smtp-Source: AFSGD/VP7tV2YVL5Fmxinos7XNSnNENKGBABy1AYLIaNFeidzWg3LW+R+qQcmtXzftx8/7fXpYDnONHEPvyA6QLafAk=
X-Received: by 2002:a24:10cb:: with SMTP id 194mr2707952ity.173.1544543452537;
 Tue, 11 Dec 2018 07:50:52 -0800 (PST)
MIME-Version: 1.0
References: <20181210115246.8188-1-jagan@amarulasolutions.com>
 <20181210115246.8188-4-jagan@amarulasolutions.com> <20181211154427.uekytnmp2wlgxwm2@flea>
In-Reply-To: <20181211154427.uekytnmp2wlgxwm2@flea>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Tue, 11 Dec 2018 21:20:40 +0530
Message-ID: <CAMty3ZBA9W0MA7BR=Cn73KbE-fSs=WXe_47c_69JpizhbsXa-g@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] media: sun6i: Set 300MHz mod clock for A64
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Dec 11, 2018 at 9:14 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> On Mon, Dec 10, 2018 at 05:22:43PM +0530, Jagan Teki wrote:
> > The default CSI_SCLK seems unable to drive the sensor to capture
> > the image, so update it to working clock rate 300MHz for A64.
> >
> > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > ---
> >  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > index bbe45e893722..4b872800b244 100644
> > --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > @@ -822,6 +822,11 @@ static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
> >               return PTR_ERR(sdev->clk_mod);
> >       }
> >
> > +     /* A64 need 300MHz mod clock to operate properly */
> > +     if (of_device_is_compatible(pdev->dev.of_node,
> > +                                 "allwinner,sun50i-a64-csi"))
> > +             clk_set_rate_exclusive(sdev->clk_mod, 300000000);
> > +
>
> Where is that 300MHz coming from? You claim in your comment that it

from BSP, even "Chen-Yu Tsai" mentioned the same. (Chen-Yu, can you
comment here)

> "operates properly", yet in your previous mail about this, you were
> saying that 1080p @30Hz is broken. Which one is it?

1080p is broken from sensor end, ie what I mentioned on the respective mail.
