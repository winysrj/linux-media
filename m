Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33902 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112Ab1DKAZE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Apr 2011 20:25:04 -0400
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
From: Andy Walls <awalls@md.metrocast.net>
To: Eric B Munson <emunson@mgebm.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, mchehab@infradead.org,
	linux-media@vger.kernel.org
In-Reply-To: <BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com>
References: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com>
	 <1301922737.5317.7.camel@morgan.silverblock.net>
	 <BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
	 <BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
	 <1302015521.4529.17.camel@morgan.silverblock.net>
	 <BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Apr 2011 20:25:35 -0400
Message-ID: <1302481535.2282.61.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-04-06 at 13:28 -0400, Eric B Munson wrote:
> On Tue, Apr 5, 2011 at 10:58 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> > On Mon, 2011-04-04 at 14:36 -0400, Eric B Munson wrote:
> >> On Mon, Apr 4, 2011 at 11:16 AM, Eric B Munson <emunson@mgebm.net> wrote:
> >> > On Mon, Apr 4, 2011 at 9:12 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> >> >> On Mon, 2011-04-04 at 08:20 -0400, Eric B Munson wrote:
> >> >>> I the above mentioned capture card and the digital side of the card
> >> >>> works well.  However, when I try to get video from the analog side of
> >> >>> the card, all I get is a red screen and no sound regardless of channel
> >> >>> requested.  This is a problem I see in 2.6.39-rc1 though I typically
> >> >>> run the ubuntu 10.10 kernel with the newest drivers built from source.
> >> >>>  Is there something in setup or configuration that I may be missing?
> >> >>
> >> >> Eric,
> >> >>
> >> >> You are likely missing the last 3 fixes here:
> >> >>
> >> >> http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/cx18_39
> >> >>
> >> >> (one of which is critical for analog to work).
> >> >>
> >> >> Also check the ivtv-users and ivtv-devel list for past discussions on
> >> >> the "red screen" showing up for known well supported models and what to
> >> >> try.
> >> >>
> >> > Thanks, I will try hand applying these.
> >> >
> >>
> >> I don't have a red screen anymore, now all get from analog static and
> >> mythtv's digital channel scanner now seems broken.
> >
> > Hmmm.
> >
> > 1. Please provide the output of dmesg when the cx18 driver loads.
> 
> [    2.882590] cx18:  Start initialization, version 1.4.1
> [    2.882623] cx18-0: Initializing card 0
> [    2.882626] cx18-0: Autodetected Hauppauge card
> [    2.882666] cx18 0000:04:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    2.920427] cx18-0: cx23418 revision 01010000 (B)
> [    3.202139] tveeprom 0-0050: Hauppauge model 74351, rev F1F5
> [    3.202146] tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155, type 54)
> [    3.202149] tveeprom 0-0050: TV standards PAL(B/G) NTSC(M) PAL(I)
> SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> [    3.202152] tveeprom 0-0050: audio processor is CX23418 (idx 38)
> [    3.202154] tveeprom 0-0050: decoder processor is CX23418 (idx 31)
> [    3.202157] tveeprom 0-0050: has no radio
> [    3.202159] cx18-0: Autodetected Hauppauge HVR-1600
> [    3.349248] cx18-0: Simultaneous Digital and Analog TV capture supported
> [    3.709066] cs5345 0-004c: chip found @ 0x98 (cx18 i2c driver #0-0)

(Richard Nixon-esque gap in the tape recording...)

> [   20.825012] cx18-0: Registered device video0 for encoder MPEG (64 x 32.00 kB)
> [   20.825015] DVB: registering new adapter (cx18)
> [   21.156176] cx18-0: DVB Frontend registered
> [   21.156180] cx18-0: Registered DVB adapter0 for TS (32 x 32.00 kB)
> [   21.156216] cx18-0: Registered device video32 for encoder YUV (20 x
> 101.25 kB)
> [   21.156272] cx18-0: Registered device vbi0 for encoder VBI (20 x 51984 bytes)
> [   21.156308] cx18-0: Registered device video24 for encoder PCM audio
> (256 x 4.00 kB)
> [   21.156311] cx18-0: Initialized card: Hauppauge HVR-1600
> [   21.156363] cx18:  End initialization
> [   21.161137] cx18-alsa: module loading...
> [   21.278026] cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
> [   21.403872] cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000
> (141200 bytes)
> [   21.410240] cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
> [   22.247372] cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
> [   22.267064] cx18-0 843: verified load of v4l-cx23418-dig.fw
> firmware (16382 bytes)

It appears you grep-ped for cx18.  That dropped all the messagea about
the tuner chips which I'd like to see.

If you are unsure of what boot-up dmesg crud to snip and what to keep
pass along, you can do this:

	kill the mythbackend
	unload the cx18 module
	reload the cx18 module.

At the end of the dmesg output will be messages relating only to the
init of the card and all it's tuner chips.


> >
> > 2. Please provide the output of v4l2-ctl -d /dev/video0 --log status
> > when tuned to an analog channel.
> 
> Status Log:
> 
>    [  289.758052] cx18-0: =================  START STATUS CARD #0
> =================
>    [  289.758059] cx18-0: Version: 1.4.1  Card: Hauppauge HVR-1600
>    [  289.801911] tveeprom 0-0050: Hauppauge model 74351, rev F1F5,
> serial# XXXXXXX
>    [  289.801917] tveeprom 0-0050: MAC address is XX:XX:XX:XX:XX:XX
>    [  289.801922] tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155, type 54)
>    [  289.801928] tveeprom 0-0050: TV standards PAL(B/G) NTSC(M)
> PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
>    [  289.801934] tveeprom 0-0050: audio processor is CX23418 (idx 38)
>    [  289.801938] tveeprom 0-0050: decoder processor is CX23418 (idx 31)
>    [  289.801942] tveeprom 0-0050: has no radio
>    [  289.801950] cx18-0 843: Video signal:              not present
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Well there's your problem. ;)

