Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7DCoPhn003885
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 08:50:25 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7DCoB6G029444
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 08:50:13 -0400
Date: Wed, 13 Aug 2008 14:49:54 +0200
From: Steve S <elcorto@gmx.net>
To: video4linux-list@redhat.com
Message-ID: <20080813124954.GA9894@ramrod.starsheriffs.de>
References: <20080523111709.GA4796@ramrod.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523111709.GA4796@ramrod.de>
Subject: [SOLVED] cx88: white noise with audio cable; no sound with cx88-alsa
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

On May 23 13:17 +0200, Steve S  wrote:
> Hi all.
> 
> This is my first post, so please be gentle :)
> 
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

[...]

>
> 1) Right now, I'm capturing the sound using the analog audio cable that's
> plugged into my onboard soundcard line-in (the VIA chip). At boot, I hear white
> (static) noise coming from the line out of the TV card. If I start my TV app
> (tvtime), the noise is replaced by the normal TV sound. When I close the TV
> app, the noise is gone.

Solution: Mute the Line In at shutdown and reboot.

At boot, the TV card sound gets activated, even if there is no need to (related
to the post by Daniel Gimpelevich: "[PATCH] Implement proper cx88
deactivation"?).  This produces white noise at the Line In. At shutdown or
reboot, /etc/init.d/alsa (/etc/rc{0,6}.d/K<NN>alsa) stores the current mixer
status, and here esspecially the Line In volume. I had to add a script 
/etc/init.d/foo (/etc/rc{0,6}.d/K<MM>foo), which mutes the Line In (`amixer set
Line mute`) *before* the ALSA K scripts are called. So, at boot, the card audio is
still active, but Line In is silent. Yeah!

best,
steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
