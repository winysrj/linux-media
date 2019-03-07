Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F448C4360F
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D82C20663
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:44:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="yGdrD+G8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfCGAor (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 19:44:47 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39800 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfCGAoq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 19:44:46 -0500
Received: by mail-lf1-f66.google.com with SMTP id r123so10334105lff.6
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 16:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=EdjfCiuchCbekJL4W7Giat1B0A1+6kbzRqbvJfARqlc=;
        b=yGdrD+G8TXw0jTbeLkrNFcZ8X4Z0I8Ox06o3AfwqnCs0ZgZwHls2CNP+mCy/mpNC31
         z59bipRAG+TT65ldVT0RHtkjHvg7fVFQ+71OF37QBP70mwkx5d1tvxAy7/dNA+3KU6tG
         qr7BfMU5WEEjEWVHnRUsAANw2UWVId3TWqR+heEXE30ll2af24zKKHsxkG96zJy63VyH
         zlr2Yvski81UO5lCh9chIWFTFQMjr8lL1hcg5k5MB29MRTtDryekDjxSN8ftahjJYLIC
         J8UugQwEamdIRBrIoEl78KdhfGTqGAGaYrUxaIyDlRARgzZjLrzcbaoHj+qPcQ/2BPcn
         Ct6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=EdjfCiuchCbekJL4W7Giat1B0A1+6kbzRqbvJfARqlc=;
        b=sGCJmK3s+SMQIH9U3Ls/uKe+1JPMX6IQnlOCqIXipuCRZnK7WGt3pI5Ws8w0dJVZVS
         PbHk5/2SmYWZpxdtnLkMbH4KRmMnxFuo+BMUVYvrKwAazNxVEjF1UNjnZgH0u9t9onbS
         M7KQC8uBLTZcQ/i3XuzocpHSsQYSRAAjOIBc6uUqCt1uFF7jXDzQ0bq6/rwofhbfqVzF
         2eR1qvYD6rnEcy5Q5xdzG1nOECLCYGz6CmsepwJAaANWYt/kGzZEO9Ges4DlAWMaCaDB
         EUPsH2rFknRTo9w1FRU8SBj5jCF6IaNo5ahJo7V2tQ+0GjzGd+r5J8Ig7d6kC+PuHDS8
         Hltg==
X-Gm-Message-State: APjAAAXSw6ZMdGbjnGQnl6un3qu/RdphM8HZ2cPUKWBzsEQ/tHQjYx/D
        FdUkeh5ydTs93a7YlL6d3XYsMg==
X-Google-Smtp-Source: APXvYqz6810hE3F6lqWBJAMV7IWHMbLp7T0cClzDY8Ko2y7z4QSG7N2dVh9GMuCnLgh0I0xamNW1rQ==
X-Received: by 2002:a19:c50f:: with SMTP id w15mr5630410lfe.81.1551919484884;
        Wed, 06 Mar 2019 16:44:44 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id w30sm573693ljd.65.2019.03.06.16.44.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Mar 2019 16:44:43 -0800 (PST)
Date:   Thu, 7 Mar 2019 01:44:43 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
Message-ID: <20190307004443.GO9239@bigcity.dyn.berto.se>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
 <TYXPR01MB1775F18270FB477D010C180EC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
 <8a5429a0-b4c5-a208-3e56-406bd031b01b@xs4all.nl>
 <20190301130613.GB32244@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190301130613.GB32244@pendragon.ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans, Laurent,

On 2019-03-01 15:06:13 +0200, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Fri, Mar 01, 2019 at 01:55:53PM +0100, Hans Verkuil wrote:
> > Hi Fabrizio,
> > 
> > It looks like this series fell through the cracks.
> > 
> > I looked at it and the main problem is that it is missing a Reviewed-by
> > from Rob Herring (devicetree maintainer). It's a bit surprising since he
> > is usually fairly prompt.
> > 
> > I recommend that you rebase and repost it and I'll delegate the v2 series
> > to me so we can hopefully get it in for 5.2 (5.1 is likely too late) once
> > Rob reviews it.
> > 
> > BTW, I'm the one who usually processes rcar patches. But it was delegated in
> > patchwork to Laurent, so I never saw it.
> 
> I handle the VSP and FDP patches. I propose delegating the CSI-2 and VIN
> to Niklas.

I be more then happy to collect patches for R-Car VIN and CSI-2 and send
PRs for them to you Hans. Would that work for you Hans?

-- 
Regards,
Niklas Söderlund
