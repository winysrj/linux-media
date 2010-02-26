Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47064 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964884Ab0BZOjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 09:39:35 -0500
Received: by bwz1 with SMTP id 1so122231bwz.21
        for <linux-media@vger.kernel.org>; Fri, 26 Feb 2010 06:39:33 -0800 (PST)
Message-ID: <4B87DD22.3000209@gmail.com>
Date: Fri, 26 Feb 2010 15:39:30 +0100
From: thomas schorpp <thomas.schorpp@googlemail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [BUG] TDA10086 : Creatix CTX929_V.1 : TS continuity errors with good
 RF signal input
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

Issue is already confirmed here:
http://www.vdr-portal.de/board/thread.php?threadid=93268

Linux 2.6.32.8, 80cm dish.

Do we have any Tuner/Decoder optimization points in the FE code?

This is not OK:

lspci -s 00:08.0 -v 00:08.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL Video Broadcast Decoder (rev 01) Subsystem: Creatix Polymedia GmbH Device 0005 Flags: bus master, medium devsel, latency 32, IRQ 19 Memory at fbeff400 (32-bit, non-prefetchable) [size=1K] Capabilities: [40] Power Management version 1 Kernel driver in use: saa7134

grep cTS2PES /var/log/syslog
Feb 26 13:46:59 tom1 vdr: [4082] cTS2PES got 7 TS errors, 113 TS continuity errors
Feb 26 13:46:59 tom1 vdr: [4082] cTS2PES got 0 TS errors, 29 TS continuity errors
Feb 26 13:47:52 tom1 vdr: [4082] cTS2PES got 17 TS errors, 5 TS continuity errors
Feb 26 14:03:03 tom1 vdr: [4082] cTS2PES got 2 TS errors, 136 TS continuity errors
Feb 26 14:03:03 tom1 vdr: [4082] cTS2PES got 0 TS errors, 32 TS continuity errors
Feb 26 14:41:42 tom1 vdr: [4082] cTS2PES got 1 TS errors, 853 TS continuity errors
Feb 26 14:41:42 tom1 vdr: [4082] cTS2PES got 0 TS errors, 194 TS continuity errors
Feb 26 14:52:58 tom1 vdr: [4082] cTS2PES got 2 TS errors, 196 TS continuity errors
Feb 26 14:52:58 tom1 vdr: [4082] cTS2PES got 0 TS errors, 52 TS continuity errors
Feb 26 14:59:34 tom1 vdr: [4082] cTS2PES got 0 TS errors, 137 TS continuity errors
Feb 26 14:59:34 tom1 vdr: [4082] cTS2PES got 0 TS errors, 43 TS continuity errors
Feb 26 14:59:34 tom1 vdr: [4082] cTS2PES got 0 TS errors, 16 TS continuity errors
Feb 26 14:59:34 tom1 vdr: [4082] cTS2PES got 0 TS errors, 57 TS continuity errors
Feb 26 14:59:54 tom1 vdr: [4082] cTS2PES got 0 TS errors, 3 TS continuity errors
Feb 26 14:59:54 tom1 vdr: [4082] cTS2PES got 0 TS errors, 2 TS continuity errors

dvbsnoop -s feinfo -adapter 2
Current parameters:
Frequency: 1236.253 MHz
Inversion: OFF
Symbol rate: 31.794142 MSym/s
FEC: FEC 3/4

dvbsnoop -s signal -adapter 2
cycle: 1 d_time: 0.001 s Sig: 26471 SNR: 49858 BER: 0 UBLK: 0 Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 2 d_time: 0.072 s Sig: 26471 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 3 d_time: 0.072 s Sig: 26728 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 4 d_time: 0.088 s Sig: 26728 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 5 d_time: 0.072 s Sig: 26471 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 6 d_time: 0.072 s Sig: 26471 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 7 d_time: 0.072 s Sig: 26471 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 8 d_time: 0.072 s Sig: 26471 SNR: 50115 BER: 0 UBLK: 0 Stat: 0x1f [SIG CARR VIT SYNC LOCK ]

Low signal strength values are AGC-loop misinterpretation as usual?

y
tom

