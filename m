Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45977C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 15:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0131120896
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 15:55:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Rw+KsPaz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbfCYPzs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 11:55:48 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:39156 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfCYPzq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 11:55:46 -0400
Received: from pendragon.ideasonboard.com (p5269001-ipngn11702marunouchi.tokyo.ocn.ne.jp [114.158.195.1])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 015BB2F3;
        Mon, 25 Mar 2019 16:55:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1553529344;
        bh=JrmJ+tGU9QZ7eKP3WIFBlQlZFt+zyCVxd09QnxDWwDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rw+KsPazVjZlovPDgGVfvaro2H1jW435aDOuKtY2BV3WTXL3u+0s+TUl4CnbBPi8i
         N35BE9Gf9RFAQMhY0D9ZxCbRxMZ/gdDoRawA1AAaQ3bnwNitLeX/775JlOmngn2hAM
         l8ga16KwgByEjWfX/j4/0DnZ1GHSQXZffAjbuttY=
Date:   Mon, 25 Mar 2019 17:55:32 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org
Subject: Re: CEC blocks idle on omap4
Message-ID: <20190325155532.GB8280@pendragon.ideasonboard.com>
References: <20190325153258.GU5717@atomide.com>
 <dc7e900c-52e2-3268-6c08-6a5b0049135a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dc7e900c-52e2-3268-6c08-6a5b0049135a@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Mon, Mar 25, 2019 at 04:51:57PM +0100, Hans Verkuil wrote:
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
> 
> And we see this more often as regulations for the maximum power
> consumption of displays are getting more and more strict.
> 
> So disabling CEC when the display is disabled is not an option.
> 
> Disabling CEC if the source is no longer transmitting isn't a good
> idea either since the display will typically still send periodic
> CEC commands to the source that it expects to reply to.

What's the periodicity of those commands ? Can the system be put to
sleep and get woken up when there's CEC activity ?

> The reality is that HDMI CEC and HDMI video are really independent of
> one another. So I wonder if it isn't better to explain the downsides
> of enabling CEC for the omap4 in the CONFIG_OMAP4_DSS_HDMI_CEC
> description. And perhaps disable it by default?

This should be controllable by userspace. From a product point of view,
it should be possible to put the system in a deep sleep state where CEC
isn't available, or in a low sleep state where CEC works as expected.

-- 
Regards,

Laurent Pinchart