>    [  289.801953] cx18-0 843: Detected format:           NTSC-M
>    [  289.801957] cx18-0 843: Specified standard:        NTSC-M
>    [  289.801960] cx18-0 843: Specified video input:     Composite 7
>    [  289.801964] cx18-0 843: Specified audioclock freq: 32000 Hz
>    [  289.801975] cx18-0 843: Detected audio mode:       mono
>    [  289.801979] cx18-0 843: Detected audio standard:   BTSC
>    [  289.801982] cx18-0 843: Audio muted:               yes
>    [  289.801985] cx18-0 843: Audio microcontroller:     running
>    [  289.801989] cx18-0 843: Configured audio standard: automatic detection
>    [  289.801992] cx18-0 843: Configured audio system:   BTSC
>    [  289.801996] cx18-0 843: Specified audio input:     Tuner (In8)
>    [  289.801999] cx18-0 843: Preferred audio mode:      stereo
>    [  289.802021] cx18-0 gpio-reset-ctrl: GPIO:  direction 0x00003801,
> value 0x00003801
>    [  289.804291] cs5345 0-004c: Input:  1
>    [  289.804293] cs5345 0-004c: Volume: 0 dB

For older boards, somewhere before this point, the analog tuner driver
should have logged what frequency it is tuned to.  (I need to check if
this happens for my newer HVR-1600 board.)

This gives me the feeling that something didn't init correctly with the
analog tuner.

