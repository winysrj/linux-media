Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0HACxv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 22:53:51 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o712rpWD002916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:53:51 -0400
Received: from pedra (vpn-10-93.rdu.redhat.com [10.11.10.93])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o712rkwE027490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:53:49 -0400
Date: Sat, 31 Jul 2010 23:54:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/7] V4L/DVB: Partially revert commit
 da7251dd0bca6c17571be2bd4434b9779dea72d8
Message-ID: <20100731235402.52f4c0e2@pedra>
In-Reply-To: <cover.1280630041.git.mchehab@redhat.com>
References: <cover.1280630041.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By mistake, changeset da7251dd0bca6c17571be2bd4434b9779dea72d8
reverted the following commits:
	commit 6795f9a1ac9e85deb96a49e46b29c809214bf5ea
	commit d69861a25a54ef1cd6ee92f5ceb6ff2c01d84803
	commit 1ba30538e2d125ce821622ac1f5e7ef31d856077

This patch partially reverts the original commit, to return the
code to its original state.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index a841e51..c533d8b 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -33,6 +33,21 @@ static struct class ir_input_class = {
 	.devnode	= ir_devnode,
 };
 
+static struct {
+	u64	type;
+	char	*name;
+} proto_names[] = {
+	{ IR_TYPE_UNKNOWN,	"unknown"	},
+	{ IR_TYPE_RC5,		"rc-5"		},
+	{ IR_TYPE_NEC,		"nec"		},
+	{ IR_TYPE_RC6,		"rc-6"		},
+	{ IR_TYPE_JVC,		"jvc"		},
+	{ IR_TYPE_SONY,		"sony"		},
+	{ IR_TYPE_LIRC,		"lirc"		},
+};
+
+#define PROTO_NONE	"none"
+
 /**
  * show_protocols() - shows the current IR protocol(s)
  * @d:		the device descriptor
@@ -50,6 +65,7 @@ static ssize_t show_protocols(struct device *d,
 	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
 	u64 allowed, enabled;
 	char *tmp = buf;
+	int i;
 
 	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
 		enabled = ir_dev->rc_tab.ir_type;
@@ -63,35 +79,12 @@ static ssize_t show_protocols(struct device *d,
 		   (long long)allowed,
 		   (long long)enabled);
 
-	if (allowed & enabled & IR_TYPE_UNKNOWN)
-		tmp += sprintf(tmp, "[unknown] ");
-	else if (allowed & IR_TYPE_UNKNOWN)
-		tmp += sprintf(tmp, "unknown ");
-
-	if (allowed & enabled & IR_TYPE_RC5)
-		tmp += sprintf(tmp, "[rc5] ");
-	else if (allowed & IR_TYPE_RC5)
-		tmp += sprintf(tmp, "rc5 ");
-
-	if (allowed & enabled & IR_TYPE_NEC)
-		tmp += sprintf(tmp, "[nec] ");
-	else if (allowed & IR_TYPE_NEC)
-		tmp += sprintf(tmp, "nec ");
-
-	if (allowed & enabled & IR_TYPE_RC6)
-		tmp += sprintf(tmp, "[rc6] ");
-	else if (allowed & IR_TYPE_RC6)
-		tmp += sprintf(tmp, "rc6 ");
-
-	if (allowed & enabled & IR_TYPE_JVC)
-		tmp += sprintf(tmp, "[jvc] ");
-	else if (allowed & IR_TYPE_JVC)
-		tmp += sprintf(tmp, "jvc ");
-
-	if (allowed & enabled & IR_TYPE_SONY)
-		tmp += sprintf(tmp, "[sony] ");
-	else if (allowed & IR_TYPE_SONY)
-		tmp += sprintf(tmp, "sony ");
+	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
+		if (allowed & enabled & proto_names[i].type)
+			tmp += sprintf(tmp, "[%s] ", proto_names[i].name);
+		else if (allowed & proto_names[i].type)
+			tmp += sprintf(tmp, "%s ", proto_names[i].name);
+	}
 
 	if (allowed & enabled & IR_TYPE_LIRC)
 		tmp += sprintf(tmp, "[lirc] ");
@@ -116,6 +109,7 @@ static ssize_t show_protocols(struct device *d,
  * Writing "+proto" will add a protocol to the list of enabled protocols.
  * Writing "-proto" will remove a protocol from the list of enabled protocols.
  * Writing "proto" will enable only "proto".
+ * Writing "none" will disable all protocols.
  * Returns -EINVAL if an invalid protocol combination or unknown protocol name
  * is used, otherwise @len.
  */
