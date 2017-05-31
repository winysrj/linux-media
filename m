Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53738 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751041AbdEaM6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 08:58:39 -0400
Subject: Re: [PATCH] ARM: dts: exynos: Add HDMI CEC device to Exynos5 SoC
 family
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <CGME20170531110029eucas1p14bb9468f72155d88364c0aa5093ac05d@eucas1p1.samsung.com>
 <1496228417-31126-1-git-send-email-m.szyprowski@samsung.com>
 <44c9e8c6-669c-848c-30df-eabad6dc1a39@xs4all.nl>
 <2497f348-5d66-f10a-5591-c490b7ee8b4e@samsung.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0e11b430-b444-b1c0-5900-809193e32902@xs4all.nl>
Date: Wed, 31 May 2017 14:58:32 +0200
MIME-Version: 1.0
In-Reply-To: <2497f348-5d66-f10a-5591-c490b7ee8b4e@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/17 14:04, Marek Szyprowski wrote:
> Hi Hans,
> 
> On 2017-05-31 13:17, Hans Verkuil wrote:
>> On 05/31/17 13:00, Marek Szyprowski wrote:
>>> Exynos5250 and Exynos542x SoCs have the same CEC hardware module as
>>> Exynos4 SoC series, so enable support for it using the same compatible
>>> string.
>>>
>>> Tested on Odroid XU3 (Exynos5422) and Google Snow (Exynos5250) boards.
>> Thanks!
>>
>> Do you know if the CEC block is always on for these devices or only if there
>> is a hotplug signal? That was a problem with the exynos4 odroid.
> 
> Odroid XU3 has exactly same wiring between SoC & HDMI connector (via 
> IP4791CZ12
> chip) as Odroid U3, so I expect the same issues.
> 
> I don't have schematic for Google Snow board, so I have no idea how it works
> there.
> 
>> I have made a patch (not posted yet) to signal this in the device tree and
>> added a CEC capability to signal this to the user.
>>
>> This capability will be added to 4.13 (see my patch 'cec: add CEC_CAP_NEEDS_HPD'
>> from May 25th) since the DisplayPort CEC tunneling feature needs it as well.
>>
>> It's easy to test: don't connect an HDMI cable and run:
>>
>> cec-ctl --playback
>> cec-ctl -t0 --image-view-on
>>
>> If this returns with a NACK error, then it is OK. If you get a kernel message
>> that the transmit timed out, then you need this capability since CEC is disabled
>> without HPD.
> 
> I've checked those commands, but on all tested boards (Odroid U3+, 
> Odroid XU3 and
> Google Snow) I get the following message:
> 
> Transmit from Unregistered to TV (255 to 0):
> CEC_MSG_IMAGE_VIEW_ON (0x04)
>          Sequence: 19 Tx Timestamp: 175.935s
>          Tx, Error (1), Max Retries
> 
> I have never got a timeout message from the kernel. Do I need to enable 
> some kind
> of CEC debugs?

Ah, that's right. CEC works, but the level shifter drops the CEC signal
when there is no HPD. So this is actually quite hard to test.

The easiest is to get a Pulse-Eight USB CEC adapter since then you can
connect the odroid to the Pulse-Eight without connecting that to a TV
in turn. Sending a CEC command would show up with the Pulse-Eight if CEC
works without HPD.

Regards,

	Hans
