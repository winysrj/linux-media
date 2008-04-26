Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3QCwgQv021879
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 08:58:42 -0400
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3QCwJTo006443
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 08:58:20 -0400
Message-ID: <481326E4.2070909@pickworth.me.uk>
Date: Sat, 26 Apr 2008 13:58:12 +0100
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20080425114526.434311ea@gaivota>	<4811F391.1070207@linuxtv.org>
	<20080426085918.09e8bdc0@gaivota>
In-Reply-To: <20080426085918.09e8bdc0@gaivota>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-dvb@linuxtv.org, video4linux-list@redhat.com, mkrufky@linuxtv.org,
	gert.vervoort@hccnet.nl
Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
Reply-To: ian@pickworth.me.uk
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

Mauro Carvalho Chehab wrote:
> 
> The issue is that set_type_addr were called at the wrong place.
> 
> Anyway, I've just committed a patch that should fix this for cx88. I'll soon
> use the same logic to fix also saa7134.
> 
> I've also added a patch for tuner-core, to improve debug (of course, this
> doesn't need to go to -stable). This helps to see the bug, if tuner debug is
> enabled.
> 
> Cheers,
> Mauro
Hi Mauro,
I have pulled the latest Mercurial source (at about 13:30 BST), compiled 
and installed. I also removed the "tuner=38" workaround from my 
modprobe.conf file. On reboot the WinTV cx88 card was detected correctly 
  - thus curing the original problem in the standard 2.6.25 drivers. 
Also, tvtime works OK with created devices - tuning to all 5 channels OK.
The dmesg trace is below.

About how long would it take for a fix like this to reach the kernel 
tree - any chance for 2.6.25?

Many thanks
Regards
Ian

[   36.728100] cx88[0]: subsystem: 0070:3401, board: Hauppauge WinTV 
34xxx models [card=1,autodetected]
[   36.728100] cx88[0]: TV tuner type -1, Radio tuner type -1
[   37.029329] tuner' 4-0043: chip found @ 0x86 (cx88[0])
[   37.029335] tda9887 4-0043: creating new instance
[   37.029337] tda9887 4-0043: tda988[5/6/7] found
[   37.032817] tuner' 4-0061: chip found @ 0xc2 (cx88[0])
[   37.085829] tveeprom 4-0050: Hauppauge model 34519, rev J157, serial# 
2906136
[   37.085834] tveeprom 4-0050: tuner model is Philips FM1216 ME MK3 
(idx 57, type 38)
[   37.085838] tveeprom 4-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
PAL(D/D1/K) (eeprom 0x74)
[   37.085841] tveeprom 4-0050: audio processor is CX881 (idx 31)
[   37.085843] tveeprom 4-0050: has radio
[   37.085845] cx88[0]: hauppauge eeprom: model=34519
[   37.086224] tuner-simple 4-0061: creating new instance
[   37.086227] tuner-simple 4-0061: type set to 38 (Philips PAL/SECAM 
multi (FM1216ME MK3))
[   37.089686] input: cx88 IR (Hauppauge WinTV 34xxx  as /class/input/input7
[   37.092223] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   37.095311] ACPI: PCI Interrupt 0000:01:0a.0[A] -> Link [LNK1] -> GSI 
11 (level, low) -> IRQ 11
[   37.095323] cx88[0]/0: found at 0000:01:0a.0, rev: 5, irq: 11, 
latency: 32, mmio: 0xe9000000
[   37.095356] cx88[0]/0: registered device video0 [v4l2]
[   37.095375] cx88[0]/0: registered device vbi0
[   37.095391] cx88[0]/0: registered device radio0

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
