Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:46050 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751878AbeDRQML (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 12:12:11 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/5] Enable two drivers with backports
Date: Wed, 18 Apr 2018 11:12:03 -0500
Message-Id: <1524067927-12113-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524067927-12113-1-git-send-email-brad@nextdimension.cc>
References: <1524067927-12113-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

si2168 has i2c mux related backports to v3.4
cx231xx has i2c mux related backports to v3.4

Both drivers are tested working in kernel v3.2

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/versions.txt | 2 --
 1 file changed, 2 deletions(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index 4912fc2..6149f7a 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -15,9 +15,7 @@ VIDEO_OV5670
 
 [4.7.0]
 # needs i2c_mux_alloc
-VIDEO_CX231XX
 DVB_LGDT3306A
-DVB_SI2168
 DVB_RTL2830
 DVB_RTL2832
 DVB_M88DS3103
-- 
2.7.4
