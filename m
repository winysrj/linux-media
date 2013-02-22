Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:60494 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3BVMA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Feb 2013 07:00:59 -0500
Message-ID: <51275DF7.4010600@gmail.com>
Date: Fri, 22 Feb 2013 20:00:55 +0800
From: Lonsn <lonsn2005@gmail.com>
MIME-Version: 1.0
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: SMDKV210 support issue in kernel 3.8 (dma-pl330 and HDMI failed)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I have tested the kernel 3.8 with a SMDKV210 like board. But I failed 
with dma-pl330 and HDMI driver.
For dma-pl330, kernel print:
dma-pl330 dma-pl330.0: PERIPH_ID 0x0, PCELL_ID 0x0 !
dma-pl330: probe of dma-pl330.0 failed with error -22
dma-pl330 dma-pl330.1: PERIPH_ID 0x0, PCELL_ID 0x0 !
dma-pl330: probe of dma-pl330.1 failed with error -22

For HDMI driver,
I have added the following HDMI related code to 
arch/arm/mach-s5pv210/mach-smdkv210.c:
/* I2C module and id for HDMIPHY */
static struct i2c_board_info hdmiphy_info = {
         I2C_BOARD_INFO("hdmiphy-s5pv210", 0x38),
};

        i2c_register_board_info(2, smdkv210_i2c_devs2,
                         ARRAY_SIZE(smdkv210_i2c_devs2));

         s5p_i2c_hdmiphy_set_platdata(NULL);
         s5p_hdmi_set_platdata(&hdmiphy_info, NULL, 0);

         s3c_ide_set_platdata(&smdkv210_ide_pdata);

then kernel print:
s5p-hdmi s5pv210-hdmi: hdmiphy adapter request failed
s5p-hdmi s5pv210-hdmi: probe failed
Samsung TV Mixer driver, (c) 2010-2011 Samsung Electronics Co., Ltd.

s5p-mixer s5p-mixer: probe start
s5p-mixer s5p-mixer: resources acquired
s5p-mixer s5p-mixer: module s5p-hdmi provides no subdev!
s5p-mixer s5p-mixer: module s5p-sdo provides no subdev!
s5p-mixer s5p-mixer: failed to register any output
s5p-mixer s5p-mixer: probe failed

Can anybody help me on how to config the HDMI output function in linux 
kernel 3.8? I mainly want to do video hardware decode using s5pv210 MFC 
and then display with HDMI.

Thanks!

The followings are full kernel boot info:
Starting kernel ...

Uncompressing Linux... done, booting the kernel.
Booting Linux on physical CPU 0x0
Linux version 3.8.0-dirty (lonsn@lonsn-laptop) (gcc version 4.4.1 
(Sourcery G++ Lite 2009q3-67) ) #14 PREEMPT Thu Feb 21 21:21:41 CST 2013
CPU: ARMv7 Processor [412fc082] revision 2 (ARMv7), cr=10c53c7d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine: SMDKV210
Memory policy: ECC disabled, Data cache writeback
CPU S5PV210/S5PC110 (id 0x43110220)
S3C24XX Clocks, Copyright 2004 Simtec Electronics
S5PV210: PLL settings, A=1000000000, M=667000000, E=80000000 V=54000000
S5PV210: ARMCLK=1000000000, HCLKM=200000000, HCLKD=166750000
HCLKP=133400000, PCLKM=100000000, PCLKD=83375000, PCLKP=66700000
sclk_dmc: source is sclk_a2m (0), rate is 200000000
sclk_onenand: source is hclk_dsys (1), rate is 166750000
sclk_fimc: source is ext_xtal (0), rate is 24000000
sclk_fimc: source is ext_xtal (0), rate is 24000000
sclk_fimc: source is ext_xtal (0), rate is 24000000
sclk_cam0: source is ext_xtal (0), rate is 24000000
sclk_cam1: source is ext_xtal (0), rate is 24000000
sclk_fimd: source is ext_xtal (0), rate is 24000000
sclk_mfc: source is sclk_a2m (0), rate is 200000000
sclk_g2d: source is sclk_a2m (0), rate is 200000000
sclk_g3d: source is sclk_a2m (0), rate is 200000000
sclk_csis: source is ext_xtal (0), rate is 24000000
sclk_pwi: source is ext_xtal (0), rate is 24000000
sclk_pwm: source is ext_xtal (0), rate is 24000000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128016
Kernel command line: console=ttySAC2,115200 init=/linuxrc root=/dev/nfs 
ip=192.168.2.20:192.168.2.200:192.168.2.1:255.255.255.0:L210::off 
nfsroot=192.168.2.200:/home/lonsn/work/s5pv210/nfs,v3 rw rootwait 
enable_wait_mode=off
PID hash table entries: 2048 (order: 1, 8192 bytes)
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
__ex_table already sorted, skipping sort
Memory: 256MB 48MB 200MB = 504MB total
Memory: 506400k/514592k available, 9696k reserved, 0K highmem
Virtual kernel memory layout:
     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
     vmalloc : 0xb0800000 - 0xff000000   (1256 MB)
     lowmem  : 0x80000000 - 0xb0000000   ( 768 MB)
     modules : 0x7f000000 - 0x80000000   (  16 MB)
       .text : 0x80008000 - 0x80466414   (4474 kB)
       .init : 0x80467000 - 0x80487884   ( 131 kB)
       .data : 0x80488000 - 0x804c3760   ( 238 kB)
        .bss : 0x804c3760 - 0x804faa48   ( 221 kB)
