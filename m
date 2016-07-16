Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33578 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbcGPLEu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 07:04:50 -0400
Date: Sat, 16 Jul 2016 16:34:41 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH v2] [media] ad9389b: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160716110441.GA15391@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160716094241.GA10290@Karyakshetra>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The workqueue work_queue is involved in EDID (Extended Display
Identification Data) handling.

It has a single work item(&state->edid_handler) and hence
doesn't require ordering. It is not being used on a memory reclaim path.
Hence, the singlethreaded workqueue has been replaced with
the use of system_wq.

&state->edid_handler is a self requeueing work item and it has been
been sync cancelled in ad9389b_remove() to ensure that nothing is
pending when the driver is disconnected.

The unused label err_unreg has also been dropped.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 Changes in v2:
	-Fixes kbuild warning: label 'err_unreg' defined but not used.

 drivers/media/i2c/ad9389b.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 0462f46..5fd2350 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -98,7 +98,6 @@ struct ad9389b_state {
 	struct ad9389b_state_edid edid;
 	/* Running counter of the number of detected EDIDs (for debugging) */
 	unsigned edid_detect_counter;
-	struct workqueue_struct *work_queue;
 	struct delayed_work edid_handler; /* work entry */
 };

@@ -843,8 +842,7 @@ static void ad9389b_edid_handler(struct work_struct *work)
 			v4l2_dbg(1, debug, sd, "%s: edid read failed\n", __func__);
 			ad9389b_s_power(sd, false);
 			ad9389b_s_power(sd, true);
-			queue_delayed_work(state->work_queue,
-					   &state->edid_handler, EDID_DELAY);
+			schedule_delayed_work(&state->edid_handler, EDID_DELAY);
 			return;
 		}
 	}
@@ -933,8 +931,7 @@ static void ad9389b_update_monitor_present_status(struct v4l2_subdev *sd)
 		ad9389b_setup(sd);
 		ad9389b_notify_monitor_detect(sd);
 		state->edid.read_retries = EDID_MAX_RETRIES;
-		queue_delayed_work(state->work_queue,
-				   &state->edid_handler, EDID_DELAY);
+		schedule_delayed_work(&state->edid_handler, EDID_DELAY);
 	} else if (!(status & MASK_AD9389B_HPD_DETECT)) {
 		v4l2_dbg(1, debug, sd, "%s: hotplug not detected\n", __func__);
 		state->have_monitor = false;
@@ -1065,8 +1062,7 @@ static bool ad9389b_check_edid_status(struct v4l2_subdev *sd)
 		ad9389b_wr(sd, 0xc9, 0xf);
 		ad9389b_wr(sd, 0xc4, state->edid.segments);
 		state->edid.read_retries = EDID_MAX_RETRIES;
-		queue_delayed_work(state->work_queue,
-				   &state->edid_handler, EDID_DELAY);
+		schedule_delayed_work(&state->edid_handler, EDID_DELAY);
 		return false;
 	}

@@ -1170,13 +1166,6 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 		goto err_entity;
 	}

-	state->work_queue = create_singlethread_workqueue(sd->name);
-	if (state->work_queue == NULL) {
-		v4l2_err(sd, "could not create workqueue\n");
-		err = -ENOMEM;
-		goto err_unreg;
-	}
-
 	INIT_DELAYED_WORK(&state->edid_handler, ad9389b_edid_handler);
 	state->dv_timings = dv1080p60;

@@ -1187,8 +1176,6 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 		  client->addr << 1, client->adapter->name);
 	return 0;

-err_unreg:
-	i2c_unregister_device(state->edid_i2c_client);
 err_entity:
 	media_entity_cleanup(&sd->entity);
 err_hdl:
@@ -1211,9 +1198,8 @@ static int ad9389b_remove(struct i2c_client *client)
 	ad9389b_s_stream(sd, false);
 	ad9389b_s_audio_stream(sd, false);
 	ad9389b_init_setup(sd);
-	cancel_delayed_work(&state->edid_handler);
+	cancel_delayed_work_sync(&state->edid_handler);
 	i2c_unregister_device(state->edid_i2c_client);
-	destroy_workqueue(state->work_queue);
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
--
2.1.4

