Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57194 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161558AbaJaCeY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 22:34:24 -0400
Received: by mail-pa0-f44.google.com with SMTP id bj1so6721835pad.17
        for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 19:34:23 -0700 (PDT)
Date: Fri, 31 Oct 2014 10:34:22 +0800
From: "=?utf-8?B?TmliYmxlIE1heA==?=" <nibble.max@gmail.com>
To: "=?utf-8?B?QW50dGkgUGFsb3NhYXJp?=" <crope@iki.fi>
Cc: "=?utf-8?B?bGludXgtbWVkaWE=?=" <linux-media@vger.kernel.org>,
	"=?utf-8?B?T2xsaSBTYWxvbmVu?=" <olli.salonen@iki.fi>
References: <201410271529188904708@gmail.com>,
 <201410301238228758761@gmail.com>
Subject: =?utf-8?B?UmU6IFJlOiBbUEFUQ0ggdjIgMy8zXSBEVkJTa3kgVjMgUENJZSBjYXJkOiBhZGQgc29tZSBjaGFuZ2VzIHRvIE04OERTMzEwM2ZvcnN1cHBvcnRpbmcgdGhlIGRlbW9kIG9mIE04OFJTNjAwMA==?=
Message-ID: <201410311034193593814@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti,

On 2014-10-31 01:36:14, Antti Palosaari wrote:
>
>
>On 10/30/2014 06:38 AM, Nibble Max wrote:
>
>>>> -	if (tab_len > 83) {
>>>> +	if (tab_len > 86) {
>>>
>>> That is not nice, but I could try find better solution and fix it later.
>>
>> What is the reason to check this parameter?
>> How about remove this check?
>
>It is just to check you will not overwrite buffer accidentally. Buffer 
>is 83 bytes long, which should be also increased...
>The correct solution is somehow calculate max possible tab size on 
>compile time. It should be possible as init tabs are static const 
>tables. Use some macro to calculate max value and use it - not plain 
>numbers.
>
>Something like that
>#define BUF_SIZE   MAX(m88ds3103_tab_dvbs, m88ds3103_tab_dvbs2, 
>m88rs6000_tab_dvbs, m88rs6000_tab_dvbs2)
>
>
>>> Clock selection. What this does:
>>> * select mclk_khz
>>> * select target_mclk
>>> * calls set_config() in order to pass target_mclk to tuner driver
>>> * + some strange looking sleep, which is not likely needed
>>
>> The clock of M88RS6000's demod comes from tuner dies.
>> So the first thing is turning on the demod main clock from tuner die after the demod reset.
>> Without this clock, the following register's content will fail to update.
>> Before changing the demod main clock, it should close clock path.
>> After changing the demod main clock, it open clock path and wait the clock to stable.
>>
>>>
>>> One thing what I don't like this is that you have implemented M88RS6000
>>> things here and M88DS3103 elsewhere. Generally speaking, code must have
>>> some logic where same things are done in same place. So I expect to see
>>> both M88DS3103 and M88RS6000 target_mclk and mclk_khz selection
>>> implemented here or these moved to place where M88DS3103 implementation is.
>>>
>>
>> I will move M88DS3103 implementation to here.
>>
>>> Also, even set_config() is somehow logically correctly used here, I
>>> prefer to duplicate that 4 line long target_mclk selection to tuner
>>> driver and get rid of whole set_config(). Even better solution could be
>>> to register M88RS6000 as a clock provider using clock framework, but
>>> imho it is not worth  that simple case.
>>
>> Do you suggest to set demod main clock and ts clock in tuner's set_params call back?
>
>Yes, and you did it already on that latest patch, thanks. It is not 
>logically correct, but a bit hackish solution, but I think it is best in 
>that special case in order to keep things simple here.
>
>
>
>One thing with that new patch I would like to check is this 10us delay 
>after clock path is enabled. You enable clock just before mcu is stopped 
>and demod is configured during mcu is on freeze. 10us is almost nothing 
>and it sounds like having no need in a situation you stop even mcu. It 
>is about one I2C command which will took longer than 10us. Hard to see 
>why you need wait 10us to settle clock in such case. What happens if you 
>don't wait? I assume nothing, it works just as it should as stable 
>clocks are needed a long after that, when mcu is take out of reset.
>

usleep_range(10000, 20000);
This delay time at least is 10ms, not 10us. 

>regards
>Antti
>
>-- 
>http://palosaari.fi/
BR,
Max

