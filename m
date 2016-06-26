Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52877 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbcFZKpG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2016 06:45:06 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B39DA180241
	for <linux-media@vger.kernel.org>; Sun, 26 Jun 2016 12:44:56 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] rc-main: fix kernel oops after unloading keymap module
Message-ID: <76672c91-bc43-0a4f-59d9-b21573bc9caf@xs4all.nl>
Date: Sun, 26 Jun 2016 12:44:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the rc_map table is created the char pointer of the name of the keymap
is copied to the rc_map->name field. However, this pointer points to memory
from the keymap module itself.

Since these keymap modules are not refcounted, that means anyone can call
rmmod to unload that module. Which is not a big deal because the contents of
the map is all copied to rc_map, except for the keymap name.

So after a keymap module is unloaded the name pointer has become stale. Unloading
the rc-core module will now cause a kernel oops in rc_dev_uevent().

The solution is to kstrdup the name so there are no more references to the
keymap module remaining.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
This fix should probably be backported to older kernels as well.

A general note: keymap loading has a big race condition: there is no protection
against unloading the keymap module between the call to seek_rc_map and the map
being copied. seek_rc_map should copy the map when it is found and while the
lock is still held. Or, alternatively, the keymap module's usecount should be
increased when its keymap is in use.
---
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 7dfc7c2..601ca23 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -130,13 +130,18 @@ static struct rc_map_list empty_map = {
 static int ir_create_table(struct rc_map *rc_map,
 			   const char *name, u64 rc_type, size_t size)
 {
-	rc_map->name = name;
+	rc_map->name = kstrdup(name, GFP_KERNEL);
+	if (!rc_map->name)
+		return -ENOMEM;
 	rc_map->rc_type = rc_type;
 	rc_map->alloc = roundup_pow_of_two(size * sizeof(struct rc_map_table));
 	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
 	rc_map->scan = kmalloc(rc_map->alloc, GFP_KERNEL);
-	if (!rc_map->scan)
+	if (!rc_map->scan) {
+		kfree(rc_map->name);
+		rc_map->name = NULL;
 		return -ENOMEM;
+	}

 	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
 		   rc_map->size, rc_map->alloc);
@@ -153,6 +158,7 @@ static int ir_create_table(struct rc_map *rc_map,
 static void ir_free_table(struct rc_map *rc_map)
 {
 	rc_map->size = 0;
+	kfree(rc_map->name);
 	kfree(rc_map->scan);
 	rc_map->scan = NULL;
 }
