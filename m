Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KaYYC-000356-Q3
	for linux-dvb@linuxtv.org; Tue, 02 Sep 2008 18:16:18 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6K00LHHT5USPR0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 02 Sep 2008 12:15:33 -0400 (EDT)
Date: Tue, 02 Sep 2008 12:15:24 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080901001259.F3CC2104F0@ws1-3.us4.outblaze.com>
To: stev391@email.com
Message-id: <48BD669C.1000702@linuxtv.org>
MIME-version: 1.0
References: <20080901001259.F3CC2104F0@ws1-3.us4.outblaze.com>
Cc: 'jackden' <jackden@gmail.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
 TV/FM capture card
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
>> To: "Thomas Goerke" <tom@goeng.com.au>
>> Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog TV/FM capture card
>> Date: Sun, 31 Aug 2008 18:10:32 -0400
>>
>>
>> Thomas Goerke wrote:
>>>> Tom,
>>>> (Jackden please try first patch and provide feedback, if that doesn't
>>>> work for your card, then try this and provide feedback)
>>>>
>>>> The second dmesg (with debugging) didn't show me what I was looking
>>>> for, but from past experience I will try something else.  I was looking
>>>> for some dma errors from the cx23885 driver, these usually occured
>>>> while streaming is being attempted.
>>>>
>>>> Attached to this email is another patch.  The difference between the
>>>> first one and the second one is that I load an extra module (cx25840),
>>>> which normally is not required for DVB as it is part of the analog side
>>>> of this card.  This does NOT mean analog will be supported.
>>>>
>>>> As of today the main v4l-dvb can be used with this patch and this means
>>>> that the cx23885-leadtek tree will soon disappear. So step 2 above has
>>>> been modified to: "Check out the latest v4l-dvb source".
>>>>
>>>> Other then that step 4 has a different file name for the patch.
>>>>
>>>> Steps that need to be completed are: 2, 3, 4, 5, 7, 9, 10 & 11. (As you
>>>> have completed the missing steps already).
>>>>
>>>> If the patch works, please do not stop communicating, as I have to
>>>> perform one more patch to prove that cx25840 is required and my
>>>> assumptions are correct. Once this is completed I will send it to
>>>> Steven Toth for inclusion in his test tree. This will need to be tested
>>>> by you again, and if all is working well after a week or more it will
>>>> be included into the main tree.
>>>>
>>>> Regards,
>>>> Stephen
>>>>
>>>>
>>>> --
>>> Stephen,
>>>
>>> After following Steven Toth's advice re CPIA, applying your patch and then
>>> make, make install, I can now report that the Compro E800F card is working!
>>> This is very impressive and thanks for your help.
>>>
>>> I have added the card to MythTV and all channels were successfully added.  I
>>> am not sure about the comparable signal strength's compared to the Hauppauge
>>> Nova card I also have installed - this is something I can provide feedback
>>> on at a later stage.
>>>
>>> I have tried from a soft and hard reset and all seems ok.
>>>
>>> See below for the o/p from dmesg.  Please let  me know if there is anything
>>> else you would like to try/test.
>> Stephen,
>>
>> It looks like your patches work. If you want this merged then mail me the patch, I'll put this 
>> up on a ~stoth/cx23885-something tree and we can have Thomas test one more time before a merge 
>> request is generated.
>>
>> Good work.
>>
>> Regards,
>>
>> Steve
> 
> Steve,
> 
> A few items I need to get your thoughts on:
> 1)  The same sub vendor and sub device ID is used for a string of cards from Compro (E300, E500, E650, E800, E300F, E500F, E600F, E650F, E800F).  The F versions appear to be the same as the non F versions except for a MS MCE approved remote control. This patch should work with all versions (same windows driver), however when the analog side is implemented it might be an issue.  The E800 has a mpeg encoder on the board, while the other lower numbers do not (other differences are scheduled power on abilities or different remotes).  At the moment I have labeled the card in the driver as the E650 as this is the first one that caught my attention on the mailing list.  
>    Do you think I should label it something else? (Such as CX23885_BOARD_COMPRO_VIDEOMATE_GENERIC and in the text description [cx23885_boards.name] list the cards?)
>    Should I get Jackden & Tom to determine if there is an eprom and the information stored in it (to help distinguish the cards)?

I suspect the card has an eeprom. Longer term that will nee to be 
queried during _probe() and a card selection made automatically. I'd 
personally prefer to see different card[] entires for each board type, 
and have the eeprom determine which card is implemented. This allows 
people to also modprove card=X for test purposes with any new devices 
that arrive, without patching code.

Label the card with the correct product description for the time being, 
until other cards can be analyzed.

Assuming it has an eeprom, try to collect eeprom dumps from different 
cards. 1) Either contact Compro for an eeprom description or 2) figure 
it out.

> 
> 2) So far I have proved the card will not work without the cx25840 module (1st patch was without it, second patch was with it).  
>    Did you want me to temporary remove the GPIO set from the cx25840 code to ensure this is what is required for this card? 
>    Or should I just make a similar comment in the GPIO set up section of cx23885-cards.c?

I'd like to know for sure that the GPIO on the 25840 is required. I know 
this means a little more work but it's good to understand the GPIO 
layout for sure - rather than through assumption. If you could generate 
a new patch that would be great.

> 
> Other then these items, there is nothing else I'm concerned with, so a patch should will be prepared shortly. (I don't have access to my testing box from work at the moment).

Great, thanks Stephen.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
