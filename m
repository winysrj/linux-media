Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34897 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756863AbeDZR1i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 13:27:38 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 4/7] Disable SOC_CAMERA for kernels older than 3.5
Date: Thu, 26 Apr 2018 12:19:19 -0500
Message-Id: <1524763162-4865-5-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Needs of_find_i2c_adapter_by_node

Migrated from 3.5 to 3.12.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/versions.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index f5e9a42..fcd6949 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -184,6 +184,7 @@ MEDIA_TUNER_E4000
 DVB_USB_AF9015
 # needs of_find_i2c_adapter_by_node
 DVB_C8SECTPFE
+SOC_CAMERA
 
 [3.4.0]
 # needs devm_regulator_bulk_get
@@ -228,7 +229,6 @@ VIDEO_GS1662
 
 [3.2.0]
 # due to the rename at include/linux from "pm_qos_params.h" to "pm_qos.h"
-SOC_CAMERA
 SOC_CAMERA_MT9V022
 SOC_CAMERA_MT9M001
 SOC_CAMERA_MT9T031
-- 
2.7.4
