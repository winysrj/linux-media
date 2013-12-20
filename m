Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3363 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3LTJcK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 42/50] adv7842: i2c dummy clients registration.
Date: Fri, 20 Dec 2013 10:31:35 +0100
Message-Id: <1387531903-20496-43-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Clear i2c_clients ptr when unregistered.
Warn if configured i2c-addr is zero.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 83 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 63 insertions(+), 20 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 2920e6b..108e1b0 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2805,8 +2805,9 @@ static const struct v4l2_ctrl_config adv7842_ctrl_free_run_color = {
 };
 
 
-static void adv7842_unregister_clients(struct adv7842_state *state)
+static void adv7842_unregister_clients(struct v4l2_subdev *sd)
 {
+	struct adv7842_state *state = to_state(sd);
 	if (state->i2c_avlink)
 		i2c_unregister_device(state->i2c_avlink);
 	if (state->i2c_cec)
@@ -2829,15 +2830,71 @@ static void adv7842_unregister_clients(struct adv7842_state *state)
 		i2c_unregister_device(state->i2c_cp);
 	if (state->i2c_vdp)
 		i2c_unregister_device(state->i2c_vdp);
+
+	state->i2c_avlink = NULL;
+	state->i2c_cec = NULL;
+	state->i2c_infoframe = NULL;
+	state->i2c_sdp_io = NULL;
+	state->i2c_sdp = NULL;
+	state->i2c_afe = NULL;
+	state->i2c_repeater = NULL;
+	state->i2c_edid = NULL;
+	state->i2c_hdmi = NULL;
+	state->i2c_cp = NULL;
+	state->i2c_vdp = NULL;
 }
 
-static struct i2c_client *adv7842_dummy_client(struct v4l2_subdev *sd,
+static struct i2c_client *adv7842_dummy_client(struct v4l2_subdev *sd, const char *desc,
 					       u8 addr, u8 io_reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct i2c_client *cp;
 
 	io_write(sd, io_reg, addr << 1);
-	return i2c_new_dummy(client->adapter, io_read(sd, io_reg) >> 1);
+
+	if (addr == 0) {
+		v4l2_err(sd, "no %s i2c addr configured\n", desc);
+		return NULL;
+	}
+
+	cp = i2c_new_dummy(client->adapter, io_read(sd, io_reg) >> 1);
+	if (!cp)
+		v4l2_err(sd, "register %s on i2c addr 0x%x failed\n", desc, addr);
+
+	return cp;
+}
+
+static int adv7842_register_clients(struct v4l2_subdev *sd)
+{
+	struct adv7842_state *state = to_state(sd);
+	struct adv7842_platform_data *pdata = &state->pdata;
+
+	state->i2c_avlink = adv7842_dummy_client(sd, "avlink", pdata->i2c_avlink, 0xf3);
+	state->i2c_cec = adv7842_dummy_client(sd, "cec", pdata->i2c_cec, 0xf4);
+	state->i2c_infoframe = adv7842_dummy_client(sd, "infoframe", pdata->i2c_infoframe, 0xf5);
+	state->i2c_sdp_io = adv7842_dummy_client(sd, "sdp_io", pdata->i2c_sdp_io, 0xf2);
+	state->i2c_sdp = adv7842_dummy_client(sd, "sdp", pdata->i2c_sdp, 0xf1);
+	state->i2c_afe = adv7842_dummy_client(sd, "afe", pdata->i2c_afe, 0xf8);
+	state->i2c_repeater = adv7842_dummy_client(sd, "repeater", pdata->i2c_repeater, 0xf9);
+	state->i2c_edid = adv7842_dummy_client(sd, "edid", pdata->i2c_edid, 0xfa);
+	state->i2c_hdmi = adv7842_dummy_client(sd, "hdmi", pdata->i2c_hdmi, 0xfb);
+	state->i2c_cp = adv7842_dummy_client(sd, "cp", pdata->i2c_cp, 0xfd);
+	state->i2c_vdp = adv7842_dummy_client(sd, "vdp", pdata->i2c_vdp, 0xfe);
+
+	if (!state->i2c_avlink ||
+	    !state->i2c_cec ||
+	    !state->i2c_infoframe ||
+	    !state->i2c_sdp_io ||
+	    !state->i2c_sdp ||
+	    !state->i2c_afe ||
+	    !state->i2c_repeater ||
+	    !state->i2c_edid ||
+	    !state->i2c_hdmi ||
+	    !state->i2c_cp ||
+	    !state->i2c_vdp)
+		return -1;
+
+	return 0;
 }
 
 static int adv7842_probe(struct i2c_client *client,
@@ -2939,21 +2996,7 @@ static int adv7842_probe(struct i2c_client *client,
 		goto err_hdl;
 	}
 
-	state->i2c_avlink = adv7842_dummy_client(sd, pdata->i2c_avlink, 0xf3);
-	state->i2c_cec = adv7842_dummy_client(sd, pdata->i2c_cec, 0xf4);
-	state->i2c_infoframe = adv7842_dummy_client(sd, pdata->i2c_infoframe, 0xf5);
-	state->i2c_sdp_io = adv7842_dummy_client(sd, pdata->i2c_sdp_io, 0xf2);
-	state->i2c_sdp = adv7842_dummy_client(sd, pdata->i2c_sdp, 0xf1);
-	state->i2c_afe = adv7842_dummy_client(sd, pdata->i2c_afe, 0xf8);
-	state->i2c_repeater = adv7842_dummy_client(sd, pdata->i2c_repeater, 0xf9);
-	state->i2c_edid = adv7842_dummy_client(sd, pdata->i2c_edid, 0xfa);
-	state->i2c_hdmi = adv7842_dummy_client(sd, pdata->i2c_hdmi, 0xfb);
-	state->i2c_cp = adv7842_dummy_client(sd, pdata->i2c_cp, 0xfd);
-	state->i2c_vdp = adv7842_dummy_client(sd, pdata->i2c_vdp, 0xfe);
-	if (!state->i2c_avlink || !state->i2c_cec || !state->i2c_infoframe ||
-	    !state->i2c_sdp_io || !state->i2c_sdp || !state->i2c_afe ||
-	    !state->i2c_repeater || !state->i2c_edid || !state->i2c_hdmi ||
-	    !state->i2c_cp || !state->i2c_vdp) {
+	if (adv7842_register_clients(sd) < 0) {
 		err = -ENOMEM;
 		v4l2_err(sd, "failed to create all i2c clients\n");
 		goto err_i2c;
@@ -2989,7 +3032,7 @@ err_work_queues:
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
 err_i2c:
-	adv7842_unregister_clients(state);
+	adv7842_unregister_clients(sd);
 err_hdl:
 	v4l2_ctrl_handler_free(hdl);
 	return err;
@@ -3008,7 +3051,7 @@ static int adv7842_remove(struct i2c_client *client)
 	destroy_workqueue(state->work_queues);
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
-	adv7842_unregister_clients(to_state(sd));
+	adv7842_unregister_clients(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	return 0;
 }
-- 
1.8.4.4

