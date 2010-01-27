Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2543 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab0A0LOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 06:14:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dmitri Belimov <d.belimov@gmail.com>
Subject: Re: saa7134 and =?iso-8859-1?q?=C3=8E=C2=BCPD61151_MPEG2?= coder
Date: Wed, 27 Jan 2010 12:14:00 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <20091007101142.3b83dbf2@glory.loctelecom.ru> <201001130838.23949.hverkuil@xs4all.nl> <20100127143637.26465503@glory.loctelecom.ru>
In-Reply-To: <20100127143637.26465503@glory.loctelecom.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001271214.01837.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitri,

Just a quick note: the video4linux mailinglist is obsolete, just use linux-media.

On Wednesday 27 January 2010 06:36:37 Dmitri Belimov wrote:
> Hi Hans.
> 
> I finished saa7134 part of SPI. Please review saa7134-spi.c and diff saa7134-core and etc.
> I wrote config of SPI to board structure. Use this config for register master and slave devices.
> 
> SPI other then I2C, do not need call request_module. Udev do it. 
> I spend 10 days for understanding :(  

I'm almost certain that spi works the same way as i2c and that means that you
must call request_module. Yes, udev will load it for you, but that is a delayed
load: i.e. the module may not be loaded when we need it. The idea behind this
is that usually i2c or spi modules are standalone, but in the context of v4l
such modules are required to be present before the bridge can properly configure
itself.

The easiest way to ensure the correct load sequence is to do a request_module
at the start.

Now, I haven't compiled this, but I think this will work:

struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
               struct spi_master *master, struct spi_board_info *info)
{
	struct v4l2_subdev *sd = NULL;
        struct spi_device *spi;
	
	BUG_ON(!v4l2_dev);

	if (module_name)
        	request_module(module_name);

	spi = spi_new_device(master, info);

	if (spi == NULL || spi->dev.driver == NULL)
		goto error;

       if (!try_module_get(spi->dev.driver->owner))
               goto error;

       sd = spi_get_drvdata(spi);

       /* Register with the v4l2_device which increases the module's
          use count as well. */

       if (v4l2_device_register_subdev(v4l2_dev, sd))
               sd = NULL;

       /* Decrease the module use count to match the first try_module_get. */
       module_put(spi->dev.driver->owner);

error:
       /* If we have a client but no subdev, then something went wrong and
          we must unregister the client. */

       if (spi && sd == NULL)
               spi_unregister_device(spi);

       return sd;
}
EXPORT_SYMBOL_GPL(v4l2_spi_new_subdev);

Note that you mixed up the spi master and spi client in your original code. So
it is no wonder you experienced crashes.

Also note that there is no need for a separate v4l2_spi_new_subdev_board function.

And in v4l2_spi_subdev_init() you should use spi_set_drvdata instead of
dev_set_drvdata.

I hope this helps.

Regards,

	Hans

