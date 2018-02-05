Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:41567 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753101AbeBEOhd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 09:37:33 -0500
From: Florian Echtler <floe@butterbrot.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: linux-input@vger.kernel.org, modin@yuri.at,
        Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 1/5] add missing blob structure tag field
Date: Mon,  5 Feb 2018 15:29:37 +0100
Message-Id: <1517840981-12280-2-git-send-email-floe@butterbrot.org>
In-Reply-To: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
References: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index f16f835..8375b06 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -81,7 +81,10 @@ struct sur40_blob {
 
 	__le32 area;       /* size in pixels/pressure (?) */
 
-	u8 padding[32];
+	u8 padding[24];
+
+	__le32 tag_id;     /* valid when type == 0x04 (SUR40_TAG) */
+	__le32 unknown;
 
 } __packed;
 
-- 
2.7.4
