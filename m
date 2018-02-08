Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:43619 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752054AbeBHIhC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 03:37:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCHv2 10/15] media: media-types.rst: fix typo
Date: Thu,  8 Feb 2018 09:36:50 +0100
Message-Id: <20180208083655.32248-11-hverkuil@xs4all.nl>
In-Reply-To: <20180208083655.32248-1-hverkuil@xs4all.nl>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alexandre Courbot <acourbot@chromium.org>

with -> which

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 Documentation/media/uapi/mediactl/media-types.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 9c1e3d3f590c..01b0b60771dd 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -26,7 +26,7 @@ Types and flags used to represent the media graph elements
 	  ``MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN``
 
        -  Unknown entity. That generally indicates that a driver didn't
-	  initialize properly the entity, with is a Kernel bug
+	  initialize properly the entity, which is a Kernel bug
 
     -  .. row 2
 
-- 
2.15.1
