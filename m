Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43405 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0JBPTc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Oct 2010 11:19:32 -0400
Received: by wwj40 with SMTP id 40so2509914wwj.1
        for <linux-media@vger.kernel.org>; Sat, 02 Oct 2010 08:19:31 -0700 (PDT)
Message-ID: <4CA74D80.7000707@gmail.com>
Date: Sat, 02 Oct 2010 17:19:28 +0200
From: thomas schorpp <thomas.schorpp@googlemail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: dvb-c: TT C-1501: tda827x.c: Cannot hold lock at 746 MHz
References: <4CA74509.6000404@gmail.com>
In-Reply-To: <4CA74509.6000404@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am 02.10.2010 16:43, schrieb thomas schorpp:
> Hello,
>
> Klaas patch is not complete:
> http://article.gmane.org/gmane.linux.drivers.dvb/47571
>
> I found a hole at 746MHz with 2.6.34.0 kernel and DE provider kabelbw.de,
> Picture fragments and audio bursts only:
>
> Oct 2 15:53:03 tom1 vdr: [16380] receiver on device 1 thread ended (pid=16268, tid=16380)
> Oct 2 15:53:03 tom1 kernel: tda827x: tda827xa_set_params:
> Oct 2 15:53:03 tom1 kernel: tda827x: tda827xa_set_params select tda827xa_dvbc
> Oct 2 15:53:03 tom1 kernel: tda827x: tda8275a AGC2 gain is: 4
> Oct 2 15:53:04 tom1 vdr: [16462] setting audio track to 1 (0)
> Oct 2 15:53:04 tom1 kernel: tda827x: tda827xa_set_params:
> Oct 2 15:53:04 tom1 kernel: tda827x: tda827xa_set_params select tda827xa_dvbc
> Oct 2 15:53:04 tom1 kernel: tda827x: tda8275a AGC2 gain is: 5
> Oct 2 15:53:04 tom1 vdr: [16279] frontend 0 lost lock on channel 496, tp 746
> Oct 2 15:53:04 tom1 vdr: [16279] frontend 0 regained lock on channel 496, tp 746
> Oct 2 15:53:05 tom1 kernel: tda827x: tda827xa_set_params:
> Oct 2 15:53:05 tom1 kernel: tda827x: tda827xa_set_params select tda827xa_dvbc
> Oct 2 15:53:05 tom1 kernel: tda827x: tda8275a AGC2 gain is: 4
> Oct 2 15:53:05 tom1 vdr: [16279] frontend 0 lost lock on channel 496, tp 746
> Oct 2 15:53:05 tom1 kernel: tda827x: tda827xa_set_params:
> Oct 2 15:53:05 tom1 kernel: tda827x: tda827xa_set_params select tda827xa_dvbc
> Oct 2 15:53:05 tom1 kernel: tda827x: tda8275a AGC2 gain is: 4
> Oct 2 15:53:05 tom1 kernel: tda827x: tda827xa_set_params:
> Oct 2 15:53:05 tom1 kernel: tda827x: tda827xa_set_params select tda827xa_dvbc
> Oct 2 15:53:05 tom1 kernel: tda827x: tda8275a AGC2 gain is: 5
> Oct 2 15:53:06 tom1 vdr: [16279] frontend 0 regained lock on channel 496, tp 746
> Oct 2 15:53:06 tom1 kernel: tda827x: tda827xa_set_params:
> Oct 2 15:53:06 tom1 kernel: tda827x: tda827xa_set_params select tda827xa_dvbc
> Oct 2 15:53:06 tom1 kernel: tda827x: tda8275a AGC2 gain is: 5
> Oct 2 15:53:06 tom1 kernel: tda827x: tda827xa_set_params:
> Oct 2 15:53:06 tom1 kernel: tda827x: tda827xa_set_params select tda827xa_dvbc
> Oct 2 15:53:06 tom1 kernel: tda827x: tda8275a AGC2 gain is: 5
> Oct 2 15:53:06 tom1 kernel: tda827x: tda827xa_set_params:
> Oct 2 15:53:06 tom1 kernel: tda827x: tda827xa_set_params select tda827xa_dvbc
> Oct 2 15:53:06 tom1 kernel: tda827x: tda8275a AGC2 gain is: 4
> Oct 2 15:53:06 tom1 vdr: [16268] switching to channel 494
>
> cycle: 78 d_time: 0.004 s Sig: 51657 SNR: 43690 BER: 1728 UBLK: 55 Stat: 0x00 []
> cycle: 79 d_time: 0.004 s Sig: 52428 SNR: 60395 BER: 1728 UBLK: 57 Stat: 0x03 [SIG CARR ]
> cycle: 80 d_time: 0.004 s Sig: 50886 SNR: 46517 BER: 1728 UBLK: 95 Stat: 0x00 []
> cycle: 81 d_time: 0.007 s Sig: 52428 SNR: 44461 BER: 1728 UBLK: 54 Stat: 0x03 [SIG CARR ]
> cycle: 82 d_time: 0.003 s Sig: 51657 SNR: 61423 BER: 1728 UBLK: 5 Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
> cycle: 83 d_time: 0.237 s Sig: 40092 SNR: 47288 BER: 1048575 UBLK: 66 Stat: 0x00 []
> cycle: 84 d_time: 0.005 s Sig: 56283 SNR: 45232 BER: 1728 UBLK: 113 Stat: 0x00 []
> cycle: 85 d_time: 0.006 s Sig: 53199 SNR: 46774 BER: 1728 UBLK: 136 Stat: 0x00 []
> cycle: 86 d_time: 0.008 s Sig: 50115 SNR: 44975 BER: 1728 UBLK: 55 Stat: 0x00 []
> cycle: 87 d_time: 0.004 s Sig: 53199 SNR: 53970 BER: 1728 UBLK: 287 Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
> cycle: 88 d_time: 0.020 s Sig: 50886 SNR: 61166 BER: 1728 UBLK: 62 Stat: 0x03 [SIG CARR ]
>
> Current parameters:
> Frequency: 746000.000 kHz
> Inversion: ON
> Symbol rate: 6.900000 MSym/s
> FEC: none
> Modulation: QAM 64
>
> Card is just bought newly:
>
> 00:06.0 0480: 1131:7146 (rev 01)
> Subsystem: 13c2:101a
> Flags: bus master, medium devsel, latency 32, IRQ 17
> Memory at fbeffc00 (32-bit, non-prefetchable) [size=512]
> Kernel driver in use: budget_ci dvb
>
> Other (tested favourite) channels are tuned in fine.
>
> No network problems for this transponder reported in cable provider's support forums.
>
> Anyone got the chips datasheet or a hint what to tweak in the tda827xa_dvbc[] for this frequency?
>
> { .lomax = 802000000, .svco = 2, .spd = 0, .scr = 2, .sbs = 4, .gc3 = 1}, ?
>
> thx,
> Y
> tom
>
>
>

Hm, this gets complicated, tuning is fine at 722+754MHz but not on 746MHz,
this is within the same control segment

	{ .lomax = 720000000, .svco = 2, .spd = 0, .scr = 1, .sbs = 4, .gc3 = 1},
	{ .lomax = 802000000, .svco = 2, .spd = 0, .scr = 2, .sbs = 4, .gc3 = 1},

