Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:40722 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388448AbeGXU21 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 16:28:27 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.19] drm_dp_cec.c: fix formatting typo: %pdH -> %phD
Message-ID: <f3720ddf-ec0f-cd22-46b6-720a5e2098f2@xs4all.nl>
Date: Tue, 24 Jul 2018 21:20:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This caused a kernel oops since %pdH interpreted the pointer
as a struct file.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/drm_dp_cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
index 87b67cc1ea58..a6cac47f6248 100644
--- a/drivers/gpu/drm/drm_dp_cec.c
+++ b/drivers/gpu/drm/drm_dp_cec.c
@@ -157,7 +157,7 @@ static void drm_dp_cec_adap_status(struct cec_adapter *adap,

 	if (drm_dp_read_desc(aux, &desc, true))
 		return;
-	seq_printf(file, "OUI: %*pdH\n",
+	seq_printf(file, "OUI: %*phD\n",
 		   (int)sizeof(id->oui), id->oui);
 	seq_printf(file, "ID: %*pE\n",
 		   (int)strnlen(id->device_id, sizeof(id->device_id)),
-- 
2.18.0
