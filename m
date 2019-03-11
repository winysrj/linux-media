Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBD2C10F06
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7D6C2084F
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfCKOFb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:05:31 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:56125 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727444AbfCKOFb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 10:05:31 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3LYShRlNn4HFn3LYVhEj3M; Mon, 11 Mar 2019 15:05:28 +0100
Subject: Re: [PATCH] media: adv748x: Don't disable CSI-2 on link_setup
To:     Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20190306112659.8310-1-jacopo+renesas@jmondi.org>
 <20190306191521.GE4791@pendragon.ideasonboard.com>
 <20190307103511.wtx2c7jecyx4nmms@uno.localdomain>
 <20190308112938.GE4802@pendragon.ideasonboard.com>
 <20190308131221.g5ueabsbhbog7oxn@uno.localdomain>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7edc4c80-541b-473a-f520-a758d73ce8d3@xs4all.nl>
Date:   Mon, 11 Mar 2019 15:05:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190308131221.g5ueabsbhbog7oxn@uno.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJAQa1rzSzkJCyNvDbcPPTwm/Ko0rYxQSRjRdW1+FJuqhTGtSDjDLNR9mWEVnB3ioBVIms9ZeBeBBySPQuDtKUVLUc2uAFhDoCsUjNlHrwx7yMA8wEVy
 kVLIOIJrkeK/dHKwLaTWb+5wyxWCvqk1EydCFcE0l2lpfLjPmT5Eu1IPdhKxh52ZcaKSVUc+GEHL7cuV/IT/qgbgusC33PdxpQBtN+RuIN/sJimTF19UNvu6
 NnwDiaBWpvnjC6CKKB3Vuo28zHwbcZXbYLWYJv/dX0mLsPhv85uplIO/TRMbwAFZpBFPXyogAKOvxqp830unA2pXEvPbwKU742CewD9SZW5PyRWTLRL0ZfPU
 a7dQkxIXinp3AMbkkttH7S/8U1S32CsIjW0U8H3KCNkzRtblW1llycn5Y7vZWNi6bWi1843rBIm81wD0uDsWKOTbuXHWQQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/8/19 2:12 PM, Jacopo Mondi wrote:
