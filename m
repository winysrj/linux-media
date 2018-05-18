Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:36420 "EHLO
        homiemail-a44.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752366AbeEROGh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:06:37 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH] OV7251 requires probe_new, disable before 4.10
Date: Fri, 18 May 2018 09:06:31 -0500
Message-Id: <1526652391-18898-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1526652391-18898-1-git-send-email-brad@nextdimension.cc>
References: <1526652391-18898-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/versions.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index 167d0d3..0b87dfb 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -16,6 +16,7 @@ RADIO_WL128X
 [4.10.0]
 # needs *probe_new in struct i2c_driver
 VIDEO_OV5670
+VIDEO_OV7251
 
 [4.8.0]
 # needs i2c_new_secondary_device
-- 
2.7.4
