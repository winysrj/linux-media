Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE25BC282CC
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 07:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9306B2148E
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 07:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="FP0capNk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfA1HcH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 02:32:07 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:39659 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfA1HcH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 02:32:07 -0500
Received: by mail-it1-f196.google.com with SMTP id a6so17921192itl.4
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 23:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mTGnqD6HTlX/N8E4wtdR/Qhebt0GeL6pNgp0cAE+85Y=;
        b=FP0capNk5QGL+WcawuamdA068tY8dz/YSgCBFM9wrmlAr+8Ovb62IcfGcrdkVDEnii
         AoOnCkSMR3Qlq3MnJeEHdWeUkD6bjikyO0+hiEltNEu6QgvTgCvsOYoEagNyFDbKfCcY
         uGLxUXJpoAiWiehBtbwO1yhM+5xr2JnVni4yk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mTGnqD6HTlX/N8E4wtdR/Qhebt0GeL6pNgp0cAE+85Y=;
        b=IYsNTof809KWwsU6yRBeYjSA9VPxfIyL83MeBtyxtQwzVAzrB1s07Z1bGjK9Wb9weO
         rKTtr4ht6kouBmiGHLmFUdHISDolp0Eq9aYW8SRwLybFMteEZyYLU52bq447LW75MABo
         swVR7zBCMR86MgYnCdpDOvPJ+OAn1v8x7zsMKnWoc3lY1DKm1gRxT66CBj/sDIHTVqGl
         2gS5hUOxZbB9bJjVxzPtKlkpnI/ve/LJ7k5fE6f1Ewd3CiYiMiA3dUTdwiyP4QTJMG7A
         QVAm83/oy1zbUvaUgDm12gRS/QiMlBkz7112v4LsNkcQ35l0s//zs99VhQ1x3/6zJ6PB
         xDDw==
X-Gm-Message-State: AJcUukdHurfx5XmmdEdyz3KFuafdWa+EpiFnt0bmazjXWaq9mRlhM4TE
        QyYtbymjkcvw/M18v3VnFSl5xjda6xw5ubwCVODJww==
X-Google-Smtp-Source: ALg8bN6QzCMRMTALAsaeCJnY8PI/UAJdQmeNoWOiUVuzDFpjWtnFZx5kxTREQHLIXcvfFMd51PKAZLZHN+jH6dSj7cs=
X-Received: by 2002:a24:385:: with SMTP id e127mr9061780ite.32.1548660725998;
 Sun, 27 Jan 2019 23:32:05 -0800 (PST)
MIME-Version: 1.0
References: <20190124180736.28408-1-jagan@amarulasolutions.com>
 <20190124180736.28408-3-jagan@amarulasolutions.com> <20190125154245.5wx2mwhzsjeaahi3@flea>
In-Reply-To: <20190125154245.5wx2mwhzsjeaahi3@flea>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Mon, 28 Jan 2019 13:01:54 +0530
Message-ID: <CAMty3ZB6Es45D=fcCLrv4dAxJAgMDr3aLbbc4hF87ZC4UizBpQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/5] media: sun6i: Add A64 CSI block support
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com,
        devicetree <devicetree@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 25, 2019 at 9:12 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> On Thu, Jan 24, 2019 at 11:37:33PM +0530, Jagan Teki wrote:
> > CSI block in Allwinner A64 has similar features as like in H3,
> > but the default CSI_SCLK rate cannot work properly to drive the
> > connected sensor interface.
> >
> > The tested mod cock rate is 300 MHz and BSP vfe media driver is also
> > using the same rate. Unfortunately there is no valid information about
> > clock rate in manual or any other sources except the BSP driver. so more
> > faith on BSP code, because same has tested in mainline.
> >
> > So, add support for A64 CSI block by setting updated mod clock rate.
> >
> > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > ---
> >  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > index ee882b66a5ea..cd2d33242c17 100644
> > --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/ioctl.h>
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> > +#include <linux/of_device.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/pm_runtime.h>
> >  #include <linux/regmap.h>
> > @@ -154,6 +155,7 @@ bool sun6i_csi_is_format_supported(struct sun6i_csi *csi,
> >  int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
> >  {
> >       struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> > +     struct device *dev = sdev->dev;
> >       struct regmap *regmap = sdev->regmap;
> >       int ret;
> >
> > @@ -161,15 +163,20 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
> >               regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
> >
> >               clk_disable_unprepare(sdev->clk_ram);
> > +             if (of_device_is_compatible(dev->of_node, "allwinner,sun50i-a64-csi"))
> > +                     clk_rate_exclusive_put(sdev->clk_mod);
> >               clk_disable_unprepare(sdev->clk_mod);
> >               reset_control_assert(sdev->rstc_bus);
> >               return 0;
> >       }
> >
> > +     if (of_device_is_compatible(dev->of_node, "allwinner,sun50i-a64-csi"))
> > +             clk_set_rate_exclusive(sdev->clk_mod, 300000000);
> > +
> >       ret = clk_prepare_enable(sdev->clk_mod);
> >       if (ret) {
> >               dev_err(sdev->dev, "Enable csi clk err %d\n", ret);
> > -             return ret;
> > +             goto clk_mod_put;
> >       }
> >
> >       ret = clk_prepare_enable(sdev->clk_ram);
> > @@ -192,6 +199,9 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
> >       clk_disable_unprepare(sdev->clk_ram);
> >  clk_mod_disable:
> >       clk_disable_unprepare(sdev->clk_mod);
> > +clk_mod_put:
> > +     if (of_device_is_compatible(dev->of_node, "allwinner,sun50i-a64-csi"))
> > +             clk_rate_exclusive_put(sdev->clk_mod);
> >       return ret;
>
> The sequence in the error path and in the disable path aren't the same, why?

True, it should be similar sequence, will fix and send next version. thanks!
