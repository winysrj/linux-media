Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1KGsWhh004725
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 11:54:32 -0500
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1KGs1Ob016696
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 11:54:02 -0500
Message-ID: <47BC5B09.7010709@linuxtv.org>
From: mkrufky@linuxtv.org
To: rgoldwyn@gmail.com
Date: Wed, 20 Feb 2008 11:53:29 -0500
MIME-Version: 1.0
in-reply-to: <20080220061151.GA14798@baloo>
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: NULL pointer dereference while loading saa7133 on 2.6.25-rc2
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

Goldwyn Rodrigues wrote:
> Hi,
>
> I am facing a NULL pointer dereference in the saa7134 driver. I suppose
> the problem occurs because the tda8290_ops or tda8295_ops structure 
> does not have the info field initialized. So, when a strlcpy occurs, 
> it encounters a NULL.
>
>   
Incorrect -- the info structure is initialized as all zeroes, and the 
name field of the info struct is filled during tda829x_attach.  But, it 
doesn't look like the tda829x driver is even being called at all --
> The trace when the module is loaded is below.
>   

Based on saa7134-cards.c , the driver expects to see a tda829x + tda827x 
combo.  However, based on the dmesg shown below, the tda9887 driver is 
successfully attaching to the driver, and it looks like tuner-simple 
should be the module that is crashing, but I don't see it listed in the 
trace

Problem #1, the tda9887 is attaching, but this should be a tda8290.
Problem #2, we don't see what driver is trying to attach to 2-0060, but 
an oops results.

Can you test using the v4l-dvb master branch @linuxtv.org, tell us if 
the problem persists.  If it does, then I'll ask you to test again with 
debug enabled, as follows:

options tuner-simple debug=1
options tda9887 debug=1
options tda8290 debug=1
options tuner debug=1

Regards,

Mike


