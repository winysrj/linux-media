Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B226AC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 15:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AE4920896
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 15:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbfCYPwF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 11:52:05 -0400
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:44163 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729106AbfCYPwF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 11:52:05 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 8RtFhh8G0NG8z8RtIhQE8D; Mon, 25 Mar 2019 16:52:03 +0100
Subject: Re: CEC blocks idle on omap4
To:     Tony Lindgren <tony@atomide.com>
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org
References: <20190325153258.GU5717@atomide.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dc7e900c-52e2-3268-6c08-6a5b0049135a@xs4all.nl>
Date:   Mon, 25 Mar 2019 16:51:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190325153258.GU5717@atomide.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAftd1gqS9cUGx32QGh8lt+3RkLuoBNCNTZq0d4ux+oflnUOJojffyyz+GawIu96Q2lNy9Mmjm/HqSu7dr+3U7BbhqqU2XO36nL4KxH/kA4QT4+pVSOv
 nFFJ/68SluKSVuC0BRcqBSawZW9IEp2x1qJAZlmQGzJwDdtxp0AiOckRAbkrFRov1lz6Tkx9NFSSBpBXWngx3BerxrkW0vHoD7x+KZ2kI2gAXjXXudPVuTGY
 RCJmu+v+0SW6iTD4WfSy/VSTM2r6I3si28ZvTWk4/snXdhlcUOxXVrdxVatVXYjLDggf7JpDmp5J2yyqjbxFKXTiG+x/qFOIK/oKu4Ic19Llt2zzywhyt5e+
 4HD2FW3WzlasE//IHO1ii2Votl43pQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tony,

On 3/25/19 4:32 PM, Tony Lindgren wrote:
> Hi Hans,
> 
> Looks like CONFIG_OMAP4_DSS_HDMI_CEC=y blocks SoC core retention
> idle on omap4 if selected.
> 
> Should we maybe move hdmi4_cec_init() to hdmi_display_enable()
> and hdmi4_cec_uninit() to hdmi_display_disable()?
> 
> Or add some enable/disable calls in addtion to the init and
> uninit calls that can be called from hdmi_display_enable()
> and hdmi_display_disable()?

For proper HDMI CEC behavior the CEC adapter has to remain active
even if the HPD of the display is low. Some displays pull down the
HPD when in standby, but CEC can still be used to wake them up.

And we see this more often as regulations for the maximum power
consumption of displays are getting more and more strict.

So disabling CEC when the display is disabled is not an option.

Disabling CEC if the source is no longer transmitting isn't a good
idea either since the display will typically still send periodic
CEC commands to the source that it expects to reply to.

The reality is that HDMI CEC and HDMI video are really independent of
one another. So I wonder if it isn't better to explain the downsides
of enabling CEC for the omap4 in the CONFIG_OMAP4_DSS_HDMI_CEC
description. And perhaps disable it by default?

Regards,

	Hans
