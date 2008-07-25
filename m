Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KMLBl-00071M-El
	for linux-dvb@linuxtv.org; Fri, 25 Jul 2008 13:10:22 +0200
Message-ID: <4889B497.20008@iki.fi>
Date: Fri, 25 Jul 2008 14:10:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: tom <thomas@ickes-home.de>
References: <0MKxQS-1KLM2V1c9L-0001hx@mrelayeu.kundenserver.de>	<1216750591.6624.3.camel@super-klappi>
	<48862536.9070906@iki.fi>	<1216752077.6686.4.camel@super-klappi>
	<48862B02.1030304@iki.fi>	<1216754067.6686.7.camel@super-klappi>
	<48863349.3090507@iki.fi>	<1216754778.6686.9.camel@super-klappi>
	<48863629.8070706@iki.fi>	<1216755359.6686.11.camel@super-klappi>	<1216756294.6686.16.camel@super-klappi>	<1216756855.6686.19.camel@super-klappi>
	<48863E02.9080803@iki.fi>	<1216758682.14975.3.camel@super-klappi>
	<1216974424.7191.9.camel@super-klappi>
In-Reply-To: <1216974424.7191.9.camel@super-klappi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] WG:  Problems with	MSI	Digivox	Duo	DVB-T	USB,
 Ubuntu 8.04
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

tom wrote:
> I have checked both tuners. And I can see slighty differences. One is
> good and the other is not so good.

yes, I know that but haven't find the bug :( Tuner number 1 goes bad 
(sensitivity is not good) after tuner number 2 is enabled. If I disable 
tuner 2 then tuner 1 is OK. And if both tuners are enabled tuner 2 is OK.
For developer point of view it looks just like some streaming settings 
are wrong...

> In addition I have tested the stick with windows. The tuning is much
> better and the picture doesn't stuck and don't brings mosaic pixels.
> 
> when I switch in windows the tuners I can see with one tuner an orange
> light, with the other tuner I see a green light. green means 100 %
> channel strongness.

Hmm. looks like tuner 1 is poorer also under Windows?

> Under linux all channels do have ~ 40 %.

Those are just values, you cannot compare Windows and Linux signals 
because driver reports what it reports and also software then shows what 
it wants to show... Linux driver reports signal between 0-0xffff.

> My impresion is that the amplifier in the stick does not work efficient
> under linux.
> could this be a driver issue?

No, I tested almost all MXL5005S tuner driver settings and any of those 
didn't help.

Antti
> 
> 
> Am Dienstag, den 22.07.2008, 22:31 +0200 schrieb tom:
>> yes, problem was old firmware...very stupid :)
>>
>> I will try out both tuners and let you know. at the moment I'm happy and
>> try to tune some channels (puh)
>>
>> which player do you use?
>>
>> Thomas
>>
>> Am Dienstag, den 22.07.2008, 23:07 +0300 schrieb Antti Palosaari:
>>> tom wrote:
>>>> !!SUCCESS!!
>>> :)
>>>> Scan has found channels and everything works!
>>> Problem was coming from too old firmware?
>>>
>>> Try both tuners. I have AzureWave which is rather similar and I have 
>>> problem that first tuner performance is bad (it goes bad immediately 
>>> when second receiver is enabled). Some noise, mosaic pixels, in picture 
>>> :o I wonder if you have same problem...
>>>
>>>> Antti, many thanks for your support and especially for your patience!
>>>>
>>>> Thomas
>>> Antti
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
