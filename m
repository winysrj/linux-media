Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.248.54]:42534 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab0CDV1t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 16:27:49 -0500
Message-ID: <4B9025D2.80100@online.no>
Date: Thu, 04 Mar 2010 22:27:46 +0100
From: Hendrik Skarpeid <skarp@online.no>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org
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
A little tweaking produced the required voltages for the LNB:

switch (voltage) {
case SEC_VOLTAGE_18:
dm1105_gpio_set(dev, GPIO16 | GPIO17);
break;
case SEC_VOLTAGE_13:
dm1105_gpio_andor(dev, GPIO16 | GPIO17, GPIO17);
break;
default:
dm1105_gpio_clear(dev, GPIO16 | GPIO17);
break;
}

But unfortunately tuning is still failing. Could it be an issue with the 
21xx driver? I will read up on the Si2109.
