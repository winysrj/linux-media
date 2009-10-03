Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx5.sysproserver.de ([78.46.249.136]:49020 "EHLO
	srv5.sysproserver.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756437AbZJCNsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 09:48:07 -0400
Received: from laptop.localnet (xdsl-87-78-37-50.netcologne.de [87.78.37.50])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by srv5.sysproserver.de (Postfix) with ESMTP id 89A811D88087
	for <linux-media@vger.kernel.org>; Sat,  3 Oct 2009 15:37:35 +0200 (CEST)
From: Niels Ole Salscheider <niels_ole@salscheider-online.de>
To: linux-media@vger.kernel.org
Subject: Patch for TeVii S470
Date: Sat, 3 Oct 2009 15:37:31 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910031537.31905.niels_ole@salscheider-online.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have downloaded and compiled the linuxtv sources from 
http://mercurial.intuxication.org/hg/s2-liplianin in order to get my TeVii 
S470 working. Nevertheless, I get the folowing error if I try to tune any 
channel:

Oct  3 11:15:51 Server kernel: ds3000_firmware_ondemand: Waiting for firmware 
upload (dvb-fe-ds3000.fw)...
Oct  3 11:15:51 Server kernel: i2c-adapter i2c-1: firmware: requesting dvb-fe-
ds3000.fw
Oct  3 11:15:51 Server kernel: ------------[ cut here ]------------
Oct  3 11:15:51 Server kernel: WARNING: at fs/sysfs/dir.c:487 
sysfs_add_one+0x12d/0x160()
Oct  3 11:15:51 Server kernel: Hardware name: System Product Name
Oct  3 11:15:51 Server kernel: sysfs: cannot create duplicate filename 
'/devices/pci0000:00/0000:00:05.0/0000:02:00.0/i2c-adapter/i2c-1/i2c-1'
Oct  3 11:15:51 Server kernel: Modules linked in: af_packet hwmon_vid i2c_dev 
powernow_k8 kvm_amd kvm nfsd nfs_acl exportfs nfs lockd auth_rpcgss sunrpc 
dvb_pll ds3000 stv0299 cx23885 cx2341x v4l2_common videodev v4l1_compat 
b2c2_flexcop_pci v4l2_compat_ioctl32 b2c2_flexcop videobuf_dma_sg videobuf_dvb 
dvb_core videobuf_core processor i2c_piix4 btcx_risc cx24123 atiixp thermal 
tveeprom ide_core cx24113 ehci_hcd ohci_hcd s5h1420 thermal_sys shpchp usbcore 
floppy atl1 ata_generic 8250_pnp rtc_cmos pata_acpi rtc_core pci_hotplug 8250 
mii sg serial_core k8temp rtc_lib hwmon button unix
Oct  3 11:15:51 Server kernel: Pid: 2548, comm: kdvb-ad-1-fe-0 Not tainted 
2.6.31-gentoo #1
Oct  3 11:15:51 Server kernel: Call Trace:
Oct  3 11:15:51 Server kernel: [<ffffffff81186f3d>] ? sysfs_add_one+0x12d/0x160
Oct  3 11:15:51 Server kernel: [<ffffffff81057af9>] ? 
warn_slowpath_common+0x89/0x100
Oct  3 11:15:51 Server kernel: [<ffffffff81186de4>] ? sysfs_pathname+0x44/0x70
Oct  3 11:15:51 Server kernel: [<ffffffff81057c11>] ? warn_slowpath_fmt+0x61/0x90
Oct  3 11:15:51 Server kernel: [<ffffffff81186de4>] ? sysfs_pathname+0x44/0x70
Oct  3 11:15:51 Server kernel: [<ffffffff8110f5bb>] ? kmem_cache_alloc+0x9b/0x160
Oct  3 11:15:51 Server kernel: [<ffffffff81186de4>] ? sysfs_pathname+0x44/0x70
Oct  3 11:15:51 Server kernel: [<ffffffff81186f3d>] ? sysfs_add_one+0x12d/0x160
Oct  3 11:15:51 Server kernel: [<ffffffff81187ee0>] ? create_dir+0x70/0xe0
Oct  3 11:15:51 Server kernel: [<ffffffff81187f8f>] ? sysfs_create_dir+0x3f/0x70
Oct  3 11:15:51 Server kernel: [<ffffffff812b23c9>] ? 
kobject_add_internal+0x109/0x210
Oct  3 11:15:51 Server kernel: [<ffffffff812b27c4>] ? kobject_add+0x64/0xb0
Oct  3 11:15:51 Server kernel: [<ffffffff8135308d>] ? dev_set_name+0x5d/0x80
Oct  3 11:15:51 Server kernel: [<ffffffff812b21f6>] ? kobject_get+0x26/0x50
Oct  3 11:15:51 Server kernel: [<ffffffff81353fdf>] ? device_add+0x18f/0x680
Oct  3 11:15:51 Server kernel: [<ffffffff8135f83e>] ? _request_firmware+0x2ae/0x5d0
Oct  3 11:15:51 Server kernel: [<ffffffffa0201ff6>] ? ds3000_tune+0xaf6/0xe98 
[ds3000]
Oct  3 11:15:51 Server kernel: [<ffffffff81066c64>] ? 
try_to_del_timer_sync+0x64/0x90
Oct  3 11:15:51 Server kernel: [<ffffffffa017da61>] ? 
dvb_frontend_swzigzag_autotune+0xe1/0x260 [dvb_core]
Oct  3 11:15:51 Server kernel: [<ffffffff81066d80>] ? process_timeout+0x0/0x40
Oct  3 11:15:51 Server kernel: [<ffffffffa017ec0a>] ? 
dvb_frontend_swzigzag+0x26a/0x2c0 [dvb_core]
Oct  3 11:15:51 Server kernel: [<ffffffffa017f0b0>] ? 
dvb_frontend_thread+0x450/0x770 [dvb_core]
Oct  3 11:15:51 Server kernel: [<ffffffff81077d80>] ? 
autoremove_wake_function+0x0/0x60
Oct  3 11:15:51 Server kernel: [<ffffffffa017ec60>] ? 
dvb_frontend_thread+0x0/0x770 [dvb_core]
Oct  3 11:15:51 Server kernel: [<ffffffffa017ec60>] ? 
dvb_frontend_thread+0x0/0x770 [dvb_core]
Oct  3 11:15:51 Server kernel: [<ffffffff81077846>] ? kthread+0xb6/0xd0
Oct  3 11:15:51 Server kernel: [<ffffffff8100d29a>] ? child_rip+0xa/0x20
Oct  3 11:15:51 Server kernel: [<ffffffff81077790>] ? kthread+0x0/0xd0
Oct  3 11:15:51 Server kernel: [<ffffffff8100d290>] ? child_rip+0x0/0x20
Oct  3 11:15:51 Server kernel: ---[ end trace 478953c6d1c9275f ]---


The following patch solves this problem for me:

diff -r 82a256f5d842 linux/drivers/media/dvb/frontends/ds3000.c
--- a/linux/drivers/media/dvb/frontends/ds3000.c        Wed Sep 23 20:44:12 
2009 +0300
+++ b/linux/drivers/media/dvb/frontends/ds3000.c        Sat Oct 03 15:28:52 
2009 +0200
@@ -444,7 +444,7 @@
                /* Load firmware */
                /* request the firmware, this will block until someone uploads 
it */
                printk("%s: Waiting for firmware upload (%s)...\n", __func__, 
DS3000_DEFAULT_FIRMWARE);
-               ret = request_firmware(&fw, DS3000_DEFAULT_FIRMWARE, &state-
>i2c->dev);
+               ret = request_firmware(&fw, DS3000_DEFAULT_FIRMWARE, state-
>i2c->dev.parent);
                printk("%s: Waiting for firmware upload(2)...\n", __func__);
                if (ret) {
                        printk("%s: No firmware uploaded (timeout or file not 
found?)\n", __func__);

Kind regards

Ole