>
> goldwyn@haathi:~/work/linux-2.6/drivers/media/video> uname -r
> 2.6.25-rc2-default
>
>
>
> ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [APC2] -> GSI 17 (level, low)
-> IRQ 17
> saa7133[0]: found at 0000:01:09.0, rev: 16, irq: 17, latency: 32, mmio:
0xfddfe000
> saa7133[0]: subsystem: 1131:4ee9, board: SKNet MonsterTV Mobile
[card=76,autodetected]
> saa7133[0]: board init: gpio is a00000
> saa7133[0]: i2c eeprom 00: 31 11 e9 4e 08 20 1c 55 43 43 a9 1c 55 43 43 a9
> saa7133[0]: i2c eeprom 10: 00 ff e6 07 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 20: 01 00 02 02 01 3f 02 bf ac 0c 02 01 07 01 02 00
> saa7133[0]: i2c eeprom 30: 00 02 02 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9c
> saa7133[0]: i2c eeprom 80: 31 11 e9 4e 08 20 1c 55 43 43 a9 1c 55 43 43 a9
> saa7133[0]: i2c eeprom 90: 00 ff e6 07 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom a0: 01 00 02 02 01 3f 02 bf ac 0c 02 01 07 01 02 00
> saa7133[0]: i2c eeprom b0: 00 02 02 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9c
> tuner' 2-0043: chip found @ 0x86 (saa7133[0])
> tda9887 2-0043: tda988[5/6/7] found
> All bytes are equal. It is not a TEA5767
> tuner' 2-0060: chip found @ 0xc0 (saa7133[0])
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff802fdd04>] strlcpy+0xd/0x31
> PGD 3b876067 PUD 3bd51067 PMD 0 
> Oops: 0000 [1] SMP 
> CPU 1 
> Modules linked in: tuner(+) tea5767 tda8290 tda827x tuner_xc2028
firmware_class tda9887 tuner_simple mt20xx tea5761 saa7134(+) snd_hda_intel
compat_ioctl32 rtc_cmos rtc_core videodev v4l1_compat snd_pcm v4l2_common
parport_pc floppy parport snd_timer videobuf_dma_sg rtc_lib videobuf_core
k8temp snd ir_kbd_i2c hwmon ir_common soundcore snd_page_alloc ohci1394
tveeprom forcedeth sr_mod ieee1394 cdrom i2c_nforce2 i2c_core button sg ext2
mbcache ehci_hcd ohci_hcd usbcore sd_mod amd74xx ide_core edd fan sata_nv
pata_amd libata scsi_mod thermal processor
> Pid: 2076, comm: modprobe Not tainted 2.6.25-rc2-default #1
> RIP: 0010:[<ffffffff802fdd04>]  [<ffffffff802fdd04>] strlcpy+0xd/0x31
> RSP: 0018:ffff81003c49fb90  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ffffffff88335a0f RCX: ffffffffffffffff
> RDX: 0000000000000014 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff81003c9b6400 R08: ffff81003b430804 R09: ffff81003763b268
> R10: ffff810001005b18 R11: 0000000000000000 R12: ffff81003b430800
> R13: 0000000000000036 R14: 0000000000000004 R15: ffffffff883aa6ec
> FS:  00007f31d48096f0(0000) GS:ffff81003d8400c0(0000)
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000003d052000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process modprobe (pid: 2076, threadinfo ffff81003c49e000, task
ffff81003763b000)
> Stack:  ffffffff883a9ffa ffff81003b1a2b90 ffff81003bdde248
0000000000000000
>  ffffffff802d107c ffff81003c9b6730 ffffffff88335a0f 0000000000000000
>  ffff81003b430828 ffff81003b430890 ffffffff803fd48e 0000000000000000
> Call Trace:
>  [<ffffffff883a9ffa>] ? :tuner:set_type+0x41f/0x710
>  [<ffffffff802d107c>] ? sysfs_create_link+0xb6/0x102
>  [<ffffffff88335a0f>] ? :saa7134:saa7134_tuner_callback+0x0/0xcc
>  [<ffffffff803fd48e>] ? klist_node_init+0x31/0x4e
>  [<ffffffff883aacaf>] ? :tuner:tuner_command+0x1f6/0xfe7
>  [<ffffffff802faec9>] ? kobject_get+0x12/0x17
>  [<ffffffff88335e2e>] ? :saa7134:attach_inform+0x16c/0x1a7
>  [<ffffffff88335a0f>] ? :saa7134:saa7134_tuner_callback+0x0/0xcc
>  [<ffffffff88156e1d>] ? :i2c_core:i2c_attach_client+0xfb/0x138
>  [<ffffffff88270328>] ? :v4l2_common:v4l2_i2c_attach+0x6b/0x8b
>  [<ffffffff883aa35a>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x1a
>  [<ffffffff88156aeb>] ? :i2c_core:i2c_probe_address+0xb9/0xfd
>  [<ffffffff88157769>] ? :i2c_core:i2c_probe+0x162/0x175
>  [<ffffffff883aa35a>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x1a
>  [<ffffffff8815709d>] ? :i2c_core:i2c_register_driver+0xa3/0xf3
>  [<ffffffff880d9082>] ? :tuner:v4l2_i2c_drv_init+0x82/0xf5
>  [<ffffffff80250bf6>] ? sys_init_module+0x18fd/0x1a02
>  [<ffffffff88156b75>] ? :i2c_core:i2c_master_send+0x0/0x43
>  [<ffffffff8028b6cd>] ? vfs_read+0xaa/0x132
>  [<ffffffff8020be9b>] ? system_call_after_swapgs+0x7b/0x80
>
>
> Code: 01 c1 48 89 c1 4c 29 c2 48 39 d0 72 04 48 8d 4a ff fc 4c 89 cf 4c 01
c0 f3 a4 c6 07 00 c3 fc 31 c0 48 83 c9 ff 49 89 f8 48 89 f7 <f2> ae 48 85 d2
48 f7 d1 48 8d 41 ff 74 15 48 39 d0 48 89 c1 72 
> RIP  [<ffffffff802fdd04>] strlcpy+0xd/0x31
>  RSP <ffff81003c49fb90>
> CR2: 0000000000000000
> ---[ end trace 2d9c963cbc0a490e ]---
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
>
>
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
