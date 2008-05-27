Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RDnARV026252
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 09:49:10 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4RDmtdv002988
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 09:48:55 -0400
Date: Tue, 27 May 2008 15:48:48 +0200
From: Steve S <elcorto@gmx.net>
To: video4linux-list@redhat.com
Message-ID: <20080527134848.GA3048@ramrod.de>
References: <20080523111709.GA4796@ramrod.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523111709.GA4796@ramrod.de>
Subject: Re: cx88: white noise with audio cable; no sound with cx88-alsa
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

On May 23 13:17, Steve S wrote:

[...]

> I have a WinTV PCI card with a cx88 chip.
> 
> --------------------------------------------
> 00:0f.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 03)
> 00:0f.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] (rev 03)
> 
> --------------------------------------------
> $ cat /proc/asound/cards
>  0 [V8235          ]: VIA8233 - VIA 8235
>                       VIA 8235 with ALC650E at 0xe000, irq 19
>  1 [CX8811         ]: CX88x - Conexant CX8811
>                       Conexant CX8811 at 0xd2000000
> 
> --------------------------------------------
> /etc/asound.names:
> 
> ctl {
> 	alsactl1 {
> 		name hw:0
> 		comment 'Physical Device - VIA 8235 with ALC650E at 0xe000, irq 19'
> 	}
> 	alsactl2 {
> 		name hw:1
> 		comment 'Physical Device - Conexant CX8811 at 0xd2000000'
> 	}
> }
> [...]
> 
> --------------------------------------------
> 
> I have 2 issues:
> 
> 1) Right now, I'm capturing the sound using the analog audio cable that's
> plugged into my onboard soundcard line-in (the VIA chip). At boot, I hear white
> (static) noise coming from the line out of the TV card. If I start my TV app
> (tvtime), the noise is replaced by the normal TV sound. When I close the TV
> app, the noise is gone.
>
> 2) After a lot of searching the net, I was not able to track this issue down.
> So I thought I try to capture the sound in another way.  According to [1,2], I
> should be also able to capture the sound via the cx88-alsa module. The only
> difference seems to be that I have rev 3, not rev 5.  I've read a lot about
> redirecting the sound from the TV card but I feel a bit lost here. I tried
> 
>     $ sox -c 2 -t alsa hw:1 -t alsa hw:0    
>     $ arecord -D hw:1 -c 2 -r 48000 -f S16_LE -t wav | aplay -
> 
> They all play nothing but silence. So, is this even possible with my card? 

update:

I was able to capture the TV sound with cx88-alsa using mplayer like so:

    $ mplayer tv:// -tv driver=v4l2:alsa:adevice=hw.1:amode=1:audiorate=48000:volume=100:immediatemode=0:norm=PAL-BG:mjpeg

So, my card can do that. I still haven't found out why the other two
possibilities above don't work, though. Also, I read that these solutions can
cause the video and audio streams to go out of sync. So, maybe this isn't a
promising route to go anyway.

Now, I've observed something else: If I keep the loopback cable plugged into
the onboard soudcard and close mplayer, the white noise/buzzing sound over the
loopback cable starts again until I start tvtime, which stops it. Can anybody
explain this? I'd really like to know why I hear white noise over the loopback
cable (or direct at the TV card's line-out).  If anybody can give me a hint,
that would be highly appreciated.

[...]

> [1] http://www.linuxtv.org/v4lwiki/index.php/Cx88_devices_(cx2388x)
> [2] http://www.mythtv.org/wiki/index.php/PCI_TV_audio
> 

steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
