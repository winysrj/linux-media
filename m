Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F40C67838
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 23:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B0E720989
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 23:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B0E720989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=iki.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbeLIXjU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 18:39:20 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50448 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726319AbeLIXjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Dec 2018 18:39:20 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id C79DC634C7F;
        Mon, 10 Dec 2018 01:39:17 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gW8fN-0000FB-RQ; Mon, 10 Dec 2018 01:39:17 +0200
Date:   Mon, 10 Dec 2018 01:39:17 +0200
From:   sakari.ailus@iki.fi
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     corbet@lwn.net, mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l2: i2c: ov7670: Fix PLL bypass register values
Message-ID: <20181209233917.dhtwrpb46y2iyx4m@valkosipuli.retiisi.org.uk>
References: <1514550146-20195-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514550146-20195-1-git-send-email-jacopo+renesas@jmondi.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On Fri, Dec 29, 2017 at 01:22:26PM +0100, Jacopo Mondi wrote:
> The following commits:
> commit f6dd927f34d6 ("[media] media: ov7670: calculate framerate properly for ov7675")
> commit 04ee6d92047e ("[media] media: ov7670: add possibility to bypass pll for ov7675")
> introduced the ability to bypass PLL multiplier and use input clock (xvclk)
> as pixel clock output frequency for ov7675 sensor.
> 
> PLL is bypassed using register DBLV[7:6], according to ov7670 and ov7675
> sensor manuals. Macros used to set DBLV register seem wrong in the
> driver, as their values do not match what reported in the datasheet.
> 
> Fix by changing DBLV_* macros to use bits [7:6] and set bits [3:0] to
> default 0x0a reserved value (according to datasheets).
> 
> While at there, remove a write to DBLV register in
> "ov7675_set_framerate()" that over-writes the previous one to the same
> register that takes "info->pll_bypass" flag into account instead of setting PLL
> multiplier to 4x unconditionally.
> 
> And, while at there, since "info->pll_bypass" is only used in
> set/get_framerate() functions used by ov7675 only, it is not necessary
> to check for the device id at probe time to make sure that when using
> ov7670 "info->pll_bypass" is set to false.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

I assume this is still valid and long overdue for merging. :-) No other
work in the area seem to have been done so I'm picking it up...

-- 
Regards,

Sakari Ailus
