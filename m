Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60122 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725982AbeIXUbK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 16:31:10 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Kyungmin Park <kyungmin.park@samsung.com>,
        Heungjun Kim <riverful.kim@samsung.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 1/1] v4l: i2c: Add a comment not to use static sub-device names in the future
Date: Mon, 24 Sep 2018 17:28:44 +0300
Message-Id: <20180924142844.5943-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A number of sub-device drivers used a static name for the sub-device, and
thus the media entity. As the entity name must be unique within a media
device, this makes it impossible to have more than one instance of each
device in a media device. This is a rather severe limitation.

Instead of fixing these drivers, add a comment to the drivers noting that
such static names may not be used in the future.

The alternative of fixing the drivers is troublesome as the entity (as
well as sub-device) name is part of the uAPI. Changing that is almost
certain to break something. As these devices are old but no-one has
encountered a problem with the static names, leave it as-is.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/m5mols/m5mols_core.c   | 1 +
 drivers/media/i2c/noon010pc30.c          | 1 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 1 +
 drivers/media/i2c/s5k4ecgx.c             | 1 +
 drivers/media/i2c/s5k6aa.c               | 1 +
 5 files changed, 5 insertions(+)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 155424a43d4c..b8b2bf4cbfb2 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -987,6 +987,7 @@ static int m5mols_probe(struct i2c_client *client,
 
 	sd = &info->sd;
 	v4l2_i2c_subdev_init(sd, client, &m5mols_ops);
+	/* Static name; NEVER use in new drivers! */
 	strscpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 4698e40fedd2..11479e65a9ae 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -720,6 +720,7 @@ static int noon010_probe(struct i2c_client *client,
 	mutex_init(&info->lock);
 	sd = &info->sd;
 	v4l2_i2c_subdev_init(sd, client, &noon010_ops);
+	/* Static name; NEVER use in new drivers! */
 	strscpy(sd->name, MODULE_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &noon010_subdev_internal_ops;
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 21ca5186f9ed..c4145194251f 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1698,6 +1698,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 		return ret;
 
 	v4l2_i2c_subdev_init(oif_sd, client, &oif_subdev_ops);
+	/* Static name; NEVER use in new drivers! */
 	strscpy(oif_sd->name, "S5C73M3-OIF", sizeof(oif_sd->name));
 
 	oif_sd->internal_ops = &oif_internal_ops;
diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index 8c0dca6cb20c..79aa2740edc4 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -954,6 +954,7 @@ static int s5k4ecgx_probe(struct i2c_client *client,
 	sd = &priv->sd;
 	/* Registering subdev */
 	v4l2_i2c_subdev_init(sd, client, &s5k4ecgx_ops);
+	/* Static name; NEVER use in new drivers! */
 	strscpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &s5k4ecgx_subdev_internal_ops;
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 52ca033f7069..63cf8db82e7d 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -1576,6 +1576,7 @@ static int s5k6aa_probe(struct i2c_client *client,
 
 	sd = &s5k6aa->sd;
 	v4l2_i2c_subdev_init(sd, client, &s5k6aa_subdev_ops);
+	/* Static name; NEVER use in new drivers! */
 	strscpy(sd->name, DRIVER_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &s5k6aa_subdev_internal_ops;
-- 
2.11.0
