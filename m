Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36087 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbcGBKmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2016 06:42:33 -0400
Date: Sat, 2 Jul 2016 16:11:53 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Mats Randgaard <matrandg@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Tejun Heo <tj@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] tc358743: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160702104153.GA1875@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The workqueue "work_queues" enables hotplugging.
It has a single work item(&state->delayed_work_enable_hotplug) and hence
doesn't require ordering. Also, it is not being used on a memory
reclaim path. Hence, the singlethreaded workqueue has been replaced with
the use of system_wq.

System workqueues have been able to handle high level of concurrency
for a long time now and hence it's not required to have a singlethreaded
workqueue just to gain concurrency. Unlike a dedicated per-cpu workqueue
created with create_singlethread_workqueue(), system_wq allows multiple
work items to overlap executions even on the same CPU; however, a
per-cpu workqueue doesn't have any CPU locality or global ordering
guarantee unless the target CPU is explicitly specified and thus the
increase of local concurrency shouldn't make any difference.

Work item has been sync cancelled in tc358743_remove() to ensure
that there are no pending tasks while disconnecting the driver.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/media/i2c/tc358743.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 6cf6d06..1e3a0dd 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -89,8 +89,6 @@ struct tc358743_state {
 	struct v4l2_ctrl *audio_sampling_rate_ctrl;
 	struct v4l2_ctrl *audio_present_ctrl;

-	/* work queues */
-	struct workqueue_struct *work_queues;
 	struct delayed_work delayed_work_enable_hotplug;

 	/* edid  */
@@ -425,8 +423,7 @@ static void tc358743_enable_edid(struct v4l2_subdev *sd)

 	/* Enable hotplug after 100 ms. DDC access to EDID is also enabled when
 	 * hotplug is enabled. See register DDC_CTL */
-	queue_delayed_work(state->work_queues,
-			   &state->delayed_work_enable_hotplug, HZ / 10);
+	schedule_delayed_work(&state->delayed_work_enable_hotplug, HZ / 10);

 	tc358743_enable_interrupts(sd, true);
 	tc358743_s_ctrl_detect_tx_5v(sd);
@@ -1884,14 +1881,6 @@ static int tc358743_probe(struct i2c_client *client,
 		goto err_hdl;
 	}

-	/* work queues */
-	state->work_queues = create_singlethread_workqueue(client->name);
-	if (!state->work_queues) {
-		v4l2_err(sd, "Could not create work queue\n");
-		err = -ENOMEM;
-		goto err_hdl;
-	}
-
 	state->pad.flags = MEDIA_PAD_FL_SOURCE;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err < 0)
@@ -1940,7 +1929,6 @@ static int tc358743_probe(struct i2c_client *client,

 err_work_queues:
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
-	destroy_workqueue(state->work_queues);
 	mutex_destroy(&state->confctl_mutex);
 err_hdl:
 	media_entity_cleanup(&sd->entity);
@@ -1954,7 +1942,6 @@ static int tc358743_remove(struct i2c_client *client)
 	struct tc358743_state *state = to_state(sd);

 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
-	destroy_workqueue(state->work_queues);
 	v4l2_async_unregister_subdev(sd);
 	v4l2_device_unregister_subdev(sd);
 	mutex_destroy(&state->confctl_mutex);
--
2.1.4

