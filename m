Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]
	helo=sasl.smtp.pobox.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <torgeir@pobox.com>) id 1Kinnt-0004tn-UO
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 12:10:34 +0200
Message-Id: <FE8D1FB7-03BC-423E-8E6C-BC73CF4AB974@pobox.com>
From: Torgeir Veimo <torgeir@pobox.com>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0809251156390.1247@pub1.ifh.de>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Thu, 25 Sep 2008 20:10:19 +1000
References: <573008.36358.qm@web52908.mail.re2.yahoo.com>
	<alpine.LRH.1.10.0809251152480.1247@pub1.ifh.de>
	<01DE66C3-8E94-4DC3-9828-DF2CD7B59EBB@pobox.com>
	<alpine.LRH.1.10.0809251156390.1247@pub1.ifh.de>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] getting rid of input dev in dvb-usb (was: Re:
 [PATCH] Add remote control support to Nova-TD (52009))
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


On 25 Sep 2008, at 19:59, Patrick Boettcher wrote:

> On Thu, 25 Sep 2008, Torgeir Veimo wrote:
>
>>
>> On 25 Sep 2008, at 19:53, Patrick Boettcher wrote:
>>
>>>> This patch is against the 2.6.26.5 kernel, and adds remote  
>>>> control support for the Hauppauge WinTV Nova-TD (Diversity)  
>>>> model. (That's the 52009 version.) It also adds the key-codes for  
>>>> the credit-card style remote control that comes with this  
>>>> particular adapter.
>>> Committed and ask to be pulled, thanks.
>>
>>
>> Am curious, would it be possible to augment these drivers to  
>> provide the raw IR codes on a raw hid device, eg. /dev/hidraw0 etc,  
>> so that other RC5 remotes than the ones that actually are sold with  
>> the card can be used with the card?
>
> I would love that idea. Maybe this is the solution I have searched  
> for so long. I desparately want to put those huge remote-control- 
> table into user-space.
>
> If hidraw is the right way, I'm with you. So far I wasn't sure what  
> to do?!
>
> How would it work with the key-table onces it is done with hidraw?


I'm not sure if I'm the right person to answer that. But at least I  
could use lircd with /dev/hidraw0 and I would be able to configure  
filtering of IR events as I please.

Maybe a generic table could be set in an input device by cat'ing the  
table in some format to a /sys/../ file.

-- 
Torgeir Veimo
torgeir@pobox.com





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
