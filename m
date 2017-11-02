Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56336 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932497AbdKBUEG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 16:04:06 -0400
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@redhat.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 4/4] dma-buf: Use rcu_assign_pointer() to set rcu protected pointers
Date: Thu,  2 Nov 2017 22:03:36 +0200
Message-Id: <20171102200336.23347-5-ville.syrjala@linux.intel.com>
In-Reply-To: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
References: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Use rcu_assign_pointer() when setting an rcu protected pointer.
This gets rid of another sparse warning.

Cc: Dave Airlie <airlied@redhat.com>
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: linaro-mm-sig@lists.linaro.org
Cc: linux-media@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/dma-buf/reservation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index b44d9d7db347..d90333e0b6d5 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -318,7 +318,7 @@ int reservation_object_copy_fences(struct reservation_object *dst,
 				continue;
 			}
 
-			dst_list->shared[dst_list->shared_count++] = fence;
+			rcu_assign_pointer(dst_list->shared[dst_list->shared_count++], fence);
 		}
 	} else {
 		dst_list = NULL;
-- 
2.13.6
