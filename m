Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49477 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932497AbdKBUDl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 16:03:41 -0400
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@redhat.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 0/4] dma-buf: Silence dma_fence __rcu sparse warnings
Date: Thu,  2 Nov 2017 22:03:32 +0200
Message-Id: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

When building drm+i915 I get around 150 lines of sparse noise from 
dma_fence __rcu warnings. This series eliminates all of that.

The first two patches were already posted by Chris, but there wasn't
any real reaction, so I figured I'd repost with a wider Cc list.

As for the other two patches, I'm no expert on dma_fence and I didn't
spend a lot of time looking at it so I can't be sure I annotated all
the accesses correctly. But I figured someone will scream at me if
I got it wrong ;)

Cc: Dave Airlie <airlied@redhat.com>
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: linaro-mm-sig@lists.linaro.org
Cc: linux-media@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>

Chris Wilson (2):
  drm/syncobj: Mark up the fence as an RCU protected pointer
  dma-buf/fence: Sparse wants __rcu on the object itself

Ville Syrjälä (2):
  drm/syncobj: Use proper methods for accessing rcu protected pointers
  dma-buf: Use rcu_assign_pointer() to set rcu protected pointers

 drivers/dma-buf/reservation.c |  2 +-
 drivers/gpu/drm/drm_syncobj.c | 11 +++++++----
 include/drm/drm_syncobj.h     |  2 +-
 include/linux/dma-fence.h     |  2 +-
 4 files changed, 10 insertions(+), 7 deletions(-)

-- 
2.13.6
