Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CBDC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 10:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7120D21873
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 10:32:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="FrGJrBQu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbeLSKcD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 05:32:03 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33376 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbeLSKcC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 05:32:02 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so18965947wrr.0
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 02:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UhnBIZYHMR/cYbeYFKc3PaWigVNId4aaU5FOYilDt/Q=;
        b=FrGJrBQuBOIr9FsDUXpaetzaQz2hLymHHJfEmMoLvFmVBSs8jBAWIAS0SpDXTY3QsB
         szUwTJqOYKqP0ayTuBSRVnqoIx5H/Re7/eyZ5QUoGjdruHEKwliNNE4AT8dh7DqOYsVj
         V0nsCCD1i6vJWVPfCR5KVVW7FkLdMzHArHvYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UhnBIZYHMR/cYbeYFKc3PaWigVNId4aaU5FOYilDt/Q=;
        b=oiIkFRG+F4xWeBWvTj984pBSn0j4ijkWQxgulKpivR1rALUn9PJ/MVDbkalGPb/U1Y
         0LnFQ2B/54AJSZ45WOT0Jd3JNOIyrvrvNSYmnPU8CSG4VA50UWsD8DooKq9MaUfqukZc
         3Zl1OJw0+umkP16OypupWyxJOsGGCSzaxA2uLqGK3DQ0LmiB/zjYKE2hxgx9fNO+wWHC
         /JP8N8HYR79Ui/mNuXKZrsBMvBecp2lrJsH0Qi9miWcpq2LeKnoqw3lo6BDR0Rp3E3rj
         r6WCrICzbx9yITUv7MaNBQNDgdrpWs+CHLTDwXEwBh7RwMFVIAROOKrQLDR0GKl7+fPY
         RRMw==
X-Gm-Message-State: AA+aEWYkMipH9pHrE7V8zW0QzQrIKgsiFPEYyujsT5jYmbTVlC14XlSb
        VOMF+HCSC+Lc7NE/glQdTqjsXxAjbHQudVS2nSVT6g==
X-Google-Smtp-Source: AFSGD/XqFgtlWXCVfvm19ylqbfNH1z4ZfKteBxq4j00eANhexFbgADWZiWuhUMuAWhpZ4mFapFmJMUrp2a1sc3zanDA=
X-Received: by 2002:adf:9422:: with SMTP id 31mr19353343wrq.106.1545215521131;
 Wed, 19 Dec 2018 02:32:01 -0800 (PST)
MIME-Version: 1.0
References: <20181218113320.4856-1-jagan@amarulasolutions.com>
 <20181218152122.4zj6wgbukhrl6ly6@flea> <CAMty3ZA4xXVLKx-yj+2_iJ700+yTLesjEAgS8Wu2i8otPScpaw@mail.gmail.com>
 <20181219102450.picswsg3yevba23j@flea>
In-Reply-To: <20181219102450.picswsg3yevba23j@flea>
From:   Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date:   Wed, 19 Dec 2018 11:31:50 +0100
Message-ID: <CAOf5uwnjR8QPeu36+t3Y_19D=+nGXJ6aMiuEzbYs7r_urKzfUw@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] media/sun6i: Allwinner A64 CSI support
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Jagan Teki <jagan@amarulasolutions.com>,
        Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-amarula@amarulasolutions.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Maxime

On Wed, Dec 19, 2018 at 11:25 AM Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
>
> On Tue, Dec 18, 2018 at 08:58:22PM +0530, Jagan Teki wrote:
> > On Tue, Dec 18, 2018 at 8:51 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > >
> > > On Tue, Dec 18, 2018 at 05:03:14PM +0530, Jagan Teki wrote:
> > > > This series support CSI on Allwinner A64.
> > > >
> > > > Tested 640x480, 320x240, 720p, 1080p resolutions UYVY8_2X8 format.
> > > >
> > > > Changes for v4:
> > > > - update the compatible string order
> > > > - add proper commit message
> > > > - included BPI-M64 patch
> > > > - skipped amarula-a64 patch
> > > > Changes for v3:
> > > > - update dt-bindings for A64
> > > > - set mod clock via csi driver
> > > > - remove assign clocks from dtsi
> > > > - remove i2c-gpio opendrian
> > > > - fix avdd and dovdd supplies
> > > > - remove vcc-csi pin group supply
> > > >
> > > > Note: This series created on top of H3 changes [1]
> > > >
> > > > [1] https://patchwork.kernel.org/cover/10705905/
> > >
> > > You had memory corruption before, how was this fixed?
> >
> > Memory corruption observed with default 600MHz on 1080p. It worked
> > fine on BPI-M64 (with 300MHz)
>
> I don't get it. In the previous version of those patches, you were
> mentionning you were still having this issue, even though you had the
> clock running at 300MHz, and then you tried to convince us to merge
> the patches nonetheless.
>
> Why would you say that then if that issue was fixed?

It's simple, we have a full working platform with ov5640 that support
all the resolutions, that can be test by anyone and
we have an industrial product that has some problem on high xvclk
because it can not give us a clear image but this is limited on
another design and another camera module vendor. Problem is not in the
kernel code but it's just on relic design. We are getting
the information on that module and see if inside is really using the
xvclk or it's clocked by some other things. We have only the schematic
up to the connector.

Michael

>
> Maxime
>
> --
> Maxime Ripard, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com



-- 
| Michael Nazzareno Trimarchi                     Amarula Solutions BV |
| COO  -  Founder                                      Cruquiuskade 47 |
| +31(0)851119172                                 Amsterdam 1018 AM NL |
|                  [`as] http://www.amarulasolutions.com               |
