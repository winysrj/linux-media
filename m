Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4402 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab2JQJSp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 05:18:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <mats.randgaard@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>
Subject: [RFC PATCH for v3.7 4/4] adv7604: restart STDI once if format is not found
Date: Wed, 17 Oct 2012 11:18:33 +0200
Message-Id: <59d24d5e73d30301c6f978b7f5608c8beb12ca8c.1350465202.git.hans.verkuil@cisco.com>
In-Reply-To: <1350465513-7304-1-git-send-email-hverkuil@xs4all.nl>
References: <1350465513-7304-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c970cc0b7e589a05fbf258792412e5564f648f79.1350465202.git.hans.verkuil@cisco.com>
References: <c970cc0b7e589a05fbf258792412e5564f648f79.1350465202.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The STDI block may measure wrong values, especially for lcvs and lcf. If the
driver can not find any valid timing, the STDI block is restarted to measure
the video timings again. The function will return an error, but the restart of
STDI will generate a new STDI interrupt and the format detection process will
restart.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 88b7984..05f8950 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -76,6 +76,7 @@ struct adv7604_state {
 	struct workqueue_struct *work_queues;
 	struct delayed_work delayed_work_enable_hotplug;
 	bool connector_hdmi;
+	bool restart_stdi_once;
 
 	/* i2c clients */
 	struct i2c_client *i2c_avlink;
@@ -1297,9 +1298,31 @@ static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 		stdi.lcvs -= 2;
 		v4l2_dbg(1, debug, sd, "%s: lcvs - 1 = %d\n", __func__, stdi.lcvs);
 		if (stdi2dv_timings(sd, &stdi, timings)) {
+			/*
+			 * The STDI block may measure wrong values, especially
+			 * for lcvs and lcf. If the driver can not find any
+			 * valid timing, the STDI block is restarted to measure
+			 * the video timings again. The function will return an
+			 * error, but the restart of STDI will generate a new
+			 * STDI interrupt and the format detection process will
+			 * restart.
+			 */
+			if (state->restart_stdi_once) {
+				v4l2_dbg(1, debug, sd, "%s: restart STDI\n", __func__);
+				/* TODO restart STDI for Sync Channel 2 */
+				/* enter one-shot mode */
+				cp_write_and_or(sd, 0x86, 0xf9, 0x00);
+				/* trigger STDI restart */
+				cp_write_and_or(sd, 0x86, 0xf9, 0x04);
+				/* reset to continuous mode */
+				cp_write_and_or(sd, 0x86, 0xf9, 0x02);
+				state->restart_stdi_once = false;
+				return -ENOLINK;
+			}
 			v4l2_dbg(1, debug, sd, "%s: format not supported\n", __func__);
 			return -ERANGE;
 		}
+		state->restart_stdi_once = true;
 	}
 found:
 
@@ -2026,6 +2049,7 @@ static int adv7604_probe(struct i2c_client *client,
 		v4l2_err(sd, "failed to create all i2c clients\n");
 		goto err_i2c;
 	}
+	state->restart_stdi_once = true;
 
 	/* work queues */
 	state->work_queues = create_singlethread_workqueue(client->name);
-- 
1.7.10.4

