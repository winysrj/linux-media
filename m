Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35347 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751812AbdLQPk4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 10:40:56 -0500
Received: by mail-wr0-f196.google.com with SMTP id z104so2970858wrb.2
        for <linux-media@vger.kernel.org>; Sun, 17 Dec 2017 07:40:55 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 1/8] [media] ddbridge: unregister I2C tuner client before detaching fe's
Date: Sun, 17 Dec 2017 16:40:42 +0100
Message-Id: <20171217154049.1125-2-d.scheller.oss@gmail.com>
In-Reply-To: <20171217154049.1125-1-d.scheller.oss@gmail.com>
References: <20171217154049.1125-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Currently, rmmod ddbridge on a KASAN enabled kernel yields this report
for hardware that utilises the tda18212 tuner driver:

  [   50.355229] ==================================================================
  [   50.355271] BUG: KASAN: use-after-free in tda18212_remove+0x5c/0xb0 [tda18212]
  [   50.355290] Write of size 288 at addr ffff8800c235cf18 by task rmmod/285

  [   50.355316] CPU: 1 PID: 285 Comm: rmmod Not tainted 4.15.0-rc1-13744-g352a86ad536f #11
  [   50.355318] Hardware name: Gigabyte Technology Co., Ltd. P35-DS3/P35-DS3, BIOS F3 06/11/2007
  [   50.355319] Call Trace:
  [   50.355326]  dump_stack+0x46/0x61
  [   50.355332]  print_address_description+0x79/0x270
  [   50.355336]  ? tda18212_remove+0x5c/0xb0 [tda18212]
  [   50.355339]  kasan_report+0x229/0x340
  [   50.355342]  memset+0x1f/0x40
  [   50.355345]  tda18212_remove+0x5c/0xb0 [tda18212]
  [   50.355350]  i2c_device_remove+0x97/0xe0
  [   50.355355]  device_release_driver_internal+0x267/0x510
  [   50.355358]  bus_remove_device+0x296/0x470
  [   50.355360]  device_del+0x35c/0x890
  [   50.355363]  ? __device_links_no_driver+0x1c0/0x1c0
  [   50.355367]  ? cxd2841er_get_algo+0x10/0x10 [cxd2841er]
  [   50.355371]  ? cxd2841er_get_algo+0x10/0x10 [cxd2841er]
  [   50.355374]  ? __module_text_address+0xe/0x140
  [   50.355377]  device_unregister+0x9/0x20
  [   50.355382]  dvb_input_detach.isra.24+0x286/0x480 [ddbridge]
  [   50.355388]  ddb_ports_detach+0x15f/0x4f0 [ddbridge]
  [   50.355393]  ddb_remove+0x3c/0xb0 [ddbridge]
  [   50.355397]  pci_device_remove+0x93/0x1d0
  [   50.355400]  device_release_driver_internal+0x267/0x510
  [   50.355403]  driver_detach+0xb9/0x1b0
  [   50.355406]  bus_remove_driver+0xd0/0x1f0
  [   50.355410]  pci_unregister_driver+0x25/0x210
  [   50.355415]  module_exit_ddbridge+0xc/0x45 [ddbridge]
  [   50.355418]  SyS_delete_module+0x314/0x440
  [   50.355420]  ? free_module+0x5b0/0x5b0
  [   50.355423]  ? exit_to_usermode_loop+0xa9/0xc0
  [   50.355425]  ? free_module+0x5b0/0x5b0
  [   50.355428]  do_syscall_64+0x179/0x4c0
  [   50.355432]  ? do_page_fault+0x1b/0x60
  [   50.355435]  entry_SYSCALL64_slow_path+0x25/0x25
  [   50.355438] RIP: 0033:0x7fe65d08ade7
  [   50.355439] RSP: 002b:00007fff5a6a09a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000b0
  [   50.355443] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe65d08ade7
  [   50.355445] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000000000f4e268
  [   50.355447] RBP: 0000000000f4e200 R08: 0000000000000000 R09: 1999999999999999
  [   50.355449] R10: 0000000000000891 R11: 0000000000000202 R12: 00007fff5a6a14ef
  [   50.355451] R13: 0000000000000000 R14: 0000000000f4e200 R15: 0000000000f4d010

  [   50.355462] Allocated by task 164:
  [   50.355477]  cxd2841er_attach+0xc3/0x7f0 [cxd2841er]
  [   50.355482]  demod_attach_cxd28xx+0x14c/0x3f0 [ddbridge]
  [   50.355486]  dvb_input_attach+0x671/0x1e20 [ddbridge]
  [   50.355490]  ddb_ports_attach+0x3d7/0xbf0 [ddbridge]
  [   50.355495]  ddb_init+0x4b3/0xa30 [ddbridge]
  [   50.355499]  ddb_probe+0xa51/0xfe0 [ddbridge]
  [   50.355501]  pci_device_probe+0x279/0x480
  [   50.355504]  driver_probe_device+0x46f/0x7a0
  [   50.355506]  __driver_attach+0x133/0x170
  [   50.355509]  bus_for_each_dev+0x10a/0x190
  [   50.355511]  bus_add_driver+0x2a3/0x5a0
  [   50.355513]  driver_register+0x182/0x3a0
  [   50.355516]  arc4_set_key+0x8f/0x2a0 [arc4]
  [   50.355518]  do_one_initcall+0x77/0x1d0
  [   50.355521]  do_init_module+0x1c2/0x548
  [   50.355523]  load_module+0x5e61/0x8df0
  [   50.355525]  SyS_finit_module+0x142/0x150
  [   50.355527]  do_syscall_64+0x179/0x4c0
  [   50.355529]  return_from_SYSCALL_64+0x0/0x65

  [   50.355539] Freed by task 285:
  [   50.355551]  kfree+0x6c/0xa0
  [   50.355558]  __dvb_frontend_free+0x81/0xb0 [dvb_core]
  [   50.355562]  dvb_input_detach.isra.24+0x17c/0x480 [ddbridge]
  [   50.355566]  ddb_ports_detach+0x15f/0x4f0 [ddbridge]
  [   50.355570]  ddb_remove+0x3c/0xb0 [ddbridge]
  [   50.355573]  pci_device_remove+0x93/0x1d0
  [   50.355576]  device_release_driver_internal+0x267/0x510
  [   50.355578]  driver_detach+0xb9/0x1b0
  [   50.355580]  bus_remove_driver+0xd0/0x1f0
  [   50.355583]  pci_unregister_driver+0x25/0x210
  [   50.355587]  module_exit_ddbridge+0xc/0x45 [ddbridge]
  [   50.355590]  SyS_delete_module+0x314/0x440
  [   50.355592]  do_syscall_64+0x179/0x4c0
  [   50.355594]  return_from_SYSCALL_64+0x0/0x65

  [   50.355604] The buggy address belongs to the object at ffff8800c235cd80
                  which belongs to the cache kmalloc-2048 of size 2048
  [   50.355630] The buggy address is located 408 bytes inside of
                  2048-byte region [ffff8800c235cd80, ffff8800c235d580)
  [   50.355652] The buggy address belongs to the page:
  [   50.355666] page:ffffea0002a7bc20 count:1 mapcount:0 mapping:ffff8800c235c500 index:0x0 compound_mapcount: 0
  [   50.355688] flags: 0x4000000000008100(slab|head)
  [   50.355703] raw: 4000000000008100 ffff8800c235c500 0000000000000000 0000000100000003
  [   50.355720] raw: ffffea000382b4b0 ffffea0002b91550 ffff88010b000800
  [   50.355734] page dumped because: kasan: bad access detected

  [   50.355754] Memory state around the buggy address:
  [   50.355767]  ffff8800c235ce00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [   50.355783]  ffff8800c235ce80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [   50.355800] >ffff8800c235cf00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [   50.355815]                             ^
  [   50.355827]  ffff8800c235cf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [   50.355843]  ffff8800c235d000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [   50.355858] ==================================================================

