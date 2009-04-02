Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:44902 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbZDBXGI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2009 19:06:08 -0400
Received: from [195.7.61.29] (joburg.koala.ie [195.7.61.29])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id n32N651i018984
	for <linux-media@vger.kernel.org>; Fri, 3 Apr 2009 00:06:06 +0100
Message-ID: <49D544DD.1060001@koala.ie>
Date: Fri, 03 Apr 2009 00:06:05 +0100
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Re : epg data grabber
References: <49D53B8A.7020900@koala.ie> <1238713191.7516.2@manu-laptop>
In-Reply-To: <1238713191.7516.2@manu-laptop>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu wrote:
> Le 02.04.2009 18:26:18, Simon Kenyon a écrit :
>   
>> i've been hacking together a epg data grabber
>> taking pieces from here, there and everywhere
>>
>> the basic idea is to grab data off-air and generate xmltv format xml
>> files
>>
>> the plan is to support DVB, Freesat, Sky (UK and IT) and 
>> MediaHighway1
>> and 2
>> i have the first two working and am working on the rest
>>
>> is this of interest to the linuxtv.org community
>> i asked the xmltv people, but they are strictly perl. i do 
>> understand.
>>
>> very little of this is original work of mine. just some applied 
>> google
>>
>> and a smidgen of C
>>
>> i could put it up on sf.net if there is no room on linutv.org
>>
>> if anyone wants the work in progress, then please let me know
>> it is big released under GPL 3
>>
>> i want to get it out there because i'm pretty soon going to be at the 
>> end of my knowledge and would appreciate help
>>
>>     
>
> Hi Simon,
> I have hacked something for what is supposedly mediaHighway epg (it is 
> used on CanalSat Caraibes which is affiliated to Canal Satellite from 
> France). I actually have a patch against mythtv (it uses the scanner to 
> get the epg directly).
> I can provide my patches if needed (will need some time to sort things 
> out abit, especially if you want a stand alone version).
> Bye
> Manu
>   
i am doing it "stand alone" so i can see what is going on
i would propose to do  mythtv version but that is some way off

don't modify your stuff. i already extracted the freesat code from the 
mythtv code base
that was a couple of hours work

regards
--
simon
