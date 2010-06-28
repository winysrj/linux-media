Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0F1RA0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 13:00:26 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5SH0Qen021350
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 13:00:26 -0400
Received: from pedra (vpn-9-119.rdu.redhat.com [10.11.9.119])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o5SH0HGL008891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 13:00:25 -0400
Date: Mon, 28 Jun 2010 13:59:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] ir-core: Add support for disabling all protocols
Message-ID: <20100628135958.3b36a6bf@pedra>
In-Reply-To: <cover.1277744236.git.mchehab@redhat.com>
References: <cover.1277744236.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Writing "none" to /dev/class/rc/rc*/protocols will disable all protocols.
This allows an easier setup, from userspace, as userspace applications don't
need to disable protocol per protocol, before enabling a different set of
protocols.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 9a464a3..db8c7f4 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -45,6 +45,8 @@ static struct {
 	{ IR_TYPE_SONY,		"sony"		},
 };
 
+#define PROTO_NONE	"none"
+
 /**
  * show_protocols() - shows the current IR protocol(s)
  * @d:		the device descriptor
@@ -101,6 +103,7 @@ static ssize_t show_protocols(struct device *d,
  * Writing "+proto" will add a protocol to the list of enabled protocols.
  * Writing "-proto" will remove a protocol from the list of enabled protocols.
  * Writing "proto" will enable only "proto".
+ * Writing "none" will disable all protocols.
  * Returns -EINVAL if an invalid protocol combination or unknown protocol name
  * is used, otherwise @len.
  */
@@ -134,16 +137,22 @@ static ssize_t store_protocols(struct device *d,
 		disable = false;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
-		if (!strncasecmp(tmp, proto_names[i].name, strlen(proto_names[i].name))) {
-			tmp += strlen(proto_names[i].name);
-			mask = proto_names[i].type;
-			break;
+
+	if (!enable && !disable && !strncasecmp(tmp, PROTO_NONE, sizeof(PROTO_NONE))) {
+		mask = 0;
+		tmp += sizeof(PROTO_NONE);
+	} else {
+		for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
+			if (!strncasecmp(tmp, proto_names[i].name, strlen(proto_names[i].name))) {
+				tmp += strlen(proto_names[i].name);
+				mask = proto_names[i].type;
+				break;
+			}
+		}
+		if (i == ARRAY_SIZE(proto_names)) {
+			IR_dprintk(1, "Unknown protocol\n");
+			return -EINVAL;
 		}
-	}
-	if (i == ARRAY_SIZE(proto_names)) {
-		IR_dprintk(1, "Unknown protocol\n");
-		return -EINVAL;
 	}
 
 	tmp = skip_spaces(tmp);
-- 
1.7.1


