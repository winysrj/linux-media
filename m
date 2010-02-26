Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:54764 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966469Ab0BZXfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 18:35:03 -0500
Received: by fxm19 with SMTP id 19so653020fxm.21
        for <linux-media@vger.kernel.org>; Fri, 26 Feb 2010 15:35:01 -0800 (PST)
Message-ID: <4B885AA2.3040402@gmail.com>
Date: Sat, 27 Feb 2010 00:34:58 +0100
From: thomas schorpp <thomas.schorpp@googlemail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: [BUG] TDA10086 : Creatix CTX929_V.1 : TS continuity errors with
 good RF signal input
References: <4B87DD22.3000209@gmail.com>
In-Reply-To: <4B87DD22.3000209@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks like fixed by linux 2.6.33 just in time, BIG Thank You guys ;-)

Even at higher BER:

Current parameters:
    Frequency:  1945.320 MHz
    Inversion:  OFF
    Symbol rate:  22.000154 MSym/s
    FEC:  FEC 5/6

cycle: 1  d_time: 0.001 s  Sig: 18504  SNR: 39578  BER: 168  UBLK: 0  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 2  d_time: 0.073 s  Sig: 18247  SNR: 39578  BER: 225  UBLK: 0  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 3  d_time: 0.079 s  Sig: 18504  SNR: 37779  BER: 140  UBLK: 0  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 4  d_time: 0.072 s  Sig: 18504  SNR: 39835  BER: 198  UBLK: 0  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 5  d_time: 0.071 s  Sig: 18504  SNR: 39835  BER: 221  UBLK: 0  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 6  d_time: 0.072 s  Sig: 18247  SNR: 39578  BER: 249  UBLK: 0  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 7  d_time: 0.072 s  Sig: 18504  SNR: 39835  BER: 191  UBLK: 0  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 8  d_time: 0.072 s  Sig: 18504  SNR: 39578  BER: 185  UBLK: 0  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 9  d_time: 0.072 s  Sig: 18761  SNR: 39578  BER: 137  UBLK: 0  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]

I'll report if issue reoccurs and try to finetune crystal based tuner/demod parameters, then.

y
tom

thomas schorpp wrote:
> Hi,
> Issue is already confirmed here:
> http://www.vdr-portal.de/board/thread.php?threadid=93268
> 
> Linux 2.6.32.8, 80cm dish.
> 
> Do we have any Tuner/Decoder optimization points in the FE code?
> 
> This is not OK:
> 
> lspci -s 00:08.0 -v 00:08.0 Multimedia controller: Philips 
> Semiconductors SAA7134/SAA7135HL Video Broadcast Decoder (rev 01) 
> Subsystem: Creatix Polymedia GmbH Device 0005 Flags: bus master, medium 
> devsel, latency 32, IRQ 19 Memory at fbeff400 (32-bit, non-prefetchable) 
> [size=1K] Capabilities: [40] Power Management version 1 Kernel driver in 
> use: saa7134
> 
> grep cTS2PES /var/log/syslog
> Feb 26 13:46:59 tom1 vdr: [4082] cTS2PES got 7 TS errors, 113 TS 
> continuity errors
> Feb 26 13:46:59 tom1 vdr: [4082] cTS2PES got 0 TS errors, 29 TS 
> continuity errors
> Feb 26 13:47:52 tom1 vdr: [4082] cTS2PES got 17 TS errors, 5 TS 
> continuity errors
> Feb 26 14:03:03 tom1 vdr: [4082] cTS2PES got 2 TS errors, 136 TS 
> continuity errors
> Feb 26 14:03:03 tom1 vdr: [4082] cTS2PES got 0 TS errors, 32 TS 
> continuity errors
> Feb 26 14:41:42 tom1 vdr: [4082] cTS2PES got 1 TS errors, 853 TS 
> continuity errors
> Feb 26 14:41:42 tom1 vdr: [4082] cTS2PES got 0 TS errors, 194 TS 
> continuity errors
> Feb 26 14:52:58 tom1 vdr: [4082] cTS2PES got 2 TS errors, 196 TS 
> continuity errors
> Feb 26 14:52:58 tom1 vdr: [4082] cTS2PES got 0 TS errors, 52 TS 
> continuity errors
> Feb 26 14:59:34 tom1 vdr: [4082] cTS2PES got 0 TS errors, 137 TS 
> continuity errors
> Feb 26 14:59:34 tom1 vdr: [4082] cTS2PES got 0 TS errors, 43 TS 
> continuity errors
> Feb 26 14:59:34 tom1 vdr: [4082] cTS2PES got 0 TS errors, 16 TS 
> continuity errors
> Feb 26 14:59:34 tom1 vdr: [4082] cTS2PES got 0 TS errors, 57 TS 
> continuity errors
> Feb 26 14:59:54 tom1 vdr: [4082] cTS2PES got 0 TS errors, 3 TS 
> continuity errors
> Feb 26 14:59:54 tom1 vdr: [4082] cTS2PES got 0 TS errors, 2 TS 
> continuity errors
> 
> dvbsnoop -s feinfo -adapter 2
> Current parameters:
> Frequency: 1236.253 MHz
> Inversion: OFF
> Symbol rate: 31.794142 MSym/s
> FEC: FEC 3/4
> 
> dvbsnoop -s signal -adapter 2
> cycle: 1 d_time: 0.001 s Sig: 26471 SNR: 49858 BER: 0 UBLK: 0 Stat: 0x1f 
> [SIG CARR VIT SYNC LOCK ]
> cycle: 2 d_time: 0.072 s Sig: 26471 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f 
> [SIG CARR VIT SYNC LOCK ]
> cycle: 3 d_time: 0.072 s Sig: 26728 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f 
> [SIG CARR VIT SYNC LOCK ]
> cycle: 4 d_time: 0.088 s Sig: 26728 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f 
> [SIG CARR VIT SYNC LOCK ]
> cycle: 5 d_time: 0.072 s Sig: 26471 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f 
> [SIG CARR VIT SYNC LOCK ]
> cycle: 6 d_time: 0.072 s Sig: 26471 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f 
> [SIG CARR VIT SYNC LOCK ]
> cycle: 7 d_time: 0.072 s Sig: 26471 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f 
> [SIG CARR VIT SYNC LOCK ]
> cycle: 8 d_time: 0.072 s Sig: 26471 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f 
> [SIG CARR VIT SYNC LOCK ]
> 
> Low signal strength values are AGC-loop misinterpretation as usual?
> 
> y
> tom
> 
> 
