Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36242 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbcGBKie (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2016 06:38:34 -0400
Date: Sat, 2 Jul 2016 16:07:22 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Tejun Heo <tj@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] adv7842: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160702103721.GA1570@Karyakshetra>
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

Work item has been sync cancelled in adv7842_remove() to ensure
that there are no pending tasks while disconnecting the driver.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/media/i2c/adv7842.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index ecaacb0..a18d28d 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -118,7 +118,6 @@ struct adv7842_state {
 	struct v4l2_fract aspect_ratio;
 	u32 rgb_quantization_range;
 	bool is_cea_format;
-	struct workqueue_struct *work_queues;
 	struct delayed_work delayed_work_enable_hotplug;
 	bool restart_stdi_once;
 	bool hdmi_port_a;
@@ -756,8 +755,7 @@ static int edid_write_vga_segment(struct v4l2_subdev *sd)
 	}

 	/* enable hotplug after 200 ms */
-	queue_delayed_work(state->work_queues,
-			&state->delayed_work_enable_hotplug, HZ / 5);
+	schedule_delayed_work(&state->delayed_work_enable_hotplug, HZ / 5);

 	return 0;
 }
@@ -855,8 +853,7 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 	}

 	/* enable hotplug after 200 ms */
-	queue_delayed_work(state->work_queues,
-			&state->delayed_work_enable_hotplug, HZ / 5);
+	schedule_delayed_work(&state->delayed_work_enable_hotplug, HZ / 5);

 	return 0;
 }
@@ -3311,13 +3308,6 @@ static int adv7842_probe(struct i2c_client *client,
 		goto err_i2c;
 	}

-	/* work queues */
-	state->work_queues = create_singlethread_workqueue(client->name);
-	if (!state->work_queues) {
-		v4l2_err(sd, "Could not create work queue\n");
-		err = -ENOMEM;
-		goto err_i2c;
-	}

 	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
 			adv7842_delayed_work_enable_hotplug);
@@ -3339,7 +3329,6 @@ err_entity:
 	media_entity_cleanup(&sd->entity);
 err_work_queues:
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
-	destroy_workqueue(state->work_queues);
 err_i2c:
 	adv7842_unregister_clients(sd);
 err_hdl:
@@ -3357,7 +3346,6 @@ static int adv7842_remove(struct i2c_client *client)
 	adv7842_irq_enable(sd, false);

 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
-	destroy_workqueue(state->work_queues);
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv7842_unregister_clients(sd);
--
2.1.4