> 
> I need help with v4l2-common.c -> function v4l2_spi_new_subdev_board
> The module of SPI slave loading after some time and spi device hasn't v4l2_subdev structure
> for v4l2_device_register_subdev.
> 
> Now I get kernel crash when call v4l2_device_register_subdev.
> 
> Need use a callback metod or other. I don't know.
> 
> Copy to Mauro Carvalho Chehab and mailing lists for review my code too.
> 
> Dmesg log without call v4l2_device_register_subdev.
> [    4.742279] Linux video capture interface: v2.00
> [    4.816171] saa7130/34: v4l2 driver version 0.2.15 loaded
> [    4.816253] saa7134 0000:04:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [    4.816304] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 19, latency: 32, mmio: 0xe5100000
> [    4.816363] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7 [card=171,autodetected]
> [    4.816430] saa7133[0]: board init: gpio is 200000
> [    4.816481] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [    4.976010] saa7133[0]: i2c eeprom 00: ce 5a 95 75 54 20 00 00 00 00 00 00 00 00 00 01
> [    4.976635] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.977231] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.977827] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.978423] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.979019] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.979615] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.980223] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.980820] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.981416] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.982012] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.982608] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.983204] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.983800] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.984437] saa7133[0]: i2c eeprom e0: 00 00 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
> [    4.985033] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
> [    5.008041] tuner 1-0061: chip found @ 0xc2 (saa7133[0])
> [    5.024036] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    5.024109] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [    5.066725] xc5000 1-0061: creating new instance
> [    5.076009] xc5000: Successfully identified at address 0x61
> [    5.076060] xc5000: Firmware has not been loaded previously
> 
> [   33.381216] saa7134 0000:04:01.0: spi master registered: bus_num=32766 num_chipselect=1
> [   33.381274] saa7133[0]: found muPD61151 MPEG encoder
> [   33.381430] saa7133[0]: registered device video0 [v4l2]
> [   33.381491] saa7133[0]: registered device vbi0
> [   33.381551] saa7133[0]: registered device radio0
> [   33.406256] saa7133[0]: registered device video1 [mpeg]
> [   33.407628] upd61151_probe function
> [   33.407672] Read test REG 0xD8 :
> [   33.409502] REG = 0x0
> [   33.409547] Write test 0x03 to REG 0xD8 :
> [   33.411353] Next read test REG 0xD8 :
> [   33.413176] REG = 0x3
> [   33.431308] saa7134 ALSA driver for DMA sound loaded
> [   33.431363] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   33.431425] saa7133[0]/alsa: saa7133[0] at 0xe5100000 irq 19 registered as card -1
> 
> [   48.657067] xc5000: I2C write failed (len=4)
> [   48.760018] xc5000: I2C write failed (len=4)
> [   48.762960] xc5000: I2C read failed
> [   48.763011] xc5000: I2C read failed
> [   48.763054] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
> [   48.763102] saa7134 0000:04:01.0: firmware: requesting dvb-fe-xc5000-1.6.114.fw
> [   48.802473] xc5000: firmware read 12401 bytes.
> [   48.802477] xc5000: firmware uploading...
> [   49.328504] eth0: no IPv6 routers present
> [   52.132007] xc5000: firmware upload complete...
> [   53.366772] ------------[ cut here ]------------
> [   53.366820] kernel BUG at lib/kernel_lock.c:126!
> [   53.366865] invalid opcode: 0000 [#1] SMP 
> [   53.366973] last sysfs file: /sys/class/firmware/0000:04:01.0/loading
> [   53.367019] Modules linked in: ipv6 dm_snapshot dm_mirror dm_region_hash dm_log dm_mod loop saa7134_alsa upd61151 saa7134_empress ir_kbd_i2c snd_hda_codec_realtek xc5000 snd_hda_intel snd_hda_codec tuner snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq saa7134 snd_timer ir_common v4l2_common videodev snd_seq_device v4l1_compat videobuf_dma_sg videobuf_core spi_bitbang psmouse snd ir_core serio_raw tveeprom soundcore parport_pc parport processor i2c_i801 button snd_page_alloc i2c_core intel_agp agpgart rng_core pcspkr evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic ata_piix libata scsi_mod ide_pci_generic ide_core ehci_hcd uhci_hcd r8169 mii usbcore thermal fan thermal_sys [last unloaded: scsi_wait_scan]
> [   53.369624] 
> [   53.369666] Pid: 2659, comm: hald-probe-vide Not tainted (2.6.30.5 #1) G31M-ES2L
> [   53.369721] EIP: 0060:[<c02f81e3>] EFLAGS: 00010286 CPU: 0
> [   53.369770] EIP is at unlock_kernel+0xd/0x24
> [   53.369814] EAX: f6bc26ac EBX: f6bc2000 ECX: f6bc26ac EDX: f707e4d0
> [   53.369860] ESI: 00000000 EDI: f6aa90c0 EBP: f6bc26ac ESP: f65b1e68
> [   53.369906]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   53.369952] Process hald-probe-vide (pid: 2659, ti=f65b0000 task=f707e4d0 task.ti=f65b0000)
> [   53.370008] Stack:
> [   53.370049]  f873e9c9 00000000 f687c804 f6aa90c0 00000000 f848e309 00000000 f6b4d680
> [   53.370298]  f6b4d680 c0190049 f6aa90c0 f6a144e4 00000000 f6aa90c0 00000000 f6a144e4
> [   53.370298]  c018ff24 c018c3b9 f701ef40 f6d11a5c f6aa90c0 f65b1f0c f65b1f0c 00008001
> [   53.370298] Call Trace:
> [   53.370298]  [<f873e9c9>] ? ts_open+0x8c/0x93 [saa7134_empress]
> [   53.370298]  [<f848e309>] ? v4l2_open+0x65/0x78 [videodev]
> [   53.370298]  [<c0190049>] ? chrdev_open+0x125/0x13c
> [   53.370298]  [<c018ff24>] ? chrdev_open+0x0/0x13c
> [   53.370298]  [<c018c3b9>] ? __dentry_open+0x119/0x208
> [   53.370298]  [<c018c539>] ? nameidata_to_filp+0x29/0x3c
> [   53.370298]  [<c0197338>] ? do_filp_open+0x41e/0x7bc
> [   53.370298]  [<c017bb3c>] ? handle_mm_fault+0x294/0x5fd
> [   53.370298]  [<c019e267>] ? alloc_fd+0x52/0xb8
> [   53.370298]  [<c018c1d1>] ? do_sys_open+0x44/0xb4
> [   53.370298]  [<c018c285>] ? sys_open+0x1e/0x23
> [   53.370298]  [<c0102f74>] ? sysenter_do_call+0x12/0x28
> [   53.370298] Code: 0f c1 05 e0 4b 3e c0 38 e0 74 09 f3 90 a0 e0 4b 3e c0 eb f3 64 a1 00 b0 43 c0 89 50 14 c3 64 8b 15 00 b0 43 c0 83 7a 14 00 79 04 <0f> 0b eb fe 8b 42 14 48 85 c0 89 42 14 79 07 f0 fe 05 e0 4b 3e 
> [   53.370298] EIP: [<c02f81e3>] unlock_kernel+0xd/0x24 SS:ESP 0068:f65b1e68
> [   53.374302] ---[ end trace 05965e9e089c46c7 ]---
> 
> 
> With my best regards, Dmitry.
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
