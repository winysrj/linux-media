Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34882 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756858AbeDZR1g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 13:27:36 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/7] Disable VIDEO_ADV748X for kernels older than 4.8
Date: Thu, 26 Apr 2018 12:19:16 -0500
Message-Id: <1524763162-4865-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Needs i2c_new_secondary_device

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/versions.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index 6220485..ae0731d 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -13,6 +13,10 @@ RADIO_WL128X
 # needs *probe_new in struct i2c_driver
 VIDEO_OV5670
 
+[4.8.0]
+# needs i2c_new_secondary_device
+VIDEO_ADV748X
+
 [4.7.0]
 # needs i2c_mux_alloc
 DVB_RTL2830
-- 
2.7.4
