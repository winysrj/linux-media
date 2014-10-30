Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49772 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327AbaJ3RgN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 13:36:13 -0400
Message-ID: <54527709.3050108@iki.fi>
Date: Thu, 30 Oct 2014 19:36:09 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Nibble Max <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Olli Salonen <olli.salonen@iki.fi>
Subject: Re: [PATCH v2 3/3] DVBSky V3 PCIe card: add some changes to M88DS3103for
 supporting the demod of M88RS6000
References: <201410271529188904708@gmail.com> <201410301238228758761@gmail.com>
In-Reply-To: <201410301238228758761@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/30/2014 06:38 AM, Nibble Max wrote:

>>> -	if (tab_len > 83) {
>>> +	if (tab_len > 86) {
>>
>> That is not nice, but I could try find better solution and fix it later.
>
> What is the reason to check this parameter?
> How about remove this check?

It is just to check you will not overwrite buffer accidentally. Buffer 
is 83 bytes long, which should be also increased...
The correct solution is somehow calculate max possible tab size on 
compile time. It should be possible as init tabs are static const 
tables. Use some macro to calculate max value and use it - not plain 
numbers.

Something like that
#define BUF_SIZE   MAX(m88ds3103_tab_dvbs, m88ds3103_tab_dvbs2, 
m88rs6000_tab_dvbs, m88rs6000_tab_dvbs2)


>> Clock selection. What this does:
>> * select mclk_khz
>> * select target_mclk
>> * calls set_config() in order to pass target_mclk to tuner driver
>> * + some strange looking sleep, which is not likely needed
>
> The clock of M88RS6000's demod comes from tuner dies.
> So the first thing is turning on the demod main clock from tuner die after the demod reset.
> Without this clock, the following register's content will fail to update.
> Before changing the demod main clock, it should close clock path.
> After changing the demod main clock, it open clock path and wait the clock to stable.
>
>>
>> One thing what I don't like this is that you have implemented M88RS6000
>> things here and M88DS3103 elsewhere. Generally speaking, code must have
>> some logic where same things are done in same place. So I expect to see
>> both M88DS3103 and M88RS6000 target_mclk and mclk_khz selection
>> implemented here or these moved to place where M88DS3103 implementation is.
>>
>
> I will move M88DS3103 implementation to here.
>
>> Also, even set_config() is somehow logically correctly used here, I
>> prefer to duplicate that 4 line long target_mclk selection to tuner
>> driver and get rid of whole set_config(). Even better solution could be
>> to register M88RS6000 as a clock provider using clock framework, but
>> imho it is not worth  that simple case.
>
> Do you suggest to set demod main clock and ts clock in tuner's set_params call back?

Yes, and you did it already on that latest patch, thanks. It is not 
logically correct, but a bit hackish solution, but I think it is best in 
that special case in order to keep things simple here.



One thing with that new patch I would like to check is this 10us delay 
after clock path is enabled. You enable clock just before mcu is stopped 
and demod is configured during mcu is on freeze. 10us is almost nothing 
and it sounds like having no need in a situation you stop even mcu. It 
is about one I2C command which will took longer than 10us. Hard to see 
why you need wait 10us to settle clock in such case. What happens if you 
don't wait? I assume nothing, it works just as it should as stable 
clocks are needed a long after that, when mcu is take out of reset.

regards
Antti

-- 
http://palosaari.fi/
