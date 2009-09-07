Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f184.google.com ([209.85.216.184]:56700 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZIGLwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 07:52:33 -0400
Received: by pxi14 with SMTP id 14so2450863pxi.19
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 04:52:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D8912B36-7521-4559-9E7A-3B9A7F6DC1E1@receptiveit.com.au>
References: <D8912B36-7521-4559-9E7A-3B9A7F6DC1E1@receptiveit.com.au>
Date: Mon, 7 Sep 2009 21:52:34 +1000
Message-ID: <702870ef0909070452o5eef67b5p6505c3db301ea65f@mail.gmail.com>
Subject: Re: Fusion HDTV Dual Digital Express - NSW Australia
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Alex Ferrara <alex@receptiveit.com.au>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have some issues with what I think is the same card, I'm in Sydney,
using mythtv.
I also have the DViCo Fusion Dual Digital 4 rev 1. (setup details at the end)

At first when I scanned I could not get the SBS HD transport.
Sometime between 28 Jun and 19 July I stopped being able to tune
anything from channel 9 as well. This does not appear to have been
triggered by a v4l code change, I did not
pull from the tree in that time frame.

The symptom I see when it "fails" is that mythv reports some signal,
but it fails to get lock.

When I try to rescan, I get weird errors - after mythtv-backend stops,
I start getting USB errors of this kind:

kernel: [  663.703978] dvb-usb: recv bulk message failed: -110
kernel: [  663.703994] zl10353: write to reg 62 failed (err = -121)!
kernel: [  664.836658] dvb-usb: recv bulk message failed: -110
kernel: [  664.836665] zl10353: write to reg 62 failed (err = -121)!
kernel: [  665.699864] dvb-usb: bulk message failed: -110 (4/0)
kernel: [  665.699869] cxusb: i2c read failed
kernel: [  666.832545] dvb-usb: bulk message failed: -110 (5/0)
kernel: [  666.832551] zl10353: write to reg 50 failed (err = -121)!
kernel: [  667.696001] dvb-usb: bulk message failed: -110 (5/0)
kernel: [  667.696016] zl10353: write to reg 50 failed (err = -121)!
kernel: [  668.828433] dvb-usb: bulk message failed: -110 (2/0)
kernel: [  669.691639] dvb-usb: bulk message failed: -110 (4/0)


At this point, the channel scan stalls out and the machine is very
sluggish because of the DoSing of the USB bus. To recover I have to
halt the machine and bring it up again.
It's unclear to me if it is a problem with the Dual DIgital 4 or the
Dual Digital Express.

This appears to be a longstanding issue, existing from 2.6.26 (my
kernel) through to 2.6.30 (see
http://www.spinics.net/lists/linux-media/msg08244.html)


I attempted to avoid the power cycling of the card by loading the
tuner module with
 options tuner_xc2028 no_poweroff=1
in /etc/modprobe.d/options, but with this option turned on I was
unable to receive any stations.

Alex, just to confirm we have the same card could you post the PCI IDs?

When the card is detected I see in syslog:
kernel: [   57.768535] CORE cx23885[0]: subsystem: 18ac:db78, board:
DViCO FusionHDTV DVB-T Dual Express [card=11,autodetected]

and lspci gives me
(lspci -n -s 04:00 && lspci -v -s 04:00)
(sudo lspci -n -s 4:00 && sudo lspci -v -s 4:00; )
04:00.0 0400: 14f1:8852 (rev 02)
04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
PCI Video and Audio Decoder (rev 02)
        Subsystem: DViCO Corporation FusionHDTV DVB-T Dual Express
        Flags: bus master, fast devsel, latency 0, IRQ 19
        Memory at 90000000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express Endpoint IRQ 0
        Capabilities: [80] Power Management version 2
        Capabilities: [90] Vital Product Data
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-


My system details:
  (cd ~/v4l; hg identify)
  2b49813f8482 tip

  /etc/issue
  Ubuntu 8.04.3 LTS

  uname -a
  2.6.24-24-generic #1 SMP Tue Aug 18 17:04:53 UTC 2009 i686 GNU/Linux

  lspci
00:00.0 0600: 8086:29c0 (rev 02)
00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM
Controller (rev 02)
00:02.0 0300: 8086:29c2 (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express
Integrated Graphics Controller (rev 02)
00:03.0 0780: 8086:29c4 (rev 02)
00:03.0 Communication controller: Intel Corporation 82G33/G31/P35/P31
Express MEI Controller (rev 02)
00:19.0 0200: 8086:294c (rev 02)
00:19.0 Ethernet controller: Intel Corporation 82566DC-2 Gigabit
Network Connection (rev 02)
00:1a.0 0c03: 8086:2937 (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #4 (rev 02)
00:1a.1 0c03: 8086:2938 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #5 (rev 02)
00:1a.2 0c03: 8086:2939 (rev 02)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #6 (rev 02)
00:1a.7 0c03: 8086:293c (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #2 (rev 02)
00:1b.0 0403: 8086:293e (rev 02)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 02)
00:1c.0 0604: 8086:2940 (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 02)
00:1c.1 0604: 8086:2942 (rev 02)
00:1c.2 0604: 8086:2944 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 3 (rev 02)
00:1c.3 0604: 8086:2946 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 4 (rev 02)
00:1c.4 0604: 8086:2948 (rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 5 (rev 02)
00:1d.0 0c03: 8086:2934 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #1 (rev 02)
00:1d.1 0c03: 8086:2935 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #2 (rev 02)
00:1d.2 0c03: 8086:2936 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #3 (rev 02)
00:1d.7 0c03: 8086:293a (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #1 (rev 02)
00:1e.0 0604: 8086:244e (rev 92)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 0601: 8086:2912 (rev 02)
00:1f.0 ISA bridge: Intel Corporation 82801IH (ICH9DH) LPC Interface
Controller (rev 02)
00:1f.2 0106: 8086:2922 (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH)
6 port SATA AHCI Controller (rev 02)
00:1f.3 0c05: 8086:2930 (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
02:00.0 0101: 11ab:6101 (rev b2)
02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101
single-port PATA133 interface (rev b2)
04:00.0 0400: 14f1:8852 (rev 02)
04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
PCI Video and Audio Decoder (rev 02)
06:00.0 0200: 10ec:8185 (rev 20)
06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8185
IEEE 802.11a/b/g Wireless LAN Controller (rev 20)
06:01.0 0c03: 1106:3038 (rev 61)
06:01.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 61)
06:01.1 0c03: 1106:3038 (rev 61)
06:01.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 61)
06:01.2 0c03: 1106:3104 (rev 63)
06:01.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)
06:03.0 0c00: 104c:8023
06:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
IEEE-1394a-2000 Controller (PHY/Link)

  lsusb
00:1f.3 0c05: 8086:2930 (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
02:00.0 0101: 11ab:6101 (rev b2)
02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101
single-port PATA133 interface (rev b2)
04:00.0 0400: 14f1:8852 (rev 02)
04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
PCI Video and Audio Decoder (rev 02)
06:00.0 0200: 10ec:8185 (rev 20)
06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8185
IEEE 802.11a/b/g Wireless LAN Controller (rev 20)
06:01.0 0c03: 1106:3038 (rev 61)
06:01.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 61)
06:01.1 0c03: 1106:3038 (rev 61)
06:01.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 61)
06:01.2 0c03: 1106:3104 (rev 63)
06:01.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)
06:03.0 0c00: 104c:8023
06:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
IEEE-1394a-2000 Controller (PHY/Link)



On 9/7/09, Alex Ferrara <alex@receptiveit.com.au> wrote:
> I bought several of these cards over a year ago thinking that they
> worked under Linux, but I found that while the cards seem to work
> flawlessly for some people, in some geographic locations, they don't
> work for me in Goulburn NSW pointing to Mt Gray.
>
> I have a mythtv backend with 2 x Dvico Dual Digital 4 PCI cards and
> they are working perfectly, but the Dual Express cards will not tune
> all transports. It seems that Prime and TEN hardly get enough signal
> to tune.
>
> I have done some tests, and under Windows with MCE the cards work
> perfectly using the same antenna
>
> I've heard that these cards have some sort of pre-amp that isn't
> getting turned on in Linux. This might be part of the issue. I have
> tried increasing signal amplification, but that degrades the other
> signals that are working ok without the extra amp.
>
> If anyone can shed some light, I would be very appreciative
>
> aF
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
