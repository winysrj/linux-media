Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:54605 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521AbcHIVlr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:47 -0400
Subject: [PATCH 01/12] [media] rc-main: clear rc_map.name in ir_free_table()
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:32:06 +0200
Message-ID: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rc_unregister_device() will first call ir_free_table(), and later
device_del(); however, the latter causes a call to rc_dev_uevent(),
which prints rc_map.name, which at this point has already bee freed.

This fixes a use-after-free bug found with KASAN.

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/rc/rc-main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 8e7f292..1e5a520 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -159,6 +159,7 @@ static void ir_free_table(struct rc_map *rc_map)
 {
 	rc_map->size = 0;
 	kfree(rc_map->name);
+	rc_map->name = NULL;
 	kfree(rc_map->scan);
 	rc_map->scan = NULL;
 }