This is due to dvb_frontend_detach() being called before
i2c_unregister_device() on the TDA18212 tuner client instance, as
dvb_frontend_detach() causes the demod drivers to release all their
resources, and the tuner driver's _remove method does further cleanup on
the now invalid (freed) resources. Fix this by putting the I2C client
deregistration in dvb_input_detach() to state/case 0x30, right before the
call to dvb_frontend_detach(). This also makes sure that any further
(tuner) hardware driven by I2C client drivers unload cleanly.

Fixes: 1502efd2d59 ("media: ddbridge: fix teardown/deregistration order in ddb_input_detach()")

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index eb43dcb4e5d2..eda004398316 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1263,6 +1263,14 @@ static void dvb_input_detach(struct ddb_input *input)
 			dvb_unregister_frontend(dvb->fe);
 		/* fallthrough */
 	case 0x30:
+		client = dvb->i2c_client[0];
+		if (client) {
+			module_put(client->dev.driver->owner);
+			i2c_unregister_device(client);
+			dvb->i2c_client[0] = NULL;
+			client = NULL;
+		}
+
 		if (dvb->fe2)
 			dvb_frontend_detach(dvb->fe2);
 		if (dvb->fe)
@@ -1271,12 +1279,6 @@ static void dvb_input_detach(struct ddb_input *input)
 		dvb->fe2 = NULL;
 		/* fallthrough */
 	case 0x20:
-		client = dvb->i2c_client[0];
-		if (client) {
-			module_put(client->dev.driver->owner);
-			i2c_unregister_device(client);
-		}
-
 		dvb_net_release(&dvb->dvbnet);
 		/* fallthrough */
 	case 0x12:
-- 
2.13.6
