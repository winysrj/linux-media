Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5DKEwJ0006432
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 16:14:58 -0400
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5DKEF8j008908
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 16:14:15 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans-Peter Diettrich <DrDiettrich1@aol.com>
In-Reply-To: <485273BB.6040608@aol.com>
References: <485273BB.6040608@aol.com>
Content-Type: text/plain
Date: Fri, 13 Jun 2008 22:13:19 +0200
Message-Id: <1213387999.2758.65.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Medion problem
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

Hi Hans-Peter,

Am Freitag, den 13.06.2008, 15:18 +0200 schrieb Hans-Peter Diettrich:
> Preface: I'm very new to Linux :-(
> 
> My Medion PC6610 comes without any Linux support, what I only noticed 
> when I started to move from Vista to Linux (openSUSE 10.3 32/64 bit).
> 
> The TV card is a proprietary Medion (Philips?) card, detected as:
> 1) SAA7134/SAA7135HL Video Broadcast Decoder
> 2) Medion 7134

that should be a Creatix CTX925 analog TV/DVB-T hybrid with Philips
FMD1216ME/I H-3 (MK3) and tda10046 DVB-T channel decoder for the usually
first of two saa7134 chips on it. The second saa7134 supports only DVB-S
and support will come with kernel 2.6.26 or by installing the recent
v4l-dvb development mercurial tree from linuxtv.org. No testers so far
for DVB-S and on older stuff that bridge#2 is disabled.

There is currently some trouble with the initialization of the analog
tda9887 demodulator on FMD1216ME MK3 tuners on first loading. On older
kernels you must reload the tuner module once ("modprobe -vr tuner" and
"modprobe -v tuner")

On latest stuff you need to reload the saa713x driver, like
"modprobe -vr saa71134-dvb" and if saa7134-alsa is loaded also that one
previously and load again with "modprobe -v saa7134".
Check with "dmesg" if the tda9887 looks OK.

> With the installed driver saa7134 I can configure the TV channels for 
> the second (Medion 7134) entry only, in the Yast2 TV card setup. The 
> detected channels (PAL, analog, cable) are stored in /etc/X11/xawtvrc. 
> NxtVEPG also works fine with that entry :-)

In previous reports the analogTV/DVB-T device came up as first device.
It looks like this is currently swapped in the blue special double PCI
bus master capable slot. I can see the same with a CTX944 md8800 Quad
currently on a recent Medion PC.

> But none of the TV applications seems to come in contact with either 
> device, most applications simply refuse to start (no window after some 
> seconds of activity). Only Kdetv opens a window, with two Video card 
> options:
> 1) Video4Linux2: Medion 7134 Bridge #2
> 2) Video4Linux2: Medion 7134
> 
> but it displays only noise for the first entry, nothing at all for the 
> second one. Channel selection has no effect, even if I could manage 
> (somehow) to fill the channel list, with channels only (no providers).
> 
> Another complication may be the graphics card, a Nvidia GeForce 8500GT, 
> which works fine together with the TV card under Vista. It seems to work 
> properly under Linux as well, with the proprietary Nvidia driver, even 
> with two monitors, but it may cause the Linux TV apps to fail?
> Even nvtv 0.4.7 only says: No supported video card found.

The Nvidia binary drivers are in most cases fine, on latest cards even
needed, since only VESA support else, that would work with xawtv in its
default overlay preview mode, but that is not supported on the binary
drivers anymore. Therefore you would like to force it to
grabdisplay/mmapped mode with "xawtv -nodga -remote -c /dev/video0"

Apps like "tvtime" should work out of the box after setting tvnorm and
channel-list. Try also xawtv's "scantv -h". With "scantv -o .xawtv" you
can create a config file in your home directory and change [defaults] to
capture = grabdisplay

There is also a saa7134 no_overlay=int insmod option ("modinfo saa7134")
to disable it, since some chipsets don't deal well with it, but you
might still need -nodga and the correct video device set.

> Also all the diagnostic tools fail to provide meaningful information, at 
> least to me <g>. If you think that it's worth the time, I can provide 
> more information...
> 
> DoDi
> 

Please copy/paste "uname -a" for your kernel version and unload at least
"modprobe -vr saa7134-dvb tuner" and "modprobe -v saa7134" and do what
else might be needed to get the tda9887 up.

Please post the relevant part of "dmesg" after that.

The tuners are known to be good and likely you get all three TV types
supported. Radio has no autoscan ability yet and for DVB-S testing, if
your kernel/module versions are sufficient once, you need to set the
saa7134-dvb use_frontend=1 option.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
