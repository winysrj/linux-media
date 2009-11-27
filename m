Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:61976 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZK0BeT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 20:34:19 -0500
Subject: [IR-RFC PATCH v4 1/6] Minimal changes to the core input system
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
From: Jon Smirl <jonsmirl@gmail.com>
Date: Thu, 26 Nov 2009 20:34:21 -0500
Message-ID: <20091127013421.7671.33657.stgit@terra>
In-Reply-To: <20091127013217.7671.32355.stgit@terra>
References: <20091127013217.7671.32355.stgit@terra>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Minimal changes to the core input system. The bulk of IR support loads as a module. These changes are passive if the rest of IR isn't loaded.

Jon Smirl
<jonsmirl@gmail.com>
---
 drivers/input/input.c           |   17 +++++++++
 include/linux/input.h           |   75 +++++++++++++++++++++++++++++++++++++++
 include/linux/mod_devicetable.h |    3 ++
 3 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 7c237e6..a531cf5 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -274,6 +274,10 @@ static void input_handle_event(struct input_dev *dev,
 	case EV_PWR:
 		disposition = INPUT_PASS_TO_ALL;
 		break;
+
+	case EV_IR:
+		disposition = INPUT_PASS_TO_ALL;
+		break;
 	}
 
 	if (disposition != INPUT_IGNORE_EVENT && type != EV_SYN)
@@ -727,6 +731,7 @@ static const struct input_device_id *input_match_device(const struct input_devic
 		MATCH_BIT(sndbit, SND_MAX);
 		MATCH_BIT(ffbit,  FF_MAX);
 		MATCH_BIT(swbit,  SW_MAX);
+		MATCH_BIT(irbit,  IR_MAX);
 
 		return id;
 	}
@@ -849,6 +854,8 @@ static int input_devices_seq_show(struct seq_file *seq, void *v)
 		input_seq_print_bitmap(seq, "FF", dev->ffbit, FF_MAX);
 	if (test_bit(EV_SW, dev->evbit))
 		input_seq_print_bitmap(seq, "SW", dev->swbit, SW_MAX);
+	if (test_bit(EV_IR, dev->evbit))
+		input_seq_print_bitmap(seq, "IR", dev->irbit, IR_MAX);
 
 	seq_putc(seq, '\n');
 
@@ -1024,6 +1031,8 @@ static int input_print_modalias(char *buf, int size, struct input_dev *id,
 				'f', id->ffbit, 0, FF_MAX);
 	len += input_print_modalias_bits(buf + len, size - len,
 				'w', id->swbit, 0, SW_MAX);
+	len += input_print_modalias_bits(buf + len, size - len,
+				'i', id->irbit, 0, IR_MAX);
 
 	if (add_cr)
 		len += snprintf(buf + len, max(size - len, 0), "\n");
@@ -1125,6 +1134,7 @@ INPUT_DEV_CAP_ATTR(LED, led);
 INPUT_DEV_CAP_ATTR(SND, snd);
 INPUT_DEV_CAP_ATTR(FF, ff);
 INPUT_DEV_CAP_ATTR(SW, sw);
