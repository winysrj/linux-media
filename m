Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42399 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460AbZKGVvw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:51:52 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:51:55 +0000
Message-ID: <1257630715.15927.431.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 35/75] pvrusb2: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/pvrusb2/pvrusb2-devattr.c |    4 ++++
 drivers/media/video/pvrusb2/pvrusb2-hdw.c     |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-devattr.c b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
index e4d7c13..aa65a8d 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-devattr.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
@@ -56,6 +56,7 @@ static const struct pvr2_device_client_desc pvr2_cli_29xxx[] = {
 static const char *pvr2_fw1_names_29xxx[] = {
 		"v4l-pvrusb2-29xxx-01.fw",
 };
+MODULE_FIRMWARE("v4l-pvrusb2-29xxx-01.fw");
 
 static const struct pvr2_device_desc pvr2_device_29xxx = {
 		.description = "WinTV PVR USB2 Model Category 29xxx",
@@ -89,6 +90,7 @@ static const struct pvr2_device_client_desc pvr2_cli_24xxx[] = {
 static const char *pvr2_fw1_names_24xxx[] = {
 		"v4l-pvrusb2-24xxx-01.fw",
 };
+MODULE_FIRMWARE("v4l-pvrusb2-24xxx-01.fw");
 
 static const struct pvr2_device_desc pvr2_device_24xxx = {
 		.description = "WinTV PVR USB2 Model Category 24xxx",
@@ -338,6 +340,7 @@ static const struct pvr2_device_client_desc pvr2_cli_73xxx[] = {
 static const char *pvr2_fw1_names_73xxx[] = {
 		"v4l-pvrusb2-73xxx-01.fw",
 };
+MODULE_FIRMWARE("v4l-pvrusb2-73xxx-01.fw");
 
 static const struct pvr2_device_desc pvr2_device_73xxx = {
 		.description = "WinTV HVR-1900 Model Category 73xxx",
@@ -443,6 +446,7 @@ static const struct pvr2_dvb_props pvr2_751xx_dvb_props = {
 static const char *pvr2_fw1_names_75xxx[] = {
 		"v4l-pvrusb2-73xxx-01.fw",
 };
+MODULE_FIRMWARE("v4l-pvrusb2-73xxx-01.fw");
 
 static const struct pvr2_device_desc pvr2_device_750xx = {
 		.description = "WinTV HVR-1950 Model Category 750xx",
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index 4c1a2a5..97a6713 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -1674,6 +1674,7 @@ int pvr2_upload_firmware2(struct pvr2_hdw *hdw)
 	return ret;
 }
 
+MODULE_FIRMWARE(CX2341X_FIRM_ENC_FILENAME);
 
 static const char *pvr2_get_state_name(unsigned int st)
 {
-- 
1.6.5.2



