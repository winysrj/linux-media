Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52116 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726858AbeH2Oyu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 10:54:50 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Kyungmin Park <kyungmin.park@samsung.com>,
        Heungjun Kim <riverful.kim@samsung.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [RFC 1/1] v4l: samsung, ov9650: Rely on V4L2-set sub-device names
Date: Wed, 29 Aug 2018 13:58:28 +0300
Message-Id: <20180829105828.4502-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_i2c_subdev_init() sets the name of the sub-devices (as well as
entities) to what is fairly certainly known to be unique in the system,
even if there were more devices of the same kind.

These drivers (m5mols, noon010pc30, ov9650, s5c73m3, s5k4ecgx, s5k6aa) set
the name to the name of the driver or the module while omitting the
device's I²C address and bus, leaving the devices with a static name and
effectively limiting the number of such devices in a media device to 1.

Address this by using the name set by the V4L2 framework.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi,

I'm a bit uncertain about this one. I discussed the matter with Hans and
his view was this is a bug (I don't disagree), but this bug affects uAPI.
Also these devices tend to be a few years old and might not see much use
in newer devices, so why bother? The naming convention musn't be copied to
newer drivers though.

Any opinions?

This patch depends on my non-RFC set I just posted, this patch in particular:

<URL:https://patchwork.linuxtv.org/patch/51788/>

 drivers/media/i2c/m5mols/m5mols_core.c   | 1 -
 drivers/media/i2c/noon010pc30.c          | 1 -
 drivers/media/i2c/ov9650.c               | 1 -
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 4 ++--
 drivers/media/i2c/s5k4ecgx.c             | 1 -
 drivers/media/i2c/s5k6aa.c               | 1 -
 6 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 12e79f9e32d5..320e79b63555 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -987,7 +987,6 @@ static int m5mols_probe(struct i2c_client *client,
 
 	sd = &info->sd;
 	v4l2_i2c_subdev_init(sd, client, &m5mols_ops);
-	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	sd->internal_ops = &m5mols_subdev_internal_ops;
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 88c498ad45df..0629bc138fbc 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -720,7 +720,6 @@ static int noon010_probe(struct i2c_client *client,
 	mutex_init(&info->lock);
 	sd = &info->sd;
 	v4l2_i2c_subdev_init(sd, client, &noon010_ops);
-	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &noon010_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 5bea31cd41aa..7e116eb415e5 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1546,7 +1546,6 @@ static int ov965x_probe(struct i2c_client *client,
 
 	sd = &ov965x->sd;
 	v4l2_i2c_subdev_init(sd, client, &ov965x_subdev_ops);
-	strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &ov965x_sd_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index ce196b60f917..64212551524e 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1683,7 +1683,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	v4l2_subdev_init(sd, &s5c73m3_subdev_ops);
 	sd->owner = client->dev.driver->owner;
 	v4l2_set_subdevdata(sd, state);
-	strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
+	v4l2_i2c_subdev_set_name(sd, client, NULL, NULL);
 
 	sd->internal_ops = &s5c73m3_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
@@ -1698,7 +1698,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 		return ret;
 
 	v4l2_i2c_subdev_init(oif_sd, client, &oif_subdev_ops);
-	strcpy(oif_sd->name, "S5C73M3-OIF");
+	v4l2_i2c_subdev_set_name(sd, client, NULL, "-OIF");
 
 	oif_sd->internal_ops = &oif_internal_ops;
 	oif_sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index 6ebcf254989a..8aaf5ad26826 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -954,7 +954,6 @@ static int s5k4ecgx_probe(struct i2c_client *client,
 	sd = &priv->sd;
 	/* Registering subdev */
 	v4l2_i2c_subdev_init(sd, client, &s5k4ecgx_ops);
-	strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &s5k4ecgx_subdev_internal_ops;
 	/* Support v4l2 sub-device user space API */
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 13c10b5e2b45..9536316e2d80 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -1576,7 +1576,6 @@ static int s5k6aa_probe(struct i2c_client *client,
 
 	sd = &s5k6aa->sd;
 	v4l2_i2c_subdev_init(sd, client, &s5k6aa_subdev_ops);
-	strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &s5k6aa_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-- 
2.11.0
