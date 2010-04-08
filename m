Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933150Ab0DHThg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Apr 2010 15:37:36 -0400
Date: Thu, 8 Apr 2010 16:37:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/8] V4L/DVB: ir-core: properly present the supported and
 current protocols
Message-ID: <20100408163717.7d193308@pedra>
In-Reply-To: <cover.1270754989.git.mchehab@redhat.com>
References: <cover.1270754989.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hardware decoders have a more limited set of decoders than software ones.
In general, they support just one protocol at a given time, but allow
changing between a few options.

Rename the previous badly named "current_protocol" as just "protocol",
meaning the current protocol(s) accepted by the driver, and
add a "support_protocols" to represent the entire universe of supported
protocols by that specific hardware.

As commented on http://lwn.net/Articles/378884/, the "one file, one value"
rule doesn't fit nor does make much sense for bitmap or enum values. So, the
supported_protocols will enum all supported protocols, and the protocol
will present all active protocols.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index efde912..9d132d0 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -55,13 +55,13 @@ static ssize_t show_protocol(struct device *d,
 	if (ir_type == IR_TYPE_UNKNOWN)
 		s = "Unknown";
 	else if (ir_type == IR_TYPE_RC5)
-		s = "RC-5";
+		s = "rc-5";
 	else if (ir_type == IR_TYPE_PD)
-		s = "Pulse/distance";
+		s = "pulse-distance";
 	else if (ir_type == IR_TYPE_NEC)
-		s = "NEC";
+		s = "nec";
 	else
-		s = "Other";
+		s = "other";
 
 	return sprintf(buf, "%s\n", s);
 }
@@ -85,23 +85,22 @@ static ssize_t store_protocol(struct device *d,
 			      size_t len)
 {
 	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
-	u64 ir_type = IR_TYPE_UNKNOWN;
+	u64 ir_type = 0;
 	int rc = -EINVAL;
 	unsigned long flags;
 	char *buf;
 
-	buf = strsep((char **) &data, "\n");
+	while (buf = strsep((char **) &data, " \n")) {
+		if (!strcasecmp(buf, "rc-5") || !strcasecmp(buf, "rc5"))
+			ir_type |= IR_TYPE_RC5;
+		if (!strcasecmp(buf, "pd") || !strcasecmp(buf, "pulse-distance"))
+			ir_type |= IR_TYPE_PD;
+		if (!strcasecmp(buf, "nec"))
+			ir_type |= IR_TYPE_NEC;
+	}
 
-	if (!strcasecmp(buf, "rc-5") || !strcasecmp(buf, "rc5"))
-		ir_type = IR_TYPE_RC5;
-	else if (!strcasecmp(buf, "pd"))
-		ir_type = IR_TYPE_PD;
-	else if (!strcasecmp(buf, "nec"))
-		ir_type = IR_TYPE_NEC;
-
-	if (ir_type == IR_TYPE_UNKNOWN) {
-		IR_dprintk(1, "Error setting protocol to %lld\n",
-			   (long long)ir_type);
+	if (!ir_type) {
+		IR_dprintk(1, "Unknown protocol\n");
 		return -EINVAL;
 	}
 
@@ -119,12 +118,34 @@ static ssize_t store_protocol(struct device *d,
 	ir_dev->rc_tab.ir_type = ir_type;
 	spin_unlock_irqrestore(&ir_dev->rc_tab.lock, flags);
 
-	IR_dprintk(1, "Current protocol is %lld\n",
+	IR_dprintk(1, "Current protocol(s) is(are) %lld\n",
 		   (long long)ir_type);
 
 	return len;
 }
 
+static ssize_t show_supported_protocols(struct device *d,
+			     struct device_attribute *mattr, char *buf)
+{
+	char *orgbuf = buf;
+	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+
+	/* FIXME: doesn't support multiple protocols at the same time */
+	if (ir_dev->props->allowed_protos == IR_TYPE_UNKNOWN)
+		buf += sprintf(buf, "unknown ");
+	if (ir_dev->props->allowed_protos & IR_TYPE_RC5)
+		buf += sprintf(buf, "rc-5 ");
+	if (ir_dev->props->allowed_protos & IR_TYPE_PD)
+		buf += sprintf(buf, "pulse-distance ");
+	if (ir_dev->props->allowed_protos & IR_TYPE_NEC)
+		buf += sprintf(buf, "nec ");
+	if (buf == orgbuf)
+		buf += sprintf(buf, "other ");
+
+	buf += sprintf(buf - 1, "\n");
+
+	return buf - orgbuf;
+}
 
 #define ADD_HOTPLUG_VAR(fmt, val...)					\
 	do {								\
@@ -148,11 +169,15 @@ static int ir_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 /*
  * Static device attribute struct with the sysfs attributes for IR's
  */
-static DEVICE_ATTR(current_protocol, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(protocol, S_IRUGO | S_IWUSR,
 		   show_protocol, store_protocol);
 
+static DEVICE_ATTR(supported_protocols, S_IRUGO | S_IWUSR,
+		   show_supported_protocols, NULL);
+
 static struct attribute *ir_hw_dev_attrs[] = {
-	&dev_attr_current_protocol.attr,
+	&dev_attr_protocol.attr,
+	&dev_attr_supported_protocols.attr,
 	NULL,
 };
 
-- 
1.6.6.1


