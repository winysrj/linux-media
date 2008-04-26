Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3QEOgSG016511
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 10:24:42 -0400
Received: from smtp40.hccnet.nl (smtp40.hccnet.nl [62.251.0.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3QENe92023466
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 10:23:40 -0400
Message-ID: <48133AE3.7070706@hccnet.nl>
Date: Sat, 26 Apr 2008 16:23:31 +0200
From: Gert Vervoort <gert.vervoort@hccnet.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <480A5CC3.6030408@pickworth.me.uk>	<480B26FC.50204@hccnet.nl>	<480B3673.3040707@pickworth.me.uk>	<1208696771.3349.49.camel@pc10.localdom.local>	<480B6CD8.7040702@hccnet.nl>	<1208726202.5682.44.camel@pc10.localdom.local>	<1209009328.3402.9.camel@pc10.localdom.local>	<20080425105618.08c5c471@gaivota>	<37219a840804250740k6b1bb64er633cff7a4e377798@mail.gmail.com>	<20080425120307.69a71e17@gaivota>	<48120D15.3010109@hccnet.nl>
	<20080426090725.4a0fdcd4@gaivota>
In-Reply-To: <20080426090725.4a0fdcd4@gaivota>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: DVB ML <linux-dvb@linuxtv.org>, video4linux-list@redhat.com,
	Michael Krufky <mkrufky@linuxtv.org>
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

Mauro Carvalho Chehab wrote:
> Hi Gert,
>
> On Fri, 25 Apr 2008 18:55:49 +0200
> Gert Vervoort <gert.vervoort@hccnet.nl> wrote:
>
>   
>> This does not make a difference for me:
>>     
>
> Please, update from v4l-dvb and test again.
>   
Yes, now correctly sets the tuner type:

cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
cx88[0]: subsystem: 107d:6611, board: Leadtek Winfast 2000XP Expert 
[card=5,autodetected]
cx88[0]: TV tuner type 44, Radio tuner type -1
tuner' 4-0043: chip found @ 0x86 (cx88[0])
tda9887 4-0043: creating new instance
tda9887 4-0043: tda988[5/6/7] found
All bytes are equal. It is not a TEA5767
tuner' 4-0060: chip found @ 0xc0 (cx88[0])
cx88[0]: Leadtek Winfast 2000XP Expert config: tuner=38, eeprom[0]=0x01
tuner-simple 4-0060: creating new instance
tuner-simple 4-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
input: cx88 IR (Leadtek Winfast 2000XP as /class/input/input6
cx88[0]/0: found at 0000:00:0a.0, rev: 5, irq: 18, latency: 32, mmio: 
0xe2000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0



   Gert


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
