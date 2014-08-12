Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f59.google.com ([209.85.192.59]:57324 "EHLO
	mail-qg0-f59.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaHLG7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 02:59:41 -0400
Received: by mail-qg0-f59.google.com with SMTP id j5so2054917qga.24
        for <linux-media@vger.kernel.org>; Mon, 11 Aug 2014 23:59:40 -0700 (PDT)
Date: Mon, 11 Aug 2014 23:25:21 -0700 (PDT)
From: anuroop.kamu@gmail.com
To: linux-sunxi@googlegroups.com
Cc: linux-media@vger.kernel.org, thomas.schorpp@gmail.com
Message-Id: <ed81b21e-44e4-40db-bfaa-6fbad2b5d7cb@googlegroups.com>
In-Reply-To: <520BC1EF.9030204@gmail.com>
References: <520BC1EF.9030204@gmail.com>
Subject: Re: [PATCH v4 2/2] [stage/sunxi-3.4] Add support for Allwinner
 (DVB/ATSC) Transport Stream Controller(s) (TSC)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_1583_1344234873.1407824721694"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_Part_1583_1344234873.1407824721694
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Wednesday, August 14, 2013 11:14:15 PM UTC+5:30, Thomas Schorpp wrote:
> OK, with the patched fex file and devices.c from
> 
> [linux-sunxi] [PATCH v2 1/1] [sunxi-boards/a20] Add support for Allwinner (DVB/ATSC) Transport Stream Controller(s) (TSC)
> 
> [PATCH v2 1/1] [stage/sunxi-3.4] sw_nand: sunxi devices core using wrong MMIO region range, overlaps TSC/TSI register base address 0x01c04000
> 
> and the driver patches from this topic here
> 
> 

> 
> the driver basically loads and inits:
> 
> 
> 
> [  161.016837] [tsc-inf] tscdev_init: kmalloc memory, size: 0x212000
> 
> [  161.042378] [tsc-dbg] register_tsiomem: check_mem_region return: 0
> 
> [  161.055409] [tsc-dbg] register_tsiomem: devp->regsaddr: 0xf0104000
> 
> 
> 
> root@vdr2:~# cat /proc/iomem |grep -C 1 -i ts
> 
> 01c03000-01c03fff : sw_nand
> 
> 01c04000-01c04fff : ts regs
> 
> 01c0a000-01c0afff : disp
> 
> 
> 
> root@vdr2:~# ls -l /dev/ts*
> 
> crw------- 1 root root 225, 0 Aug 14 19:10 /dev/tsc_dev
> 
> 
> 
> And ioctl() triggers the controller setup successfully.
> 
> 
> 
> root@vdr2:~# dd if=/dev/tsc_dev of=/dev/null bs=1K count=100 &
> 
> 
> 
> [ 1064.861178] [tsc-inf] tscdev_open: ahb_ts clk rate: 0x1
> 
> [ 1064.871506] [tsc-inf] tscdev_open: parent clock rate 384000000
> 
> [ 1064.881674] [tsc-inf] tscdev_open: clock rate 192000000
> 
> [ 1064.891079] [tsc-inf] tscdev_open: clock rate 192000000
> 
> 
> 
> Ready to build the Philips CU1216-MKIII TDA10023 DVB-C- Receiver "recycling" SMT extension board next days.
> 
> Others are invited to build boards with their receiver modules and extend driver Kconfig for more receivers, too.
> 
> 
> 
> Next i2c and frontend driver integration, if someone can do that faster, pls don't wait for me and pls CC linux-media list.
> 
> 
> 
> dvb_core integration after the hardware and driver PIO tests success.
> 
> 
> 
> Thanks for all the great community support :-)
> 
> 
> 
> y
> 
> tom

Hi, I need some help. I am trying to take TS stream input through TS0 Allwinner A20 board by SMDT. 
I have the Fex file info as below.
[tsc_para]
tsc_used                 = 1
tsc_cla                  = port:PE00<2><default><default><default>
tsc_err                  = port:PE01<2><default><default><default>
tsc_sync                 = port:PE02<2><default><default><default>
tsc_dvld                 = port:PE03<2><default><default><default>
tsc_d0                   = port:PE04<2><default><default><default>
tsc_d1                   = port:PE05<2><default><default><default>
tsc_d2                   = port:PE06<2><default><default><default>
tsc_d3                   = port:PE07<2><default><default><default>
tsc_d4                   = port:PE08<2><default><default><default>
tsc_d5                   = port:PE09<2><default><default><default>
tsc_d6                   = port:PE10<2><default><default><default>
tsc_d7                   = port:PE11<2><default><default><default>

Now, with this I get some error when I load the tscdrv.ko.
below are the errors
<6>[  775.488646] [tsc-inf] tscdev_init: kmalloc memory, size: 0x212000
<6>[  775.509833] [tsc-inf] request_tsc_pio: request tsc pio119 failed, maybe error
<6>[  775.509889] [tsc-inf] request_tsc_pio: request tsc pio120 failed, maybe error
<6>[  775.509934] [tsc-inf] request_tsc_pio: request tsc pio121 failed, maybe error
<6>[  775.509979] [tsc-inf] request_tsc_pio: request tsc pio122 failed, maybe error
<6>[  775.510023] [tsc-inf] request_tsc_pio: request tsc pio123 failed, maybe error
<6>[  775.510067] [tsc-inf] request_tsc_pio: request tsc pio124 failed, maybe error
<6>[  775.510112] [tsc-inf] request_tsc_pio: request tsc pio125 failed, maybe error
<6>[  775.510156] [tsc-inf] request_tsc_pio: request tsc pio126 failed, maybe error
<6>[  775.510200] [tsc-inf] request_tsc_pio: request tsc pio127 failed, maybe error
<6>[  775.510245] [tsc-inf] request_tsc_pio: request tsc pio128 failed, maybe error
<6>[  775.510289] [tsc-inf] request_tsc_pio: request tsc pio129 failed, maybe error
<6>[  775.510333] [tsc-inf] request_tsc_pio: request tsc pio130 failed, maybe error
<6>[  775.514859] [tsc-dbg] register_tsiomem: check_mem_region return: 0
<6>[  775.514991] [tsc-dbg] register_tsiomem: devp->regsaddr: 0xf0012000

am I missing something? Do I need to modify the fex file?

please forgive me if my questions are wrong. I am fairly new to android & Allwinner platform.

thanks a lot
Anuroop


------=_Part_1583_1344234873.1407824721694--