> Hi Laurent,
> 
> On Fri, Mar 08, 2019 at 01:29:38PM +0200, Laurent Pinchart wrote:
>> Hi Jacopo,
>>
>> On Thu, Mar 07, 2019 at 11:35:11AM +0100, Jacopo Mondi wrote:
>>> On Wed, Mar 06, 2019 at 09:15:21PM +0200, Laurent Pinchart wrote:
>>>> On Wed, Mar 06, 2019 at 12:26:59PM +0100, Jacopo Mondi wrote:
>>>>> When both the media links between AFE and HDMI and the two TX CSI-2 outputs
>>>>> gets disabled, the routing register ADV748X_IO_10 gets zeroed causing both
>>>>> TXA and TXB output to get disabled.
>>>>>
>>>>> This causes some HDMI transmitters to stop working after both AFE and
>>>>> HDMI links are disabled.
>>>>
>>>> Could you elaborate on why this would be the case ? By HDMI transmitter,
>>>> I assume you mean the device connected to the HDMI input of the ADV748x.
>>>> Why makes it fail (and how ?) when the TXA and TXB are both disabled ?
>>>
>>> I know, it's weird, the HDMI transmitter is connected to the HDMI
>>> input of adv748x and should not be bothered by CSI-2 outputs
>>> enablement/disablement.
>>>
>>> BUT, when I developed the initial adv748x AFE->TXA patches I was
>>> testing HDMI capture using a laptop, and things were smooth.
>>>
>>> I recently started using a chrome cast device I found in some drawer
>>> to test HDMI, as with it I don't need to go through xrandr as I had to
>>> do when using a laptop for testing, but it seems the two behaves differently.
>>>
>>> Failures are of different types: from detecting a non-realisting
>>> resolution from the HDMI subdevice, and then messing up the pipeline
>>> configuration, to capture operations apparently completing properly
>>> but resulting in mangled images.
>>>
>>> Do not deactivate the CSI-2 ouputs seems to fix the issue for the
>>> Chromecast, and still work when capturing from laptop. There might be
>>> something I am missing about HDMI maybe, but the patch not just fixes
>>> the issue for me, but it might make sense on its own as disabling the
>>> TXes might trigger some internal power saving state, or simply mess up
>>> the HDMI link.
>>
>> I think this needs more investigation. It feels to me that you're
>> working around an issue by chance, and it will come back to bite us
>> later :-(
>>
> 
> I'm sorry I really can't tell what's happening, and why it is
> happening on that specific device, which I cannot debug for sure.
> 
> Ian suggested a possible cause, but I cannot tell due to my
> HDMI-ignorance.

I agree with Ian that it is likely related to EDID and/or HPD handling
of the adv748x. The only other option is if the HDMI transmitter supports
RxSense (i.e. detecting the pull-ups of the TMDS clock lines as a way of
detecting that the transmitter is connected to a display).

Not many transmitters support RxSense, though.

HPD and/or EDID are the most likely culprits. It certainly has nothing
to do with the CSI ports as such.

Regards,

	Hans

> 
>>> As disabling both TXes usually happens at media link reset time, just
>>> before enabling one of them (or both), going through a full disable
>>> makes little sense, even more if it triggers any sort of malfunctioning.
>>>
>>> Does this make sense to you?
>>
>> It also doesn't make too much sense to keep them both enabled when they
>> don't need to be :-) You'll end up consuming more power.
>>
> 
> They've alwyas been up before introduction of dynamic routing, provided
> something is connected to the TX source pad in DT.
> https://elixir.bootlin.com/linux/latest/source/drivers/media/i2c/adv748x/adv748x-core.c#L489
> 
> Power saving wise, we're not doing worse than before, and if that's a
> concern, it should be identified first why the CSI-2 Tx PLL never gets
> turned off:
> https://elixir.bootlin.com/linux/latest/source/drivers/media/i2c/adv748x/adv748x-core.c#L269
> See "mipi_pll_en, CSI-TXA Map, Address 0xDA[0]" registrer description.
> 
> The two issues might be actually connected, I tried fixing this in the past,
> but frame capture broke, and I didn't have time to investigate
> fruther.
> 
> To sum up, this patch solves an issue on some devices, it does not
> perform worse than what we had from a power consumption perspective,
> but I agree it might work around some deeper issues it might be worth
> chasing.
> 
> If I got your NAK on this, I'll keep carrying it in my tree when
> testing with that device.
> 
> Thanks
>   j
> 
> 
>>>>> Fix this by preventing writing 0 to
>>>>> ADV748X_IO_10 register, which gets only updated when links are enabled
>>>>> again.
>>>>>
>>>>> Fixes: 9423ca350df7 ("media: adv748x: Implement TX link_setup callback")
>>>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>>>>> ---
>>>>> The issue presents itself only on some HDMI transmitters, and went unnoticed
>>>>> during the development of:
>>>>> "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
>>>>>
>>>>> Patch intended to be applied on top of latest media-master, where the
>>>>> "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
>>>>> series is applied.
>>>>>
>>>>> The patch reports a "Fixes" tag, but should actually be merged with the above
>>>>> mentioned series.
>>>>>
>>>>> ---
>>>>>  drivers/media/i2c/adv748x/adv748x-core.c | 3 +++
>>>>>  1 file changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
>>>>> index f57cd77a32fa..0e5a75eb6d75 100644
>>>>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
>>>>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
>>>>> @@ -354,6 +354,9 @@ static int adv748x_link_setup(struct media_entity *entity,
>>>>>
>>>>>  	tx->src = enable ? rsd : NULL;
>>>>>
>>>>> +	if (!enable)
>>>>> +		return 0;
>>>>> +
>>>>>  	if (state->afe.tx) {
>>>>>  		/* AFE Requires TXA enabled, even when output to TXB */
>>>>>  		io10 |= ADV748X_IO_10_CSI4_EN;
>>
>> --
>> Regards,
>>
>> Laurent Pinchart

