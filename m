Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F42C43444
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 06:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93CB620675
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 06:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="YJ26QTTr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfAKGFm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 01:05:42 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:37944 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728789AbfAKGFm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 01:05:42 -0500
Received: by mail-io1-f68.google.com with SMTP id l14so11343572ioj.5
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 22:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GMfxBDBj51g4/LgB4KANuC0aezrsIPcZoBlXSsXh8CY=;
        b=YJ26QTTrBb0XvooQeIN7ACUccZBi5iSSXiBEWBE6w/1c+c7Kfw2zXAR2R0AYFUUZ/j
         rXSn1uDg650mfCe8G7UbFvqgB3ooOrJwr6041JGre2T8GU//qmicq8drCEr+GCMGGl2t
         Jd11J7FX6IC+cl0LP6zcYlQTx0Fi+nhVfrwg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GMfxBDBj51g4/LgB4KANuC0aezrsIPcZoBlXSsXh8CY=;
        b=Zsx+UILIJIlMzkRm0socan5rHr/Z7XBb+ulQu1QIyDc0QAeLkETdZOsowY2ZiOn+SE
         olWLwGQNdTFkIsqLJQYTCK3pz3QH0Pk6lty3u0lwRVwREDTsiE7gLJ5F8jlFSYC2QfLr
         +SjAEHJz4SYbAqIuVxhxXg8JTVEV6ny4lFQA3HtWpUZvlfCzikR0R2iVaFTVIzJWaKBZ
         cSXMzigsf9CL9Cujp2+aTPMuF8NSKJ/i1KdgueB0byy9D/d45BsJWYpvvcPtrfVyvtl5
         HbUZiHq5eyWsyiT5fYbjifmwKqotfD3QB4rKCLPRZ/2AUX3eC9EBtM0rfkq1+x+/WG0k
         bwxQ==
X-Gm-Message-State: AJcUukfAyvUeKgrj+sMrtG8N0oVmLTHo8gfoGWCmxlGq2r/AzkqxufQH
        boemvfzuqnlL/CI+wb6P5eTTSTST50l9MdhvN1hVjQ==
X-Google-Smtp-Source: ALg8bN7Z/2+9dpkuuf4RYz9izMExwXaxmaDc2H9xzT2OKgtyn1+UI1D3i4h7W2C6fe3xa/svc/uNAdobR67kWb7/9tg=
X-Received: by 2002:a6b:7a0a:: with SMTP id h10mr8233118iom.114.1547186741145;
 Thu, 10 Jan 2019 22:05:41 -0800 (PST)
MIME-Version: 1.0
References: <20181220125438.11700-1-jagan@amarulasolutions.com>
 <20181220125438.11700-3-jagan@amarulasolutions.com> <20181221130025.lbvw7yvy74brf3jn@flea>
 <CAMty3ZCG5cF3tP2mid5xyS=yhtxkY+TOcGkwRkv+vrZt1=0iQg@mail.gmail.com> <20190107132929.ksyajmzn2gzr6oep@flea>
In-Reply-To: <20190107132929.ksyajmzn2gzr6oep@flea>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Fri, 11 Jan 2019 11:35:29 +0530
Message-ID: <CAMty3ZAAa0VEOt50prvEApdNi9tkPe_vFC4oKone0z6pVd_Ziw@mail.gmail.com>
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

On Mon, Jan 7, 2019 at 6:59 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> On Mon, Dec 24, 2018 at 08:57:48PM +0530, Jagan Teki wrote:
> > On Fri, Dec 21, 2018 at 6:30 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > >
> > > On Thu, Dec 20, 2018 at 06:24:34PM +0530, Jagan Teki wrote:
> > > > Unfortunately default CSI_SCLK rate cannot work properly to
> > > > drive the connected sensor interface, particularly on few
> > > > Allwinner SoC's like A64.
> > > >
> > > > So, add mod_rate quirk via driver data so-that the respective
> > > > SoC's which require to alter the default mod clock rate can assign
> > > > the operating clock rate.
> > > >
> > > > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > > > ---
> > > >  .../platform/sunxi/sun6i-csi/sun6i_csi.c      | 34 +++++++++++++++----
> > > >  1 file changed, 28 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > index ee882b66a5ea..fe002beae09c 100644
> > > > --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > @@ -15,6 +15,7 @@
> > > >  #include <linux/ioctl.h>
> > > >  #include <linux/module.h>
> > > >  #include <linux/of.h>
> > > > +#include <linux/of_device.h>
> > > >  #include <linux/platform_device.h>
> > > >  #include <linux/pm_runtime.h>
> > > >  #include <linux/regmap.h>
> > > > @@ -28,8 +29,13 @@
> > > >
> > > >  #define MODULE_NAME  "sun6i-csi"
> > > >
> > > > +struct sun6i_csi_variant {
> > > > +     unsigned long                   mod_rate;
> > > > +};
> > > > +
> > > >  struct sun6i_csi_dev {
> > > >       struct sun6i_csi                csi;
> > > > +     const struct sun6i_csi_variant  *variant;
> > > >       struct device                   *dev;
> > > >
> > > >       struct regmap                   *regmap;
> > > > @@ -822,33 +828,43 @@ static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
> > > >               return PTR_ERR(sdev->clk_mod);
> > > >       }
> > > >
> > > > +     if (sdev->variant->mod_rate)
> > > > +             clk_set_rate_exclusive(sdev->clk_mod, sdev->variant->mod_rate);
> > > > +
> > >
> > > It still doesn't make any sense to do it in the probe function...
> >
> > I'm not sure we discussed about the context wrt probe, we discussed
> > about exclusive put clock.
>
> https://lkml.org/lkml/2018/12/18/584
>
> "Doing it here is not really optimal either, since you'll put a
> constraint on the system (maintaining that clock at 300MHz), while
> it's not in use."
>
> > Since clocks were enabling in set_power and clock rate can be set
> > during probe in single time instead of setting it in set_power for
> > every power enablement. anything wrong with that.
>
> See above.
>
> Plus, a clock running draws power. It doesn't really make sense to
> draw power for something that is unused.

True, but clock is enabled only on sun6i_csi_set_power so setting
clock frequency in probe will draw power?
