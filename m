Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133D3C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 04:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D537F20657
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 04:34:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="KZFPWe/i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbfAQEeU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 23:34:20 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:40713 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbfAQEeU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 23:34:20 -0500
Received: by mail-it1-f194.google.com with SMTP id h193so6008825ita.5
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 20:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ncfqnoSxbMnH+Fh+JaP/u+vtHVJmV/Txi/tk5jsE1wU=;
        b=KZFPWe/iqDMTX1Z0rZuglCSYugvqmZAr8uYaIvWOq+aCivOr8RSzEAm9MACZm2SV7B
         oqiSM4j2jtsbo+jBocrC7Px31uIXaSmdXGV54ycyG/qaBU0kRt7nqwcyKcEnD4H9FzVt
         9SqzRQ5uOHSkOfL8XVsx+4P142FN14EZA3eb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ncfqnoSxbMnH+Fh+JaP/u+vtHVJmV/Txi/tk5jsE1wU=;
        b=XEB9XzMEi4vVDTjIBqoffonlco2dUxYxIk8Ugp73Bwhjjjc+9V0AzJaylkD+BhsXTI
         CatDBFg15XCM4bflYVSKzQzznQof4VaM7nRnlcWvr9xZrbixH8G5EfLVheJG5ySwubYp
         mFJKBsEbIvmmcRXEhbqbnfOw7flFc/m0JHxJl/KXhZTs4atvKEg4vy7bYsOjxcMs/E5t
         dXtOzEJ6aDWj9CoqPB8aZi+e5/Jgq+l4d0+ZnG3SkfvMhF0eZlmJVhnQpzfSR3YdSvdR
         LAzKt9gdQ8F/dRxq4mHWpZX/BCgBNAYiX/CUgjdxvQLOdXWWi/dk5UqTpoKIHXFv+0Jd
         bpqQ==
X-Gm-Message-State: AJcUukdX+SAcE12L3WA5NX3+OXj0b4kz4QjvDBAaKnx2S6hQh/VmMe2a
        OfDg35QZ0UCCnPoe/8R+aNNlZQusd1K9hkNeWDE2sQIp2VI=
X-Google-Smtp-Source: ALg8bN7PY+YyWWjnAskyUKb7H5PgEJxwvAQCMXiyFS7v4t4l7nbNcfqbkzzCuTUHsVmk+k7DWGxgb01bYWne72CtBwI=
X-Received: by 2002:a02:4d99:: with SMTP id t25mr7459772jad.58.1547699659321;
 Wed, 16 Jan 2019 20:34:19 -0800 (PST)
MIME-Version: 1.0
References: <20181220125438.11700-1-jagan@amarulasolutions.com>
 <20181220125438.11700-3-jagan@amarulasolutions.com> <20181221130025.lbvw7yvy74brf3jn@flea>
 <CAMty3ZCG5cF3tP2mid5xyS=yhtxkY+TOcGkwRkv+vrZt1=0iQg@mail.gmail.com>
 <20190107132929.ksyajmzn2gzr6oep@flea> <CAMty3ZAx9MthB0M-eFmsZv9CxF3Z1BkFTU6Hw=ZT5wu6aJwjGQ@mail.gmail.com>
 <20190116111109.dkc4zgsz6lcjlzs5@flea>
In-Reply-To: <20190116111109.dkc4zgsz6lcjlzs5@flea>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Thu, 17 Jan 2019 10:04:08 +0530
Message-ID: <CAMty3ZDVMW_BRmBgqjHWbkQF7P7T81Z5q3er9mBiJeeEVBZWXQ@mail.gmail.com>
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

On Thu, Jan 17, 2019 at 12:48 AM Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
>
> On Fri, Jan 11, 2019 at 11:54:12AM +0530, Jagan Teki wrote:
> > On Mon, Jan 7, 2019 at 6:59 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > > On Mon, Dec 24, 2018 at 08:57:48PM +0530, Jagan Teki wrote:
> > > > On Fri, Dec 21, 2018 at 6:30 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > > > >
> > > > > On Thu, Dec 20, 2018 at 06:24:34PM +0530, Jagan Teki wrote:
> > > > > > Unfortunately default CSI_SCLK rate cannot work properly to
> > > > > > drive the connected sensor interface, particularly on few
> > > > > > Allwinner SoC's like A64.
> > > > > >
> > > > > > So, add mod_rate quirk via driver data so-that the respective
> > > > > > SoC's which require to alter the default mod clock rate can assign
> > > > > > the operating clock rate.
> > > > > >
> > > > > > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > > > > > ---
> > > > > >  .../platform/sunxi/sun6i-csi/sun6i_csi.c      | 34 +++++++++++++++----
> > > > > >  1 file changed, 28 insertions(+), 6 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > > > index ee882b66a5ea..fe002beae09c 100644
> > > > > > --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > > > +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > > > @@ -15,6 +15,7 @@
> > > > > >  #include <linux/ioctl.h>
> > > > > >  #include <linux/module.h>
> > > > > >  #include <linux/of.h>
> > > > > > +#include <linux/of_device.h>
> > > > > >  #include <linux/platform_device.h>
> > > > > >  #include <linux/pm_runtime.h>
> > > > > >  #include <linux/regmap.h>
> > > > > > @@ -28,8 +29,13 @@
> > > > > >
> > > > > >  #define MODULE_NAME  "sun6i-csi"
> > > > > >
> > > > > > +struct sun6i_csi_variant {
> > > > > > +     unsigned long                   mod_rate;
> > > > > > +};
> > > > > > +
> > > > > >  struct sun6i_csi_dev {
> > > > > >       struct sun6i_csi                csi;
> > > > > > +     const struct sun6i_csi_variant  *variant;
> > > > > >       struct device                   *dev;
> > > > > >
> > > > > >       struct regmap                   *regmap;
> > > > > > @@ -822,33 +828,43 @@ static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
> > > > > >               return PTR_ERR(sdev->clk_mod);
> > > > > >       }
> > > > > >
> > > > > > +     if (sdev->variant->mod_rate)
> > > > > > +             clk_set_rate_exclusive(sdev->clk_mod, sdev->variant->mod_rate);
> > > > > > +
> > > > >
> > > > > It still doesn't make any sense to do it in the probe function...
> > > >
> > > > I'm not sure we discussed about the context wrt probe, we discussed
> > > > about exclusive put clock.
> > >
> > > https://lkml.org/lkml/2018/12/18/584
> > >
> > > "Doing it here is not really optimal either, since you'll put a
> > > constraint on the system (maintaining that clock at 300MHz), while
> > > it's not in use."
> >
> > But this constraint is only set, for SoC's who need mod_rate change
> > not for whole SoCs.
>
> Still, that constraint is there for the whole system on affected
> SoCs. Whether it applies to one SoC or not is not really relevant.

OK, please see this code change and let me know the comments.

https://gist.github.com/openedev/518b9e141f53814bb3adfac6f2bfd78c
