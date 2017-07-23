Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34503 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751487AbdGWUmS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 16:42:18 -0400
Received: by mail-wr0-f195.google.com with SMTP id o33so8527822wrb.1
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 13:42:17 -0700 (PDT)
Date: Sun, 23 Jul 2017 22:42:13 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org
Cc: Manfred.Knick@T-Online.de
Subject: Fw: [PATCH RESEND 00/14] ddbridge: bump to ddbridge-0.9.29
Message-ID: <20170723224213.44ec2ed8@macbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manfred kindly asked me to forward his message to the list as he received a bounce from vger.kernel.org on this.

Beginn der weitergeleiteten Nachricht:

Datum: Sun, 23 Jul 2017 22:10:02 +0200
Von: Manfred_Knick <Manfred.Knick@T-Online.de>
An: Daniel Scheller <d.scheller.oss@gmail.com>, linux-media@vger.kernel.org, mchehab@kernel.org, mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de, rjkm@metzlerbros.de
Betreff: Re: [PATCH RESEND 00/14] ddbridge: bump to ddbridge-0.9.29


Am 23.07.2017 um 20:16 schrieb Daniel Scheller:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Preferrably for Linux 4.14 (to get things done).
> 
> Resend reasons (resend since no real changes went in):
> * rebased on latest mediatree-master wrt
>     commit 618e8aac3d7c ("media: ddbridge: constify i2c_algorithm structure")
> * build error in ddbridge-core.c fixed wrt
>     commit dcda9b04713c ("mm, tree wide: replace __GFP_REPEAT by __GFP_RETRY_MAYFAIL with more useful semantic")
> * useless return removed from void calc_con()
> * UTF8 in ddbridge-regs.h removed
> * Tested-by's added to commit messages
> 
> ...  

####################################################
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
####################################################

I initially got involved into this by finding out about Daniel's
Gentoo overlay carrying ddbridge-sources, which installs the gentoo
kernel sources with these exact patches ontop. The first version I
tried was with kernel 4.9 which had an older revision of the patchset,
and am now up at version 4.12.3, having the patches posted here ontop
of a stable kernel version.

Air-borne TV in Munich, Germany is DVB-T2 _only_ since March 29, 2017.

+1:     The pach set is working to my perfect satisfaction:

Displaying channels works flawlessly with VLC and Kaffeine.
For recording I exploit Kaffeine's comfortable graphical user interface.

        media-video/kaffeine-9999:5         (latest git)
        media-video/vlc-2.2.6-r1:0/5-8

I am grateful for Daniels support, always quick and friendly,
to help me get up and running in the beginning,
as well as his cooperation and very fast reaction lately:

Integrating into cxd2841er in

. . . sys-kernel/ddbridge-sources-4.12.0   ( CONFIG_DVB_CXD2841ER )

resulted in failure of scanning for channels within Kaffeine.
Daniel's patch [1] fixed the underlying deeper problem:
. . . changing from DVB-T to DVB-T2 without stopping the frontend,
. . . the demod operation mode isn't re-setup
(Mauro <mchehab> was on CC).

It was immediately integrated (amongst other improvements) by Daniel into

. . . sys-kernel/ddbridge-sources-4.12.{1,2,3}

delivering the services mentioned above as solid as expected.

Many "Thanks!" to Daniel - and to the reviewers.

+1:     for integrating this cleaned-up structure into mainline

This rescues users of DD HW from being enslaved by DD's
   "one big undocumented blob for everything"
   "only our HW counts" "exclude all other media hw"
attitude.

Personally, I want a clean HW driver *only*,
and disgust being forced into installing an inscrutable "Octopus" network
compulsorily just for being able to use a tiny bit of HW locally.

Regards,

Manfred

[1] . . . [ https://github.com/herrnst/dddvb-linux-kernel/commit/
    . . .                        ca17298941f3a6aafa1f625535cc2eab041187be ]

#############
POSTSCRIPTUM:
#############

I would be happy tp provide any additional information as needed.

# uname -a
   Linux sid 4.12.3-ddbridge #1 SMP Sun Jul 23 00:12:41 CEST 2017
   x86_64 Intel(R) Xeon(R) CPU E3-1276 v3 @ 3.60GHz GenuineIntel GNU/Linux

#  grep -i cxd2841er /usr/src/linux/.config
CONFIG_DVB_CXD2841ER=y

