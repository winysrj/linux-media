Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KindT-00048m-HK
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 11:59:48 +0200
Date: Thu, 25 Sep 2008 11:59:07 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Torgeir Veimo <torgeir@pobox.com>
In-Reply-To: <01DE66C3-8E94-4DC3-9828-DF2CD7B59EBB@pobox.com>
Message-ID: <alpine.LRH.1.10.0809251156390.1247@pub1.ifh.de>
References: <573008.36358.qm@web52908.mail.re2.yahoo.com>
	<alpine.LRH.1.10.0809251152480.1247@pub1.ifh.de>
	<01DE66C3-8E94-4DC3-9828-DF2CD7B59EBB@pobox.com>
MIME-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] getting rid of input dev in dvb-usb (was: Re: [PATCH]
 Add remote control support to Nova-TD (52009))
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

On Thu, 25 Sep 2008, Torgeir Veimo wrote:

>
> On 25 Sep 2008, at 19:53, Patrick Boettcher wrote:
>
>>> 
>>> This patch is against the 2.6.26.5 kernel, and adds remote control support 
>>> for the Hauppauge WinTV Nova-TD (Diversity) model. (That's the 52009 
>>> version.) It also adds the key-codes for the credit-card style remote 
>>> control that comes with this particular adapter.
>> 
>> Committed and ask to be pulled, thanks.
>
>
> Am curious, would it be possible to augment these drivers to provide the raw 
> IR codes on a raw hid device, eg. /dev/hidraw0 etc, so that other RC5 remotes 
> than the ones that actually are sold with the card can be used with the card?

I would love that idea. Maybe this is the solution I have searched for so 
long. I desparately want to put those huge remote-control-table into 
user-space.

If hidraw is the right way, I'm with you. So far I wasn't sure what to 
do?!

How would it work with the key-table onces it is done with hidraw?

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
