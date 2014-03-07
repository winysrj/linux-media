Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4090 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbaCGKVc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 05:21:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 4/5] adv*: replace the deprecated v4l2_subdev_edid by v4l2_edid.
Date: Fri,  7 Mar 2014 11:21:18 +0100
Message-Id: <1394187679-7345-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394187679-7345-1-git-send-email-hverkuil@xs4all.nl>
References: <1394187679-7345-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 2 +-
 drivers/media/i2c/adv7511.c | 2 +-
 drivers/media/i2c/adv7604.c | 4 ++--
 drivers/media/i2c/adv7842.c | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 83225d6..1b7ecfd 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -573,7 +573,7 @@ static const struct v4l2_subdev_core_ops ad9389b_core_ops = {
 
 /* ------------------------------ PAD OPS ------------------------------ */
 
-static int ad9389b_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid)
+static int ad9389b_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
 	struct ad9389b_state *state = get_ad9389b_state(sd);
 
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index ee61894..942ca4b 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -597,7 +597,7 @@ static int adv7511_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	return 0;
 }
 
-static int adv7511_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid)
+static int adv7511_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 71c8570..98cc540 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1658,7 +1658,7 @@ static int adv7604_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	return 0;
 }
 
-static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid)
+static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
 	struct adv7604_state *state = to_state(sd);
 	u8 *data = NULL;
@@ -1728,7 +1728,7 @@ static int get_edid_spa_location(const u8 *edid)
 	return -1;
 }
 
-static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid)
+static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
 	struct adv7604_state *state = to_state(sd);
 	int spa_loc;
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index e04fe3f..4d1e07e 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2014,7 +2014,7 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	return 0;
 }
 
-static int adv7842_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid)
+static int adv7842_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
 	struct adv7842_state *state = to_state(sd);
 	u8 *data = NULL;
@@ -2054,7 +2054,7 @@ static int adv7842_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 	return 0;
 }
 
-static int adv7842_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *e)
+static int adv7842_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *e)
 {
 	struct adv7842_state *state = to_state(sd);
 	int err = 0;
-- 
1.9.0

