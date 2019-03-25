Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A961BC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 16:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BD5E20896
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 16:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbfCYQSU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 12:18:20 -0400
Received: from muru.com ([72.249.23.125]:42448 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbfCYQSU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 12:18:20 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id D499C80CC;
        Mon, 25 Mar 2019 16:18:30 +0000 (UTC)
Date:   Mon, 25 Mar 2019 09:18:14 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, Jyri Sarha <jsarha@ti.com>
Subject: Re: CEC blocks idle on omap4
Message-ID: <20190325161814.GL19425@atomide.com>
References: <20190325153258.GU5717@atomide.com>
 <dc7e900c-52e2-3268-6c08-6a5b0049135a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc7e900c-52e2-3268-6c08-6a5b0049135a@xs4all.nl>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

* Hans Verkuil <hverkuil@xs4all.nl> [190325 15:52]:
> Hi Tony,
> 
> On 3/25/19 4:32 PM, Tony Lindgren wrote:
> > Hi Hans,
> > 
> > Looks like CONFIG_OMAP4_DSS_HDMI_CEC=y blocks SoC core retention
> > idle on omap4 if selected.
> > 
> > Should we maybe move hdmi4_cec_init() to hdmi_display_enable()
> > and hdmi4_cec_uninit() to hdmi_display_disable()?
> > 
> > Or add some enable/disable calls in addtion to the init and
> > uninit calls that can be called from hdmi_display_enable()
> > and hdmi_display_disable()?
> 
> For proper HDMI CEC behavior the CEC adapter has to remain active
> even if the HPD of the display is low. Some displays pull down the
> HPD when in standby, but CEC can still be used to wake them up.

OK

> And we see this more often as regulations for the maximum power
> consumption of displays are getting more and more strict.
> 
> So disabling CEC when the display is disabled is not an option.

OK

> Disabling CEC if the source is no longer transmitting isn't a good
> idea either since the display will typically still send periodic
> CEC commands to the source that it expects to reply to.

Hmm I wonder if we could test for HPD floating and then disable
cec? Then we would know nothing is connected, right?

> The reality is that HDMI CEC and HDMI video are really independent of
> one another. So I wonder if it isn't better to explain the downsides
> of enabling CEC for the omap4 in the CONFIG_OMAP4_DSS_HDMI_CEC
> description. And perhaps disable it by default?

From distro kernel point of view we should find some way to
disable cec dynamically. Can we maybe do something via /sys or
some command line option for cec.ko?

Then if we find a way to check for floating HPD pin or something
we could support that too.

Regards,

Tony
