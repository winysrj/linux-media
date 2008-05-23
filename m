Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4NBHpGP024466
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 07:17:51 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4NBHHmY011889
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 07:17:32 -0400
Date: Fri, 23 May 2008 13:17:09 +0200
From: Steve S <elcorto@gmx.net>
To: video4linux <video4linux-list@redhat.com>
Message-ID: <20080523111709.GA4796@ramrod.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: cx88: white noise with audio cable; no sound with cx88-alsa
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

Hi all.

This is my first post, so please be gentle :)

I have a WinTV PCI card with a cx88 chip.

--------------------------------------------
00:0f.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 03)
00:0f.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] (rev 03)

--------------------------------------------
$ cat /proc/asound/cards
 0 [V8235          ]: VIA8233 - VIA 8235
                      VIA 8235 with ALC650E at 0xe000, irq 19
 1 [CX8811         ]: CX88x - Conexant CX8811
                      Conexant CX8811 at 0xd2000000

--------------------------------------------
/etc/asound.names:

ctl {
	alsactl1 {
		name hw:0
		comment 'Physical Device - VIA 8235 with ALC650E at 0xe000, irq 19'
	}
	alsactl2 {
		name hw:1
		comment 'Physical Device - Conexant CX8811 at 0xd2000000'
	}
}
[...]

--------------------------------------------

I have 2 issues:

1) Right now, I'm capturing the sound using the analog audio cable that's
plugged into my onboard soundcard line-in (the VIA chip). At boot, I hear white
(static) noise coming from the line out of the TV card. If I start my TV app
(tvtime), the noise is replaced by the normal TV sound. When I close the TV
app, the noise is gone.

2) After a lot of searching the net, I was not able to track this issue down.
So I thought I try to capture the sound in another way.  According to [1,2], I
should be also able to capture the sound via the cx88-alsa module. The only
difference seems to be that I have rev 3, not rev 5.  I've read a lot about
redirecting the sound from the TV card but I feel a bit lost here. I tried

    $ sox -c 2 -t alsa hw:1 -t alsa hw:0    
    $ arecord -D hw:1 -c 2 -r 48000 -f S16_LE -t wav | aplay -

They all play nothing but silence. So, is this even possible with my card? 

My system: Debian testing, kernel compiled from from Debian kernel sources
(linux-source-2.6.24-6).

If you need more information, please say so. I'd be happy to provide as much as
I can, I just don't know where to start :) Many thanks!

steve

[1] http://www.linuxtv.org/v4lwiki/index.php/Cx88_devices_(cx2388x)
[2] http://www.mythtv.org/wiki/index.php/PCI_TV_audio

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
