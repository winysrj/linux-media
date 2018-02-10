Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61263 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750946AbeBJMNg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Feb 2018 07:13:36 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH] media: m88ds3103: don't call a non-initalized function
Date: Sat, 10 Feb 2018 10:13:30 -0200
Message-Id: <50428a71afb3edb25444c0a9259f758ef5029d34.1518264808.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If m88d3103 chip ID is not recognized, the device is not initialized.

However, it returns from probe without any error, causing this OOPS:

[    7.689289] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[    7.689297] pgd = 7b0bd7a7
[    7.689302] [00000000] *pgd=00000000
[    7.689318] Internal error: Oops: 80000005 [#1] SMP ARM
[    7.689322] Modules linked in: dvb_usb_dvbsky(+) m88ds3103 dvb_usb_v2 dvb_core videobuf2_vmalloc videobuf2_memops videobuf2_core crc32_arm_ce videodev media
[    7.689358] CPU: 3 PID: 197 Comm: systemd-udevd Not tainted 4.15.0-mcc+ #23
[    7.689361] Hardware name: BCM2835
[    7.689367] PC is at 0x0
[    7.689382] LR is at m88ds3103_attach+0x194/0x1d0 [m88ds3103]
[    7.689386] pc : [<00000000>]    lr : [<bf0ae1ec>]    psr: 60000013
[    7.689391] sp : ed8e5c20  ip : ed8c1e00  fp : ed8945c0
[    7.689395] r10: ed894000  r9 : ed894378  r8 : eda736c0
[    7.689400] r7 : ed894070  r6 : ed8e5c44  r5 : bf0bb040  r4 : eda77600
[    7.689405] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : eda77600
[    7.689412] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[    7.689417] Control: 10c5383d  Table: 2d8e806a  DAC: 00000051
[    7.689423] Process systemd-udevd (pid: 197, stack limit = 0xe9dbfb63)
[    7.689428] Stack: (0xed8e5c20 to 0xed8e6000)
[    7.689439] 5c20: ed853a80 eda73640 ed894000 ed8942c0 ed853a80 bf0b9e98 ed894070 bf0b9f10
[    7.689449] 5c40: 00000000 00000000 bf08c17c c08dfc50 00000000 00000000 00000000 00000000
[    7.689459] 5c60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    7.689468] 5c80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    7.689479] 5ca0: 00000000 00000000 ed8945c0 ed8942c0 ed894000 ed894830 bf0b9e98 00000000
[    7.689490] 5cc0: ed894378 bf0a3cb4 bf0bc3b0 0000533b ed920540 00000000 00000034 bf0a6434
[    7.689500] 5ce0: ee952070 ed826600 bf0a7038 bf0a2dd8 00000001 bf0a6768 bf0a2f90 ed8943c0
[    7.689511] 5d00: 00000000 c08eca68 ed826620 ed826620 00000000 ee952070 bf0bc034 ee952000
[    7.689521] 5d20: ed826600 bf0bb080 ffffffed c0aa9e9c c0aa9dac ed826620 c16edf6c c168c2c8
[    7.689531] 5d40: c16edf70 00000000 bf0bc034 0000000d 00000000 c08e268c bf0bb080 ed826600
[    7.689541] 5d60: bf0bc034 ed826654 ed826620 bf0bc034 c164c8bc 00000000 00000001 00000000
[    7.689553] 5d80: 00000028 c08e2948 00000000 bf0bc034 c08e2848 c08e0778 ee9f0a58 ed88bab4
[    7.689563] 5da0: bf0bc034 ed90ba80 c168c1f0 c08e1934 bf0bb3bc c17045ac bf0bc034 c164c8bc
[    7.689574] 5dc0: bf0bc034 bf0bb3bc ed91f564 c08e34ec bf0bc000 c164c8bc bf0bc034 c0aa8dc4
[    7.689584] 5de0: ffffe000 00000000 bf0bf000 ed91f600 ed91f564 c03021e4 00000001 00000000
[    7.689595] 5e00: c166e040 8040003f ed853a80 bf0bc448 00000000 c1678174 ed853a80 f0f22000
[    7.689605] 5e20: f0f21fff 8040003f 014000c0 ed91e700 ed91e700 c16d8e68 00000001 ed91e6c0
[    7.689615] 5e40: bf0bc400 00000001 bf0bc400 ed91f564 00000001 00000000 00000028 c03c9a24
[    7.689625] 5e60: 00000001 c03c8c94 ed8e5f50 ed8e5f50 00000001 bf0bc400 ed91f540 c03c8cb0
[    7.689637] 5e80: bf0bc40c 00007fff bf0bc400 c03c60b0 00000000 bf0bc448 00000028 c0e09684
[    7.689647] 5ea0: 00000002 bf0bc530 c1234bf8 bf0bc5dc bf0bc514 c10ebbe8 ffffe000 bf000000
[    7.689657] 5ec0: 00011538 00000000 ed8e5f48 00000000 00000000 00000000 00000000 00000000
[    7.689666] 5ee0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    7.689676] 5f00: 00000000 00000000 7fffffff 00000000 00000013 b6e55a18 0000017b c0309104
[    7.689686] 5f20: ed8e4000 00000000 00510af0 c03c9430 7fffffff 00000000 00000003 00000000
[    7.689697] 5f40: 00000000 f0f0f000 00011538 00000000 f0f107b0 f0f0f000 00011538 f0f1fdb8
[    7.689707] 5f60: f0f1fbe8 f0f1b974 00004000 000041e0 bf0bc3d0 00000001 00000000 000024c4
[    7.689717] 5f80: 0000002d 0000002e 00000019 00000000 00000010 00000000 16894000 00000000
[    7.689727] 5fa0: 00000000 c0308f20 16894000 00000000 00000013 b6e55a18 00000000 b6e5652c
[    7.689737] 5fc0: 16894000 00000000 00000000 0000017b 00020000 00508110 00000000 00510af0
[    7.689748] 5fe0: bef68948 bef68938 b6e4d3d0 b6d32590 60000010 00000013 00000000 00000000
[    7.689790] [<bf0ae1ec>] (m88ds3103_attach [m88ds3103]) from [<bf0b9f10>] (dvbsky_s960c_attach+0x78/0x280 [dvb_usb_dvbsky])
[    7.689821] [<bf0b9f10>] (dvbsky_s960c_attach [dvb_usb_dvbsky]) from [<bf0a3cb4>] (dvb_usbv2_probe+0xa3c/0x1024 [dvb_usb_v2])
[    7.689849] [<bf0a3cb4>] (dvb_usbv2_probe [dvb_usb_v2]) from [<c0aa9e9c>] (usb_probe_interface+0xf0/0x2a8)
[    7.689869] [<c0aa9e9c>] (usb_probe_interface) from [<c08e268c>] (driver_probe_device+0x2f8/0x4b4)
[    7.689881] [<c08e268c>] (driver_probe_device) from [<c08e2948>] (__driver_attach+0x100/0x11c)
[    7.689895] [<c08e2948>] (__driver_attach) from [<c08e0778>] (bus_for_each_dev+0x4c/0x9c)
[    7.689909] [<c08e0778>] (bus_for_each_dev) from [<c08e1934>] (bus_add_driver+0x1c0/0x264)
[    7.689919] [<c08e1934>] (bus_add_driver) from [<c08e34ec>] (driver_register+0x78/0xf4)
[    7.689931] [<c08e34ec>] (driver_register) from [<c0aa8dc4>] (usb_register_driver+0x70/0x134)
[    7.689946] [<c0aa8dc4>] (usb_register_driver) from [<c03021e4>] (do_one_initcall+0x44/0x168)
[    7.689963] [<c03021e4>] (do_one_initcall) from [<c03c9a24>] (do_init_module+0x64/0x1f4)
[    7.689979] [<c03c9a24>] (do_init_module) from [<c03c8cb0>] (load_module+0x20a0/0x25c8)
[    7.689993] [<c03c8cb0>] (load_module) from [<c03c9430>] (SyS_finit_module+0xb4/0xec)
[    7.690007] [<c03c9430>] (SyS_finit_module) from [<c0308f20>] (ret_fast_syscall+0x0/0x54)
[    7.690018] Code: bad PC value

