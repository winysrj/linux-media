Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44286 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305Ab2EWJyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:55 -0400
Subject: [PATCH 41/43] rc-core: add keytable events
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:45:36 +0200
Message-ID: <20120523094535.14474.51347.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add separe rc device events on keytable addition/removal.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |    2 ++
 include/media/rc-core.h    |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 6c8bc3a..b16dbf4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -513,6 +513,7 @@ static int rc_add_keytable(struct rc_dev *dev, const char *name,
 	rcu_assign_pointer(dev->keytables[i], kt);
 	list_add_rcu(&kt->node, &dev->keytable_list);
 	synchronize_rcu();
+	rc_event(dev, RC_CORE, RC_CORE_KT_ADDED, i);
 	return 0;
 }
 
@@ -530,6 +531,7 @@ static int rc_remove_keytable(struct rc_dev *dev, unsigned i)
 		return -EINVAL;
 
 	rc_keytable_destroy(kt);
+	rc_event(dev, RC_CORE, RC_CORE_KT_REMOVED, i);
 	return 0;
 }
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index ea3dcf4..056275a 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -221,6 +221,8 @@ struct rc_event {
 
 /* RC_CORE codes */
 #define RC_CORE_DROPPED		0x0
+#define RC_CORE_KT_ADDED	0x1
+#define RC_CORE_KT_REMOVED	0x2
 
 /* RC_KEY codes */
 #define RC_KEY_REPEAT		0x0

