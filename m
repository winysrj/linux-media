Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36672 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1B0RiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 12:38:15 -0500
Received: from localhost.localdomain (unknown [91.178.64.100])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 848A035995
	for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 17:38:14 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: videobuf2: Typo fix
Date: Sun, 27 Feb 2011 18:38:19 +0100
Message-Id: <1298828299-9615-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

vb2_get_plane_payload() gets the bytesused field for a plane, it doesn't
set it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/videobuf2-core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 0d71fc5..597efe6 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -351,7 +351,7 @@ static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
 }
 
 /**
- * vb2_get_plane_payload() - set bytesused for the plane plane_no
+ * vb2_get_plane_payload() - get bytesused for the plane plane_no
  * @vb:		buffer for which plane payload should be set
  * @plane_no:	plane number for which payload should be set
  * @size:	payload in bytes
-- 
1.7.3.4

