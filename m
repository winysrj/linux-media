Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJCp3Kg032482
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 07:51:03 -0500
Received: from www20.your-server.de (www20.your-server.de [213.133.104.20])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJCon27011444
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 07:50:49 -0500
Received: from [82.83.49.146] (helo=[192.168.242.4])
	by www20.your-server.de with esmtpa (Exim 4.69)
	(envelope-from <xl@xlsigned.net>) id 1LDeob-0000Es-7V
	for video4linux-list@redhat.com; Fri, 19 Dec 2008 13:50:49 +0100
Message-ID: <494B98A4.8000801@xlsigned.net>
Date: Fri, 19 Dec 2008 13:50:44 +0100
From: "Dyks, Axel (XL)" <xl@xlsigned.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: cx88: Tuner not detected when driver build into kernel (broken in
 2.6.26/27, fixed in 2.6.28-rc)
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

Hi,

I'm currently working on a bug report from a gentoo user who spotted
a 2.6.26 regression that seems to be fixed meanwhile (2.6.28-rc).

The problem is that the (analog only) tuner of his WinTV card isn't
detected (even not when tuner type is passed as a kernel parameter)
when the cx88 driver is build into the kernel. It works, when cx88
is build as a module.

This is a dmesg excerpt from a 2.6.26 kernel with cx88 build in.
----------------------------------------------------------------
  cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
  ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
  ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
  cx88[0]: subsystem: 0070:3401, board: Hauppauge WinTV 34xxx models [card=1,autodetected]
  cx88[0]: TV tuner type -1, Radio tuner type -1
  tveeprom 0-0050: Hauppauge model 34504, rev E148, serial# 7041745
  tveeprom 0-0050: tuner model is LG TP18PSB11D (idx 48, type 29)
  tveeprom 0-0050: TV standards PAL(B/G) (eeprom 0x04)
  tveeprom 0-0050: audio processor is CX881 (idx 31)
  tveeprom 0-0050: has radio
  cx88[0]: warning: unknown hauppauge model #34504
  cx88[0]: hauppauge eeprom: model=34504
  input: cx88 IR (Hauppauge WinTV 34xxx  as /class/input/input2
  cx88[0]/0: found at 0000:01:06.0, rev: 3, irq: 16, latency: 32, mmio: 0xf3000000
  cx88[0]/0: registered device video0 [v4l2]
  cx88[0]/0: registered device vbi0
  cx88[0]/0: registered device radio0
  cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
  tuner' 0-0061: chip found @ 0xc2 (cx88[0])
  ...
  tuner' 0-0061: tuner type not set
----------------------------------------------------------------

We've spotted the commit that introduced the regression and were able
to verify that reverting the commit fixes it on 2.6.26.

 cx88: fix tuner setup
 http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4bf1226a7018bf79d05e0ce59244d702819529d1

Now I would like to backport the patch(es) that fixed it in 2.6.28-rc
to 2.6.27, but it's quite hard to figure it out, especially because
many of the patches depend on each other.

So any hints on which patch(es) might have fixed it are welcome.

Thanks,

Axel

P. S.: Link to gentoo bug report: http://bugs.gentoo.org/show_bug.cgi?id=250609

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
