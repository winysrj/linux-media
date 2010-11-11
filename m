Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53437 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab0KKTBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 14:01:31 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so1018933wyb.19
        for <linux-media@vger.kernel.org>; Thu, 11 Nov 2010 11:01:30 -0800 (PST)
From: Albin Kauffmann <albin.kauffmann@gmail.com>
To: Sasha Sirotkin <demiurg@femtolinux.com>
Subject: Re: Wintv-HVR-1120 woes
Date: Thu, 11 Nov 2010 20:01:23 +0100
Cc: linux-media@vger.kernel.org, fabio tirapelle <ftirapelle@yahoo.it>
References: <AANLkTint2Xw3bJuGh2voUpncWderrbUgbeOaPdp1-yNm@mail.gmail.com> <201010242055.30799.albin.kauffmann@gmail.com> <AANLkTinwb_7ErteoWcO2VC1nu9uNqUwu6N+HEhrDwwg-@mail.gmail.com>
In-Reply-To: <AANLkTinwb_7ErteoWcO2VC1nu9uNqUwu6N+HEhrDwwg-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011112001.24046.albin.kauffmann@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday 24 October 2010 22:22:18 Sasha Sirotkin wrote:
> On Sun, Oct 24, 2010 at 8:55 PM, Albin Kauffmann
> 
> <albin.kauffmann@gmail.com> wrote:
> > On Thursday 21 October 2010 23:25:29 Sasha Sirotkin wrote:
> >> I'm having all sorts of troubles with Wintv-HVR-1120 on Ubuntu 10.10
> >> (kernel 2.6.35-22). Judging from what I've seen on the net, including
> >> this mailing list, I'm not the only one not being able to use this
> >> card and no solution seem to exist.
> >> 
> >> Problems:
> >> 1. The driver yells various cryptic error messages
> >> ("tda18271_write_regs: [1-0060|M] ERROR: idx = 0x5, len = 1,
> >> i2c_transfer returned: -5", "tda18271_set_analog_params: [1-0060|M]
> >> error -5 on line 1045", etc)
> > 
> > yes, indeed :(
> > (cf "Hauppauge WinTV-HVR-1120 on Unbuntu 10.04" thread)
> > 
> >> 2. DVB-T scan (using w_scan) produces no results
> > 
> > Is this happening after each reboot? As far as I'm concerned, I've never
> > had problems with DVB-T scans.
> 
> Almost always. I think I had a lucky reboot or two, but most of the
> time DVB-T scan produces nothing.

Strange. I use kaffeine and it works really well (except when getting errors 
mentionned in 1.). I also tried to use w_scan as you talked about it, and it 
works (output available at the end of this email).
So, I'm trying to understand your problems :
 - Do you get errors? (in dmesg for example?)
 - Does it work under Windows? / Are you sure your antenna is good?

> >> 3. Analog seems to work, but with very poor quality
> > 
> > I just tried to use Analog TV in order to confirm the problem but I
> > cannot get any picture. Maybe I just don't know how to use it. I'm using
> > commands like (I'm located in France):
> > 
> > mplayer tv:// -tv driver=v4l2:norm=SECAM:chanlist=france -tvscan
> > autostart
> > 
> > ... and just get some "snow" on scanned channels.
> > As I might have a problem with my antenna (an interior one), I am going
> > to test it under Windows and report back my experience.
> 
> I'm using tvtime-scanner

I set up a Windows so I'm sure my Analog TV is working.
After having set "SECAM" and "france" in /etc/tvtime/tvtime.xml, I have run 
tvtime-scanner and it seems to be successful:

sh> tvtime-scanner
Reading configuration from /etc/tvtime/tvtime.xml
Scanning using TV standard SECAM.
Scanning from  44.00 MHz to 958.00 MHz.
Found a channel at  45.00 MHz (44.75 - 45.00 MHz), adding to channel list.
I/O warning : failed to load external entity 
"/data/./home/albinkauf/.tvtime/stationlist.xml"
station: No station file found, creating a new one.
Found a channel at 101.50 MHz (101.25 - 101.50 MHz), adding to channel list.
Found a channel at 117.50 MHz (117.25 - 117.50 MHz), adding to channel list.
Found a channel at 145.00 MHz (144.75 - 145.00 MHz), adding to channel list.
Found a channel at 302.75 MHz (302.50 - 302.75 MHz), adding to channel list.
Found a channel at 389.00 MHz (388.75 - 389.00 MHz), adding to channel list.
Found a channel at 480.25 MHz (479.25 - 481.00 MHz), adding to channel list.
Found a channel at 503.50 MHz (503.25 - 503.75 MHz), adding to channel list.
Found a channel at 505.00 MHz (504.75 - 505.00 MHz), adding to channel list.
Found a channel at 528.50 MHz (528.25 - 528.50 MHz), adding to channel list.
Found a channel at 544.75 MHz (544.50 - 544.75 MHz), adding to channel list.
Found a channel at 588.75 MHz (588.50 - 588.75 MHz), adding to channel list.
Found a channel at 639.75 MHz (639.50 - 639.75 MHz), adding to channel list.
Found a channel at 646.00 MHz (645.75 - 646.00 MHz), adding to channel list.
Found a channel at 664.75 MHz (664.50 - 664.75 MHz), adding to channel list.
Found a channel at 675.50 MHz (675.25 - 675.50 MHz), adding to channel list.
Found a channel at 702.00 MHz (701.75 - 702.00 MHz), adding to channel list.
Found a channel at 711.00 MHz (710.75 - 711.00 MHz), adding to channel list.
Found a channel at 749.25 MHz (749.00 - 749.25 MHz), adding to channel list.
Found a channel at 778.00 MHz (777.75 - 778.00 MHz), adding to channel list.
Found a channel at 924.00 MHz (923.75 - 924.00 MHz), adding to channel list.
Found a channel at 932.75 MHz (932.50 - 932.75 MHz), adding to channel list.
tvtime-scanner  0.10s user 139.36s system 2% cpu 1:44:44.25 total

However, I've seen a lot of errors related to tda18271 in `dmesg` and I can't 
get any picture when running tvime. Do you also get that kind of errors?


In order to solve the 1st problem (TV sometimes not working), I also try to 
boot under Windows in order to load the the original tda10048 firmware. Then, I 
started my Linux box several times (without the firmware available in 
/lib/firmware). After 4 boots, it fails so the firmware is probably not the 
sources of our problems.
Then, I've started to read the sources and the documentation of the saa7134 
chip. This documentation is not bad but it misses particularities of the 
Hauppauge HVR1120 such as how the different chips are plugged together. Did 
Hauppauge make this kind of documentation public? Does anyone know where can I 
find it?

Thanks,



----- Output of w_scan -----

sh> w_scan -c FR
w_scan version 20100529 (compiled for DVB API 5.1)
using settings for FRANCE
DVB aerial
DVB-T FR
frontend_type DVB-T, channellist 5
output format vdr-1.6
Info: using DVB adapter auto detection.
        /dev/dvb/adapter0/frontend0 -> DVB-T "NXP TDA10048HN DVB-T": good :-)
Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_ 
Using DVB API 5.1
frontend NXP TDA10048HN DVB-T supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_ 
Scanning 7MHz frequencies...
177500: (time: 00:01) 
184500: (time: 00:04) 
191500: (time: 00:07) 
198500: (time: 00:11) 
205500: (time: 00:14) 
212500: (time: 00:17) 
219500: (time: 00:20) 
226500: (time: 00:24) 
Scanning 8MHz frequencies...
474000: (time: 00:27) 
474167: (time: 00:30) (time: 00:33) signal ok:
        QAM_AUTO f = 474167 kHz I999B8C999D999T999G999Y999
undefined coderate HP
        new transponder:
           (QAM_64   f = 4294967 kHz I999B8C999D0T8G32Y0)
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
473833: skipped (already known transponder)
482000: (time: 00:49) 
482167: (time: 00:52) 
481833: (time: 00:55) 
490000: (time: 00:59) 
490167: (time: 01:02) (time: 01:05) signal ok:
        QAM_AUTO f = 490167 kHz I999B8C999D999T999G999Y999
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
489833: skipped (already known transponder)
498000: (time: 01:21) 
498167: (time: 01:24) (time: 01:26) signal ok:
        QAM_AUTO f = 498167 kHz I999B8C999D999T999G999Y999
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
497833: skipped (already known transponder)
506000: (time: 01:43) 
506167: (time: 01:46) 
505833: (time: 01:49) 
514000: (time: 01:53) 
514167: (time: 01:56) 
513833: (time: 01:59) 
522000: (time: 02:03) 
522167: (time: 02:06) (time: 02:08) signal ok:
        QAM_AUTO f = 522167 kHz I999B8C999D999T999G999Y999
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
521833: skipped (already known transponder)
530000: (time: 02:25) 
530167: (time: 02:29) 
529833: (time: 02:32) 
538000: (time: 02:35) 
538167: (time: 02:38) (time: 02:41) signal ok:
        QAM_AUTO f = 538167 kHz I999B8C999D999T999G999Y999
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
537833: skipped (already known transponder)
546000: (time: 02:57) 
546167: (time: 03:00) 
545833: (time: 03:03) 
554000: (time: 03:07) 
554167: (time: 03:10) 
553833: (time: 03:13) 
562000: (time: 03:17) 
562167: (time: 03:20) (time: 03:22) signal ok:
        QAM_AUTO f = 562167 kHz I999B8C999D999T999G999Y999
undefined coderate HP
        new transponder:
           (QAM_64   f = 4294967 kHz I999B8C999D0T8G8Y0)
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
561833: skipped (already known transponder)
570000: (time: 03:39) 
570167: (time: 03:43) 
569833: (time: 03:46) 
578000: (time: 03:49) 
578167: (time: 03:53) 
577833: (time: 03:56) 
586000: (time: 03:59) 
586167: (time: 04:02) (time: 04:05) signal ok:
        QAM_AUTO f = 586167 kHz I999B8C999D999T999G999Y999
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
585833: skipped (already known transponder)
594000: (time: 04:21) 
594167: (time: 04:24) 
593833: (time: 04:27) 
602000: (time: 04:30) 
602167: (time: 04:34) 
601833: (time: 04:37) 
610000: (time: 04:40) 
610167: (time: 04:44) 
609833: (time: 04:47) 
618000: (time: 04:50) 
618167: (time: 04:53) 
617833: (time: 04:57) 
626000: (time: 05:00) 
626167: (time: 05:03) 
625833: (time: 05:07) 
634000: (time: 05:10) 
634167: (time: 05:13) 
633833: (time: 05:16) 
642000: (time: 05:20) 
642167: (time: 05:23) 
641833: (time: 05:26) 
650000: (time: 05:30) 
650167: (time: 05:33) 
649833: (time: 05:36) 
658000: (time: 05:39) 
658167: (time: 05:43) 
657833: (time: 05:46) 
666000: (time: 05:49) 
666167: (time: 05:53) 
665833: (time: 05:56) 
674000: (time: 05:59) 
674167: (time: 06:02) 
673833: (time: 06:06) 
682000: (time: 06:09) 
682167: (time: 06:12) 
681833: (time: 06:15) 
690000: (time: 06:19) 
690167: (time: 06:22) 
689833: (time: 06:25) 
698000: (time: 06:29) 
698167: (time: 06:32) 
697833: (time: 06:35) 
706000: (time: 06:38) 
706167: (time: 06:42) 
705833: (time: 06:45) 
714000: (time: 06:48) 
714167: (time: 06:52) 
713833: (time: 06:55) 
722000: (time: 06:58) 
722167: (time: 07:01) 
721833: (time: 07:05) 
730000: (time: 07:08) 
730167: (time: 07:11) 
729833: (time: 07:15) 
738000: (time: 07:18) 
738167: (time: 07:21) 
737833: (time: 07:24) 
746000: (time: 07:28) 
746167: (time: 07:31) 
745833: (time: 07:34) 
754000: (time: 07:38) 
754167: (time: 07:41) 
753833: (time: 07:44) 
762000: (time: 07:47) 
762167: (time: 07:51) 
761833: (time: 07:54) 
770000: (time: 07:57) 
770167: (time: 08:01) 
769833: (time: 08:04) 
778000: (time: 08:07) 
778167: (time: 08:10) 
777833: (time: 08:14) 
786000: (time: 08:17) 
786167: (time: 08:20) 
785833: (time: 08:23) 
794000: (time: 08:27) 
794167: (time: 08:30) 
793833: (time: 08:33) 
802000: (time: 08:37) 
802167: (time: 08:40) 
801833: (time: 08:43) 
810000: (time: 08:46) 
810167: (time: 08:50) 
809833: (time: 08:53) 
818000: (time: 08:56) 
818167: (time: 09:00) 
817833: (time: 09:03) 
826000: (time: 09:06) 
826167: (time: 09:09) 
825833: (time: 09:13) 
834000: (time: 09:16) 
834167: (time: 09:19) 
833833: (time: 09:23) 
842000: (time: 09:26) 
842167: (time: 09:29) 
841833: (time: 09:32) 
850000: (time: 09:36) 
850167: (time: 09:39) 
849833: (time: 09:42) 
858000: (time: 09:46) 
858167: (time: 09:49) set_frontend:1710: ERROR: Setting frontend parameters 
failed (API v5.x)
: 22 Invalid argument

initial_tune:2099: Setting frontend failed QAM_AUTO f = 858167 kHz 
I999B8C999D999T999G999Y999
857833: (time: 09:49) 
tune to: QAM_AUTO f = 474167 kHz I999B8C999D999T999G999Y999 
(time: 09:52) undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
        service = Direct 8 (NTN)
        service = BFM TV (NTN)
        service = i>TELE (NTN)
        service = DirectStar (NTN)
        service = Gulli (NTN)
        service = France 4 (NTN)
tune to: QAM_64   f = 4294967 kHz I999B8C999D0T8G32Y0 
(time: 10:07) set_frontend:1710: ERROR: Setting frontend parameters failed 
(API v5.x)
: 22 Invalid argument
tune to: QAM_64   f = 4294967 kHz I999B8C999D0T8G32Y0 
(time: 10:07) set_frontend:1710: ERROR: Setting frontend parameters failed 
(API v5.x)
: 22 Invalid argument
tune to: QAM_AUTO f = 490167 kHz I999B8C999D999T999G999Y999 
(time: 10:07) undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
        service = Canal 21 (Multi-7)
        service = IDF1 (Multi-7)
        service = NRJ Paris (Multi-7)
        service = CAP 24 (Multi-7)
tune to: QAM_AUTO f = 498167 kHz I999B8C999D999T999G999Y999 
(time: 10:22)   service = ARTE HD (Multi 4)
        service = PARIS PREMIERE (MULTI4)
        service = M6 (MULTI4)
        service = W9 (MULTI4)
        service = NT1 (MULTI4)
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
tune to: QAM_AUTO f = 522167 kHz I999B8C999D999T999G999Y999 
(time: 10:37)   service = CANAL+ (CNH)
        service = CANAL+ CINEMA (CNH)
        service = CANAL+ SPORT (CNH)
        service = PLANETE (CNH)
        service = TPS STAR (CNH)
        service = (null) (CNH)
        service = (null) (CNH)
        service = (null) (CNH)
        service = (null) (CNH)
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
tune to: QAM_AUTO f = 538167 kHz I999B8C999D999T999G999Y999 
(time: 10:52) undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
        service = TF1 HD (MR5)
        service = France 2 HD (MR5)
        service = M6HD (MR5)
tune to: QAM_AUTO f = 562167 kHz I999B8C999D999T999G999Y999 
(time: 11:07)   service = TF1 (SMR6)
        service = NRJ12 (SMR6)
        service = Eurosport  (SMR6)
        service = LCI (SMR6)
        service = TMC (SMR6)
        service = TF6 (SMR6)
        service = ARTE (SMR6)
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
tune to: QAM_64   f = 4294967 kHz I999B8C999D0T8G8Y0 
(time: 11:22) set_frontend:1710: ERROR: Setting frontend parameters failed 
(API v5.x)
: 22 Invalid argument
tune to: QAM_64   f = 4294967 kHz I999B8C999D0T8G8Y0 
(time: 11:22) set_frontend:1710: ERROR: Setting frontend parameters failed 
(API v5.x)
: 22 Invalid argument
tune to: QAM_AUTO f = 586167 kHz I999B8C999D999T999G999Y999 
(time: 11:22) undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
        service = France 3 (GR1)
        service = France 2 (GR1)
        service = France 5 (GR1)
        service = LCP (GR1)
        service = France � (GR1)
dumping lists (43 services)
Direct 
8;NTN:474167:I999B8C999D999M999T999G999Y999:T:27500:120:130=fra:145:0:513:0:0:0
BFM 
TV;NTN:474167:I999B8C999D999M999T999G999Y999:T:27500:320:330=fra:345:0:515:0:0:0
i>TELE;NTN:474167:I999B8C999D999M999T999G999Y999:T:27500:420:430=fra:445:0:516:0:0:0
DirectStar;NTN:474167:I999B8C999D999M999T999G999Y999:T:27500:520:530=fra:545:0:517:0:0:0
Gulli;NTN:474167:I999B8C999D999M999T999G999Y999:T:27500:620:630=fra:645:0:518:0:0:0
France 
4;NTN:474167:I999B8C999D999M999T999G999Y999:T:27500:720:730=fra:745:0:519:0:0:0
Canal 
21;Multi-7:490167:I999B8C999D999M999T999G999Y999:T:27500:3521:3641=fra:0:0:2050:0:0:0
IDF1;Multi-7:490167:I999B8C999D999M999T999G999Y999:T:27500:3522:3642=fra:0:0:2051:0:0:0
NRJ 
Paris;Multi-7:490167:I999B8C999D999M999T999G999Y999:T:27500:3523:3643=fra:768:0:2052:0:0:0
CAP 
24;Multi-7:490167:I999B8C999D999M999T999G999Y999:T:27500:3524:3644=fra:0:0:2053:0:0:0
M6;MULTI4:498167:I999B8C999D999M999T999G999Y999:T:27500:120:130=fra,131=eng:0:0:1025:0:0:0
W9;MULTI4:498167:I999B8C999D999M999T999G999Y999:T:27500:220:230=fra,231=eng:0:0:1026:0:0:0
NT1;MULTI4:498167:I999B8C999D999M999T999G999Y999:T:27500:320:330=fra:340:0:1027:0:0:0
PARIS 
PREMIERE;MULTI4:498167:I999B8C999D999M999T999G999Y999:T:27500:420:430=fra,431=eng:0:181f,4adc,500,100,102,103:1028:0:0:0
ARTE HD;Multi 
4:498167:I999B8C999D999M999T999G999Y999:T:27500:720:730=fra,731=deu:0:0:1031:0:0:0
CANAL+;CNH:522167:I999B8C999D999M999T999G999Y999:T:27500:160:0;83:0:500,4adc,181f:769:0:0:0
CANAL+ 
CINEMA;CNH:522167:I999B8C999D999M999T999G999Y999:T:27500:161:0;85:0:500,4adc,181f:770:0:0:0
CANAL+ 
SPORT;CNH:522167:I999B8C999D999M999T999G999Y999:T:27500:162:0;89:0:500,4adc,181f:771:0:0:0
PLANETE;CNH:522167:I999B8C999D999M999T999G999Y999:T:27500:163:92=fra:0:4adc,500,181f,100,102,103:772:0:0:0
TPS 
STAR;CNH:522167:I999B8C999D999M999T999G999Y999:T:27500:165:100=fra,101=eng:0:500,4adc,181f,100,103:774:0:0:0
TF1 
HD;MR5:538167:I999B8C999D999M999T999G999Y999:T:27500:120:0;131:0:0:1281:0:0:0
France 2 
HD;MR5:538167:I999B8C999D999M999T999G999Y999:T:27500:220:0;230:0:0:1282:0:0:0
M6HD;MR5:538167:I999B8C999D999M999T999G999Y999:T:27500:320:0;331:0:0:1283:0:0:0
TF1;SMR6:562167:I999B8C999D999M999T999G999Y999:T:27500:120:130=fra,131=eng,133=deu:140:0:1537:0:0:0
NRJ12;SMR6:562167:I999B8C999D999M999T999G999Y999:T:27500:220:230=fra,232=eng:240:0:1538:0:0:0
LCI;SMR6:562167:I999B8C999D999M999T999G999Y999:T:27500:320:330=fra:0:181f,500,4adc,100,102,103:1539:0:0:0
Eurosport 
;SMR6:562167:I999B8C999D999M999T999G999Y999:T:27500:420:430=fra:0:181f,500,4adc,100,102,103:1540:0:0:0
TF6;SMR6:562167:I999B8C999D999M999T999G999Y999:T:27500:520:530=fra:0:181f,500,4adc,100,102,103:1541:0:0:0
TMC;SMR6:562167:I999B8C999D999M999T999G999Y999:T:27500:620:630=fra,631=eng:0:0:1542:0:0:0
ARTE;SMR6:562167:I999B8C999D999M999T999G999Y999:T:27500:720:730=fra,731=deu:0:0:1543:0:0:0
France 
2;GR1:586167:I999B8C999D999M999T999G999Y999:T:27500:120:130=fra:0:0:257:0:0:0
France 
5;GR1:586167:I999B8C999D999M999T999G999Y999:T:27500:320:330=fra:0:0:260:0:0:0
France 
�;GR1:586167:I999B8C999D999M999T999G999Y999:T:27500:520:530=fra:0:0:261:0:0:0
LCP;GR1:586167:I999B8C999D999M999T999G999Y999:T:27500:620:630=fra:0:0:262:0:0:0
France 
3;GR1:586167:I999B8C999D999M999T999G999Y999:T:27500:220:230=fra:0:0:273:0:0:0
Done.

----- END OF w_scan -----


-- 
Albin Kauffmann
Open Wide - Architecte Open Source
