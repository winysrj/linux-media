Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35048 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbcGBKn7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2016 06:43:59 -0400
Date: Sat, 2 Jul 2016 16:13:55 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Tejun Heo <tj@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] adv7604: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160702104355.GA2100@Karyakshetra>
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

Work item has been sync cancelled in adv76xx_remove() to ensure
that there are no pending tasks while disconnecting the driver.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/media/i2c/adv7604.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index beb2841..010f24c 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -184,7 +184,6 @@ struct adv76xx_state {
 	u16 spa_port_a[2];
 	struct v4l2_fract aspect_ratio;
 	u32 rgb_quantization_range;
-	struct workqueue_struct *work_queues;
 	struct delayed_work delayed_work_enable_hotplug;
 	bool restart_stdi_once;

@@ -2130,8 +2129,7 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	}

 	/* enable hotplug after 100 ms */
-	queue_delayed_work(state->work_queues,
-			&state->delayed_work_enable_hotplug, HZ / 10);
+	schedule_delayed_work(&state->delayed_work_enable_hotplug, HZ / 10);
 	return 0;
 }

@@ -3182,14 +3180,6 @@ static int adv76xx_probe(struct i2c_client *client,
 		}
 	}

-	/* work queues */
-	state->work_queues = create_singlethread_workqueue(client->name);
-	if (!state->work_queues) {
-		v4l2_err(sd, "Could not create work queue\n");
-		err = -ENOMEM;
-		goto err_i2c;
-	}
-
 	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
 			adv76xx_delayed_work_enable_hotplug);

@@ -3225,7 +3215,6 @@ err_entity:
 	media_entity_cleanup(&sd->entity);
 err_work_queues:
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
-	destroy_workqueue(state->work_queues);
 err_i2c:
 	adv76xx_unregister_clients(state);
 err_hdl:
@@ -3241,7 +3230,6 @@ static int adv76xx_remove(struct i2c_client *client)
 	struct adv76xx_state *state = to_state(sd);

 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
-	destroy_workqueue(state->work_queues);
 	v4l2_async_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv76xx_unregister_clients(to_state(sd));
--
2.1.4

