Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:51436 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388258AbeHPNvF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 09:51:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/5] drm_dp_cec: add note about good MegaChips 2900 CEC support
Date: Thu, 16 Aug 2018 12:53:16 +0200
Message-Id: <20180816105319.6411-3-hverkuil@xs4all.nl>
In-Reply-To: <20180816105319.6411-1-hverkuil@xs4all.nl>
References: <20180816105319.6411-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

A big problem with DP CEC-Tunneling-over-AUX is that it is tricky
to find adapters with a chipset that supports this AND where the
manufacturer actually connected the HDMI CEC line to the chipset.

Add a mention of the MegaChips 2900 chipset which seems to support
this feature well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/drm_dp_cec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
index 1407b13a8d5d..8a718f85079a 100644
--- a/drivers/gpu/drm/drm_dp_cec.c
+++ b/drivers/gpu/drm/drm_dp_cec.c
@@ -16,7 +16,9 @@
  * here. Quite a few active (mini-)DP-to-HDMI or USB-C-to-HDMI adapters
  * have a converter chip that supports CEC-Tunneling-over-AUX (usually the
  * Parade PS176), but they do not wire up the CEC pin, thus making CEC
- * useless.
+ * useless. Note that MegaChips 2900-based adapters appear to have good
+ * support for CEC tunneling. Those adapters that I have tested using
+ * this chipset all have the CEC line connected.
  *
  * Sadly there is no way for this driver to know this. What happens is
  * that a /dev/cecX device is created that is isolated and unable to see
-- 
2.18.0
