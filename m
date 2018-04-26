Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34895 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756862AbeDZR1h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 13:27:37 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 3/7] Disable DVBC8SECTPFE for kernels older than 3.5
Date: Thu, 26 Apr 2018 12:19:18 -0500
Message-Id: <1524763162-4865-4-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Needs of_find_i2c_adapter_by_node

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/versions.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index 2306830..f5e9a42 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -182,6 +182,8 @@ VIDEO_S5K6AA
 MEDIA_TUNER_E4000
 # needs regmap_init with 4 arguments
 DVB_USB_AF9015
+# needs of_find_i2c_adapter_by_node
+DVB_C8SECTPFE
 
 [3.4.0]
 # needs devm_regulator_bulk_get
-- 
2.7.4
