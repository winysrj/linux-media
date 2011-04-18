Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34486 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756041Ab1DRRAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 13:00:37 -0400
References: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com> <1301922737.5317.7.camel@morgan.silverblock.net> <BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com> <BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com> <1302015521.4529.17.camel@morgan.silverblock.net> <BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com> <1302481535.2282.61.camel@localhost> <20110411163239.GA4324@mgebm.net> <20110418141514.GA4611@mgebm.net>
In-Reply-To: <20110418141514.GA4611@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 18 Apr 2011 13:00:29 -0400
To: Eric B Munson <emunson@mgebm.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, mchehab@infradead.org,
	linux-media@vger.kernel.org
Message-ID: <ac791492-7bc5-4a78-92af-503dda599346@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Eric B Munson <emunson@mgebm.net> wrote:

>On Mon, 11 Apr 2011, Eric B Munson wrote:
>
>> On Sun, 10 Apr 2011, Andy Walls wrote:
>> 
>> > On Wed, 2011-04-06 at 13:28 -0400, Eric B Munson wrote:
>> > > On Tue, Apr 5, 2011 at 10:58 AM, Andy Walls
><awalls@md.metrocast.net> wrote:
>> > > > On Mon, 2011-04-04 at 14:36 -0400, Eric B Munson wrote:
>> > > >> On Mon, Apr 4, 2011 at 11:16 AM, Eric B Munson
><emunson@mgebm.net> wrote:
>> > > >> > On Mon, Apr 4, 2011 at 9:12 AM, Andy Walls
><awalls@md.metrocast.net> wrote:
>> > > >> >> On Mon, 2011-04-04 at 08:20 -0400, Eric B Munson wrote:
>> > > >> >>> I the above mentioned capture card and the digital side of
>the card
>> > > >> >>> works well.  However, when I try to get video from the
>analog side of
>> > > >> >>> the card, all I get is a red screen and no sound
>regardless of channel
>> > > >> >>> requested.  This is a problem I see in 2.6.39-rc1 though I
>typically
>> > > >> >>> run the ubuntu 10.10 kernel with the newest drivers built
>from source.
>> > > >> >>>  Is there something in setup or configuration that I may
>be missing?
>> > > >> >>
>> > > >> >> Eric,
>> > > >> >>
>> > > >> >> You are likely missing the last 3 fixes here:
>> > > >> >>
>> > > >> >>
>http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/cx18_39
>> > > >> >>
>> > > >> >> (one of which is critical for analog to work).
>> > > >> >>
>> > > >> >> Also check the ivtv-users and ivtv-devel list for past
>discussions on
>> > > >> >> the "red screen" showing up for known well supported models
>and what to
>> > > >> >> try.
>> > > >> >>
>> > > >> > Thanks, I will try hand applying these.
>> > > >> >
>> > > >>
>> > > >> I don't have a red screen anymore, now all get from analog
>static and
>> > > >> mythtv's digital channel scanner now seems broken.
>> > > >
>> > > > Hmmm.
>> > > >
>> > > > 1. Please provide the output of dmesg when the cx18 driver
>loads.
>> > > 
>> 
>> [332935.115343] cx18:  Start initialization, version 1.4.1
>> [332935.115385] cx18-0: Initializing card 0
>> [332935.115389] cx18-0: Autodetected Hauppauge card
>> [332935.115449] cx18 0000:04:01.0: PCI INT A -> GSI 16 (level, low)
>-> IRQ 16
>> [332935.127005] cx18-0: cx23418 revision 01010000 (B)
>> [332935.342426] tveeprom 0-0050: Hauppauge model 74351, rev F1F5,
>serial# 7384278
>> [332935.342432] tveeprom 0-0050: MAC address is 00:0d:fe:70:ac:d6
>> [332935.342437] tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155,
>type 54)
>> [332935.342443] tveeprom 0-0050: TV standards PAL(B/G) NTSC(M) PAL(I)
>SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
>> [332935.342448] tveeprom 0-0050: audio processor is CX23418 (idx 38)
>> [332935.342453] tveeprom 0-0050: decoder processor is CX23418 (idx
>31)
>> [332935.342457] tveeprom 0-0050: has no radio
>> [332935.342460] cx18-0: Autodetected Hauppauge HVR-1600
>> [332935.392016] cx18-0: Simultaneous Digital and Analog TV capture
>supported
>> [332935.497007] tuner 1-0042: Tuner -1 found with type(s) Radio TV.
>> [332935.501259] cs5345 0-004c: chip found @ 0x98 (cx18 i2c driver
>#0-0)
>> [332935.548567] tda829x 1-0042: setting tuner address to 60
>> [332935.572554] tda18271 1-0060: creating new instance
>> [332935.612568] TDA18271HD/C2 detected @ 1-0060
>> [332936.676587] tda18271: performing RF tracking filter calibration
>> [332950.816567] tda18271: RF tracking filter calibration complete
>> [332950.864571] tda829x 1-0042: type set to tda8295+18271
>> [332951.569137] cx18-0: Registered device video0 for encoder MPEG (64
>x 32.00 kB)
>> [332951.569143] DVB: registering new adapter (cx18)
>> [332951.672187] tda18271 0-0060: creating new instance
>> [332951.678691] TDA18271HD/C2 detected @ 0-0060
>> [332951.737797] cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332
>bytes)
>> [332951.876157] cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000
>(141200 bytes)
>> [332951.882195] cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
>> [332951.984040] DVB: registering adapter 0 frontend 0 (Samsung
>S5H1411 QAM/8VSB Frontend)...
>> [332951.984208] cx18-0: DVB Frontend registered
>> [332951.984214] cx18-0: Registered DVB adapter0 for TS (32 x 32.00
>kB)
>> [332951.984268] cx18-0: Registered device video32 for encoder YUV (20
>x 101.25 kB)
>> [332951.984320] cx18-0: Registered device vbi0 for encoder VBI (20 x
>51984 bytes)
>> [332951.984367] cx18-0: Registered device video24 for encoder PCM
>audio (256 x 4.00 kB)
>> [332951.984372] cx18-0: Initialized card: Hauppauge HVR-1600
>> [332951.984415] cx18:  End initialization
>> [332951.994916] cx18-alsa: module loading...
>> [332952.733994] cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382
>bytes)
>> [332952.753703] cx18-0 843: verified load of v4l-cx23418-dig.fw
>firmware (16382 bytes)
>> 
>> > > > 3. Please provide the relevant portion of the mythbackend log
>where
>> > > > where the digital scanner starts and then fails.
>> > > 
>> > > So the Digital scanner doesn't fail per se, it just doesn't pick
>up
>> > > most of the digital channels available.  The same is true of
>scan, it
>> > > seems to find only 1 channel when I know that I have access to
>18.
>> > 
>> > Make sure it's not a signal integrity problem:
>> > 
>> > 	http://ivtvdriver.org/index.php/Howto:Improve_signal_quality
>> > 
>> > wild speculation: If the analog tuner driver init failed, maybe
>that is
>> > having some bad EMI efect on the digital tuner
>> > 
>> > I'm assumiong you got more than the 1 channel before trying to
>enable
>> > analog tuning.A
>> 
>> That is true, when I was running the backported drivers on the Ubuntu
>10.10
>> kernel I was able to see 16 of the 18 available to me.
>> 
>> > 
>> > > >
>> > > > 4. Does digital tuning still work in MythTV despite the digital
>scanner
>> > > > not working?
>> > > 
>> > > Using the command line tools you linked I am able to tune to the
>> > > channel that is found and watch it via mplayer.
>> > 
>> > Can you tune to other known digital channels?
>> 
>> I will have to see if I can set one up by hand and try it.  I will
>get back to
>> you when I am able to do this (should be later today).
>> 
>> > 
>> > > Let me know if you need anything else.
>> > 
>> > Are you tuning digital cable (North American QAM) or digital Over
>The
>> > Air (ATSC)?
>> 
>> I am using digital cable (NA QAM).
>> 
>
>Is there anything else I can provide to help with this?

Eric,

Sorry for not getting back sooner (I've been dealing with a personal situation and haven't logged into my dev system for a few weeks).

What rf analog source are you using?
Have you used v4l2-ctl to ensure the tuner is set to the right tv standard (my changes default to NTSC-M)?
Have you used v4l2-ctl or ivtv-tune to tune to the proper tv channel (the driver defaults to US channel 4)?
Does v4l2-ctl --log-status still show no signal present for the '843 core in the CX23418?
Does mplayer /dev/videoN -cache 8192 have a tv station when set to the rf analog input with v4l2-ctl?

>From what I recall the analog tuner init looked ok.
-Andy