@@ -129,67 +123,62 @@ static ssize_t store_protocols(struct device *d,
 	const char *tmp;
 	u64 type;
 	u64 mask;
-	int rc;
+	int rc, i, count = 0;
 	unsigned long flags;
 
-	tmp = skip_spaces(data);
-
-	if (*tmp == '+') {
-		enable = true;
-		disable = false;
-		tmp++;
-	} else if (*tmp == '-') {
-		enable = false;
-		disable = true;
-		tmp++;
-	} else {
-		enable = false;
-		disable = false;
-	}
-
-	if (!strncasecmp(tmp, "unknown", 7)) {
-		tmp += 7;
-		mask = IR_TYPE_UNKNOWN;
-	} else if (!strncasecmp(tmp, "rc5", 3)) {
-		tmp += 3;
-		mask = IR_TYPE_RC5;
-	} else if (!strncasecmp(tmp, "nec", 3)) {
-		tmp += 3;
-		mask = IR_TYPE_NEC;
-	} else if (!strncasecmp(tmp, "rc6", 3)) {
-		tmp += 3;
-		mask = IR_TYPE_RC6;
-	} else if (!strncasecmp(tmp, "jvc", 3)) {
-		tmp += 3;
-		mask = IR_TYPE_JVC;
-	} else if (!strncasecmp(tmp, "sony", 4)) {
-		tmp += 4;
-		mask = IR_TYPE_SONY;
-	} else if (!strncasecmp(tmp, "lirc", 4)) {
-		tmp += 4;
-		mask = IR_TYPE_LIRC;
-	} else {
-		IR_dprintk(1, "Unknown protocol\n");
-		return -EINVAL;
-	}
-
-	tmp = skip_spaces(tmp);
-	if (*tmp != '\0') {
-		IR_dprintk(1, "Invalid trailing characters\n");
-		return -EINVAL;
-	}
-
 	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
 		type = ir_dev->rc_tab.ir_type;
 	else
 		type = ir_dev->raw->enabled_protocols;
 
-	if (enable)
-		type |= mask;
-	else if (disable)
-		type &= ~mask;
-	else
-		type = mask;
+	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
+		if (!*tmp)
+			break;
+
+		if (*tmp == '+') {
+			enable = true;
+			disable = false;
+			tmp++;
+		} else if (*tmp == '-') {
+			enable = false;
+			disable = true;
+			tmp++;
+		} else {
+			enable = false;
+			disable = false;
+		}
+
+		if (!enable && !disable && !strncasecmp(tmp, PROTO_NONE, sizeof(PROTO_NONE))) {
+			tmp += sizeof(PROTO_NONE);
+			mask = 0;
+			count++;
+		} else {
+			for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
+				if (!strncasecmp(tmp, proto_names[i].name, strlen(proto_names[i].name))) {
+					tmp += strlen(proto_names[i].name);
+					mask = proto_names[i].type;
+					break;
+				}
+			}
+			if (i == ARRAY_SIZE(proto_names)) {
+				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
+				return -EINVAL;
+			}
+			count++;
+		}
+
+		if (enable)
+			type |= mask;
+		else if (disable)
+			type &= ~mask;
+		else
+			type = mask;
+	}
+
+	if (!count) {
+		IR_dprintk(1, "Protocol not specified\n");
+		return -EINVAL;
+	}
 
 	if (ir_dev->props && ir_dev->props->change_protocol) {
 		rc = ir_dev->props->change_protocol(ir_dev->props->priv,
-- 
1.7.1


