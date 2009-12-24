Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:38237 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbZLXW32 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2009 17:29:28 -0500
Received: from mail01.m-online.net (mail.m-online.net [192.168.3.149])
	by mail-out.m-online.net (Postfix) with ESMTP id 47DB61C15B31
	for <linux-media@vger.kernel.org>; Thu, 24 Dec 2009 23:29:27 +0100 (CET)
Received: from localhost (dynscan2.mnet-online.de [192.168.1.215])
	by mail.m-online.net (Postfix) with ESMTP id 44AA89026B
	for <linux-media@vger.kernel.org>; Thu, 24 Dec 2009 23:29:27 +0100 (CET)
Received: from mail.mnet-online.de ([192.168.3.149])
	by localhost (dynscan2.mnet-online.de [192.168.1.215]) (amavisd-new, port 10024)
	with ESMTP id Gm9h+plAI+dI for <linux-media@vger.kernel.org>;
	Thu, 24 Dec 2009 23:29:26 +0100 (CET)
Received: from [192.168.1.5] (ppp-88-217-19-215.dynamic.mnet-online.de [88.217.19.215])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.mnet-online.de (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Thu, 24 Dec 2009 23:29:26 +0100 (CET)
Message-ID: <4B33EB44.1020206@a-city.de>
Date: Thu, 24 Dec 2009 23:29:24 +0100
From: TAXI <taxi@a-city.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Bad image quality with Medion MD 95700
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I tried a Medion MD 95700 with kernel 2.6.32 (for tests: 2.6.30.9) and
have a very bad image and sound quality.
Right now I'm using 2.6.32 with V4L/DVB from SVN (v4l-dvb-4506e2d54126)

Here is an example: http://img200.imageshack.us/img200/3950/dvbtlinux.png
and another: http://img130.imageshack.us/img130/6278/dvbt2.png

The DVB-T stream seems to be good:
femon
FE: Conexant CX22702 DVB-T (DVBT)
status SCVYL | signal 6565 | snr ffff | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status SCVYL | signal 6565 | snr ffff | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status SCVYL | signal 6565 | snr ffff | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status SCVYL | signal 6565 | snr ffff | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status SCVYL | signal 6565 | snr ffff | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status SCVYL | signal 6565 | snr ffff | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status SCVYL | signal 6565 | snr ffff | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
(it's a bit bad right now, normally the signal is around 50%)

under windows XP the image and sound is perfect.

P.S. this is the output from mplayer after looking DVB-T for a few seconds:
mplayer "dvb://ProSieben(ProSiebenSat.1)"
MPlayer SVN-r29796-4.4.2 (C) 2000-2009 MPlayer Team

Spiele dvb://ProSieben(ProSiebenSat.1).
dvb_tune Freq: 690000000
TS-Dateiformat erkannt!
VIDEO MPEG2(pid=511) AUDIO MPA(pid=512) NO SUBS (yet)!  PROGRAM N. 0
VIDEO:  MPEG2  720x576  (aspect 3)  25.000 fps  15000.0 kbps (1875.0
kbyte/s)
==========================================================================
Öffne Videodecoder: [mpegpes] MPEG 1/2 Video passthrough
Konnte keinen passenden Farbraum finden - neuer Versuch mit '-vf scale'...
Öffne Videofilter: [scale]
Der ausgewählte Videoausgabetreiber ist nicht kompatibel mit diesem Codec.
Versuche den scale-Filter zu deiner Filterliste hinzuzufügen,
z.B. mit -vf spp,scale an Stelle von -vf spp.
Initialisierung des Videodecoders fehlgeschlagen  :(
Öffne Videodecoder: [ffmpeg] FFmpeg's libavcodec codec family
Unsupported PixelFormat -1
Ausgewählter Videocodec: [ffmpeg2] vfm: ffmpeg (FFmpeg MPEG-2)
==========================================================================
==========================================================================
Öffne Audiodecoder: [mp3lib] MPEG layer-2, layer-3
AUDIO: 48000 Hz, 2 ch, s16le, 192.0 kbit/12.50% (ratio: 24000->192000)
Ausgewählter Audiocodec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
==========================================================================
AO: [alsa] 48000Hz 2ch s16le (2 bytes per sample)
Starte Wiedergabe...
Film-Aspekt ist 1,78:1 - Vorskalierung zur Korrektur der Seitenverhältnisse.
VO: [xv] 720x576 => 1024x576 Planar YV12
[mpeg2video @ 0xc62be0]ac-tex damaged at 23 4
[mpeg2video @ 0xc62be0]ac-tex damaged at 14 9
[mpeg2video @ 0xc62be0]skipped MB in I frame at 40 10
[mpeg2video @ 0xc62be0]invalid mb type in I Frame at 29 15
[mpeg2video @ 0xc62be0]skipped MB in I frame at 32 19
[mpeg2video @ 0xc62be0]ac-tex damaged at 34 33
[mpeg2video @ 0xc62be0]Warning MVs not available
[mpeg2video @ 0xc62be0]concealing 319 DC, 319 AC, 319 MV errors
[mpeg2video @ 0xc62be0]concealing 319 DC, 319 AC, 319 MV errors?% 0 0
[mpeg2video @ 0xc62be0]concealing 319 DC, 319 AC, 319 MV errors% 0 0
[mpeg2video @ 0xc62be0]mb incr damaged,008   3/  3 ??% ??% ??,?% 0 0
[mpeg2video @ 0xc62be0]00 motion_type at 27 17
[mpeg2video @ 0xc62be0]Warning MVs not available
[mpeg2video @ 0xc62be0]concealing 98 DC, 98 AC, 98 MV errors
[mpeg2video @ 0xc62be0]00 motion_type at 34 54/  4 ??% ??% ??,?% 0 0
[mpeg2video @ 0xc62be0]Warning MVs not available
[mpeg2video @ 0xc62be0]concealing 90 DC, 90 AC, 90 MV errors
[mpeg2video @ 0xc62be0]00 motion_type at 35 95/  5 ??% ??% ??,?% 0 0
[mpeg2video @ 0xc62be0]concealing 90 DC, 90 AC, 90 MV errors
[mpeg2video @ 0xc62be0]ac-tex damaged at 36 86/  6 ??% ??% ??,?% 0 0
[mpeg2video @ 0xc62be0]invalid cbp at 25 13
[mpeg2video @ 0xc62be0]ac-tex damaged at 4 23
[mpeg2video @ 0xc62be0]concealing 157 DC, 157 AC, 157 MV errors
[mpeg2video @ 0xc62be0]00 motion_type at 8 8 7/  7 ??% ??% ??,?% 0 0
[mpeg2video @ 0xc62be0]concealing 90 DC, 90 AC, 90 MV errors
[mpeg2video @ 0xc62be0]concealing 50 DC, 50 AC, 50 MV errors?,?% 0 0
Bindung für Taste 'c' nicht gefunden.                         ?% 0 0
[mpeg2video @ 0xc62be0]invalid mb type in P Frame at 4 16
[mpeg2video @ 0xc62be0]concealing 45 DC, 45 AC, 45 MV errors
[mpeg2video @ 0xc62be0]invalid mb type in B Frame at 0 31% ??,?% 0 0
[mpeg2video @ 0xc62be0]concealing 225 DC, 225 AC, 225 MV errors
[mpeg2video @ 0xc62be0]mb incr damaged,040  11/ 11 ??% ??% ??,?% 0 0
[mpeg2video @ 0xc62be0]invalid cbp at 28 30
[mpeg2video @ 0xc62be0]concealing 203 DC, 203 AC, 203 MV errors
[mpeg2video @ 0xc62be0]ac-tex damaged at 24 72/ 12 ??% ??% ??,?% 0 0
[mpeg2video @ 0xc62be0]skipped MB in I frame at 6 12
[mpeg2video @ 0xc62be0]skipped MB in I frame at 1 19
[mpeg2video @ 0xc62be0]skipped MB in I frame at 23 25
[mpeg2video @ 0xc62be0]concealing 186 DC, 186 AC, 186 MV errors
[mpeg2video @ 0xc62be0]00 motion_type at 14 22/ 13 ??% ??% ??,?% 0 0
[mpeg2video @ 0xc62be0]concealing 45 DC, 45 AC, 45 MV errors
[mpeg2video @ 0xc62be0]concealing 258 DC, 258 AC, 258 MV errors% 0 0
[mpeg2video @ 0xc62be0]ac-tex damaged at 12 24/ 15 25%  4% 13,0% 0 0
[mpeg2video @ 0xc62be0]ac-tex damaged at 10 31
[mpeg2video @ 0xc62be0]concealing 270 DC, 270 AC, 270 MV errors
[mpeg2video @ 0xc62be0]00 motion_type at 40 13/ 16 25%  4% 12,2% 0 0
[mpeg2video @ 0xc62be0]00 motion_type at 43 17
[mpeg2video @ 0xc62be0]slice mismatch
[mpeg2video @ 0xc62be0]concealing 270 DC, 270 AC, 270 MV errors
[mpeg2video @ 0xc62be0]00 motion_type at 1 717/ 17 24%  3% 20,2% 0 0
[mpeg2video @ 0xc62be0]concealing 151 DC, 151 AC, 151 MV errors
[mpeg2video @ 0xc62be0]ac-tex damaged at 29 88/ 18 23%  3% 19,1% 0 0
[mpeg2video @ 0xc62be0]mb incr damaged
[mpeg2video @ 0xc62be0]concealing 135 DC, 135 AC, 135 MV errors
[mpeg2video @ 0xc62be0]00 motion_type at 23 17/ 19 23%  3% 18,0% 0 0
[mpeg2video @ 0xc62be0]concealing 136 DC, 136 AC, 136 MV errors
[mpeg2video @ 0xc62be0]ac-tex damaged at 21 23/ 20 23%  3% 17,1% 0 0
[mpeg2video @ 0xc62be0]concealing 119 DC, 119 AC, 119 MV errors
[mpeg2video @ 0xc62be0]ac-tex damaged at 22 01/ 21 22%  3% 25,5% 0 0
[mpeg2video @ 0xc62be0]ac-tex damaged at 42 9
[mpeg2video @ 0xc62be0]ac-tex damaged at 31 10
[mpeg2video @ 0xc62be0]invalid mb type in P Frame at 35 12
[mpeg2video @ 0xc62be0]00 motion_type at 18 17
[mpeg2video @ 0xc62be0]00 motion_type at 1 22
[mpeg2video @ 0xc62be0]ac-tex damaged at 29 23
[mpeg2video @ 0xc62be0]ac-tex damaged at 38 31
[mpeg2video @ 0xc62be0]concealing 450 DC, 450 AC, 450 MV errors
[mpeg2video @ 0xc62be0]00 motion_type at 22 12/ 22 22%  2% 24,3% 0 0
[mpeg2video @ 0xc62be0]00 motion_type at 12 14
[mpeg2video @ 0xc62be0]00 motion_type at 29 22
[mpeg2video @ 0xc62be0]concealing 180 DC, 180 AC, 180 MV errors
[mpeg2video @ 0xc62be0]00 motion_type at 16 73/ 23 22%  2% 23,3% 0 0
[mpeg2video @ 0xc62be0]ac-tex damaged at 10 14
[mpeg2video @ 0xc62be0]concealing 132 DC, 132 AC, 132 MV errors
[mpeg2video @ 0xc62be0]ac-tex damaged at 17 84/ 24 22%  2% 37,0% 0 0
[mpeg2video @ 0xc62be0]ac-tex damaged at 18 11
[mpeg2video @ 0xc62be0]ac-tex damaged at 16 13
[mpeg2video @ 0xc62be0]ac-tex damaged at 11 15
[mpeg2video @ 0xc62be0]invalid mb type in I Frame at 27 20
[mpeg2video @ 0xc62be0]skipped MB in I frame at 29 23
[mpeg2video @ 0xc62be0]invalid mb type in I Frame at 38 31
[mpeg2video @ 0xc62be0]concealing 421 DC, 421 AC, 421 MV errors
[mpeg2video @ 0xc62be0]concealing 90 DC, 90 AC, 90 MV errors4,4% 1 0
[mpeg2video @ 0xc62be0]00 motion_type at 29 13/ 26 21%  2% 70,7% 2 0
[mpeg2video @ 0xc62be0]00 motion_type at 6 21
[mpeg2video @ 0xc62be0]concealing 180 DC, 180 AC, 180 MV errors
[mpeg2video @ 0xc62be0]ac-tex damaged at 21 67/ 27 21%  2% 104,0% 3 0
[mpeg2video @ 0xc62be0]ac-tex damaged at 19 14
[mpeg2video @ 0xc62be0]ac-tex damaged at 1 25
[mpeg2video @ 0xc62be0]mb incr damaged
[mpeg2video @ 0xc62be0]concealing 251 DC, 251 AC, 251 MV errors
A:20536,2 V:20535,2 A-V:  0,997 ct: -0,101  28/ 28 21%  2% 135,0% 4 0
Beenden... (Ende)
