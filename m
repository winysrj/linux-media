Return-path: <linux-media-owner@vger.kernel.org>
Received: from apollo.dupie.be ([85.17.239.130]:59704 "EHLO apollo.dupie.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbZBPWJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 17:09:46 -0500
Message-ID: <4999E421.6030007@dupondje.be>
Date: Mon, 16 Feb 2009 23:09:37 +0100
From: Jean-Louis Dupond <info@dupondje.be>
MIME-Version: 1.0
To: wk <handygewinnspiel@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: Bad sound on HVR1300 & cx88-alsa not loading anymore for HVR1300
References: <4998A55E.6020808@dupondje.be> <4999A0A8.2070500@gmx.de>
In-Reply-To: <4999A0A8.2070500@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have sound yes! I also tried cx88_blackbird, but have no sound untill 
cx88_alsa is loaded ... Maby I set something wrong in MythTV ?

I have PAL also. And it seems u don't load the cx88_alsa module, try it 
out, and get sound normally :)

wk schreef:
>
>> Hello,
>>
>> I'm running Ubuntu 8.10, and 2.6.27-11-generic kernel. I also tried 
>> compiling the newest modules from linuxtv.
>>
>> The first problem:
>> The sound from my HVR1300 is really bad, it like a robotic sound, 
>> with high tones in it!
>>
>> 2nd problem:
>> cx88-alsa module is not loading automaticly when booting my system. 
>> While my HVR1300 needs it !
>>
>> Regards,
>> Jean-Louis Dupond
>>
> So that means you do have at least any sound, different as it is for me?
> I guess you're not using the cx88_blackbird module, since you use the 
> alsa device for sound?
>
> Are you using PAL video norm on TV input and does your initialisation 
> differ from mine, see some posts before yours?
>
> -Winfried
