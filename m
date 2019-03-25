Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A985C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 16:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04E8C2083D
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 16:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfCYQMa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 12:12:30 -0400
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:59670 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbfCYQMa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 12:12:30 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 8SD3hhHrlNG8z8SD6hQNvw; Mon, 25 Mar 2019 17:12:28 +0100
Subject: Re: CEC blocks idle on omap4
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org
References: <20190325153258.GU5717@atomide.com>
 <dc7e900c-52e2-3268-6c08-6a5b0049135a@xs4all.nl>
 <20190325155532.GB8280@pendragon.ideasonboard.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d3619d3b-1051-9b05-a0a9-ebc9b69241ce@xs4all.nl>
Date:   Mon, 25 Mar 2019 17:12:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190325155532.GB8280@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOxLoDyNEQO/k1/556E01OmAFjpMC6KeEgV7Hee0feIqcisMjHJkAt2ksVKX0VinUvUMz7n5DBO1iQGoUOFRJMkpC0uoo4kG8n44IXq4innhVl3+aNti
 bvjY0ExZJ5NsvOjDou9qChVowaLpHJs6gmkr8hu0YvmFon/Deo7xF12nOq8bllATz0ZdNczuBqb5JTSblb+kJXJHnzBm36dl3cyN1lO+0T4/gjsqP9/2lrg3
 7WNCVi7+RXolG326I1zV35sgSaST0gfDHeoyY1rn7f8WpptV/8V1L9ZPrt6B3D+DnCvcv+6GG9rYto9JGpVK3HT9u3x4vwSJugkySXVa+lqvKlLPjWQavTZW
 vnp53MYw2P0R2nlQK/LoaQ3vYVhlXw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/25/19 4:55 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Mon, Mar 25, 2019 at 04:51:57PM +0100, Hans Verkuil wrote:
>> On 3/25/19 4:32 PM, Tony Lindgren wrote:
>>> Hi Hans,
>>>
>>> Looks like CONFIG_OMAP4_DSS_HDMI_CEC=y blocks SoC core retention
>>> idle on omap4 if selected.
>>>
>>> Should we maybe move hdmi4_cec_init() to hdmi_display_enable()
>>> and hdmi4_cec_uninit() to hdmi_display_disable()?
>>>
>>> Or add some enable/disable calls in addtion to the init and
>>> uninit calls that can be called from hdmi_display_enable()
>>> and hdmi_display_disable()?
>>
>> For proper HDMI CEC behavior the CEC adapter has to remain active
>> even if the HPD of the display is low. Some displays pull down the
>> HPD when in standby, but CEC can still be used to wake them up.
>>
>> And we see this more often as regulations for the maximum power
>> consumption of displays are getting more and more strict.
>>
>> So disabling CEC when the display is disabled is not an option.
>>
>> Disabling CEC if the source is no longer transmitting isn't a good
>> idea either since the display will typically still send periodic
>> CEC commands to the source that it expects to reply to.
> 
> What's the periodicity of those commands ? Can the system be put to
> sleep and get woken up when there's CEC activity ?

You don't control that. The sink can transmit a CEC message at any
time and the omap4 CEC adapter has to be active to correctly react.

> 
>> The reality is that HDMI CEC and HDMI video are really independent of
>> one another. So I wonder if it isn't better to explain the downsides
>> of enabling CEC for the omap4 in the CONFIG_OMAP4_DSS_HDMI_CEC
>> description. And perhaps disable it by default?
> 
> This should be controllable by userspace. From a product point of view,
> it should be possible to put the system in a deep sleep state where CEC
> isn't available, or in a low sleep state where CEC works as expected.
> 

Userspace can always disable CEC. The hdmi_cec_adap_enable() callback in
hdmi4_cec.c is called whenever the CEC adapter is enabled or disabled.

I'm not actually sure why hdmi4_cec_init() would block anything since it
just registers the CEC device. It does not enable it until userspace
explicitly enables it with e.g. 'cec-ctl --playback'.

hdmi4_cec_init() does configure a CEC clock, but that can be moved to
hdmi_cec_adap_enable() if necessary.

Note that I am not sure what is meant with 'SoC core retention idle',
so perhaps I just misunderstand the problem.

Regards,

	Hans
