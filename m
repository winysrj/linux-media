Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB8EC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 10:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CBD220700
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 10:03:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Vce095GU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfBVKDf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:03:35 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:57972 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfBVKDf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 05:03:35 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8C6E2255;
        Fri, 22 Feb 2019 11:03:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550829813;
        bh=NakHNHDHVLs0l8eNyy93tJZWDOF9c1uT1Y6AI3b+sPc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vce095GUKsBRejHpfb5/sEObh9xzn6n74EWf1vDsR8CuBmgbZVaS6X7sO+ku4KUIb
         l7c+JV8Yvr6JQFRqNCCla3HNkXOGjGcE0gHw2WVOFaB+uw2iKZOnvgYzpi0if0O6Sz
         JHUraMa/+cYwKZkigTUq4Q+f0BLJujCzb+Pmi3wU=
Date:   Fri, 22 Feb 2019 12:03:29 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH yavta 0/3] Fixes for compound control support
Message-ID: <20190222100329.GC3522@pendragon.ideasonboard.com>
References: <20190220151952.15376-1-laurent.pinchart@ideasonboard.com>
 <20190220213428.osyghernh5drqo7x@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190220213428.osyghernh5drqo7x@valkosipuli.retiisi.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Feb 20, 2019 at 11:34:28PM +0200, Sakari Ailus wrote:
> On Wed, Feb 20, 2019 at 05:19:49PM +0200, Laurent Pinchart wrote:
> > Hello,
> > 
> > This small series fixes issues in yavta reported during the review of
> > the compound control support patches.
> > 
> > Laurent Pinchart (3):
> >   Fix emulation of old API for string controls
> >   Print numerical control type for unsupported types
> >   Fix control array parsing
> > 
> >  yavta.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> 
> Oh my. Aren't you planning to send v2 that would address the comments?

I would have if v1 hadn't been merged yet.

> That said, the changes seem fine to me.

Thank you. I've pushed these fixes.

-- 
Regards,

Laurent Pinchart
