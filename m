Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]
	helo=sasl.smtp.pobox.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <torgeir@pobox.com>) id 1Kina3-0003fW-Iy
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 11:56:18 +0200
Message-Id: <01DE66C3-8E94-4DC3-9828-DF2CD7B59EBB@pobox.com>
From: Torgeir Veimo <torgeir@pobox.com>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0809251152480.1247@pub1.ifh.de>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Thu, 25 Sep 2008 19:56:02 +1000
References: <573008.36358.qm@web52908.mail.re2.yahoo.com>
	<alpine.LRH.1.10.0809251152480.1247@pub1.ifh.de>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Add remote control support to Nova-TD
 (52009)
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


On 25 Sep 2008, at 19:53, Patrick Boettcher wrote:

>>
>> This patch is against the 2.6.26.5 kernel, and adds remote control  
>> support for the Hauppauge WinTV Nova-TD (Diversity) model. (That's  
>> the 52009 version.) It also adds the key-codes for the credit-card  
>> style remote control that comes with this particular adapter.
>
> Committed and ask to be pulled, thanks.


Am curious, would it be possible to augment these drivers to provide  
the raw IR codes on a raw hid device, eg. /dev/hidraw0 etc, so that  
other RC5 remotes than the ones that actually are sold with the card  
can be used with the card?

-- 
Torgeir Veimo
torgeir@pobox.com





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