>    [  289.804295] cx18-0: Video Input: Tuner 1
>    [  289.804297] cx18-0: Audio Input: Tuner 1
>    [  289.804299] cx18-0: GPIO:  direction 0x00003801, value 0x00003801
>    [  289.804301] cx18-0: Tuner: TV
>    [  289.804303] cx18-0: Stream Type: MPEG-2 Program Stream (grabbed)
>    [  289.804306] cx18-0: Stream VBI Format: Private packet, IVTV
> format (grabbed)
>    [  289.804310] cx18-0: Audio Sampling Frequency: 32 kHz (grabbed)
>    [  289.804313] cx18-0: Audio Encoding: MPEG-1/2 Layer II (grabbed)
>    [  289.804316] cx18-0: Audio Layer II Bitrate: 384 kbps (grabbed)
>    [  289.804319] cx18-0: Audio Stereo Mode: Stereo
>    [  289.804322] cx18-0: Audio Stereo Mode Extension: Bound 4 (inactive)
>    [  289.804325] cx18-0: Audio Emphasis: No Emphasis
>    [  289.804328] cx18-0: Audio CRC: No CRC
>    [  289.804330] cx18-0: Audio Mute: false
>    [  289.804332] cx18-0: Video Encoding: MPEG-2
>    [  289.804335] cx18-0: Video Aspect: 4x3
>    [  289.804337] cx18-0: Video B Frames: 2
>    [  289.804340] cx18-0: Video GOP Size: 15
>    [  289.804342] cx18-0: Video GOP Closure: true
>    [  289.804345] cx18-0: Video Bitrate Mode: Variable Bitrate (grabbed)
>    [  289.804348] cx18-0: Video Bitrate: 4500000 (grabbed)
>    [  289.804351] cx18-0: Video Peak Bitrate: 6000000 (grabbed)
>    [  289.804354] cx18-0: Video Temporal Decimation: 0
>    [  289.804356] cx18-0: Video Mute: false
>    [  289.804359] cx18-0: Video Mute YUV: 32896
>    [  289.804362] cx18-0: Spatial Filter Mode: Manual
>    [  289.804364] cx18-0: Spatial Filter: 0
>    [  289.804367] cx18-0: Spatial Luma Filter Type: 1D Horizontal
>    [  289.804370] cx18-0: Spatial Chroma Filter Type: 1D Horizontal
>    [  289.804373] cx18-0: Temporal Filter Mode: Manual
>    [  289.804375] cx18-0: Temporal Filter: 8
>    [  289.804378] cx18-0: Median Filter Type: Off
>    [  289.804380] cx18-0: Median Luma Filter Minimum: 0 (inactive)
>    [  289.804383] cx18-0: Median Luma Filter Maximum: 255 (inactive)
>    [  289.804386] cx18-0: Median Chroma Filter Minimum: 0 (inactive)
>    [  289.804389] cx18-0: Median Chroma Filter Maximum: 255 (inactive)
>    [  289.804392] cx18-0: Insert Navigation Packets: false
>    [  289.804395] cx18-0: Status flags: 0x00200001
>    [  289.804398] cx18-0: Stream encoder MPEG: status 0x0118, 1% of
> 2048 KiB (64 buffers) in use
>    [  289.804401] cx18-0: Stream encoder YUV: status 0x0000, 0% of
> 2025 KiB (20 buffers) in use
>    [  289.804404] cx18-0: Stream encoder VBI: status 0x0038, 10% of
> 1015 KiB (20 buffers) in use
>    [  289.804407] cx18-0: Stream encoder PCM audio: status 0x0000, 0%
> of 1024 KiB (256 buffers) in use
>    [  289.804409] cx18-0: Read MPEG/VBI: 165570560/328504 bytes
>    [  289.804411] cx18-0: ==================  END STATUS CARD #0
> ==================
> 
> 
> >
> > 3. Please provide the relevant portion of the mythbackend log where
> > where the digital scanner starts and then fails.
> 
> So the Digital scanner doesn't fail per se, it just doesn't pick up
> most of the digital channels available.  The same is true of scan, it
> seems to find only 1 channel when I know that I have access to 18.

Make sure it's not a signal integrity problem:

	http://ivtvdriver.org/index.php/Howto:Improve_signal_quality

wild speculation: If the analog tuner driver init failed, maybe that is
having some bad EMI efect on the digital tuner

I'm assumiong you got more than the 1 channel before trying to enable
analog tuning.

> >
> > 4. Does digital tuning still work in MythTV despite the digital scanner
> > not working?
> 
> Using the command line tools you linked I am able to tune to the
> channel that is found and watch it via mplayer.

Can you tune to other known digital channels?

> Let me know if you need anything else.

Are you tuning digital cable (North American QAM) or digital Over The
Air (ATSC)?

I tune ATSC with a high gain antenna and a Winegard preamplifer for
fringe areas; I'm 75 miles away from the city.  One of the most
important contributions to getting a good signal was a lightning
protection/grounding block for the coaxial cable shield near the antenna
end of the cable.  I suspect I was picking up a lot of EMI from in-home
sources and other local sources.

If using a preamp, make sure you are not over-amplifying the signal.  It
will cause clipping in the tuner's front end, inducing intermodulation
products which look like noise and degrade the SNR.

Regards,
Andy



