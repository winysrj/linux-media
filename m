Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49337 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaCCKHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:53 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 50/79] [media] drx-j: Avoid any regressions by preserving old behavior
Date: Mon,  3 Mar 2014 07:06:44 -0300
Message-Id: <1393841233-24840-51-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The version is initialized with zero at drx_driver.c. Keep it,
in order to avoid the risk of causing any regression.

While here, remove the drx_driver.h from drxj, as this is not
required there.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index a06c45d92955..b92ca9013f55 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -39,7 +39,6 @@ INCLUDE FILES
 
 #include "drxj.h"
 #include "drxj_map.h"
-#include "drx_driver.h"
 
 /*============================================================================*/
 /*=== DEFINES ================================================================*/
@@ -20982,7 +20981,7 @@ static int drx_ctrl_version(struct drx_demod_instance *demod,
 {
 	static char drx_driver_core_module_name[] = "Core driver";
 	static char drx_driver_core_version_text[] =
-	    DRX_VERSIONSTRING(VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH);
+	    DRX_VERSIONSTRING(0, 0, 0);
 
 	static struct drx_version drx_driver_core_version;
 	static struct drx_version_list drx_driver_core_version_list;
@@ -21003,9 +21002,9 @@ static int drx_ctrl_version(struct drx_demod_instance *demod,
 	/* Always fill in the information of the driver SW . */
 	drx_driver_core_version.module_type = DRX_MODULE_DRIVERCORE;
 	drx_driver_core_version.module_name = drx_driver_core_module_name;
-	drx_driver_core_version.v_major = VERSION_MAJOR;
-	drx_driver_core_version.v_minor = VERSION_MINOR;
-	drx_driver_core_version.v_patch = VERSION_PATCH;
+	drx_driver_core_version.v_major = 0;
+	drx_driver_core_version.v_minor = 0;
+	drx_driver_core_version.v_patch = 0;
 	drx_driver_core_version.v_string = drx_driver_core_version_text;
 
 	drx_driver_core_version_list.version = &drx_driver_core_version;
-- 
1.8.5.3

