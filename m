Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0F1RAZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 13:00:25 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5SH0P5D029471
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 13:00:25 -0400
Received: from pedra (vpn-9-119.rdu.redhat.com [10.11.9.119])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o5SH0HGK008891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 13:00:23 -0400
Date: Mon, 28 Jun 2010 13:59:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] ir-core: allow specifying multiple protocols at one
 open/write
Message-ID: <20100628135957.4bb18df2@pedra>
In-Reply-To: <cover.1277744236.git.mchehab@redhat.com>
References: <cover.1277744236.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With this change, it is now possible to do something like:
        su -c 'echo "none +rc-5 +nec" > /sys/class/rc/rc1/protocols'

This prevents the need of multiple opens, one for each protocol change,
and makes userspace application easier.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index db8c7f4..e538f16 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -117,61 +117,62 @@ static ssize_t store_protocols(struct device *d,
 	const char *tmp;
 	u64 type;
 	u64 mask;
-	int rc, i;
+	int rc, i, count = 0;
 	unsigned long flags;
 
-	tmp = skip_spaces(data);
-	if (*tmp == '\0') {
-		IR_dprintk(1, "Protocol not specified\n");
-		return -EINVAL;
-	} else if (*tmp == '+') {
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
-
-	if (!enable && !disable && !strncasecmp(tmp, PROTO_NONE, sizeof(PROTO_NONE))) {
-		mask = 0;
-		tmp += sizeof(PROTO_NONE);
-	} else {
-		for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
-			if (!strncasecmp(tmp, proto_names[i].name, strlen(proto_names[i].name))) {
-				tmp += strlen(proto_names[i].name);
-				mask = proto_names[i].type;
-				break;
-			}
-		}
-		if (i == ARRAY_SIZE(proto_names)) {
-			IR_dprintk(1, "Unknown protocol\n");
-			return -EINVAL;
-		}
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
@@ -191,7 +192,6 @@ static ssize_t store_protocols(struct device *d,
 		ir_dev->raw->enabled_protocols = type;
 	}
 
-
 	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
 		   (long long)type);
 
-- 
1.7.1

