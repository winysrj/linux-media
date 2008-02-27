Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1R0nbj7016416
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 19:49:37 -0500
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1R0mxL4020089
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 19:48:59 -0500
Message-ID: <47C4B371.1050209@linuxtv.org>
Date: Tue, 26 Feb 2008 19:48:49 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Goldwyn Rodrigues <rgoldwyn@gmail.com>
References: <20080220061151.GA14798@baloo> <47BC5B09.7010709@linuxtv.org>
	<241c7a2b0802260708l3773ba8o503a4d72250a3b54@mail.gmail.com>
In-Reply-To: <241c7a2b0802260708l3773ba8o503a4d72250a3b54@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] NULL pointer dereference while
 loading	saa7133 on 2.6.25-rc2
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
> Hi Mike,
>
> On Wed, Feb 20, 2008 at 10:23 PM,  <mkrufky@linuxtv.org> wrote:
>   
>> Goldwyn Rodrigues wrote:
>>  > Hi,
>>  >
>>  > I am facing a NULL pointer dereference in the saa7134 driver. I suppose
>>  > the problem occurs because the tda8290_ops or tda8295_ops structure
>>  > does not have the info field initialized. So, when a strlcpy occurs,
>>  > it encounters a NULL.
>>  >
>>  >
>>  Incorrect -- the info structure is initialized as all zeroes, and the
>>  name field of the info struct is filled during tda829x_attach.  But, it
>>  doesn't look like the tda829x driver is even being called at all --
>>
>>     
>>> The trace when the module is loaded is below.
>>>       
>>  >
>>
>>  Based on saa7134-cards.c , the driver expects to see a tda829x + tda827x
>>  combo.  However, based on the dmesg shown below, the tda9887 driver is
>>  successfully attaching to the driver, and it looks like tuner-simple
>>  should be the module that is crashing, but I don't see it listed in the
>>  trace
>>
>>  Problem #1, the tda9887 is attaching, but this should be a tda8290.
>>  Problem #2, we don't see what driver is trying to attach to 2-0060, but
>>  an oops results.
>>
>>  Can you test using the v4l-dvb master branch @linuxtv.org, tell us if
>>     
>
> Yes the problem happened again with the branch from linuxtv.org
>
>   
>>  the problem persists.  If it does, then I'll ask you to test again with
>>  debug enabled, as follows:
>>
>>  options tuner-simple debug=1
>>  options tda9887 debug=1
>>  options tda8290 debug=1
>>  options tuner debug=1
>>
>>     
>
> The complete log follows:
>
> Linux version 2.6.25-rc3-default (goldwyn@haathi) (gcc version 4.2.1
> (SUSE Linux)) #3 SMP Tue Feb 26 17:52:49 IST 2008
> Command line: root=/dev/sda7 vga=0x317 resume=/dev/sda6 splash=silent
>
> <snipped>
> Uniform CD-ROM driver Revision: 3.20
> sr 3:0:0:0: Attached scsi CD-ROM sr0
> rtc_cmos: probe of 00:05 failed with error -16
> Linux video capture interface: v2.00
> saa7130/34: v4l2 driver version 0.2.14 loaded
> forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:1d:60:40:3d:c0
> forcedeth 0000:00:14.0: highdma pwrctl timirq gbit lnktim desc-v3
> ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI 22 (level,
> low) -> IRQ 22
> PCI: Setting latency timer of device 0000:00:10.1 to 64
> ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
> ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [APC2] -> GSI 17 (level,
> low) -> IRQ 17
> saa7133[0]: found at 0000:01:09.0, rev: 16, irq: 17, latency: 32,
> mmio: 0xfddfe000
> saa7133[0]: subsystem: 1131:4ee9, board: SKNet MonsterTV Mobile
> [card=76,autodetected]
> saa7133[0]: board init: gpio is a00000
> ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d800016eccd7]
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
> tuner' 2-0043: type set to tda9887
> tuner' 2-0043: tv freq set to 0.00
> tuner' 2-0043: TV freq (0.00) out of range (44-958)
> tda9887 2-0043: Unsupported tvnorm entry - audio muted
> tda9887 2-0043: writing: b=0xc0 c=0x00 e=0x00
> tuner' 2-0043: saa7133[0] tuner' I2C addr 0x86 with type 74 used for 0x0e
> tuner' 2-0043: Calling set_type_addr for type=54, addr=0xff,
> mode=0x04, config=0x00
> tuner' 2-0043: set addr for type 74
> All bytes are equal. It is not a TEA5767
> tuner' 2-0060: Setting mode_mask to 0x0e
> tuner' 2-0060: chip found @ 0xc0 (saa7133[0])
> tuner' 2-0060: tuner 0x60: Tuner type absent
> tuner' 2-0060: Calling set_type_addr for type=54, addr=0xff,
> mode=0x04, config=0x00
> tuner' 2-0060: set addr for type -1
> tuner' 2-0060: defining GPIO callback
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff802fdd90>] strlcpy+0xd/0x31
> PGD 37560067 PUD 3b079067 PMD 0
> Oops: 0000 [1] SMP
> CPU 0
> Modules linked in: tuner(+) tea5767 tda8290 tda18271 tda827x
> tuner_xc2028 xc5000 firmware_class tda9887 tuner_simple tuner_types
> mt20xx tea5761 saa7134(+) compat_ioctl32 videodev snd_hda_intel(+)
> v4l1_compat v4l2_common videobuf_dma_sg rtc_cmos videobuf_core
> rtc_core sr_mod floppy parport_pc ir_kbd_i2c parport forcedeth snd_pcm
> snd_timer k8temp rtc_lib hwmon ohci1394 snd ir_common soundcore
> ieee1394 tveeprom cdrom snd_page_alloc button i2c_nforce2 i2c_core sg
> ext2 mbcache ehci_hcd ohci_hcd usbcore sd_mod amd74xx ide_core edd fan
> sata_nv pata_amd libata scsi_mod thermal processor
> Pid: 2075, comm: modprobe Not tainted 2.6.25-rc3-default #3
> RIP: 0010:[<ffffffff802fdd90>]  [<ffffffff802fdd90>] strlcpy+0xd/0x31
> RSP: 0018:ffff81003d0edb90  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ffffffff883357bf RCX: ffffffffffffffff
> RDX: 0000000000000014 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff81003b568c00 R08: ffff81003759c804 R09: ffff810037644a58
> R10: ffff810001011b18 R11: ffffffffffffffff R12: ffff81003759c800
> R13: 0000000000000036 R14: 0000000000000004 R15: ffffffff883c96a5
> FS:  00007f83655b56f0(0000) GS:ffffffff80509000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000003cd7e000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process modprobe (pid: 2075, threadinfo ffff81003d0ec000, task ffff8100376447f0)
> Stack:  ffffffff883c8fbc ffff8100375cc7d0 ffff81003b02c248 0000000000000000
>  ffffffff802d1108 ffff81003b568f30 ffffffff883357bf 0000000000000000
>  ffff81003759c828 ffff81003759c890 ffffffff803fd356 0000000000000000
> Call Trace:
>  [<ffffffff883c8fbc>] ? :tuner:set_type+0x419/0x701
>  [<ffffffff802d1108>] ? sysfs_create_link+0xb6/0x102
>  [<ffffffff883357bf>] ? :saa7134:saa7134_tuner_callback+0x0/0x16e
>  [<ffffffff803fd356>] ? klist_node_init+0x31/0x4e
>  [<ffffffff883c9c68>] ? :tuner:tuner_command+0x1f6/0xfe6
>  [<ffffffff802faf55>] ? kobject_get+0x12/0x17
>  [<ffffffff88336f7e>] ? :saa7134:attach_inform+0x16c/0x1a7
>  [<ffffffff883357bf>] ? :saa7134:saa7134_tuner_callback+0x0/0x16e
>  [<ffffffff8814fe1d>] ? :i2c_core:i2c_attach_client+0xfb/0x138
>  [<ffffffff8829f328>] ? :v4l2_common:v4l2_i2c_attach+0x6b/0x8b
>  [<ffffffff883c9313>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x1a
>  [<ffffffff8814faeb>] ? :i2c_core:i2c_probe_address+0xb9/0xfd
>  [<ffffffff88150769>] ? :i2c_core:i2c_probe+0x162/0x175
>  [<ffffffff883c9313>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x1a
>  [<ffffffff8815009d>] ? :i2c_core:i2c_register_driver+0xa3/0xf3
>  [<ffffffff880da082>] ? :tuner:v4l2_i2c_drv_init+0x82/0xf5
>  [<ffffffff80250c7e>] ? sys_init_module+0x18fd/0x1a02
>  [<ffffffff8814fb75>] ? :i2c_core:i2c_master_send+0x0/0x43
>  [<ffffffff8028b759>] ? vfs_read+0xaa/0x132
>  [<ffffffff8020be9b>] ? system_call_after_swapgs+0x7b/0x80
>
>
> Code: 01 c1 48 89 c1 4c 29 c2 48 39 d0 72 04 48 8d 4a ff fc 4c 89 cf
> 4c 01 c0 f3 a4 c6 07 00 c3 fc 31 c0 48 83 c9 ff 49 89 f8 48 89 f7 <f2>
> ae 48 85 d2 48 f7 d1 48 8d 41 ff 74 15 48 39 d0 48 89 c1 72
> RIP  [<ffffffff802fdd90>] strlcpy+0xd/0x31
>  RSP <ffff81003d0edb90>
> CR2: 0000000000000000
> ---[ end trace e299e9653aac288b ]---
> tuner' 2-0043: switching to v4l2
> tuner' 2-0060: switching to v4l2
> tuner' 2-0060: tv freq set to 400.00
> tuner' 2-0060: Tuner has no way to set tv freq
> tuner' 2-0060: tv freq set to 400.00
> tuner' 2-0060: Tuner has no way to set tv freq
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> tuner' 2-0043: Cmd TUNER_SET_STANDBY accepted for analog TV
> tda9887 2-0043: Unsupported tvnorm entry - audio muted
> tda9887 2-0043: writing: b=0xe0 c=0x00 e=0x00
> tuner' 2-0060: Cmd TUNER_SET_STANDBY accepted for analog TV
> Adding 1534168k swap on /dev/sda6.  Priority:-1 extents:1 across:1534168k
> device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
> loop: module loaded
> powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4000+
> processors (2 cpu cores) (version 2.20.00)
> powernow-k8: MP systems not supported by PSB BIOS structure
> powernow-k8: MP systems not supported by PSB BIOS structure
>
> <snipped again>
>
> Regards,
>
>   
I'm sorry -- I should have been more specific.

Can you test using a stable, released kernel (such as 2.6.24 or anything
earlier) PLUS the v4l-dvb tree on linuxtv.org


I just want to make sure that the bug is specific to v4l-dvb, or whether
it was caused by something else broken upstream.

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
