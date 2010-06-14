Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52855 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab0FNU06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 16:26:58 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	clemens@ladisch.de, debora@linux.vnet.ibm.com,
	dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/8]drm:drm_gem Fix  warning: variable 'dev' set but not used
Date: Mon, 14 Jun 2010 13:26:45 -0700
Message-Id: <1276547208-26569-6-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Probably not even a fix for this warning:

  CC [M]  drivers/gpu/drm/drm_gem.o
drivers/gpu/drm/drm_gem.c: In function 'drm_gem_handle_delete':
drivers/gpu/drm/drm_gem.c:188:21: warning: variable 'dev' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/gpu/drm/drm_gem.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 33dad3f..e8180c9 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -206,6 +206,8 @@ drm_gem_handle_delete(struct drm_file *filp, u32 handle)
 		return -EINVAL;
 	}
 	dev = obj->dev;
+	if (!dev)
+		dev = 0;
 
 	/* Release reference and decrement refcount. */
 	idr_remove(&filp->object_idr, handle);
-- 
1.7.1.rc1.21.gf3bd6

