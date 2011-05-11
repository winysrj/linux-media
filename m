Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:58227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab1EKVRi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 17:17:38 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, stable@kernel.org
Subject: [PATCH] [media] rc: add locking to fix register/show race
Date: Wed, 11 May 2011 17:17:05 -0400
Message-Id: <1305148625-10078-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

When device_add is called in rc_register_device, the rc sysfs nodes show
up, and there's a window in which ir-keytable can be launched via udev
and trigger a show_protocols call, which runs without various rc_dev
fields filled in yet. Add some locking around registration and
store/show_protocols to prevent that from happening.

The problem manifests thusly:

[64692.957872] BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
[64692.957878] IP: [<ffffffffa036a4c1>] show_protocols+0x47/0xf1 [rc_core]
[64692.957890] PGD 19cfc7067 PUD 19cfc6067 PMD 0
[64692.957894] Oops: 0000 [#1] SMP
[64692.957897] last sysfs file: /sys/devices/pci0000:00/0000:00:03.1/usb3/3-1/3-1:1.0/rc/rc2/protocols
[64692.957902] CPU 3
[64692.957903] Modules linked in: redrat3(+) ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge ir_nec
_decoder rc_core ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_mi
di_event snd_seq_midi_emul snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_seq snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem pcsp
kr tg3 snd_hwdep emu10k1_gp snd amd64_edac_mod gameport edac_core soundcore edac_mce_amd k8temp shpchp i2c_piix4 lm63 e100 mii uinput ipv6 raid0 rai
d1 ata_generic firewire_ohci pata_acpi firewire_core crc_itu_t sata_svw pata_serverworks floppy radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: redrat3]
[64692.957949] [64692.957952] Pid: 12265, comm: ir-keytable Tainted: G   M    W   2.6.39-rc6+ #2 empty empty/TYAN Thunder K8HM S3892
[64692.957957] RIP: 0010:[<ffffffffa036a4c1>]  [<ffffffffa036a4c1>] show_protocols+0x47/0xf1 [rc_core]
[64692.957962] RSP: 0018:ffff880194509e38  EFLAGS: 00010202
[64692.957964] RAX: 0000000000000000 RBX: ffffffffa036d1e0 RCX: ffffffffa036a47a
[64692.957966] RDX: ffff88019a84d000 RSI: ffffffffa036d1e0 RDI: ffff88019cf2f3f0
[64692.957969] RBP: ffff880194509e68 R08: 0000000000000002 R09: 0000000000000000
[64692.957971] R10: 0000000000000002 R11: 0000000000001617 R12: ffff88019a84d000
[64692.957973] R13: 0000000000001000 R14: ffff8801944d2e38 R15: ffff88019ce5f190
[64692.957976] FS:  00007f0a30c9a720(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
[64692.957979] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[64692.957981] CR2: 0000000000000090 CR3: 000000019a8e0000 CR4: 00000000000006e0
[64692.957983] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[64692.957986] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[64692.957989] Process ir-keytable (pid: 12265, threadinfo ffff880194508000, task ffff88019a9fc720)
[64692.957991] Stack:
[64692.957992]  0000000000000002 ffffffffa036d1e0 ffff880194509f58 0000000000001000
[64692.957997]  ffff8801944d2e38 ffff88019ce5f190 ffff880194509e98 ffffffff8131484b
[64692.958001]  ffffffff8118e923 ffffffff810e9b2f ffff880194509e98 ffff8801944d2e18
[64692.958005] Call Trace:
[64692.958014]  [<ffffffff8131484b>] dev_attr_show+0x27/0x4e
[64692.958014]  [<ffffffff8118e923>] ? sysfs_read_file+0x94/0x172
[64692.958014]  [<ffffffff810e9b2f>] ? __get_free_pages+0x16/0x52
[64692.958014]  [<ffffffff8118e94c>] sysfs_read_file+0xbd/0x172
[64692.958014]  [<ffffffff8113205e>] vfs_read+0xac/0xf3
[64692.958014]  [<ffffffff8113347b>] ? fget_light+0x3a/0xa1
[64692.958014]  [<ffffffff811320f2>] sys_read+0x4d/0x74
[64692.958014]  [<ffffffff814c19c2>] system_call_fastpath+0x16/0x1b

Its a bit difficult to reproduce, but I'm fairly confident this has
fixed the problem. At least, I haven't been able to reproduce it in a
few dozen load/unload cycles of the redrat3 driver I'm working on...

This was originally reported by an Ubuntu 11.04 user running their
2.6.38 kernel, so this should probably go to 2.6.38 stable as well. (I
don't have a Reported-by line to provide here, it was someone on #lirc
on freenode that pastebinned it, driver was mceusb in that case).

CC: stable@kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/rc-main.c |   47 ++++++++++++++++++++++++++++++++++++++-----
 include/media/rc-core.h    |    7 ++++-
 2 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 646d701..0497e06 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -748,6 +748,9 @@ static struct {
  * it is trigged by reading /sys/class/rc/rc?/protocols.
  * It returns the protocol names of supported protocols.
  * Enabled protocols are printed in brackets.
+ *
+ * dev->lock is taken to guard against races between device
+ * registration, store_protocols and show_protocols.
  */
 static ssize_t show_protocols(struct device *device,
 			      struct device_attribute *mattr, char *buf)
@@ -761,6 +764,8 @@ static ssize_t show_protocols(struct device *device,
 	if (!dev)
 		return -EINVAL;
 
+	mutex_lock(&dev->lock);
+
 	if (dev->driver_type == RC_DRIVER_SCANCODE) {
 		enabled = dev->rc_map.rc_type;
 		allowed = dev->allowed_protos;
@@ -783,6 +788,9 @@ static ssize_t show_protocols(struct device *device,
 	if (tmp != buf)
 		tmp--;
 	*tmp = '\n';
+
+	mutex_unlock(&dev->lock);
+
 	return tmp + 1 - buf;
 }
 
@@ -801,6 +809,9 @@ static ssize_t show_protocols(struct device *device,
  * Writing "none" will disable all protocols.
  * Returns -EINVAL if an invalid protocol combination or unknown protocol name
  * is used, otherwise @len.
+ *
+ * dev->lock is taken to guard against races between device
+ * registration, store_protocols and show_protocols.
  */
 static ssize_t store_protocols(struct device *device,
 			       struct device_attribute *mattr,
@@ -814,18 +825,22 @@ static ssize_t store_protocols(struct device *device,
 	u64 mask;
 	int rc, i, count = 0;
 	unsigned long flags;
+	ssize_t ret;
 
 	/* Device is being removed */
 	if (!dev)
 		return -EINVAL;
 
+	mutex_lock(&dev->lock);
+
 	if (dev->driver_type == RC_DRIVER_SCANCODE)
 		type = dev->rc_map.rc_type;
 	else if (dev->raw)
 		type = dev->raw->enabled_protocols;
 	else {
 		IR_dprintk(1, "Protocol switching not supported\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
@@ -859,7 +874,8 @@ static ssize_t store_protocols(struct device *device,
 			}
 			if (i == ARRAY_SIZE(proto_names)) {
 				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
-				return -EINVAL;
+				ret = -EINVAL;
+				goto out;
 			}
 			count++;
 		}
@@ -874,7 +890,8 @@ static ssize_t store_protocols(struct device *device,
 
 	if (!count) {
 		IR_dprintk(1, "Protocol not specified\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	if (dev->change_protocol) {
@@ -882,7 +899,8 @@ static ssize_t store_protocols(struct device *device,
 		if (rc < 0) {
 			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
 				   (long long)type);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
@@ -897,7 +915,11 @@ static ssize_t store_protocols(struct device *device,
 	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
 		   (long long)type);
 
-	return len;
+	ret = len;
+
+out:
+	mutex_unlock(&dev->lock);
+	return ret;
 }
 
 static void rc_dev_release(struct device *device)
@@ -973,6 +995,7 @@ struct rc_dev *rc_allocate_device(void)
 
 	spin_lock_init(&dev->rc_map.lock);
 	spin_lock_init(&dev->keylock);
+	mutex_init(&dev->lock);
 	setup_timer(&dev->timer_keyup, ir_timer_keyup, (unsigned long)dev);
 
 	dev->dev.type = &rc_dev_type;
@@ -1018,12 +1041,21 @@ int rc_register_device(struct rc_dev *dev)
 	if (dev->close)
 		dev->input_dev->close = ir_close;
 
+	/*
+	 * Take the lock here, as the device sysfs node will appear
+	 * when device_add() is called, which may trigger an ir-keytable udev
+	 * rule, which will in turn call show_protocols and access either
+	 * dev->rc_map.rc_type or dev->raw->enabled_protocols before it has
+	 * been initialized.
+	 */
+	mutex_lock(&dev->lock);
+
 	dev->devno = (unsigned long)(atomic_inc_return(&devno) - 1);
 	dev_set_name(&dev->dev, "rc%ld", dev->devno);
 	dev_set_drvdata(&dev->dev, dev);
 	rc = device_add(&dev->dev);
 	if (rc)
-		return rc;
+		goto out_unlock;
 
 	rc = ir_setkeytable(dev, rc_map);
 	if (rc)
@@ -1057,6 +1089,7 @@ int rc_register_device(struct rc_dev *dev)
 		if (rc < 0)
 			goto out_input;
 	}
+	mutex_unlock(&dev->lock);
 
 	if (dev->change_protocol) {
 		rc = dev->change_protocol(dev, rc_map->rc_type);
@@ -1082,6 +1115,8 @@ out_table:
 	ir_free_table(&dev->rc_map);
 out_dev:
 	device_del(&dev->dev);
+out_unlock:
+	mutex_unlock(&dev->lock);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(rc_register_device);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 2963263..60536c7 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -40,10 +40,12 @@ enum rc_driver_type {
  * @driver_name: name of the hardware driver which registered this device
  * @map_name: name of the default keymap
  * @rc_map: current scan/key table
+ * @lock: used to ensure we've filled in all protocol details before
+ *	anyone can call show_protocols or store_protocols
  * @devno: unique remote control device number
  * @raw: additional data for raw pulse/space devices
  * @input_dev: the input child device used to communicate events to userspace
- * @driver_type: specifies if protocol decoding is done in hardware or software 
+ * @driver_type: specifies if protocol decoding is done in hardware or software
  * @idle: used to keep track of RX state
  * @allowed_protos: bitmask with the supported RC_TYPE_* protocols
  * @scanmask: some hardware decoders are not capable of providing the full
@@ -86,7 +88,8 @@ struct rc_dev {
 	struct input_id			input_id;
 	char				*driver_name;
 	const char			*map_name;
-	struct rc_map	rc_map;
+	struct rc_map			rc_map;
+	struct mutex			lock;
 	unsigned long			devno;
 	struct ir_raw_event_ctrl	*raw;
 	struct input_dev		*input_dev;
-- 
1.7.1

