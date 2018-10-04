Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:53332 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727451AbeJDQBZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 12:01:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] omapdrm/dss/hdmi4_cec.c: don't set the retransmit count
Date: Thu,  4 Oct 2018 11:09:00 +0200
Message-Id: <20181004090900.32915-6-hverkuil@xs4all.nl>
In-Reply-To: <20181004090900.32915-1-hverkuil@xs4all.nl>
References: <20181004090900.32915-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The HDMI_CEC_DBG_3 register does have a retransmit count, but you
can't write to it, those bits are read-only.

So drop the attempt to set the retransmit count, since it doesn't
work.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
index dee66a5101b5..00407f1995a8 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
@@ -280,9 +280,6 @@ static int hdmi_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 	hdmi_write_reg(core->base, HDMI_CEC_INT_STATUS_1,
 		       HDMI_CEC_RETRANSMIT_CNT_INT_MASK);
 
-	/* Set the retry count */
-	REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, attempts - 1, 6, 4);
-
 	/* Set the initiator addresses */
 	hdmi_write_reg(core->base, HDMI_CEC_TX_INIT, cec_msg_initiator(msg));
 
-- 
2.18.0
