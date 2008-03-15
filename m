Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2FLiwSF032503
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 17:44:58 -0400
Received: from smtp102.rog.mail.re2.yahoo.com (smtp102.rog.mail.re2.yahoo.com
	[206.190.36.80])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2FLiOMN011367
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 17:44:24 -0400
Message-ID: <47DC4331.7040100@rogers.com>
Date: Sat, 15 Mar 2008 17:44:17 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: ATI "HDTV Wonder" audio
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

> I'm trying to use an HDTV Wonder, using the cx88 chipset, and I am 
> getting no sound. Originally I was getting the native sound disabled 
> by the card, just putting it in a system. However, by moving the 
> driver usiung "index=" in modprobe.conf, I can keep sound for 
> everything except the card. It will grab an image just fine, but 
> there's no audio. Is there a known solution? Google didn't find one in 
> English, and I assume that it's as simple as an option in the module 
> load, if I know what module to change. I tried the cx88_alsa, and 
> alsamixer sees the card, but doesn't capture the sound.


cx88 supports tv-audio only; it does not feature ADC for external audio
sources.  This point is alluded to in the wiki:
http://www.linuxtv.org/wiki/index.php/ATI/AMD_HDTV_Wonder

Further explanation is found within this post here:
http://marc.info/?l=linux-dvb&m=119955615903163&w=2

I doubt very much that anything will ever be heard from the person
originally looking at the ak5355, so those seeking a driver will need to
write it themselves ... the chip's data sheet is available and appears 
to be straight forward.

Good luck.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
