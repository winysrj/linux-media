Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43898 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118Ab2GFSYY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 14:24:24 -0400
Message-ID: <4FF72D4F.8090005@iki.fi>
Date: Fri, 06 Jul 2012 21:24:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi> <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/06/2012 02:04 PM, Marx wrote:
> On 06.07.2012 11:34, Antti Palosaari wrote:
>> Did I missed something? PCTV device does not support CI/CAM and thus no
>> support for encrypted channels. Is there still CI slot?
>
> no, I simply use external reader with plugin in VDR. Unfortunetelly on
> Hotbird there is no unencrypted HD channel I can use to test.

 From the driver / device perspective HD or SD channel does not have 
much difference - difference is just used video codec and likely wider 
stream. For demodulator driver perspective there could some difference 
as HD channels are more often transmitted using DVB-S2 standard - but 
not always.

Also as you are using SoftCAM there is no difference from driver POV if 
stream is encrypted or unencrypted. Device just moves bits from the 
antenna to the computer - it does not know if those bits are encrypted 
or not.

>>> Anyway when using card logs are full of i2c errors
>>
>> Argh! But this must be issue of earlier driver too.
>
> yes, those errors were in logs earlier on previous driver. Hovewer
> previous driver allowed to play only once or two time and then was
> stopping work. And i've never played successfully HD channel on this card.

Could you say what was the original problem of your device?

>> I debug it and it seems to be totally clueless implementation of
>> stb6100_read_reg() as it sets device address like "device address +
>> register address". This makes stb6100 I2C address of tuner set for that
>> request 0x66 whilst it should be 0x60. Is that code never tested...
>>
>> pctv452e DVB USB driver behaves just correctly as it says this is not
>> valid and returns error.
>>
>> Also pctv452e I2C adapter supports only I2C operations that are done
>> with repeated STOP condition - but I cannot see there is logic to sent
>> STOP after last message. I suspect it is not correct as logically but
>> will work - very common mistake with many I2C adapters we have.

Oops, s/repeated STOP condition/repeated START condition/

> I have second card in this computer
> http://www.proftuners.com/prof8000.html
> which uses STB6100 (and also STV0903 and CX23885).
> I wasn't aware that both of this card uses the same chip (as I see from
> http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI
> it uses STB6100 too).
> Can it be a problem? Anyway i will take off this second card a test again.

I never say it could not be problem, but it is highly unlikely. Anyhow 
it is possible there is some static variables inside driver that could 
have effect. But it is very very unlikely and those kind of shared 
variables should not exits without very good reason.

>> Regardless of those errors it still works?
>
> Thank you for help. I had only a few minutes at the morning to test it
> and it partly worked. More test are planned tonight and I will write
> here outcomes.

Still waiting....


regards
Antti

-- 
http://palosaari.fi/


