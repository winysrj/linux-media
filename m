Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33840 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbGKGKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jul 2015 02:10:00 -0400
Date: Sat, 11 Jul 2015 08:47:37 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rc/keymaps: Add helper macro for rc_map_list
 boilerplate
Message-ID: <20150711031737.GA12067@vaishali-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For simple modules that contain a single rc_map_list without any
additional setup code then ends up being a block of duplicated
boilerplate. This patch adds a new macro, module_rc_map_list(),
which replaces the module_init()/module_exit() registrations with
template functions.

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 include/media/rc-map.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 27763d5..07e765d 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -96,6 +96,16 @@ struct rc_map_list {
 	struct rc_map map;
 };
 
+/**
+ * module_rc_map_list() - Helper macro for registering a RC drivers
+ * @__rc_map_list: rc_map_list struct
+ * Helper macro for RC drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only
+ * use this macro once, and calling it replaces module_init() and module_exit()
+ */
+#define module_rc_map_list(__rc_map_list) \
+	module_driver(__rc_map_list, rc_map_register, rc_map_unregister)
+
 /* Routines from rc-map.c */
 
 int rc_map_register(struct rc_map_list *map);
-- 
1.9.1

