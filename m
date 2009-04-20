Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:51619 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbZDTSUo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 14:20:44 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KIE004GYWA8G5K0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 20 Apr 2009 14:20:33 -0400 (EDT)
Date: Mon, 20 Apr 2009 14:20:32 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
In-reply-to: <1240249684.5388.146.camel@mountainboyzlinux0>
To: linux-media@vger.kernel.org
Message-id: <49ECBCF0.3060806@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <23cedc300904170207w74f50fc1v3858b663de61094c@mail.gmail.com>
 <BAY102-W34E8EA79DEE83E18177655CF7B0@phx.gbl> <49E9C4EA.30706@linuxtv.org>
 <loom.20090420T150829-849@post.gmane.org> <49EC9A08.50603@linuxtv.org>
 <1240245715.5388.126.camel@mountainboyzlinux0> <49ECA8DD.9090708@linuxtv.org>
 <1240249684.5388.146.camel@mountainboyzlinux0>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>
>> Step 2. What happens when you try to use azap and what does syslog subsequently 
>> look like?
>>
>> - Steve
> Since there is no channels.conf file by default,  in the past, I have 
> tried using w_scan to generate one.

If you know MCE works then put you zip into antennaweb.org and find out the 
physical channels and create a channels.conf by hand. Match the channels that 
work on MCE mentally with one or two channels you want to tune under linux.

So, under MCE find a major network ABC, NBC or CBS that works perfectly for you 
then locate the RF channel on antenna web.org.

Report back here with the RF channel reported by antennaweb for a couple of 
channels and I'll help you with a fake channels.conf.

> This slowly scans all through all frequencies, though the light on the 
> tuner card does not come on. At the end it says no channels found and 
> does not create the channels.conf file.
> While I am trying to tune in over-the-air signals in a fairly rural 
> area, the card works on 20+ channels in mce.

Agreed, w_scan not working is interesting.

> 
> Today, I just used a channels.conf file for broadcast channels in a 
> different us city which I found posted online and tuned to an arbitrary 
> channel. Still no activity light. status fields in azap ouput are 0 
> signals and noise both 87.
> 
> But the good news is that dmesg says it loaded the firmware for at least 
> part of the card:
> ....snip.....
> [12250.084481] firmware: requesting xc3028-v27.fw
> [12250.113053] xc2028 3-0061: Loading 80 firmware images from 
> xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> [12250.140031] xc2028 3-0061: Loading firmware for type=BASE (1), id 
> 0000000000000000.
> [12251.105854] xc2028 3-0061: Loading firmware for type=D2633 DTV6 ATSC 
> (10030), id 0000000000000000.
> ....snip....

This is good news, the card and driver look fine. You probably just need a 
channels.conf (and perhaps w_scan has a bug?).

I don't use w_scan so I can't comment much on this.

> 
> Thank you so much for looking at this. I cannot begin to tell you how 
> much I appreciate it. I hope it is just something small, or something I 
> am doing wrong that is keeping this from working.

Probably.

> 
> Ben
> p.s. sorry about the faux-pas
> 

That's fine. :)

- Steve
