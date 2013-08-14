Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:41165 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368Ab3HNRoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Aug 2013 13:44:18 -0400
Received: by mail-qc0-f172.google.com with SMTP id a1so5083481qcx.31
        for <linux-media@vger.kernel.org>; Wed, 14 Aug 2013 10:44:18 -0700 (PDT)
Message-ID: <520BC1EF.9030204@gmail.com>
Date: Wed, 14 Aug 2013 19:44:15 +0200
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com
CC: linux-media@vger.kernel.org
Subject: [PATCH v4 2/2] [stage/sunxi-3.4] Add support for Allwinner (DVB/ATSC)
 Transport Stream Controller(s) (TSC)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, with the patched fex file and devices.c from
[linux-sunxi] [PATCH v2 1/1] [sunxi-boards/a20] Add support for Allwinner (DVB/ATSC) Transport Stream Controller(s) (TSC)
[PATCH v2 1/1] [stage/sunxi-3.4] sw_nand: sunxi devices core using wrong MMIO region range, overlaps TSC/TSI register base address 0x01c04000
and the driver patches from this topic here

the driver basically loads and inits:

[  161.016837] [tsc-inf] tscdev_init: kmalloc memory, size: 0x212000
[  161.042378] [tsc-dbg] register_tsiomem: check_mem_region return: 0
[  161.055409] [tsc-dbg] register_tsiomem: devp->regsaddr: 0xf0104000

root@vdr2:~# cat /proc/iomem |grep -C 1 -i ts
01c03000-01c03fff : sw_nand
01c04000-01c04fff : ts regs
01c0a000-01c0afff : disp

root@vdr2:~# ls -l /dev/ts*
crw------- 1 root root 225, 0 Aug 14 19:10 /dev/tsc_dev

And ioctl() triggers the controller setup successfully.

root@vdr2:~# dd if=/dev/tsc_dev of=/dev/null bs=1K count=100 &

[ 1064.861178] [tsc-inf] tscdev_open: ahb_ts clk rate: 0x1
[ 1064.871506] [tsc-inf] tscdev_open: parent clock rate 384000000
[ 1064.881674] [tsc-inf] tscdev_open: clock rate 192000000
[ 1064.891079] [tsc-inf] tscdev_open: clock rate 192000000

Ready to build the Philips CU1216-MKIII TDA10023 DVB-C- Receiver "recycling" SMT extension board next days.
Others are invited to build boards with their receiver modules and extend driver Kconfig for more receivers, too.

Next i2c and frontend driver integration, if someone can do that faster, pls don't wait for me and pls CC linux-media list.

dvb_core integration after the hardware and driver PIO tests success.

Thanks for all the great community support :-)

y
tom

