Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <udo_richter@gmx.de>) id 1L5SNB-00072N-OM
	for linux-dvb@linuxtv.org; Wed, 26 Nov 2008 22:56:38 +0100
Message-ID: <492DC5F5.3060501@gmx.de>
Date: Wed, 26 Nov 2008 22:56:05 +0100
From: Udo Richter <udo_richter@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <49293640.10808@cadsoft.de> <492A53C4.5030509@makhutov.org>
In-Reply-To: <492A53C4.5030509@makhutov.org>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

Artem Makhutov wrote:
> Klaus Schmidinger schrieb:
>> The attached patch adds a capability flag that allows an application
>> to determine whether a particular device can handle "second generation
>> modulation" transponders. 
> Wouldn't it be better to add something like this:
> 
> FE_CAN_8PSK
> FE_CAN_16APSK
> FE_CAN_32APSK

Without knowing enough about the differences between -S and -S2 tuners 
and whatever cards are on the market, I'll try to step back and give 
this my 2c point of view:

What does a DVB app need to know? A DVB app probably just needs to know 
"What devices are capable of tuning to channel XYZ?". The API could 
answer this the same way as it would tune to channel XYZ, just without 
actually doing it. Try-before-you-buy.

This would also give maximum flexibility to the driver, as a device that 
supports some -S2 features could offer these, or a device that has known 
bugs on some tuning modes could also deny these. Non-standard modes 
could be offered without requiring yet another FE_CAN_XYZ.


Cheers,

Udo


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
