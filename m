Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF45EC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 16:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8F8B2083D
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 16:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbfCYQVT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 12:21:19 -0400
Received: from muru.com ([72.249.23.125]:42462 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729778AbfCYQVS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 12:21:18 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id F3F8C80CC;
        Mon, 25 Mar 2019 16:21:31 +0000 (UTC)
Date:   Mon, 25 Mar 2019 09:21:15 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org
Subject: Re: CEC blocks idle on omap4
Message-ID: <20190325162115.GM19425@atomide.com>
References: <20190325153258.GU5717@atomide.com>
 <dc7e900c-52e2-3268-6c08-6a5b0049135a@xs4all.nl>
 <20190325155532.GB8280@pendragon.ideasonboard.com>
 <d3619d3b-1051-9b05-a0a9-ebc9b69241ce@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3619d3b-1051-9b05-a0a9-ebc9b69241ce@xs4all.nl>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

* Hans Verkuil <hverkuil@xs4all.nl> [190325 16:12]:
> On 3/25/19 4:55 PM, Laurent Pinchart wrote:
> >> The reality is that HDMI CEC and HDMI video are really independent of
> >> one another. So I wonder if it isn't better to explain the downsides
> >> of enabling CEC for the omap4 in the CONFIG_OMAP4_DSS_HDMI_CEC
> >> description. And perhaps disable it by default?
> > 
> > This should be controllable by userspace. From a product point of view,
> > it should be possible to put the system in a deep sleep state where CEC
> > isn't available, or in a low sleep state where CEC works as expected.
> > 
> 
> Userspace can always disable CEC. The hdmi_cec_adap_enable() callback in
> hdmi4_cec.c is called whenever the CEC adapter is enabled or disabled.

OK

> I'm not actually sure why hdmi4_cec_init() would block anything since it
> just registers the CEC device. It does not enable it until userspace
> explicitly enables it with e.g. 'cec-ctl --playback'.
> 
> hdmi4_cec_init() does configure a CEC clock, but that can be moved to
> hdmi_cec_adap_enable() if necessary.

Hey I'm pretty sure that's the right fix then :)

> Note that I am not sure what is meant with 'SoC core retention idle',
> so perhaps I just misunderstand the problem.

If certain SoC clocks are busy, the SoC will not enter deeper
idle states. The hardware has autoidle type features on omaps.

Regards,

Tony