This may happen on normal circumstances, if, for some reason, the demod
hangs and start returning an invalid chip ID:

[   10.394395] m88ds3103 3-0068: Unknown device. Chip_id=00

So, change the logic to cause probe to fail with -ENODEV, preventing
the OOPS.

Detected while testing DVB MMAP patches on Raspberry Pi 3 with
DVBSky S960CI.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/m88ds3103.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 50bce68ffd66..65d157fe76d1 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1262,11 +1262,12 @@ static int m88ds3103_select(struct i2c_mux_core *muxc, u32 chan)
  * New users must use I2C client binding directly!
  */
 struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
-		struct i2c_adapter *i2c, struct i2c_adapter **tuner_i2c_adapter)
+				      struct i2c_adapter *i2c,
+				      struct i2c_adapter **tuner_i2c_adapter)
 {
 	struct i2c_client *client;
 	struct i2c_board_info board_info;
-	struct m88ds3103_platform_data pdata;
+	struct m88ds3103_platform_data pdata = {};
 
 	pdata.clk = cfg->clock;
 	pdata.i2c_wr_max = cfg->i2c_wr_max;
@@ -1409,6 +1410,8 @@ static int m88ds3103_probe(struct i2c_client *client,
 	case M88DS3103_CHIP_ID:
 		break;
 	default:
+		ret = -ENODEV;
+		dev_err(&client->dev, "Unknown device. Chip_id=%02x\n", dev->chip_id);
 		goto err_kfree;
 	}
 
-- 
2.14.3
