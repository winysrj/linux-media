Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3KBKeiZ020699
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 07:20:40 -0400
Received: from smtp40.hccnet.nl (smtp40.hccnet.nl [62.251.0.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3KBKTAf025124
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 07:20:30 -0400
Received: from [10.0.0.100] by smtp40.hccnet.nl
	via a62-251-28-45.adsl.xs4all.nl [62.251.28.45] with ESMTP for
	<video4linux-list@redhat.com>
	id m3KBKShq016134 (8.13.6/2.05); Sun, 20 Apr 2008 13:20:29 +0200 (CEST)
Message-ID: <480B26FC.50204@hccnet.nl>
Date: Sun, 20 Apr 2008 13:20:28 +0200
From: Gert Vervoort <gert.vervoort@hccnet.nl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <480A5CC3.6030408@pickworth.me.uk>
In-Reply-To: <480A5CC3.6030408@pickworth.me.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
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

Ian Pickworth wrote:
> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the drivers 
> for   the Hauppauge WinTV appear to have suffered some regression 
> between the two kernel versions.
>
> The problem is that the tuner is not being detected and set correctly 
> for either the video or the radio device on the card.
>
Similar issue here with a Leadtek Winfast 2000XP card. Video works, but 
radio doesn't.
For my card I can workaround the issue by adding the "tuner=38" option 
to the cx88xx module.

   Gert

2.6.25 log:

cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
cx88[0]: subsystem: 107d:6611, board: Leadtek Winfast 2000XP Expert 
[card=5,autodetected]
cx88[0]: TV tuner type 44, Radio tuner type -1
tuner' 1-0043: chip found @ 0x86 (cx88[0])
tda9887 1-0043: tda988[5/6/7] found
All bytes are equal. It is not a TEA5767
tuner' 1-0060: chip found @ 0xc0 (cx88[0])
tuner-simple 1-0060: type set to 44 (Philips 4 in 1 (ATI TV Wonder 
Pro/Conexant))
cx88[0]: Leadtek Winfast 2000XP Expert config: tuner=38, eeprom[0]=0x01
input: cx88 IR (Leadtek Winfast 2000XP as /class/input/input6
cx88[0]/0: found at 0000:00:0a.0, rev: 5, irq: 18, latency: 32, mmio: 
0xe2000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0


2.6.24 log:

cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
cx88[0]: subsystem: 107d:6611, board: Leadtek Winfast 2000XP Expert 
[card=5,autodetected]
cx88[0]: TV tuner type 44, Radio tuner type -1
cx88[0]: Leadtek Winfast 2000XP Expert config: tuner=38, eeprom[0]=0x01
input: cx88 IR (Leadtek Winfast 2000XP as /class/input/input6
cx88[0]/0: found at 0000:00:0a.0, rev: 5, irq: 18, latency: 32, mmio: 
0xe2000000
tuner 1-0043: chip found @ 0x86 (cx88[0])
tda9887 1-0043: tda988[5/6/7] found @ 0x43 (tuner)
tuner 1-0043: type set to tda9887
All bytes are equal. It is not a TEA5767
tuner 1-0060: chip found @ 0xc0 (cx88[0])
tuner-simple 1-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
tuner 1-0060: type set to Philips PAL/SECAM m
tuner-simple 1-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
tuner 1-0060: type set to Philips PAL/SECAM m
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
