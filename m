Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54993 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938492AbdEYPGp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 May 2017 11:06:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Clint Taylor <clinton.a.taylor@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/7] cec: add cec_phys_addr_invalidate() helper function
Date: Thu, 25 May 2017 17:06:23 +0200
Message-Id: <20170525150626.29748-5-hverkuil@xs4all.nl>
In-Reply-To: <20170525150626.29748-1-hverkuil@xs4all.nl>
References: <20170525150626.29748-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplifies setting the physical address to CEC_PHYS_ADDR_INVALID.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/cec.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/media/cec.h b/include/media/cec.h
index 9989cdb58bd8..6123a5eec540 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -361,4 +361,9 @@ static inline int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
 
 #endif
 
+static inline void cec_phys_addr_invalidate(struct cec_adapter *adap)
+{
+	cec_s_phys_addr(adap, CEC_PHYS_ADDR_INVALID, false);
+}
+
 #endif /* _MEDIA_CEC_H */
-- 
2.11.0
