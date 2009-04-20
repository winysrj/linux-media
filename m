Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc3-s13.bay0.hotmail.com ([65.54.246.213]:2433 "EHLO
	bay0-omc3-s13.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756437AbZDTTuK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 15:50:10 -0400
Message-ID: <BAY102-W339894E1642F0C670E8745CF760@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: <stoth@linuxtv.org>, <linux-media@vger.kernel.org>
Subject: RE: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
Date: Mon, 20 Apr 2009 14:50:09 -0500
In-Reply-To: <49ECBCF0.3060806@linuxtv.org>
References: <23cedc300904170207w74f50fc1v3858b663de61094c@mail.gmail.com>
 <BAY102-W34E8EA79DEE83E18177655CF7B0@phx.gbl> <49E9C4EA.30706@linuxtv.org>
  <loom.20090420T150829-849@post.gmane.org> <49EC9A08.50603@linuxtv.org>
  <1240245715.5388.126.camel@mountainboyzlinux0>
 <49ECA8DD.9090708@linuxtv.org>
  <1240249684.5388.146.camel@mountainboyzlinux0>
 <49ECBCF0.3060806@linuxtv.org>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


My card shows similar dmesg and similar activity (no lights come on, scans take a long time under mythtv)  Iget 6 or 7 channels in Wintv V6 in windows and 4 in MCE in windows.  I do need to get my antenna up higher, but I should be able to get the same channels in mythtv as I can under windows.

I will try a fake channels.conf if someone can post one so I can get an idea what it should look like.


Thanks,

Tom
----------------------------------------
> Date: Mon, 20 Apr 2009 14:20:32 -0400
> From: stoth@linuxtv.org
> Subject: Re: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
> To: linux-media@vger.kernel.org
>
>>>
>>> Step 2. What happens when you try to use azap and what does syslog subsequently
>>> look like?
>>>
>>> - Steve
>> Since there is no channels.conf file by default, in the past, I have
>> tried using w_scan to generate one.
>
> If you know MCE works then put you zip into antennaweb.org and find out the
> physical channels and create a channels.conf by hand. Match the channels that
> work on MCE mentally with one or two channels you want to tune under linux.
>
> So, under MCE find a major network ABC, NBC or CBS that works perfectly for you
> then locate the RF channel on antenna web.org.
>
> Report back here with the RF channel reported by antennaweb for a couple of
> channels and I'll help you with a fake channels.conf.
>
>> This slowly scans all through all frequencies, though the light on the
>> tuner card does not come on. At the end it says no channels found and
>> does not create the channels.conf file.
>> While I am trying to tune in over-the-air signals in a fairly rural
>> area, the card works on 20+ channels in mce.
>
> Agreed, w_scan not working is interesting.
>
>>
>> Today, I just used a channels.conf file for broadcast channels in a
>> different us city which I found posted online and tuned to an arbitrary
>> channel. Still no activity light. status fields in azap ouput are 0
>> signals and noise both 87.
>>
>> But the good news is that dmesg says it loaded the firmware for at least
>> part of the card:
>> ....snip.....
>> [12250.084481] firmware: requesting xc3028-v27.fw
>> [12250.113053] xc2028 3-0061: Loading 80 firmware images from
>> xc3028-v27.fw, type: xc2028 firmware, ver 2.7
>> [12250.140031] xc2028 3-0061: Loading firmware for type=BASE (1), id
>> 0000000000000000.
>> [12251.105854] xc2028 3-0061: Loading firmware for type=D2633 DTV6 ATSC
>> (10030), id 0000000000000000.
>> ....snip....
>
> This is good news, the card and driver look fine. You probably just need a
> channels.conf (and perhaps w_scan has a bug?).
>
> I don't use w_scan so I can't comment much on this.
>
>>
>> Thank you so much for looking at this. I cannot begin to tell you how
>> much I appreciate it. I hope it is just something small, or something I
>> am doing wrong that is keeping this from working.
>
> Probably.
>
>>
>> Ben
>> p.s. sorry about the faux-pas
>>
>
> That's fine. :)
>
> - Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

_________________________________________________________________
Windows Live™: Keep your life in sync.
http://windowslive.com/explore?ocid=TXT_TAGLM_WL_allup_1a_explore_042009