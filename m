Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.248.54]:38098 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab0CDWQJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 17:16:09 -0500
Message-ID: <4B903127.208@online.no>
Date: Thu, 04 Mar 2010 23:16:07 +0100
From: Hendrik Skarpeid <skarp@online.no>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org,
	Nameer Kazzaz <nameer.kazzaz@gmail.com>
Subject: Re: DM1105: could not attach frontend 195d:1105
References: <4B7D83B2.4030709@online.no> <201003031749.24261.liplianin@me.by> <4B8E9182.2010906@online.no> <201003032105.06263.liplianin@me.by>
In-Reply-To: <201003032105.06263.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Igor M. Liplianin skrev:
> On 3 марта 2010 18:42:42 Hendrik Skarpeid wrote:
>   
>> Igor M. Liplianin wrote:
>>     
>>> Now to find GPIO's for LNB power control and ... watch TV :)
>>>       
>> Yep. No succesful tuning at the moment. There might also be an issue
>> with the reset signal and writing to GPIOCTR, as the module at the
>> moment loads succesfully only once.
>> As far as I can make out, the LNB power control is probably GPIO 16 and
>> 17, not sure which is which, and how they work.
>> GPIO15 is wired to tuner #reset
>>     
> New patch to test
>   
> ------------------------------------------------------------------------
>
>
> No virus found in this incoming message.
> Checked by AVG - www.avg.com 
> Version: 9.0.733 / Virus Database: 271.1.1/2721 - Release Date: 03/03/10 20:34:00
>

modprobe si21xx debug=1 produces this output when scanning.

[ 2187.998349] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
[ 2187.998353] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
[ 2187.999881] si21xx: si21xx_setacquire
[ 2187.999884] si21xx: si21xx_set_symbolrate : srate = 27500000
[ 2188.022645] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x01
[ 2188.054350] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
[ 2188.054355] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
[ 2188.055875] si21xx: si21xx_setacquire
[ 2188.055879] si21xx: si21xx_set_symbolrate : srate = 27500000
[ 2188.110359] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
[ 2188.110366] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
[ 2188.111885] si21xx: si21xx_setacquire
[ 2188.111889] si21xx: si21xx_set_symbolrate : srate = 27500000
[ 2188.166350] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
[ 2188.166354] si21xx: si21xx_set_frontend : FE_SET_FRONTEND

Since the tuner at hand uses a Si2109 chip, VSTATUS 0x01 and 0x02 would 
indicate that blind scanning is used. Blind scanning is a 2109/2110 
specific function, and may not very usable since we always use initial 
tuning files anyway. 2109/10 also supports the legacy scanning method 
which is supported by Si2107708.

Is the use of blind scanning intentional?
