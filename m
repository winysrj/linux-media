Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:45903 "EHLO
        homiemail-a123.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751926AbeAPUOI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 15:14:08 -0500
Subject: Re: [PATCH 4/7] si2168: Add ts bus coontrol, turn off bus on sleep
To: Antti Palosaari <crope@iki.fi>, Brad Love <brad@nextdimension.cc>,
        linux-media@vger.kernel.org
References: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
 <1515773982-6411-5-git-send-email-brad@nextdimension.cc>
 <ce8faa6a-0ffb-a432-e269-58486c857fea@iki.fi>
 <0770dc98-9153-e386-ca54-b7e4123b774d@nextdimension.cc>
 <3dbf6692-ea03-38d1-a6c0-3291cf48dbae@iki.fi>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <491ebce5-cc46-5c1b-b223-f46d5f387285@nextdimension.cc>
Date: Tue, 16 Jan 2018 14:14:07 -0600
MIME-Version: 1.0
In-Reply-To: <3dbf6692-ea03-38d1-a6c0-3291cf48dbae@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 2018-01-16 13:32, Antti Palosaari wrote:
> On 01/16/2018 07:31 PM, Brad Love wrote:
>>
>> On 2018-01-15 23:07, Antti Palosaari wrote:
>>> Hello
>>> And what is rationale here, is there some use case demod must be
>>> active and ts set to tristate (disabled)? Just put demod sleep when
>>> you don't use it.
>>>
>>> regards
>>> Antti
>>
>> Hello Antti,
>>
>> Perhaps the .ts_bus_ctrl callback does not need to be included in ops,
>> but the function is necessary. The demod is already put to sleep when
>> not in use, but it leaves the ts bus open. The ts bus has no reason to
>> be open when the demod is put to sleep. Leaving the ts bus open during
>> sleep affects the other connected demod and nothing is received by it.
>> The lgdt3306a driver already tri states its ts bus when put to sleep,
>> the si2168 should as well.
>
> Sounds possible, but unlikely as chip is firmware driven. When you put
> chip to sleep you usually want set ts pins to tristate (also other
> unused pins) in order to save energy. I haven't never tested it anyway
> though, so it could be possible it leaves those pins to some other
> state like random output at given time.
>
> And if you cannot get stream from lgdt3306a, which is connected to
> same bus, it really sounds like ts bus pins are left some state
> (cannot work if same pin is driven high to other demod whilst other
> tries to drive it low.
>
> Setting ts pins to tri-state during sleep should resolve your issue.

Hello Antti,

This patch fixes the issue I'm describing, hence why I submitted it. The
ts bus must be tristated before putting the chip to sleep for the other
demod to get a stream.

Cheers,

Brad



>
>
> regards
> Antti
