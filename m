Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33044 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbKWOVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 09:21:22 -0500
From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] rc-core: Try loading modules if the kernel supports them
Date: Mon, 23 Nov 2015 15:21:18 +0100
Message-Id: <1448288478-23042-1-git-send-email-sjoerd.simons@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Always try to load modules for RC keymaps when the kernel supports
modules, not just when the RC Core is build as a module. Fixes
module autoloading issues when the core is builtin but the keymaps
are not.

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

---

 drivers/media/rc/rc-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 3f0f71a..ea1008c 100644
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
2.6.2

