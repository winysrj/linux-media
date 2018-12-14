Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138B5C65BAE
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 02:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C9820811
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 02:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6C9820811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbeLNCYC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 21:24:02 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:47083 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbeLNCYC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 21:24:02 -0500
Received: by mail-ed1-f67.google.com with SMTP id o10so3687375edt.13;
        Thu, 13 Dec 2018 18:24:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WrNL09/DBqFQdRHyvLiqUAfyU2rTzrkrVarVXUnajTc=;
        b=S+4QEu77uSRlSTTPczBx0iefEyx/zCDCJDfaXUWAjU9a64c+BhBWPXrM0fgZWEIp1y
         sv4KXmsGOzLRAUwZDrr4Dtkry5Oe0xDdv3FQ02obksE1JidqqkdXv7TEidewRFxaHnZw
         Hv8QDzIIRIGi0SRubjR36TCPCLarKD8V6DyWyiEzxL5OOS6VjSst++IqDFrMsRp6EpiP
         GEC4QVqM/YIei3ZGprdiOLM9To/QrXfSiPJXm10FwI2BLtjiMKiLXzKCpwpG6jdymxT6
         8UyyoLdJ0cIGFcOAYyIEnugia0h10iVUuJFvd2V9jtCFCs6eaamTCxzKa/m59Mke17dN
         wuAg==
X-Gm-Message-State: AA+aEWbmXmY+f9v023O9NO9IzHDBW2R/FU76UbwwMxiYwXET1LQWJUxj
        kBO6/m7r8KSI80BBlIMEoCnj7G01m0w=
X-Google-Smtp-Source: AFSGD/XpHQWyXtdxR6TPU6AN+2yT1zUAGBcArETjbMb+++H0SPAZdAsk5DndG2WcwNg98VXlsEfs4A==
X-Received: by 2002:a50:a826:: with SMTP id j35mr1417136edc.230.1544754239671;
        Thu, 13 Dec 2018 18:23:59 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id b49sm1184102edb.73.2018.12.13.18.23.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 18:23:59 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id t27so3943795wra.6;
        Thu, 13 Dec 2018 18:23:58 -0800 (PST)
X-Received: by 2002:a5d:5208:: with SMTP id j8mr1018504wrv.188.1544754238556;
 Thu, 13 Dec 2018 18:23:58 -0800 (PST)
MIME-Version: 1.0
References: <20181130075849.16941-1-wens@csie.org> <20181213221030.f7c5mzuyke3ik43r@valkosipuli.retiisi.org.uk>
In-Reply-To: <20181213221030.f7c5mzuyke3ik43r@valkosipuli.retiisi.org.uk>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Fri, 14 Dec 2018 10:23:46 +0800
X-Gmail-Original-Message-ID: <CAGb2v675OQ6CQLr3Gzjd6yN-wkfB=ZfttgtTceN5AD2EXo2YEw@mail.gmail.com>
Message-ID: <CAGb2v675OQ6CQLr3Gzjd6yN-wkfB=ZfttgtTceN5AD2EXo2YEw@mail.gmail.com>
Subject: Re: [PATCH 0/6] media: sun6i: Separate H3 compatible from A31
To:     sakari.ailus@iki.fi
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 14, 2018 at 6:10 AM <sakari.ailus@iki.fi> wrote:
>
> Hi Chen-Yu,
>
> On Fri, Nov 30, 2018 at 03:58:43PM +0800, Chen-Yu Tsai wrote:
> > The CSI (camera sensor interface) controller found on the H3 (and H5)
> > is a reduced version of the one found on the A31. It only has 1 channel,
> > instead of 4 channels supporting time-multiplexed BT.656 on the A31.
> > Since the H3 is a reduced version, it cannot "fallback" to a compatible
> > that implements more features than it supports.
> >
> > This series separates support for the H3 variant from the A31 variant.
> >
> > Patches 1 ~ 3 separate H3 CSI from A31 CSI in the bindings, driver, and
> > device tree, respectively.
> >
> > Patch 4 adds a pinmux setting for the MCLK (master clock). Some camera
> > sensors use the master clock from the SoC instead of a standalone
> > crystal.
>
> I've picked patches 1 and 2, but I presume patches 3 and 4 would go through
> another tree. Is that right?

We'll merge patch 3 through the sunxi tree, probably as a fix for 4.21-rc.
Maxime has said that pinmux settings won't be merged unless there are actual
users in tree, so patch 4 won't be merged for now.

Thanks!
ChenYu

>
> >
> > Patches 5 and 6 are examples of using a camera sensor with an SBC.
> > Since the modules are detachable, these changes should not be merged.
> > They should be implemented as overlays instead.
> >
> > Please have a look.
> >
> > In addition, I found that the first frame captured seems to always be
> > incomplete, with either parts cropped, out of position, or missing
> > color components.
>
>
> --
> Regards,
>
> Sakari Ailus
