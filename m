Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:34723 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164AbbJHQ2p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2015 12:28:45 -0400
Received: by ykdg206 with SMTP id g206so53746903ykd.1
        for <linux-media@vger.kernel.org>; Thu, 08 Oct 2015 09:28:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGGr8Nsc4NPcG6WK0ZJoa3-ev7Bo3+tSH-no-xxLigs6ALXj3Q@mail.gmail.com>
References: <CAGGr8Nt3pWTOsDJZQ9_hQo1j1Aow47W6xrTsPgXsH_+0S1sksA@mail.gmail.com>
	<CAHFNz9L_wxNwju6nXuhv+H4ObhBPJnrauYqv0Gmp4soQG7fgrg@mail.gmail.com>
	<CAGGr8Nsc4NPcG6WK0ZJoa3-ev7Bo3+tSH-no-xxLigs6ALXj3Q@mail.gmail.com>
Date: Thu, 8 Oct 2015 21:58:44 +0530
Message-ID: <CAHFNz9+R-Twg+LALn9VUbNMmPr4-L1bUF7dtzFsoyaNg8Y_Ekg@mail.gmail.com>
Subject: Re: AverMedia HD Duet (White Box) A188WB drivers
From: Manu Abraham <abraham.manu@gmail.com>
To: David Nelson <nelson.dt@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I just got back at work again. Will set things up this weekend/next week.

On Thu, Oct 8, 2015 at 3:38 AM, David Nelson <nelson.dt@gmail.com> wrote:
> It's been a while since I originally asked you about this has there
> been any progress?
>
> On Fri, Jun 12, 2015 at 11:21 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> Hi David,
>>
>> The saa7160 chipset is supported by the saa716x driver.
>> I wrote a driver for it, which is over here.
>> http://git.linuxtv.org/cgit.cgi/manu/saa716x_new.git
>>
>> I do have the A188 card and documentation also with me,
>> thanks to Avermedia.
>>
>> The card is not yet supported in the above tree, so cloning
>> that tree will not help much in your case. Though I have
>> some code related to that, it is only on my local testbox
>>
>> I've been with an accident and my other hand is in a restrictive
>> state with minimal movements. It will be a few weeks, before
>> I can do something in this area. It's not much help to you at
>> this point right now, but just fyi
>>
>> Manu
>>
>>
>>
>> On Sat, Jun 13, 2015 at 8:46 AM, David Nelson <nelson.dt@gmail.com> wrote:
>>> I have the AverMedia HD Duet (White Box) A188WB. Which has been
>>> working great for several years in Windows 7 Media Center. I just
>>> tried installing Mythbuntu but it does not appear to be recognized. I
>>> am a bit of a newbie but I managed to find some info about it.
>>>
>>> Does anyone know of a driver for it? lspci says it uses the Philips
>>> SAA7160 which does appear to be in a few other supported devices.
>>>
>>> Details follow
>>>
>>> I get the following from lspci -vvnnk
>>>
>>> 03:00.0 Multimedia controller [0480]: Philips Semiconductors SAA7160
>>> [1131:7160] (rev 01)
>>> Subsystem: Avermedia Technologies Inc Device [1461:1e55]
>>> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>>> Stepping- SERR- FastB2B- DisINTx-
>>> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>> Latency: 0, Cache Line Size: 64 bytes
>>> Interrupt: pin A routed to IRQ 10
>>> Region 0: Memory at ef800000 (64-bit, non-prefetchable) [size=1M]
>>> Capabilities: <access denied>
>>>
>>>
>>> I can see that there is a driver for a few other devices with this
>>> chip at http://www.linuxtv.org/wiki/index.php/NXP_SAA716x  (i.e.
>>> heading "As of (2014-06-07)"
>>>
>>>
>>> --
>>> -David Nelson
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> -David Nelson
> Home: 801-302-1347
> Cell: 801-205-8248
