Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:37382 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727701AbeJEUgh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 16:36:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 4/6] adv7842: when the EDID is cleared, unconfigure CEC as well
Date: Fri,  5 Oct 2018 15:37:43 +0200
Message-Id: <20181005133745.8593-5-hverkuil@xs4all.nl>
In-Reply-To: <20181005133745.8593-1-hverkuil@xs4all.nl>
References: <20181005133745.8593-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When there is no EDID the CEC adapter should be unconfigured as
well. So call cec_phys_addr_invalidate() when this happens.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index cd63cc6564e9..4721d49dcf0f 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -786,8 +786,10 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 	/* Disable I2C access to internal EDID ram from HDMI DDC ports */
 	rep_write_and_or(sd, 0x77, 0xf3, 0x00);
 
-	if (!state->hdmi_edid.present)
+	if (!state->hdmi_edid.present) {
+		cec_phys_addr_invalidate(state->cec_adap);
 		return 0;
+	}
 
 	pa = v4l2_get_edid_phys_addr(edid, 256, &spa_loc);
 	err = v4l2_phys_addr_validate(pa, &pa, NULL);
-- 
2.18.0
