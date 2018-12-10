Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEF9C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 08:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5844B2082F
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 08:14:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5844B2082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=iki.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbeLJIOY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 03:14:24 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52368 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726029AbeLJIOY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 03:14:24 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id EFB70634C7F;
        Mon, 10 Dec 2018 10:14:19 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gWGhn-0000Jz-PG; Mon, 10 Dec 2018 10:14:19 +0200
Date:   Mon, 10 Dec 2018 10:14:19 +0200
From:   sakari.ailus@iki.fi
To:     jacopo mondi <jacopo@jmondi.org>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>, corbet@lwn.net,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l2: i2c: ov7670: Fix PLL bypass register values
Message-ID: <20181210081419.vkv2vmt6uecorid7@valkosipuli.retiisi.org.uk>
References: <1514550146-20195-1-git-send-email-jacopo+renesas@jmondi.org>
 <20181209233917.dhtwrpb46y2iyx4m@valkosipuli.retiisi.org.uk>
 <20181210075902.GG5597@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210075902.GG5597@w540>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 10, 2018 at 08:59:02AM +0100, jacopo mondi wrote:
> Hi Sakari,
>    thanks for digging this out
> 
> On Mon, Dec 10, 2018 at 01:39:17AM +0200, sakari.ailus@iki.fi wrote:
> > Hi Jacopo,
> >
> > On Fri, Dec 29, 2017 at 01:22:26PM +0100, Jacopo Mondi wrote:
> > > The following commits:
> > > commit f6dd927f34d6 ("[media] media: ov7670: calculate framerate properly for ov7675")
> > > commit 04ee6d92047e ("[media] media: ov7670: add possibility to bypass pll for ov7675")
> > > introduced the ability to bypass PLL multiplier and use input clock (xvclk)
> > > as pixel clock output frequency for ov7675 sensor.
> > >
> > > PLL is bypassed using register DBLV[7:6], according to ov7670 and ov7675
> > > sensor manuals. Macros used to set DBLV register seem wrong in the
> > > driver, as their values do not match what reported in the datasheet.
> > >
> > > Fix by changing DBLV_* macros to use bits [7:6] and set bits [3:0] to
> > > default 0x0a reserved value (according to datasheets).
> > >
> > > While at there, remove a write to DBLV register in
> > > "ov7675_set_framerate()" that over-writes the previous one to the same
> > > register that takes "info->pll_bypass" flag into account instead of setting PLL
> > > multiplier to 4x unconditionally.
> > >
> > > And, while at there, since "info->pll_bypass" is only used in
> > > set/get_framerate() functions used by ov7675 only, it is not necessary
> > > to check for the device id at probe time to make sure that when using
> > > ov7670 "info->pll_bypass" is set to false.
> > >
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >
> > I assume this is still valid and long overdue for merging. :-) No other
> > work in the area seem to have been done so I'm picking it up...
> >
> 
> It should still be valid, and should still apply regardless of its
> age :) Is it worth a proper 'Fixes' tag?
> 
> Fixes: f6dd927f34d6 ("[media] media: ov7670: calculate framerate properly for ov7675")

Thanks; I added that to the commit message.

-- 
Sakari Ailus
