Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7PFjP34016217
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 11:45:25 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7PFieP9026450
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 11:44:41 -0400
From: Marcel Tiede <badcel@gmx.de>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Mon, 25 Aug 2008 17:44:38 +0200
Message-Id: <1219679078.4182.7.camel@archlinux>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Setting the tuner type of cx88xx Module in Kernel 2.6.26.2 does
	not work anymore
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

Hello,

till the last Kernel Upgrade of my distribution (Archlinux) I'm not able
to set the tuner type of my conexant card in order to view tv. The
setting is recognized by cx88xx module, but the tuner-simple seems to
overwrite this setting again.

Extract:

Because my card is not recognized correctly, I use the following script
to load
my modules correctly:

modprobe -r cx88-dvb cx88-blackbird cx8802 cx88-alsa cx8800 cx88xx tuner
tuner-simple
modprobe tuner-simple debug=1
modprobe cx88xx tuner=38
modprobe cx8800

After running this script dmesg states:

tda9887 2-0043: destroying instance
tuner-simple 2-0061: destroying instance
Linux video capture interface: v2.00
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [APC1] -> GSI 16 (level, high) ->
IRQ 16
cx88[0]: subsystem: 0070:3401, board: Hauppauge WinTV 34xxx models
[card=1,autodetected]
cx88[0]: TV tuner type 38, Radio tuner type -1
tuner' 2-0043: chip found @ 0x86 (cx88[0])
tda9887 2-0043: creating new instance
tda9887 2-0043: tda988[5/6/7] found
tuner' 2-0061: chip found @ 0xc2 (cx88[0])
tveeprom 2-0050: Encountered bad packet header [00]. Corrupt or not a Hauppauge
eeprom.
cx88[0]: warning: unknown hauppauge model #0
cx88[0]: hauppauge eeprom: model=0
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 0 (Temic PAL (4002 FH5))
tuner-simple 2-0061: tuner 0 atv rf input will be autoselected
tuner-simple 2-0061: tuner 0 dtv rf input will be autoselected
tuner-simple 2-0061: using tuner params #0 (pal)
tuner-simple 2-0061: freq = 400.00 (6400), range = 1, config = 0x8e, cb = 0x04
tuner-simple 2-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz,
div=7023
tuner-simple 2-0061: tv 0x1b 0x6f 0x8e 0x04
input: cx88 IR (Hauppauge WinTV 34xxx  as /class/input/input9
cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 16, latency: 32, mmio:
0xe6000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
tuner-simple 2-0061: desired params (ntsc) undefined for tuner 0
tuner-simple 2-0061: using tuner params #0 (pal)
tuner-simple 2-0061: freq = 400.00 (6400), range = 1, config = 0x8e, cb = 0x04
tuner-simple 2-0061: Freq= 400.00 MHz, V_IF=45.75 MHz, Offset=0.00 MHz,
div=7132
tuner-simple 2-0061: tv 0x1b 0xdc 0x8e 0x04

>From my point of view this line is critical:

tuner-simple 2-0061: type set to 0 (Temic PAL (4002 FH5))

This should type 38 instead, like in:

cx88[0]: TV tuner type 38, Radio tuner type -1

I already opened a bugreport in the Kernels bugzilla, but noone is
responding: http://bugzilla.kernel.org/show_bug.cgi?id=11367 So I
thought this would be the correct place to get things rolling.

Thanks for your help.

Marcel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
