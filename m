Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA56C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 10:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9825218AE
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 10:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="H790KpFA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbeLSKmD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 05:42:03 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:35743 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728832AbeLSKmD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 05:42:03 -0500
Received: by mail-io1-f65.google.com with SMTP id o13so325333ioh.2
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 02:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I6I5jg1KYTO2ZnWGYRIpKrCIH1+bHKYeEMYRuF+H5c0=;
        b=H790KpFAEYAQoQeZjDOttAcOsXVLrqqdPiNnYIFV2Nxb//W/fM+mUYSPhrgN6U/ZPk
         UTXj9hYY6l9NaR+NukYoXtbdq1wIxSt0rMcn46lyx/hbRMtFaMIavl+5CuTh7iQ2Wiij
         B/9ycdQVLsO6qAUn1piM3+8j5ScHSorl5SSqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I6I5jg1KYTO2ZnWGYRIpKrCIH1+bHKYeEMYRuF+H5c0=;
        b=DsELLnPQmmSFFGTKxxjl78QaiLGYpGrhCcMtmTguG1Cz43cqqgtci/yZFc263mHjOX
         iZXKSn763o9ujZQdZpotDLsgQ14qqDH3EIy/Qfk1XrTN0gPK4ehOYgQW5x3kWryijPxn
         AAFNwuVipJP+uEibK3C9u6Y54PSY3hVa0SBKdKCy6Y5BPeMkB2D5COX4pZNgXBaVMMd/
         qEsdYim5e03lAgOSp3Fg/LsGZfRa5kr6fnKSFebVgLRE6ALr7Ho9+BOub6xFlLU0gdjB
         pLSvGMcb+4MdXp9O8JleUbFu7G7KVOBlTdKlIdnTZ3EI451xCzDbWWj8ocqqBrPMRNzw
         DWhw==
X-Gm-Message-State: AA+aEWZZiwZBtgAIvReKkIkgs43dNUloXAP9Z2lq86JU2cft5JytC+15
        t005Fdm3C8rNCjuNUWa8X077bfB7WkrU1S8kCCF8B9Fku4s=
X-Google-Smtp-Source: AFSGD/XFykBB1VcG+DE/qkaJQ4oV6LcEpMKEafQRWp3DLXpeT3ex0t3KF8X7HeeM7eW3Hwc/7nJeX113DgQ1sUVq0MU=
X-Received: by 2002:a6b:1411:: with SMTP id 17mr17725808iou.252.1545216122223;
 Wed, 19 Dec 2018 02:42:02 -0800 (PST)
MIME-Version: 1.0
References: <20181218113320.4856-1-jagan@amarulasolutions.com>
 <20181218152122.4zj6wgbukhrl6ly6@flea> <CAMty3ZA4xXVLKx-yj+2_iJ700+yTLesjEAgS8Wu2i8otPScpaw@mail.gmail.com>
 <20181219102450.picswsg3yevba23j@flea>
In-Reply-To: <20181219102450.picswsg3yevba23j@flea>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Wed, 19 Dec 2018 16:11:50 +0530
Message-ID: <CAMty3ZB04E46kMKVvo-QxpVQBus74at3uKJC_QzS788UiCAeeg@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] media/sun6i: Allwinner A64 CSI support
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

On Wed, Dec 19, 2018 at 3:55 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
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

Previous version has A64-Relic board, which has some xclk issue on
sensor side wrt 1080p. I have tried 300MHz on the same hardware, it's
failing to capture on 30fps and so I tried 600MHz(which is default) on
the same configuration but it encounter memory corruption.

So, for checking whether there is an issue with hardware on A64-Relic
I moved with BPI-M64 dev board. which is working 1080p with 300MHz, ie
reason I have not included A64-Relic on this version and included
BPI-M64. We processed A64-Relic to hardware team to figure out the
clock and once ie fixed I'm planning to send DTS patch for that.

This is overall summary, hope you understand.