#  dmesg | grep -i cxd284
[    2.343582] ddbridge 0000:03:00.0: Port 0: Link 0, Link Port 0 (TAB 1): DUAL DVB-C2T2 CXD2843
[    2.361510] i2c i2c-8: cxd2841er_attach(): I2C adapter ffffc9000cf05800 SLVX addr 6e SLVT addr 6c
[    2.362781] i2c i2c-8: cxd2841er_attach(): attaching CXD2843ER DVB-C/C2/T/T2 frontend
[    2.363818] i2c i2c-8: cxd2841er_attach(): chip ID 0xa4 OK.
[    2.366675] ddbridge 0000:03:00.0: DVB: registering adapter 0 frontend 0 (Sony CXD2843ER DVB-T/T2/C/C2 demodulator)...
[    2.367928] i2c i2c-8: cxd2841er_attach(): I2C adapter ffffc9000cf05800 SLVX addr 6f SLVT addr 6d
[    2.369280] i2c i2c-8: cxd2841er_attach(): attaching CXD2843ER DVB-C/C2/T/T2 frontend
[    2.370364] i2c i2c-8: cxd2841er_attach(): chip ID 0xa4 OK.
[    2.373132] ddbridge 0000:03:00.0: DVB: registering adapter 1 frontend 0 (Sony CXD2843ER DVB-T/T2/C/C2 demodulator)...
[    2.374416] i2c i2c-9: cxd2841er_attach(): I2C adapter ffffc9000cf05c30 SLVX addr 6e SLVT addr 6c
[    2.376374] i2c i2c-9: cxd2841er_attach(): attaching CXD2843ER DVB-C/C2/T/T2 frontend
[    2.377481] i2c i2c-9: cxd2841er_attach(): chip ID 0xa4 OK.
[    2.381931] ddbridge 0000:03:00.0: DVB: registering adapter 2 frontend 0 (Sony CXD2843ER DVB-T/T2/C/C2 demodulator)...
[    2.383230] i2c i2c-9: cxd2841er_attach(): I2C adapter ffffc9000cf05c30 SLVX addr 6f SLVT addr 6d
[    2.385216] i2c i2c-9: cxd2841er_attach(): attaching CXD2843ER DVB-C/C2/T/T2 frontend
[    2.386336] i2c i2c-9: cxd2841er_attach(): chip ID 0xa4 OK.
[    2.390885] ddbridge 0000:03:00.0: DVB: registering adapter 3 frontend 0 (Sony CXD2843ER DVB-T/T2/C/C2 demodulator)...

$  grep -i -R "CXD28" ~/.local/share/kaffeine/ | sort -u
      .../config.dvb:frontendName=Sony CXD2843ER DVB-T/T2/C/C2 demodulator

# lspci      [ ASUS P9D-WS | 32 GB ]

00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v3 Processor DRAM Controller (rev 06)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v3/4th Gen Core Processor PCI Express x16 Controller (rev 06)
00:01.1 PCI bridge: Intel Corporation Xeon E3-1200 v3/4th Gen Core Processor PCI Express x8 Controller (rev 06)
00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v3 Processor Integrated Graphics Controller (rev 06)     <---
00:03.0 Audio device: Intel Corporation Xeon E3-1200 v3/4th Gen Core Processor HD Audio Controller (rev 06)                <---
00:14.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset Family USB xHCI (rev 05)
00:16.0 Communication controller: Intel Corporation 8 Series/C220 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset Family USB EHCI #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 8 Series/C220 Series Chipset High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #1 (rev d5)
00:1c.1 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d5)
00:1c.2 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #3 (rev d5)
00:1c.3 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #4 (rev d5)
00:1c.4 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family PCI Express Root Port #5 (rev d5)
00:1d.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset Family USB EHCI #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation C226 Series Chipset Family Server Advanced SKU LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 8 Series/C220 Series Chipset Family 6-port SATA Controller 1 [AHCI mode] (rev 05)
00:1f.3 SMBus: Intel Corporation 8 Series/C220 Series Chipset Family SMBus Controller (rev 05)
01:00.0 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)
02:00.0 VGA compatible controller: NVIDIA Corporation GK104 [GeForce GTX 660 Ti] (rev a1)                                  <---
02:00.1 Audio device: NVIDIA Corporation GK104 HDMI Audio Controller (rev a1)
03:00.0 Multimedia controller: Digital Devices GmbH Cine V7                                                                <---
04:00.0 PCI bridge: ASMedia Technology Inc. ASM1083/1085 PCIe to PCI Bridge (rev 03)
05:01.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)                                    <---
05:01.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)                                          <---
06:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
07:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
08:00.0 RAID bus controller: Adaptec Series 6 - 6G SAS/PCIe 2 (rev 01)

I'm exploiting Intel _and_ NVida VGA combined into a classical Multiple-separate-X11-Screen (ZapHod mode) setup.
