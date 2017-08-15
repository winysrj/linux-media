Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36305 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751509AbdHOLYD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 07:24:03 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: p.zabel@pengutronix.de, mchehab@kernel.org,
        prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 2/3] [media] davinci: constify platform_device_id
Date: Tue, 15 Aug 2017 16:53:41 +0530
Message-Id: <1502796222-9681-3-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1502796222-9681-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502796222-9681-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

platform_device_id are not supposed to change at runtime. All functions
working with platform_device_id provided by <linux/platform_device.h>
work with const platform_device_id. So mark the non-const structs as
const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/platform/davinci/vpbe_osd.c  | 2 +-
 drivers/media/platform/davinci/vpbe_venc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
index df042e8..6644979 100644
--- a/drivers/media/platform/davinci/vpbe_osd.c
+++ b/drivers/media/platform/davinci/vpbe_osd.c
@@ -37,7 +37,7 @@
 
 #define MODULE_NAME	"davinci-vpbe-osd"
 
-static struct platform_device_id vpbe_osd_devtype[] = {
+static const struct platform_device_id vpbe_osd_devtype[] = {
 	{
 		.name = DM644X_VPBE_OSD_SUBDEV_NAME,
 		.driver_data = VPBE_VERSION_1,
diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
index 8bfe90a..3a4e785 100644
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -36,7 +36,7 @@
 
 #define MODULE_NAME	"davinci-vpbe-venc"
 
-static struct platform_device_id vpbe_venc_devtype[] = {
+static const struct platform_device_id vpbe_venc_devtype[] = {
 	{
 		.name = DM644X_VPBE_VENC_SUBDEV_NAME,
 		.driver_data = VPBE_VERSION_1,
-- 
2.7.4