SLUB: Genslabs=11, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:208
VIC @f6000000: id 0x00041192, vendor 0x41
VIC @f6010000: id 0x00041192, vendor 0x41
VIC @f6020000: id 0x00041192, vendor 0x41
VIC @f6030000: id 0x00041192, vendor 0x41
sched_clock: 32 bits at 33MHz, resolution 29ns, wraps every 128784ms
Console: colour dummy device 80x30
Calibrating delay loop... 663.55 BogoMIPS (lpj=1658880)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
Setting up static identity map for 0x2034e1a8 - 0x2034e200
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
S3C Power Management, Copyright 2004 Simtec Electronics
S5PV210: Initializing architecture
bio: create slab <bio-0> at 0
SCSI subsystem initialized
s3c-i2c s3c2440-i2c.0: slave address 0x10
s3c-i2c s3c2440-i2c.0: bus frequency set to 65 KHz
s3c-i2c s3c2440-i2c.0: i2c-0: S3C I2C adapter
s3c-i2c s3c2440-i2c.1: slave address 0x10
s3c-i2c s3c2440-i2c.1: bus frequency set to 65 KHz
s3c-i2c s3c2440-i2c.1: i2c-1: S3C I2C adapter
s3c-i2c s3c2440-i2c.2: slave address 0x10
s3c-i2c s3c2440-i2c.2: bus frequency set to 65 KHz
s3c-i2c s3c2440-i2c.2: i2c-2: S3C I2C adapter
Linux video capture interface: v2.00
Advanced Linux Sound Architecture Driver Initialized.
Switching to clocksource s5p_clocksource_timer
NET: Registered protocol family 2
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 4, 81920 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP: reno registered
UDP hash table entries: 256 (order: 1, 12288 bytes)
UDP-Lite hash table entries: 256 (order: 1, 12288 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
NFS: Registering the id_resolver key type
Key type id_resolver registered
Key type id_legacy registered
ROMFS MTD (C) 2007 Red Hat, Inc.
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
s3c-fb s5pv210-fb: window 0: fb
dma-pl330 dma-pl330.0: PERIPH_ID 0x0, PCELL_ID 0x0 !
dma-pl330: probe of dma-pl330.0 failed with error -22
dma-pl330 dma-pl330.1: PERIPH_ID 0x0, PCELL_ID 0x0 !
dma-pl330: probe of dma-pl330.1 failed with error -22
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
s5pv210-uart.0: ttySAC0 at MMIO 0xe2900000 (irq = 74) is a S3C6400/10
s5pv210-uart.1: ttySAC1 at MMIO 0xe2900400 (irq = 75) is a S3C6400/10
s5pv210-uart.2: ttySAC2 at MMIO 0xe2900800 (irq = 76) is a S3C6400/10
console [ttySAC2] enabled
s5pv210-uart.3: ttySAC3 at MMIO 0xe2900c00 (irq = 77) is a S3C6400/10
brd: module loaded
loop: module loaded
dm9000 Ethernet Driver, V1.31
eth0: dm9000a at b09da300,b09dc30c IRQ 41 MAC: 00:09:c0:ff:ec:48 
(platform data)
mousedev: PS/2 mouse device common for all mice
i2c /dev entries driver
m2m-testdev m2m-testdev.0: mem2mem-testdevDevice registered as /dev/video0
s5p-jpeg s5p-jpeg.0: encoder device registered as /dev/video1
s5p-jpeg s5p-jpeg.0: decoder device registered as /dev/video2
s5p-jpeg s5p-jpeg.0: Samsung S5P JPEG codec
s5p-mfc s5p-mfc: decoder registered as /dev/video3
s5p-mfc s5p-mfc: encoder registered as /dev/video4
s5p-hdmi s5pv210-hdmi: hdmiphy adapter request failed
s5p-hdmi s5pv210-hdmi: probe failed
Samsung TV Mixer driver, (c) 2010-2011 Samsung Electronics Co., Ltd.

s5p-mixer s5p-mixer: probe start
s5p-mixer s5p-mixer: resources acquired
s5p-mixer s5p-mixer: module s5p-hdmi provides no subdev!
s5p-mixer s5p-mixer: module s5p-sdo provides no subdev!
s5p-mixer s5p-mixer: failed to register any output
s5p-mixer s5p-mixer: probe failed
samsung-ac97 samsung-ac97: ac97 failed to get ac97_clock
soc-audio soc-audio: ASoC: machine SMDK WM9713 should use 
snd_soc_register_card()
soc-audio soc-audio: ASoC: CPU DAI samsung-ac97 not registered
platform soc-audio: Driver soc-audio requests probe deferral
TCP: cubic registered
NET: Registered protocol family 17
Key type dns_resolver registered
VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 2
soc-audio: probe of soc-audio failed with error -22
dm9000 dm9000 eth0: link up, 100Mbps, full-duplex, lpa 0xCDE1
IP-Config: Complete:
      device=eth0, hwaddr=00:09:c0:ff:ec:48, ipaddr=192.168.2.20, 
mask=255.255.255.0, gw=192.168.2.1
      host=L210, domain=, nis-domain=(none)
      bootserver=192.168.2.200, rootserver=192.168.2.200, rootpath=
ALSA device list:
   No soundcards found.
VFS: Mounted root (nfs filesystem) on device 0:9.
Freeing init memory: 128K
Failed to execute /linuxrc.  Attempting defaults...
init: ureadahead main process (1031) terminated with status 5

Last login: Thu Jan  1 00:00:16 UTC 1970 on tty1
root@linaro-developer:~#

