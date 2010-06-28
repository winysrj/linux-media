Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0F1RAW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 13:00:22 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5SH0LqZ002516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 13:00:22 -0400
Received: from pedra (vpn-9-119.rdu.redhat.com [10.11.9.119])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o5SH0HGI008891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 13:00:20 -0400
Date: Mon, 28 Jun 2010 14:00:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] ir-core: Remove magic numbers at the sysfs logic
Message-ID: <20100628140000.2fef2911@pedra>
In-Reply-To: <cover.1277744236.git.mchehab@redhat.com>
References: <cover.1277744236.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using "magic" sizes for protocol names, replace them by an
array, and use strlen().

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index f73e4a6..2b1a9d2 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -33,6 +33,18 @@ static struct class ir_input_class = {
 	.devnode	= ir_devnode,
 };
 
+static struct {
+	u64	type;
+	char	*name;
+} proto_names[] = {
+	{ IR_TYPE_UNKNOWN,	"unknown"	},
+	{ IR_TYPE_RC5,		"rc5"		},
+	{ IR_TYPE_NEC,		"nec"		},
+	{ IR_TYPE_RC6,		"rc6"		},
+	{ IR_TYPE_JVC,		"jvc"		},
+	{ IR_TYPE_SONY,		"sony"		},
+};
+
 /**
  * show_protocols() - shows the current IR protocol(s)
  * @d:		the device descriptor
@@ -50,6 +62,7 @@ static ssize_t show_protocols(struct device *d,
 	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
 	u64 allowed, enabled;
 	char *tmp = buf;
+	int i;
 
 	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
 		enabled = ir_dev->rc_tab.ir_type;
@@ -63,35 +76,12 @@ static ssize_t show_protocols(struct device *d,
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
 
 	if (tmp != buf)
 		tmp--;
@@ -124,12 +114,14 @@ static ssize_t store_protocols(struct device *d,
 	const char *tmp;
 	u64 type;
 	u64 mask;
-	int rc;
+	int rc, i;
 	unsigned long flags;
 
 	tmp = skip_spaces(data);
-
-	if (*tmp == '+') {
+	if (*tmp == '\0') {
+		IR_dprintk(1, "Protocol not specified\n");
+		return -EINVAL;
+	} else if (*tmp == '+') {
 		enable = true;
 		disable = false;
 		tmp++;
@@ -142,25 +134,14 @@ static ssize_t store_protocols(struct device *d,
 		disable = false;
 	}
 
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
-	} else {
+	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
+		if (!strncasecmp(tmp, proto_names[i].name, strlen(proto_names[i].name))) {
+			tmp += strlen(proto_names[i].name);
+			mask = proto_names[i].type;
+			break;
+		}
+	}
+	if (i == ARRAY_SIZE(proto_names)) {
 		IR_dprintk(1, "Unknown protocol\n");
 		return -EINVAL;
 	}
-- 
1.7.1


