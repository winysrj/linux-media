Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6E8C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 22:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7EBC2075B
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 22:10:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7EBC2075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=iki.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbeLMWKu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 17:10:50 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38042 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726457AbeLMWKt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 17:10:49 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 1CE71634C7D;
        Fri, 14 Dec 2018 00:10:31 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gXZBf-0000lZ-3R; Fri, 14 Dec 2018 00:10:31 +0200
Date:   Fri, 14 Dec 2018 00:10:31 +0200
From:   sakari.ailus@iki.fi
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] media: sun6i: Separate H3 compatible from A31
Message-ID: <20181213221030.f7c5mzuyke3ik43r@valkosipuli.retiisi.org.uk>
References: <20181130075849.16941-1-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130075849.16941-1-wens@csie.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Chen-Yu,

On Fri, Nov 30, 2018 at 03:58:43PM +0800, Chen-Yu Tsai wrote:
> The CSI (camera sensor interface) controller found on the H3 (and H5)
> is a reduced version of the one found on the A31. It only has 1 channel,
> instead of 4 channels supporting time-multiplexed BT.656 on the A31.
> Since the H3 is a reduced version, it cannot "fallback" to a compatible
> that implements more features than it supports.
> 
> This series separates support for the H3 variant from the A31 variant.
> 
> Patches 1 ~ 3 separate H3 CSI from A31 CSI in the bindings, driver, and
> device tree, respectively.
> 
> Patch 4 adds a pinmux setting for the MCLK (master clock). Some camera
> sensors use the master clock from the SoC instead of a standalone
> crystal.

I've picked patches 1 and 2, but I presume patches 3 and 4 would go through
another tree. Is that right?

> 
> Patches 5 and 6 are examples of using a camera sensor with an SBC.
> Since the modules are detachable, these changes should not be merged.
> They should be implemented as overlays instead.
> 
> Please have a look.
> 
> In addition, I found that the first frame captured seems to always be
> incomplete, with either parts cropped, out of position, or missing
> color components.


-- 
Regards,

Sakari Ailus
