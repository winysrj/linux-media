Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 687F1C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 23:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33960206A3
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 23:13:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="g0kr04RN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfBUXM7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 18:12:59 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49202 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfBUXM7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 18:12:59 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 83E29255;
        Fri, 22 Feb 2019 00:12:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550790777;
        bh=kFC0xIXVUL3R5C2VsXSBFX6bqFXSBApC7F2ALP8OmC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g0kr04RNY3iX/QzlmvDFwWlrrMzt50BJFvo/P45yq9UP3bhAo8XueJ11Sayzn+79o
         FqZgcJ612OZAlChPEOfIzSoXieTfWfcODMORqqop73i7Qw2/lzMPZFxIiKoPv4gcei
         z1xYFEwjUfMLDyHElFdIN21lue9KVJMJ0fxe9wJ0=
Date:   Fri, 22 Feb 2019 01:12:52 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Brian Starkey <Brian.Starkey@arm.com>
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, nd <nd@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] VSP1: Display writeback support
Message-ID: <20190221231252.GE3485@pendragon.ideasonboard.com>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190218122257.o5blxfs7jo5xu7ge@DESKTOP-E1NTVVP.localdomain>
 <20190221082317.GB3451@pendragon.ideasonboard.com>
 <20190221095019.rht64aylk52jqe5r@DESKTOP-E1NTVVP.localdomain>
 <20190221100257.GD3451@pendragon.ideasonboard.com>
 <20190221121913.l7e5zlitcfpvkupi@DESKTOP-E1NTVVP.localdomain>
 <20190221122310.GM3451@pendragon.ideasonboard.com>
 <20190221134456.ahwo7xt3wcfc6zkw@DESKTOP-E1NTVVP.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190221134456.ahwo7xt3wcfc6zkw@DESKTOP-E1NTVVP.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Brian,

On Thu, Feb 21, 2019 at 01:44:56PM +0000, Brian Starkey wrote:
> On Thu, Feb 21, 2019 at 02:23:10PM +0200, Laurent Pinchart wrote:
> > On Thu, Feb 21, 2019 at 12:19:13PM +0000, Brian Starkey wrote:
> 
> [snip]
> 
> >> I used a pre-existing internal tool which does exactly that.
> > 
> > Any hope of sharing the sources ?
> 
> Not in a timescale or form which would be useful to you. I'm convinced
> people only ask questions like this to make us look like Bad Guys.

I didn't have big hopes, but it was a honest question.

> Opening everything up is a process, and it's going to take us time.
> Sure we could be doing better, but I also think there's a lot of
> people who do worse.

No question that ARM is neither the worst nor the best. I also value
your and the other graphics developer's efforts more than I value ARM's
open-source policy, as you are fighting against company policies to
drive open-source.

> >> I appreciate that we don't have upstream tooling for writeback. As you
> >> say, it's a young API (well, not by date, but certainly by usage).
> >> 
> >> I also do appreciate you taking the time to consider it, identifying
> >> issues which we did not, and for fixing them. The only way it stops
> >> being a young API, with bugs and no tooling, is if people adopt it.
> > 
> > If the developers who initially pushed the API upstream without an
> > open-source test tool could spend a bit of time on this issue, I'm sure
> > it would help too :-)
> 
> No one suggested a test test tool before. In fact, the DRM subsystem
> explicitly requires that features land with something that isn't only
> a test tool, hence why we did drm_hwcomposer.
> 
> That said, yes, we should be trying harder to get the igts landed. I
> personally think igts are far more useful than a random example C
> file, but I guess opinions differ.

I think both are useful, for different purposes. Automated test cases
are very valuable to test for compliance and catch regressions, while a
manualy tool is very valuable during development.

-- 
Regards,

Laurent Pinchart
