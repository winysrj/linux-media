Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:38389 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbJOQP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 12:15:29 -0400
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rc: allow rc modules to be loaded if rc-main is not a module
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ZmlBc-0001Rn-M2@rmk-PC.arm.linux.org.uk>
Date: Thu, 15 Oct 2015 17:15:24 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rc-main mistakenly uses #ifdef MODULE to determine whether it should
load the rc keymap modules.  This symbol is only defined if rc-main
is being built as a module itself, and bears no relation to whether
the rc keymaps are modules.

Fix this to use CONFIG_MODULES instead.

Fixes: 631493ecacd8 ("[media] rc-core: merge rc-map.c into rc-main.c")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/media/rc/rc-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index a639ea653c7e..70af646ca397 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -61,7 +61,7 @@ struct rc_map *rc_map_get(const char *name)
 	struct rc_map_list *map;
 
 	map = seek_rc_map(name);
-#ifdef MODULE
+#ifdef CONFIG_MODULES
 	if (!map) {
 		int rc = request_module("%s", name);
 		if (rc < 0) {
-- 
2.1.0