+INPUT_DEV_CAP_ATTR(IR, ir);
 
 static struct attribute *input_dev_caps_attrs[] = {
 	&dev_attr_ev.attr,
@@ -1136,6 +1146,7 @@ static struct attribute *input_dev_caps_attrs[] = {
 	&dev_attr_snd.attr,
 	&dev_attr_ff.attr,
 	&dev_attr_sw.attr,
+	&dev_attr_ir.attr,
 	NULL
 };
 
@@ -1253,6 +1264,8 @@ static int input_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 		INPUT_ADD_HOTPLUG_BM_VAR("FF=", dev->ffbit, FF_MAX);
 	if (test_bit(EV_SW, dev->evbit))
 		INPUT_ADD_HOTPLUG_BM_VAR("SW=", dev->swbit, SW_MAX);
+	if (test_bit(EV_IR, dev->evbit))
+		INPUT_ADD_HOTPLUG_BM_VAR("IR=", dev->irbit, IR_MAX);
 
 	INPUT_ADD_HOTPLUG_MODALIAS_VAR(dev);
 
@@ -1371,6 +1384,10 @@ void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int
 		__set_bit(code, dev->ffbit);
 		break;
 
+	case EV_IR:
+		__set_bit(code, dev->irbit);
+		break;
+
 	case EV_PWR:
 		/* do nothing */
 		break;
diff --git a/include/linux/input.h b/include/linux/input.h
index 8b3bc3e..159a99d 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -80,6 +80,8 @@ struct input_absinfo {
 #define EVIOCRMFF		_IOW('E', 0x81, int)			/* Erase a force effect */
 #define EVIOCGEFFECTS		_IOR('E', 0x84, int)			/* Report number of effects playable at the same time */
 
+#define EVIOIRSEND		_IOC(_IOC_WRITE, 'E', 0x80, sizeof(struct ir_command))	/* send an IR command */
+
 #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
 
 /*
@@ -98,6 +100,7 @@ struct input_absinfo {
 #define EV_FF			0x15
 #define EV_PWR			0x16
 #define EV_FF_STATUS		0x17
+#define EV_IR			0x18
 #define EV_MAX			0x1f
 #define EV_CNT			(EV_MAX+1)
 
@@ -985,6 +988,56 @@ struct ff_effect {
 #define FF_MAX		0x7f
 #define FF_CNT		(FF_MAX+1)
 
+/*
+ * IR Support
+ */
+
+#define IR_PROTOCOL_RESERVED 0
+#define IR_PROTOCOL_JVC 1
+#define IR_PROTOCOL_NEC 2
+#define IR_PROTOCOL_NOKIA 3
+#define IR_PROTOCOL_SHARP 4
+#define IR_PROTOCOL_SONY_12 5
+#define IR_PROTOCOL_SONY_15 6
+#define IR_PROTOCOL_SONY_20 7
+#define IR_PROTOCOL_PHILIPS_RC5 8
+#define IR_PROTOCOL_PHILIPS_RC6 9
+#define IR_PROTOCOL_PHILIPS_RCMM 10
+#define IR_PROTOCOL_PHILIPS_RECS80 11
+#define IR_PROTOCOL_RCA 12
+#define IR_PROTOCOL_ITT 13
+
+#define IR_PROTOCOL 1
+#define IR_DEVICE 2
+#define IR_COMMAND 3
+
+#define IR_CAP_RECEIVE_BASEBAND 0
+#define IR_CAP_RECEIVE_36K 1
+#define IR_CAP_RECEIVE_38K 2
+#define IR_CAP_RECEIVE_40K 3
+#define IR_CAP_RECEIVE_56K 4
+#define IR_CAP_SEND_BASEBAND 5
+#define IR_CAP_SEND_36K 6
+#define IR_CAP_SEND_38K 7
+#define IR_CAP_SEND_40K 8
+#define IR_CAP_SEND_56K 9
+#define IR_CAP_XMITTER_1 10
+#define IR_CAP_XMITTER_2 11
+#define IR_CAP_XMITTER_3 12
+#define IR_CAP_XMITTER_4 13
+#define IR_CAP_RECEIVE_RAW 14
+#define IR_CAP_SEND_RAW 15
+#define IR_MAX 0x0f
+#define IR_CNT IR_MAX + 1
+
+struct ir_command {
+	__u32 protocol;
+	__u32 device;
+	__u32 command;
+	__u32 transmitters;
+};
+
+
 #ifdef __KERNEL__
 
 /*
@@ -1012,6 +1065,7 @@ struct ff_effect {
  * @sndbit: bitmap of sound effects supported by the device
  * @ffbit: bitmap of force feedback effects supported by the device
  * @swbit: bitmap of switches present on the device
+ * @irbit: bitmap of capabilies of the IR hardware
  * @keycodemax: size of keycode table
  * @keycodesize: size of elements in keycode table
  * @keycode: map of scancodes to keycodes for this device
@@ -1084,6 +1138,7 @@ struct input_dev {
 	unsigned long sndbit[BITS_TO_LONGS(SND_CNT)];
 	unsigned long ffbit[BITS_TO_LONGS(FF_CNT)];
 	unsigned long swbit[BITS_TO_LONGS(SW_CNT)];
+	unsigned long irbit[BITS_TO_LONGS(IR_CNT)];
 
 	unsigned int keycodemax;
 	unsigned int keycodesize;
@@ -1092,6 +1147,7 @@ struct input_dev {
 	int (*getkeycode)(struct input_dev *dev, int scancode, int *keycode);
 
 	struct ff_device *ff;
+	struct ir_device *ir;
 
 	unsigned int repeat_key;
 	struct timer_list timer;
@@ -1328,6 +1384,11 @@ static inline void input_report_switch(struct input_dev *dev, unsigned int code,
 	input_event(dev, EV_SW, code, !!value);
 }
 
+static inline void input_report_ir(struct input_dev *dev, unsigned int code, int value)
+{
+	input_event(dev, EV_IR, code, value);
+}
+
 static inline void input_sync(struct input_dev *dev)
 {
 	input_event(dev, EV_SYN, SYN_REPORT, 0);
@@ -1411,5 +1472,19 @@ int input_ff_erase(struct input_dev *dev, int effect_id, struct file *file);
 int input_ff_create_memless(struct input_dev *dev, void *data,
 		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
 
+/**
+ * IR support functions
+ */
+
+typedef int (*send_func)(void *private, unsigned int *buffer, unsigned int count,
+		unsigned int frequency, unsigned int xmitters);
+
+int input_ir_create(struct input_dev *dev, void *private, send_func send);
+void input_ir_destroy(struct input_dev *dev);
+
+void input_ir_decode(struct input_dev *dev, unsigned int delta, unsigned int bit);
+int input_ir_send(struct input_dev *dev, struct ir_command *ir_command, struct file *file);
+int input_ir_register(struct input_dev *dev);
+
 #endif
 #endif
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 1bf5900..2bdf253 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -293,6 +293,7 @@ struct pcmcia_device_id {
 #define INPUT_DEVICE_ID_SND_MAX		0x07
 #define INPUT_DEVICE_ID_FF_MAX		0x7f
 #define INPUT_DEVICE_ID_SW_MAX		0x0f
+#define INPUT_DEVICE_ID_IR_MAX		0x0f
 
 #define INPUT_DEVICE_ID_MATCH_BUS	1
 #define INPUT_DEVICE_ID_MATCH_VENDOR	2
@@ -308,6 +309,7 @@ struct pcmcia_device_id {
 #define INPUT_DEVICE_ID_MATCH_SNDBIT	0x0400
 #define INPUT_DEVICE_ID_MATCH_FFBIT	0x0800
 #define INPUT_DEVICE_ID_MATCH_SWBIT	0x1000
+#define INPUT_DEVICE_ID_MATCH_IRBIT	0x2000
 
 struct input_device_id {
 
@@ -327,6 +329,7 @@ struct input_device_id {
 	kernel_ulong_t sndbit[INPUT_DEVICE_ID_SND_MAX / BITS_PER_LONG + 1];
 	kernel_ulong_t ffbit[INPUT_DEVICE_ID_FF_MAX / BITS_PER_LONG + 1];
 	kernel_ulong_t swbit[INPUT_DEVICE_ID_SW_MAX / BITS_PER_LONG + 1];
+	kernel_ulong_t irbit[INPUT_DEVICE_ID_IR_MAX / BITS_PER_LONG + 1];
 
 	kernel_ulong_t driver_info;
 };

