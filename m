Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:57343 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387896AbeHPNvG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 09:51:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/5] drm_dp_cec: check that aux has a transfer function
Date: Thu, 16 Aug 2018 12:53:15 +0200
Message-Id: <20180816105319.6411-2-hverkuil@xs4all.nl>
In-Reply-To: <20180816105319.6411-1-hverkuil@xs4all.nl>
References: <20180816105319.6411-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If aux->transfer == NULL, then just return without doing
anything. In that case the function is likely called for
a non-(e)DP connector.

This never happened for the i915 driver, but the nouveau and amdgpu
drivers need this check.

The alternative would be to add this check in those drivers before
every drm_dp_cec call, but it makes sense to check it in the
drm_dp_cec functions to prevent a kernel oops.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/drm_dp_cec.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
index 988513346e9c..1407b13a8d5d 100644
--- a/drivers/gpu/drm/drm_dp_cec.c
+++ b/drivers/gpu/drm/drm_dp_cec.c
@@ -238,6 +238,10 @@ void drm_dp_cec_irq(struct drm_dp_aux *aux)
 	u8 cec_irq;
 	int ret;
 
+	/* No transfer function was set, so not a DP connector */
+	if (!aux->transfer)
+		return;
+
 	mutex_lock(&aux->cec.lock);
 	if (!aux->cec.adap)
 		goto unlock;
@@ -293,6 +297,10 @@ void drm_dp_cec_set_edid(struct drm_dp_aux *aux, const struct edid *edid)
 	unsigned int num_las = 1;
 	u8 cap;
 
+	/* No transfer function was set, so not a DP connector */
+	if (!aux->transfer)
+		return;
+
 #ifndef CONFIG_MEDIA_CEC_RC
 	/*
 	 * CEC_CAP_RC is part of CEC_CAP_DEFAULTS, but it is stripped by
@@ -361,6 +369,10 @@ EXPORT_SYMBOL(drm_dp_cec_set_edid);
  */
 void drm_dp_cec_unset_edid(struct drm_dp_aux *aux)
 {
+	/* No transfer function was set, so not a DP connector */
+	if (!aux->transfer)
+		return;
+
 	cancel_delayed_work_sync(&aux->cec.unregister_work);
 
 	mutex_lock(&aux->cec.lock);
@@ -404,6 +416,8 @@ void drm_dp_cec_register_connector(struct drm_dp_aux *aux, const char *name,
 				   struct device *parent)
 {
 	WARN_ON(aux->cec.adap);
+	if (WARN_ON(!aux->transfer))
+		return;
 	aux->cec.name = name;
 	aux->cec.parent = parent;
 	INIT_DELAYED_WORK(&aux->cec.unregister_work,
-- 
2.18.0
