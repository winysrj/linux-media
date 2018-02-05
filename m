Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:40972 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752166AbeBECYT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Feb 2018 21:24:19 -0500
Received: by mail-pl0-f65.google.com with SMTP id k8so8579169pli.8
        for <linux-media@vger.kernel.org>; Sun, 04 Feb 2018 18:24:19 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] media: media-types.rst: fix typo
Date: Mon,  5 Feb 2018 11:24:02 +0900
Message-Id: <20180205022402.153959-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

with -> which

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 Documentation/media/uapi/mediactl/media-types.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 8d64b0c06ebc..932823e3cca8 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -26,7 +26,7 @@ Types and flags used to represent the media graph elements
 	  ``MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN``
 
        -  Unknown entity. That generally indicates that a driver didn't
-	  initialize properly the entity, with is a Kernel bug
+	  initialize properly the entity, which is a Kernel bug
 
     -  .. row 2
 
-- 
2.16.0.rc1.238.g530d649a79-goog
