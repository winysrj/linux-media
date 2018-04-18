Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:46067 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752699AbeDRQMM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 12:12:12 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 5/5] Remove lgdt3306a v4.7 limitation
Date: Wed, 18 Apr 2018 11:12:07 -0500
Message-Id: <1524067927-12113-6-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524067927-12113-1-git-send-email-brad@nextdimension.cc>
References: <1524067927-12113-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Backports are now included for lgdt3306a back
to v3.4 and the driver has been well tested
back to kernel v3.2

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/versions.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index 6149f7a..6220485 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -15,7 +15,6 @@ VIDEO_OV5670
 
 [4.7.0]
 # needs i2c_mux_alloc
-DVB_LGDT3306A
 DVB_RTL2830
 DVB_RTL2832
 DVB_M88DS3103
-- 
2.7.4
