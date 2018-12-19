Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38124C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 10:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05BB921871
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 10:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="rGN0HFR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbeLSKmu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 05:42:50 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:51521 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728751AbeLSKmu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 05:42:50 -0500
Received: by mail-it1-f193.google.com with SMTP id w18so8634137ite.1
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 02:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TIsaOUia+4f6xiB5ne3A07PpfINF67awrDp0lnaaVwA=;
        b=rGN0HFR6UM/at1z8mRFLiTvtXFt9ibuZMTACZ0XLLWxdXt+SSALX9eFLLwY000QGsc
         ycPc87ljD/pXurAOY/Y06Y7BmGpyrZLBbKUauTcfNpPc5tIbnsiGpaV9MJpifMBM7xNw
         CEVxLmE35zYtXeoNa66ZRqE3D1xSISGZ/RZOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TIsaOUia+4f6xiB5ne3A07PpfINF67awrDp0lnaaVwA=;
        b=Zam/SckC0HEtIXyXja+ILS/jsOPYepO51AWWq6oUbvSzyUl6MziHYwkWDxAveZaq5Q
         WFhANqubn6wxr7Vd21obbiPaqJ9ElfTX7sLJz1izR0lXIzN7UxtsuDSVw1D32zXJPteU
         oIJWbCIs2UDuYUTRjNsw/abD+TiZAFlhNnOnyC1zBpL4xZKk/4g94pSoCBdn8FtM2k0C
         8LrJOj3T+6skLV0ncVSnb9PS902zg+XmNwIZDf5RP+ntAWklJnrVAwHNDBur3N7OC2wE
         twyNRRMtzJZ2FAgXYaqRTIEuNTCJBxlZV0WHIK04dmbHqdIwb4eozz/JwVskUBw/D4ch
         PlQQ==
X-Gm-Message-State: AA+aEWaJEb/A+yBSfop/bzY4Br5p3lAh8a38uWmwV7VhAHfOkLPeZPvL
        CokXIYQXknCgfW7u1/Gjp+kxNpM2Rw8CDTVb2eW26g==
X-Google-Smtp-Source: AFSGD/UNfYBBYtAG2Nw1A2p+D0ueJnUI8wDsbqBGB52Ihg6vJfQgO94aSPji9meSv+0PKGZCvC5lGisycx2aqaSlTIQ=
X-Received: by 2002:a02:104a:: with SMTP id 71mr7451064jay.103.1545216169586;
 Wed, 19 Dec 2018 02:42:49 -0800 (PST)
MIME-Version: 1.0
References: <20181218113320.4856-1-jagan@amarulasolutions.com>
 <20181218113320.4856-4-jagan@amarulasolutions.com> <20181218152318.duynff7f5m2gxtv4@flea>
 <CAMty3ZCS+QT_YqbJueR-qeityaDxNbQ7p_d3D6bNATSJLQpRnQ@mail.gmail.com> <20181219100738.iakvqigi7z3k2coa@flea>
In-Reply-To: <20181219100738.iakvqigi7z3k2coa@flea>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Wed, 19 Dec 2018 16:12:38 +0530
Message-ID: <CAMty3ZDm0jPTigzX_jnNcOKRp6MbTFuwHpaTUmxnnkW8AQZRng@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] media: sun6i: Update default CSI_SCLK for A64
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

On Wed, Dec 19, 2018 at 3:37 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> On Tue, Dec 18, 2018 at 09:08:17PM +0530, Jagan Teki wrote:
> > On Tue, Dec 18, 2018 at 8:53 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > >
> > > On Tue, Dec 18, 2018 at 05:03:17PM +0530, Jagan Teki wrote:
> > > > Unfortunately A64 CSI cannot work with default CSI_SCLK rate.
> > > >
> > > > A64 BSP is using 300MHz clock rate as default csi clock,
> > > > so sun6i_csi require explicit change to update CSI_SCLK
> > > > rate to 300MHZ for A64 SoC's.
> > > >
> > > > So, set the clk_mod to 300MHz only for A64.
> > > >
> > > > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > > > ---
> > > >  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > index 9ff61896e4bb..91470edf7581 100644
> > > > --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> > > > @@ -822,6 +822,11 @@ static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
> > > >               return PTR_ERR(sdev->clk_mod);
> > > >       }
> > > >
> > > > +     /* A64 require 300MHz mod clock to operate properly */
> > > > +     if (of_device_is_compatible(pdev->dev.of_node,
> > > > +                                 "allwinner,sun50i-a64-csi"))
> > > > +             clk_set_rate_exclusive(sdev->clk_mod, 300000000);
> > > > +
> > >
> > > If you're using clk_set_rate_exclusive, you need to put back the
> > > "exclusive" reference once you're not using the clock.
> > >
> > > Doing it here is not really optimal either, since you'll put a
> > > constraint on the system (maintaining that clock at 300MHz), while
> > > it's not in use.
> >
> > I think we can handle via clk_rate_exclusive_put for those errors
> > cases? If I'm not wrong
>
> Yes, but it's not only for the error case, it's also for the inactive
> case.

Yes, I will try to add this next version.
