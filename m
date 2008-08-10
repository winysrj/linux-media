Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KSAws-0004h2-AB
	for linux-dvb@linuxtv.org; Sun, 10 Aug 2008 15:27:08 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5D005Y7ZZR8200@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 10 Aug 2008 09:26:16 -0400 (EDT)
Date: Sun, 10 Aug 2008 09:26:15 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080810053101.8695447808F@ws1-5.us4.outblaze.com>
To: stev391@email.com
Message-id: <489EEC77.4080403@linuxtv.org>
MIME-version: 1.0
References: <20080810053101.8695447808F@ws1-5.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
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

stev391@email.com wrote:
>> ----- Original Message -----
>> From: "Steven Toth" <stoth@linuxtv.org>
>> To: stev391@email.com
>> Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB Only support
>> Date: Tue, 05 Aug 2008 10:30:57 -0400
>>
>>
>> stev391@email.com wrote:
>>> Steve,
>>>
>>> I have reworked the tuner callback now against your branch at:
>>> http://linuxtv.org/hg/~stoth/v4l-dvb
>>>
>>> The new Patch (to add support for this card) is attached inline below for testing (this is a 
>>> hint Mark & Jon), I have not provided a signed-off note on purpose as I want to solve the 
>>> issue mentioned in the next paragraph first.
>>>
>>> Regarding the cx25840 module; the card doesn't seem to initialise properly (no DVB output and 
>>> DMA errors in log) unless I have this requested.  Once the card is up and running I can unload 
>>> all drivers, recompile without the cx25840 and load and it will work again until I power off 
>>> the computer and back on again (This has been tedious trying to work out which setting I had 
>>> missed).  Is there some initialisation work being performed in the cx25840 module that I can 
>>> incorporate into my patch to remove this dependency? Or should I leave it as is?
>>>
>>> Anyway nearly bedtime here.
>> The patch looks good, with the exception of requesting the cx25840.
>>
>> I've always been able to run DVB without that driver being present, so something is odd with the 
>> Leadtek card. I'm not aware of any relationship between the cx25840 driver and the DVB core.
>>
>> You're going to need to find the magic register write that the cx25840 is performing so we can 
>> discuss here. I'd rather we figured that out cleanly, than just merged the patch and have the 
>> problem linger on.
>>
>> Other than that, good patch.
>>
>> - Steve
> 
> Steve,
> 
> I have found the lines (starting at line 1441) within cx25840-core.c that effects the DVB working or not working. These lines are:
> 	if (state->is_cx23885) {
> 		/* Drive GPIO2 direction and values */
> 		cx25840_write(client, 0x160, 0x1d);
> 		cx25840_write(client, 0x164, 0x00);
> 	}
> 
> If I comment these lines out in the code, the DVB side doesn't work.  I have tried incorporating these register writes into various places in the cx23885 code (cx23885_gpio_setup(), cx23885_card_setup() and dvb_register()) as the following lines:
> cx_write(0x160, 0x1d);
> cx_write(0x164, 0x00);
> 
> But this does not allow the card to work.
> 
> I have also commented out/ removed all of the code in cx25840-core.c except for the read, write, probe(now only contains the above cx25840_writes) and remove functions and the various struct configs, to ensure that it is not something else contributing to the dependency.
> 
> Have a used cx_write correctly?
> 
> I have also noticed that the following card also uses the cx25840 without any analog support in the driver:
> CX23885_BOARD_HAUPPAUGE_HVR1700
> 
> Perhaps the person who included support for this card has already gone down this track...
> 
> There are two possible directions that I would like to take from here:
> 1) Submit the patch as is with the cx25840 dependency
> 2) Work on why the registers writes aren't working. (However this is out of my depth of knowledge and will need some guidance or pass it onto someone else).

OK, so they tied the demod reset to the GPIO on the avcore, rather than 
a regular GPIO on the pcie bridge itself. I've only ever seen one other 
card do that (which you found - the HVR1700) because Hauppauge ran out 
of GPIO's on the bridge itself.

In this new case, for the Leadtek, I accept that we'll have to 
request_module for the card.

You should also add a comment to the _gpio_setup() code (where generally 
I try to ensure all card GPIO's are document), to say that the GPIO is 
on the AVCore (like the HVR1700). See the HVR1700 example comments.

One comment the bitmask in the tuner reset looks unusually long for 
resetting the xc3028. 70404, and it dosn't match the value used in your 
_gpio_setup() implementation (0x04).

So three very minor things to get this patch accepted:
1. Change 70404 to 4, this is clean.
2. Add the cx25840 request_module() code back.
3. Update the comments in _gpio_setup() to indicate the GPIO for the 
zilink part os on the AVcore.

Good work Steve, thanks for helping. Please publish the patch to this 
mailing list (with your sign-off) and I'll put up an official tree for 
retest and final merge.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
