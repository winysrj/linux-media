Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33772 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753185AbeDKNkE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 09:40:04 -0400
Received: by mail-wm0-f68.google.com with SMTP id o23so25549974wmf.0
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2018 06:40:04 -0700 (PDT)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: [PATCH 3/5] drm/ttm: remove the backing store if no placement is given
Date: Wed, 11 Apr 2018 15:39:57 +0200
Message-Id: <20180411133959.4257-3-christian.koenig@amd.com>
In-Reply-To: <20180411133959.4257-1-christian.koenig@amd.com>
References: <20180411133959.4257-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pipeline removal of the BOs backing store when the placement is given
during validation.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 98e06f8bf23b..17e821f01d0a 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1078,6 +1078,18 @@ int ttm_bo_validate(struct ttm_buffer_object *bo,
 	uint32_t new_flags;
 
 	reservation_object_assert_held(bo->resv);
+
+	/*
+	 * Remove the backing store if no placement is given.
+	 */
+	if (!placement->num_placement && !placement->num_busy_placement) {
+		ret = ttm_bo_pipeline_gutting(bo);
+		if (ret)
+			return ret;
+
+		return ttm_tt_create(bo, false);
+	}
+
 	/*
 	 * Check whether we need to move buffer.
 	 */
-- 
2.14.1
