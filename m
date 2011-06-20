Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:52081 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab1FTV3m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 17:29:42 -0400
Message-ID: <4DFFBBC5.2080503@iki.fi>
Date: Tue, 21 Jun 2011 00:29:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Rune Evjen <rune.evjen@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C) - DVB-C channel
 scan in mythtv - missing
References: <BANLkTimkYw70GAu1keW-N6ND=AyiRn2+CA@mail.gmail.com>	<4DF49E2A.9030804@iki.fi>	<BANLkTi=dGyN8SEwwAStD0Ob99k+FKkQPFg@mail.gmail.com>	<BANLkTik=37qHUx273bSRN91HeyYrtUv6og@mail.gmail.com>	<BANLkTi=gdVhVKjF4tqUwy+DxFv9imUipHw@mail.gmail.com>	<4DFFB56B.3000802@iki.fi> <BANLkTikYWVU814UWNAZFTTC9dX43Ydy4sA@mail.gmail.com> <4DFFBABD.3040302@iki.fi>
In-Reply-To: <4DFFBABD.3040302@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/21/2011 12:25 AM, Antti Palosaari wrote:
> On 06/21/2011 12:20 AM, Rune Evjen wrote:
>> 2011/6/20 Antti Palosaari<crope@iki.fi>:
>>> LNA is controlled by demod GPIO line. I don't remember if it is on or
>>> off
>>> for DVB-C currently. Look em28xx-dvb.c file, you can disable or
>>> enable it
>>> from there (needs re-compiling driver).
>>>
>>> I also saw BER counter running some muxes during development, but I
>>> think
>>> all channels I have are still working. And I didn't even have time to
>>> optimal parameters for tuner / demod. I will try to examine those
>>> later...
>>>
>> Thank you Antti,
>>
>> I will test with lna disabled in the em28xx-dvb module
>>
>> In line 349 of the code, I see this:
>> /* enable LNA for DVB-T2 and DVB-C */
>> .gpio_dvbt2[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
>> .gpio_dvbc[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
>>
>> I suspect I should modify line 351, what should it be changed to ?
>
> Remove corresponding line (.gpio_dvbc[0]).

Or change CXD2820R_GPIO_L => CXD2820R_GPIO_H. Have to check that too, I 
suspect removing it leaves it Hi-Z (which could result same).


Antti


-- 
http://palosaari.fi/
