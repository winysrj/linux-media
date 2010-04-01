Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758694Ab0DAR5z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:57:55 -0400
Date: Thu, 1 Apr 2010 14:56:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/15] V4L/DVB: ir-nec-decoder: Add sysfs node to
 enable/disable per irrcv
Message-ID: <20100401145631.716b7967@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the help of raw_register/raw_unregister, adds a sysfs group
associated with the decoder, inside the corresponding irrcv node.

Writing 1 to nec_decoder/enabled enables the decoder, while
writing 0 disables it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index cb57cc2..83a9912 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -39,6 +39,85 @@
 
 #define REPEAT_TIME	240 /* ms */
 
+/* Used to register nec_decoder clients */
+static LIST_HEAD(decoder_list);
+static spinlock_t decoder_lock;
+
+struct decoder_data {
+	struct list_head	list;
+	struct ir_input_dev	*ir_dev;
+	int			enabled:1;
+};
+
+
+/**
+ * get_decoder_data()	- gets decoder data
+ * @input_dev:	input device
+ *
+ * Returns the struct decoder_data that corresponds to a device
+ */
+
+static struct decoder_data *get_decoder_data(struct  ir_input_dev *ir_dev)
+{
+	struct decoder_data *data = NULL;
+
+	spin_lock(&decoder_lock);
+	list_for_each_entry(data, &decoder_list, list) {
+		if (data->ir_dev == ir_dev)
+			break;
+	}
+	spin_unlock(&decoder_lock);
+	return data;
+}
+
+static ssize_t store_enabled(struct device *d,
+			     struct device_attribute *mattr,
+			     const char *buf,
+			     size_t len)
+{
+	unsigned long value;
+	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	struct decoder_data *data = get_decoder_data(ir_dev);
+
+	if (!data)
+		return -EINVAL;
+
+	if (strict_strtoul(buf, 10, &value) || value > 1)
+		return -EINVAL;
+
+	data->enabled = value;
+
+	return len;
+}
+
+static ssize_t show_enabled(struct device *d,
+			     struct device_attribute *mattr, char *buf)
+{
+	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	struct decoder_data *data = get_decoder_data(ir_dev);
+
+	if (!data)
+		return -EINVAL;
+
+	if (data->enabled)
+		return sprintf(buf, "1\n");
+	else
+	return sprintf(buf, "0\n");
+}
+
+static DEVICE_ATTR(enabled, S_IRUGO | S_IWUSR, show_enabled, store_enabled);
+
+static struct attribute *decoder_attributes[] = {
+	&dev_attr_enabled.attr,
+	NULL
+};
+
+static struct attribute_group decoder_attribute_group = {
+	.name	= "nec_decoder",
+	.attrs	= decoder_attributes,
+};
+
+
 /** is_repeat - Check if it is a NEC repeat event
  * @input_dev:	the struct input_dev descriptor of the device
  * @pos:	the position of the first event
@@ -184,9 +263,15 @@ static int ir_nec_decode(struct input_dev *input_dev,
 			 struct ir_raw_event *evs,
 			 int len)
 {
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct decoder_data *data;
 	int pos = 0;
 	int rc = 0;
 
+	data = get_decoder_data(ir_dev);
+	if (!data || !data->enabled)
+		return 0;
+
 	while (pos < len) {
 		if (__ir_nec_decode(input_dev, evs, len, &pos) > 0)
 			rc++;
@@ -194,8 +279,54 @@ static int ir_nec_decode(struct input_dev *input_dev,
 	return rc;
 }
 
+static int ir_nec_register(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct decoder_data *data;
+	int rc;
+
+	rc = sysfs_create_group(&ir_dev->dev.kobj, &decoder_attribute_group);
+	if (rc < 0)
+		return rc;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		sysfs_remove_group(&ir_dev->dev.kobj, &decoder_attribute_group);
+		return -ENOMEM;
+	}
+
+	data->ir_dev = ir_dev;
+	data->enabled = 1;
+
+	spin_lock(&decoder_lock);
+	list_add_tail(&data->list, &decoder_list);
+	spin_unlock(&decoder_lock);
+
+	return 0;
+}
+
+static int ir_nec_unregister(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	static struct decoder_data *data;
+
+	data = get_decoder_data(ir_dev);
+	if (!data)
+		return 0;
+
+	sysfs_remove_group(&ir_dev->dev.kobj, &decoder_attribute_group);
+
+	spin_lock(&decoder_lock);
+	list_del(&data->list);
+	spin_unlock(&decoder_lock);
+
+	return 0;
+}
+
 static struct ir_raw_handler nec_handler = {
-	.decode = ir_nec_decode,
+	.decode		= ir_nec_decode,
+	.raw_register	= ir_nec_register,
+	.raw_unregister	= ir_nec_unregister,
 };
 
 static int __init ir_nec_decode_init(void)
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 11f23f4..371d88e 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -223,7 +223,7 @@ static void init_decoders(struct work_struct *work)
 void ir_raw_init(void)
 {
 	spin_lock_init(&ir_raw_handler_lock);
-	
+
 #ifdef MODULE
 	INIT_WORK(&wq_load, init_decoders);
 	schedule_work(&wq_load);
-- 
1.6.6.1


