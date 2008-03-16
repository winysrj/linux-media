Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2G3roAO020459
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 23:53:50 -0400
Received: from gaimboi.tmr.com (mail.tmr.com [64.65.253.246])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2G3rH9o031557
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 23:53:18 -0400
Message-ID: <47DC9B27.50601@tmr.com>
Date: Sat, 15 Mar 2008 23:59:35 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: CityK <cityk@rogers.com>
References: <47DC4331.7040100@rogers.com>	<1205622683.4814.13.camel@pc08.localdom.local>
	<47DC6303.2040802@rogers.com>
In-Reply-To: <47DC6303.2040802@rogers.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: ATI "HDTV Wonder" audio
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

CityK wrote:
> Hi Hermann
> 
> hermann pitton wrote:
>> for sure blame me not being up to date on this and I am not even sure,
>> what it is all about.
>> For example, since the using of cx88-alsa seems to be intended, analog
>> NTSC with picture, but no sound from tuner is reported (?)
>> Or like you pointed now, likely analog video from an external input and
>> then missing the specific ADC support for external analog audio input?
>>
>> ...
>>
>> Is it at all about analog NTSC-M video working from the tuner?
>> But no sound, hrmm ;)
>>   
> Oops ... umm, its not that I  failed to take broadcast audio into 
> consideration (as I wasn't sure if Bill was talking about broadcast 
> audio too), its just that I was hell bent on talking about the external 
> audio problem :P

I'm not sure what you mean by external audio, when the card was tried in 
a Windows system it had sound, so there is some way to get the audio 
"external" of the card and into the computer. I loaded the cx88_alsa 
module with "index=1" and now /proc/asound/cards shows the internal 
audio as card0 and the cx88 as card1. But I can't get any sound OUT of 
the card to play, or even record.

> So now, for a more complete picture:
> IIRC, the HDTV Wonder lacks any sort of audio out (via either an 
> internal loop back cable to the sound card or similarly an external out 
> on the riser).  Therefore, while the cx88 will perform ADC for analog 
> broadcast audio, you would indeed need to use cx88-alsa, as quite 
> correctly alluded to by Hermann.  In the more limited case (which I had 
> wrongly only took into consideration) one will be unable to receive 
> external audio for the reasons I specified -- i.e. cx88 doesn't do ADC 
> for external audio; need a driver for the AK5355 for that, and then 
> correctly code for the GPIO pins for the cx88 as used on the HDTV Wonder.
> 
As noted in my original post, I'm using cx88_alsa, it just doesn't work. 
It's not muted, the volume is up, but nothing. Why they didn't populate 
the soundcard out on the card I don't know, all the traces are there but 
no socket is provided.

Is it likely that "pulseaudio" stuff is the problem? This is the first 
time I've used it with video, so I'm at least suspicious, but several 
people warned I can't just rip it out, I may have to drop back to 
several older things.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
