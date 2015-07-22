Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52669 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbbGVUz1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 16:55:27 -0400
Subject: [PATCH] rc-core: improve the lirc protocol reporting
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Wed, 22 Jul 2015 22:55:24 +0200
Message-ID: <20150722205524.1907.37521.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 275ddb40bcf686d210d86c6718e42425a6a0bc76 removed the lirc
"protocol" but kept backwards compatibility by always listing
the protocol as present and enabled. This patch further improves
the logic by only listing the protocol if the lirc module is loaded
(or if lirc is builtin).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index ecaee02..3f0f71a 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -828,6 +828,23 @@ struct rc_filter_attribute {
 		.mask = (_mask),					\
 	}
 
+static bool lirc_is_present(void)
+{
+#if defined(CONFIG_LIRC_MODULE)
+	struct module *lirc;
+
+	mutex_lock(&module_mutex);
+	lirc = find_module("lirc_dev");
+	mutex_unlock(&module_mutex);
+
+	return lirc ? true : false;
+#elif defined(CONFIG_LIRC)
+	return true;
+#else
+	return false;
+#endif
+}
+
 /**
  * show_protocols() - shows the current/wakeup IR protocol(s)
  * @device:	the device descriptor
@@ -882,7 +899,7 @@ static ssize_t show_protocols(struct device *device,
 			allowed &= ~proto_names[i].type;
 	}
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW)
+	if (dev->driver_type == RC_DRIVER_IR_RAW && lirc_is_present())
 		tmp += sprintf(tmp, "[lirc] ");
 
 	if (tmp != buf)

