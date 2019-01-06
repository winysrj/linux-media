Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AF1C43387
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 16:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB0312087F
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 16:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="kafZP4HN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfAFQbJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 11:31:09 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:54948 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfAFQbJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2019 11:31:09 -0500
Received: by mail-it1-f193.google.com with SMTP id i145so7658081ita.4
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2019 08:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RpNm2IaOF3siha2bkIDP1P0vfouRYq2qejSlkkMzJKo=;
        b=kafZP4HNAEAQnx+wui8iHMPWYPay7xwNwbhhoR1///YTISjQRDlYNGiRDAxAdFp0fE
         qNRrcKZ/Ct1QQ+ebCLVk4NZiQSfQb20+rukN5pgkKKKkxn4PoC1max4MsgCYvgXtlqA9
         H29tuvlHAYzTkmMwMuuCi0+5Gdn4jT84Xnzgo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RpNm2IaOF3siha2bkIDP1P0vfouRYq2qejSlkkMzJKo=;
        b=QJaBwN4U8FO2NUzJ34jAD3BcsTw2HLkvrqzXV60UcE7HrhDjHBE5XAinTNdoMw4L6B
         sDsYQ+TDaTt3fj8KEfI2hVV0kZQfN8x7lsiKHg1XM4207G3Qb6SHBWx5ceN+t2PnajGT
         EVO6dQ+bC3RbZJLAnixK5nqCaN+Dq8+M6ekUsKBAH5KfSc9kHyGRzzcY+V4iRTPaaEVC
         CdP298wiQozjtqjJ5EaXkAVIusH2L20qsKqb9IZTGkTC+nvzDrokXh0sGame+iGWHkOJ
         4ItsYt3sYUX9nGO1rb137HQCtsMJ7P8gQQHsjh5OhRSuMXKN4OuCPJMNdOqnEyJTMLpG
         Sp/Q==
X-Gm-Message-State: AA+aEWbOoHVVEOOb6XHteF9f6/BKVnlq3at6E9XXBLkZ3EROlGgDthBW
        sBE3HU7TrP+fWk/dd/qeSuLq26sCN4a1lf9spU2NdQ==
X-Google-Smtp-Source: AFSGD/VmUsm1CGUrMdpHtObGhn5j8zdXwFc8djaRxi4UBlCC4gL55AIaDKBzNkf/T+fDSKH7wLr98CfHH/FjMHkxqWk=
X-Received: by 2002:a02:781e:: with SMTP id p30mr40814158jac.85.1546792268054;
 Sun, 06 Jan 2019 08:31:08 -0800 (PST)
MIME-Version: 1.0
References: <20181220125438.11700-1-jagan@amarulasolutions.com>
 <20181220125438.11700-3-jagan@amarulasolutions.com> <20181221130025.lbvw7yvy74brf3jn@flea>
 <CAMty3ZCG5cF3tP2mid5xyS=yhtxkY+TOcGkwRkv+vrZt1=0iQg@mail.gmail.com>
In-Reply-To: <CAMty3ZCG5cF3tP2mid5xyS=yhtxkY+TOcGkwRkv+vrZt1=0iQg@mail.gmail.com>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Sun, 6 Jan 2019 22:00:56 +0530
Message-ID: <CAMty3ZBeopJTm7kUzqarSfqYAJup7B5eqVWPg4aRpgFJOWP7XA@mail.gmail.com>
Subject: Re: [PATCH v5 2/6] media: sun6i: Add mod_rate quirk
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

On Mon, Dec 24, 2018 at 8:57 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
>
> On Fri, Dec 21, 2018 at 6:30 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> >
> > On Thu, Dec 20, 2018 at 06:24:34PM +0530, Jagan Teki wrote:
> > > Unfortunately default CSI_SCLK rate cannot work properly to
> > > drive the connected sensor interface, particularly on few
> > > Allwinner SoC's like A64.
> > >
> > > So, add mod_rate quirk via driver data so-that the respective
> > > SoC's which require to alter the default mod clock rate can assign
> > > the operating clock rate.
> > >
> > > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > > ---
> > >  .../platform/sunxi/sun6i-csi/sun6i_csi.c      | 34 +++++++++++++++----
> > >  1 file changed, 28 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > index ee882b66a5ea..fe002beae09c 100644
> > > --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > @@ -15,6 +15,7 @@
> > >  #include <linux/ioctl.h>
> > >  #include <linux/module.h>
> > >  #include <linux/of.h>
> > > +#include <linux/of_device.h>
> > >  #include <linux/platform_device.h>
> > >  #include <linux/pm_runtime.h>
> > >  #include <linux/regmap.h>
> > > @@ -28,8 +29,13 @@
> > >
> > >  #define MODULE_NAME  "sun6i-csi"
> > >
> > > +struct sun6i_csi_variant {
> > > +     unsigned long                   mod_rate;
> > > +};
> > > +
> > >  struct sun6i_csi_dev {
> > >       struct sun6i_csi                csi;
> > > +     const struct sun6i_csi_variant  *variant;
> > >       struct device                   *dev;
> > >
> > >       struct regmap                   *regmap;
> > > @@ -822,33 +828,43 @@ static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
> > >               return PTR_ERR(sdev->clk_mod);
> > >       }
> > >
> > > +     if (sdev->variant->mod_rate)
> > > +             clk_set_rate_exclusive(sdev->clk_mod, sdev->variant->mod_rate);
> > > +
> >
> > It still doesn't make any sense to do it in the probe function...
>
> I'm not sure we discussed about the context wrt probe, we discussed
> about exclusive put clock. Since clocks were enabling in set_power and
> clock rate can be set during probe in single time instead of setting
> it in set_power for every power enablement. anything wrong with that.
>
> >
> > We discussed this in the previous iteration already.
> >
> > What we didn't discuss is the variant function that you introduce,
> > while the previous approach was enough.
>
> We discussed about clk_rate_exclusive_put, and that even handle it in
> .remove right? so I have variant to handle it in sun6i_csi_remove.

Any comments?
