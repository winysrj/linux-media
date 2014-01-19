Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:36172 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaASNjd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 08:39:33 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZN00JWTHXVCT00@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sun, 19 Jan 2014 08:39:31 -0500 (EST)
To: undisclosed-recipients:;
Date: Sun, 19 Jan 2014 11:39:26 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [ANNOUNCE EXPERIMENTAL] PCTV 80e driver
Message-id: <20140119113926.60e0f586@samsung.com>
In-reply-to: <20140119022328.55f6a741@samsung.com>
References: <20140119022328.55f6a741@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 19 Jan 2014 02:23:28 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> And, after a while:
> 
>  PID          FREQ         SPEED       TOTAL
> 0000      8.39 p/s     12.3 Kbps      539 KB
> 0f75    419.96 p/s    616.8 Kbps    26985 KB
> 0fff      8.78 p/s     12.9 Kbps      564 KB
> 1000      8.33 p/s     12.2 Kbps      535 KB
> 1683    420.27 p/s    617.3 Kbps    27005 KB
> 1ae4    419.68 p/s    616.4 Kbps    26967 KB
> 1fff      8.33 p/s     12.2 Kbps      535 KB
> TOT    1334.12 p/s   1959.5 Kbps    85728 KB
> 
> Of course, other DVB applications should equally work.
> 
> PS.: at least here on my tests with dvbv5 apps at v4l-utils, there are some
> instability at the driver: sometimes, it shows the full PID table, sometimes 
> it shows only a subset of the existing PIDs, and sometimes, it doesn't show
> anything.
> 
> That seems to be some sort of bug at PID filtering.
> 
> At this stage, I'm not sure where is the bug, as I just make the driver
> to work.

It seems that subsequent tuning makes the device worse, reducing the
maximum effective packet bandwidth. Btw, this happens with both xHCI
and EHCI drivers, so, it is not related to any USB 3.0 issue.

Enabling some demux logs, it is possible to see that there are too many
FEC errors:

[73514.186880] dvb_dmx_swfilter_packet: 4546 callbacks suppressed
[73514.186933] TEI detected. PID=0x17f data1=0xc1
[73514.186965] TEI detected. PID=0x1c68 data1=0xbc
[73514.186993] TEI detected. PID=0x17f data1=0xc1
[73514.187022] TEI detected. PID=0x1c68 data1=0xbc
[73514.187049] TEI detected. PID=0x17f data1=0xc1
[73514.187080] TEI detected. PID=0x1c68 data1=0xbc
[73514.187105] TEI detected. PID=0x17f data1=0xc1
[73514.194878] TEI detected. PID=0x1c68 data1=0xbc
[73514.194906] TEI detected. PID=0x17f data1=0xc1
[73514.194927] TEI detected. PID=0x1c68 data1=0xbc
[73521.569205] TS speed 402 Kbits/sec 

I'm starting to suspect that this could be a hardware issue.

It would be good to see if others can use it and tune to several
channels.

> Ah, I didn't work at the remote controller yet. I'll handle it after
> doing more tests with the DVB functionality.

Remote controller support was added.

Regards,
Mauro
