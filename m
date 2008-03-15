Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2FNKnQi025009
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 19:20:49 -0400
Received: from mail-in-05.arcor-online.net (mail-in-05.arcor-online.net
	[151.189.21.45])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2FNKEpI022468
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 19:20:14 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: CityK <cityk@rogers.com>
In-Reply-To: <47DC4331.7040100@rogers.com>
References: <47DC4331.7040100@rogers.com>
Content-Type: text/plain
Date: Sun, 16 Mar 2008 00:11:23 +0100
Message-Id: <1205622683.4814.13.camel@pc08.localdom.local>
Mime-Version: 1.0
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

Am Samstag, den 15.03.2008, 17:44 -0400 schrieb CityK:
> > I'm trying to use an HDTV Wonder, using the cx88 chipset, and I am 
> > getting no sound. Originally I was getting the native sound disabled 
> > by the card, just putting it in a system. However, by moving the 
> > driver usiung "index=" in modprobe.conf, I can keep sound for 
> > everything except the card. It will grab an image just fine, but 
> > there's no audio. Is there a known solution? Google didn't find one in 
> > English, and I assume that it's as simple as an option in the module 
> > load, if I know what module to change. I tried the cx88_alsa, and 
> > alsamixer sees the card, but doesn't capture the sound.
> 
> 
> cx88 supports tv-audio only; it does not feature ADC for external audio
> sources.  This point is alluded to in the wiki:
> http://www.linuxtv.org/wiki/index.php/ATI/AMD_HDTV_Wonder
> 
> Further explanation is found within this post here:
> http://marc.info/?l=linux-dvb&m=119955615903163&w=2
> 
> I doubt very much that anything will ever be heard from the person
> originally looking at the ak5355, so those seeking a driver will need to
> write it themselves ... the chip's data sheet is available and appears 
> to be straight forward.
> 
> Good luck.
> 

Hi CityK and all interested,

for sure blame me not being up to date on this and I am not even sure,
what it is all about. 

For example, since the using of cx88-alsa seems to be intended, analog
NTSC with picture, but no sound from tuner is reported (?) 

Or like you pointed now, likely analog video from an external input and
then missing the specific ADC support for external analog audio input?

Without looking any deeper back, but slightly wondering, why has the
TUV1236D the TDA9887_PRESENT on the saa7134 cards, but not on this one?

Is it at all about analog NTSC-M video working from the tuner?
But no sound, hrmm ;)

Cheers,
Hermann




 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
