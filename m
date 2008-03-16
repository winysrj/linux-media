Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2G00g1E002026
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 20:00:42 -0400
Received: from smtp109.rog.mail.re2.yahoo.com (smtp109.rog.mail.re2.yahoo.com
	[68.142.225.207])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2G00AiJ006480
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 20:00:10 -0400
Message-ID: <47DC6303.2040802@rogers.com>
Date: Sat, 15 Mar 2008 20:00:03 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <47DC4331.7040100@rogers.com>
	<1205622683.4814.13.camel@pc08.localdom.local>
In-Reply-To: <1205622683.4814.13.camel@pc08.localdom.local>
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

Hi Hermann

hermann pitton wrote:
> for sure blame me not being up to date on this and I am not even sure,
> what it is all about. 
>
> For example, since the using of cx88-alsa seems to be intended, analog
> NTSC with picture, but no sound from tuner is reported (?) 
>
> Or like you pointed now, likely analog video from an external input and
> then missing the specific ADC support for external analog audio input?
>
> ...
>
> Is it at all about analog NTSC-M video working from the tuner?
> But no sound, hrmm ;)
>   
Oops ... umm, its not that I  failed to take broadcast audio into 
consideration (as I wasn't sure if Bill was talking about broadcast 
audio too), its just that I was hell bent on talking about the external 
audio problem :P 

So now, for a more complete picture:
IIRC, the HDTV Wonder lacks any sort of audio out (via either an 
internal loop back cable to the sound card or similarly an external out 
on the riser).  Therefore, while the cx88 will perform ADC for analog 
broadcast audio, you would indeed need to use cx88-alsa, as quite 
correctly alluded to by Hermann.  In the more limited case (which I had 
wrongly only took into consideration) one will be unable to receive 
external audio for the reasons I specified -- i.e. cx88 doesn't do ADC 
for external audio; need a driver for the AK5355 for that, and then 
correctly code for the GPIO pins for the cx88 as used on the HDTV Wonder.

> Without looking any deeper back, but slightly wondering, why has the
> TUV1236D the TDA9887_PRESENT on the saa7134 cards, but not on this one?

Just a mistake on my part lead to the confusion.  TDA9887 present in all 
cases of TUV1236D.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
