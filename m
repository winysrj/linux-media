Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47437 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbcD2KPK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 06:15:10 -0400
Date: Fri, 29 Apr 2016 12:15:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
	sre@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com, tuukkat76@gmail.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org
Subject: Re: v4l subdevs without big device was Re:
 drivers/media/i2c/adp1653.c: does not show as /dev/video* or v4l-subdev*
Message-ID: <20160429101506.GB22743@amd>
References: <20160428084546.GA9957@amd>
 <20160429071525.GA4823@amd>
 <57230DE7.3020701@xs4all.nl>
 <20160429075649.GG32125@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20160429075649.GG32125@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> > Warning: I'm no DT expert, so this is just a first attempt.
> > 
> > Platform drivers (omap3isp) will have to add these controller devices to the list
> > of subdevs to load asynchronously.
> 
> I seem to have patches I haven't had time to push back then:
> 
> <URL:http://salottisipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux.git;a=shortlog;h=refs/heads/leds-as3645a>
> 
> This seems to be mostly in line with what has been discussed in the meeting,
> except that the patches add a device specific property. Please ignore the
> led patches in that tree for now (i.e. four patches on the top are the
> relevant ones here).

Ok, I attempted to forward-port the patches to v4.6. Not sure if I was successful.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--azLHFNyN32YCQGCU
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-omap3isp-Fix-async-notifier-registration-order.patch"

>From fad952ee3d1e888401b047c9657f04afeaf40fc5 Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@iki.fi>
Date: Sat, 16 May 2015 23:34:34 +0300
Subject: [PATCH 1/5] omap3isp: Fix async notifier registration order

The async notifier was registered before the v4l2_device was registered and
before the notifier callbacks were set. This could lead to missing the
bound() and complete() callbacks and to attempting to spin_lock() and
uninitialised spin lock.

Also fix unregistering the async notifier in the case of an error --- the
function may not fail anymore after the notifier is registered.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Conflicts:
	drivers/media/platform/omap3isp/isp.c
---
 arch/arm/boot/dts/omap3-n900.dts      | 24 ++++++++++++++++++++++++
 drivers/media/i2c/ad5820.c            |  2 +-
 drivers/media/i2c/adp1653.c           |  9 ++++++++-
 drivers/media/platform/omap3isp/isp.c | 12 ++++++++++++
 4 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 640d409..0729c69 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -186,6 +186,7 @@
 		module {
 			model = "TCM8341MD";
 			sensor = <&cam1>;
+			focus = <&autofocus>;			
 		};
 	};
 
@@ -198,6 +199,11 @@
 		};
 	};
 
+	autofocus: dac-camera-autofocus {
+		compatible = "dac-camera-autofocus";
+		io-channels = <&ad5820>;
+	};
+
 	video-bus-switch {
 		compatible = "video-bus-switch";
 
@@ -255,6 +261,11 @@
 				crc = <0>;
 			};
 		};
+		port@99 {
+			adp1653_link: endpoint {
+				      remote-endpoint = <&adp1653_ep>;
+			};
+		};
 	};
 };
 
@@ -696,6 +707,11 @@
 		indicator {
 			led-max-microamp = <17500>;
 		};
+		port {
+			adp1653_ep: endpoint {
+				   remote-endpoint = <&adp1653_link>;
+ 			};
+ 		};
 	};
 
 	lp5523: lp5523@32 {
@@ -879,6 +895,14 @@
 			};
 		};
 	};
+
+	/* D/A converter for auto-focus */
+	ad5820: dac@0c {
+		compatible = "adi,ad5820";
+		reg = <0x0c>;
+
+		#io-channel-cells = <0>;
+	};
 };
 
 &mmc1 {
diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 58a44f1..400200c 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -421,7 +421,7 @@ static int ad5820_probe(struct i2c_client *client,
 	coil->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	coil->subdev.internal_ops = &ad5820_internal_ops;
 
-	ret = media_entity_init(&coil->subdev.entity, 0, NULL, 0);
+	ret = media_entity_pads_init(&coil->subdev.entity, 0, NULL);
 	if (ret < 0)
 		kfree(coil);
 
diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index b90e15b..6dd5d6a 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -515,6 +515,7 @@ static int adp1653_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&flash->subdev, client, &adp1653_ops);
 	flash->subdev.internal_ops = &adp1653_internal_ops;
 	flash->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	strcpy(flash->subdev.name, "adp1653 flash");
 
 	ret = adp1653_init_controls(flash);
 	if (ret)
@@ -524,7 +525,13 @@ static int adp1653_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto free_and_quit;
 
-	dev_info(&client->dev, "adp1653 probe: should be ok\n");		
+	dev_info(&client->dev, "adp1653 probe: should be ok\n");
+
+	ret = v4l2_async_register_subdev(&flash->subdev);
+	if (ret < 0)
+		goto free_and_quit;
+
+	dev_info(&client->dev, "adp1653 probe: async register subdev ok\n");	
 
 	flash->subdev.entity.function = MEDIA_ENT_F_FLASH;
 
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 6361fde..9f51127 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2392,6 +2392,7 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_modules;
 
+<<<<<<< HEAD
 	ret = isp_create_links(isp);
 	if (ret < 0)
 		goto error_register_entities;
@@ -2402,6 +2403,17 @@ static int isp_probe(struct platform_device *pdev)
 	ret = v4l2_async_notifier_register(&isp->v4l2_dev, &isp->notifier);
 	if (ret)
 		goto error_register_entities;
+=======
+	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
+		isp->notifier.bound = isp_subdev_notifier_bound;
+		isp->notifier.complete = isp_subdev_notifier_complete;
+
+		ret = v4l2_async_notifier_register(&isp->v4l2_dev,
+						   &isp->notifier);
+		if (ret)
+			goto error_register_entities;
+	}
+>>>>>>> a035633... omap3isp: Fix async notifier registration order
 
 	isp_core_init(isp, 1);
 	omap3isp_put(isp);
-- 
2.1.4


--azLHFNyN32YCQGCU
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-Solve-conflict-I-missed.patch"

>From 4f8286dfb13a14c1e166a61837ec20f5a096ed7b Mon Sep 17 00:00:00 2001
From: Pavel <pavel@ucw.cz>
Date: Fri, 29 Apr 2016 12:02:07 +0200
Subject: [PATCH 2/5] Solve conflict I missed.

---
 drivers/media/platform/omap3isp/isp.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 9f51127..7419404 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2392,18 +2392,14 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_modules;
 
-<<<<<<< HEAD
 	ret = isp_create_links(isp);
 	if (ret < 0)
 		goto error_register_entities;
 
-	isp->notifier.bound = isp_subdev_notifier_bound;
-	isp->notifier.complete = isp_subdev_notifier_complete;
-
 	ret = v4l2_async_notifier_register(&isp->v4l2_dev, &isp->notifier);
 	if (ret)
 		goto error_register_entities;
-=======
+
 	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
 		isp->notifier.bound = isp_subdev_notifier_bound;
 		isp->notifier.complete = isp_subdev_notifier_complete;
@@ -2413,7 +2409,6 @@ static int isp_probe(struct platform_device *pdev)
 		if (ret)
 			goto error_register_entities;
 	}
->>>>>>> a035633... omap3isp: Fix async notifier registration order
 
 	isp_core_init(isp, 1);
 	omap3isp_put(isp);
-- 
2.1.4


--azLHFNyN32YCQGCU
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0003-Cherry-pick-manually.patch"

>From b402e5a19c46a9c264a311b7656c0e7e0d65322f Mon Sep 17 00:00:00 2001
From: Pavel <pavel@ucw.cz>
Date: Fri, 29 Apr 2016 12:06:32 +0200
Subject: [PATCH 3/5] Cherry-pick (manually)

commit b3691ff97a99bcf28790c4da906ffc17c822844a
Author: Sakari Ailus <sakari.ailus@iki.fi>
Date:   Sat May 16 23:56:03 2015 +0300

    omap3isp: Support the ti,camera-flashes property

    Before this patch the omap3isp driver only supported external
    devices that
        are connected to it by a data bus. This patch adds support for
    flash
        devices, in form of an array of phandles to sensor and
    associated flash
        devices, respectively, in the "ti,camera-flashes" property.

    The non image source devices are recognised by empty bus field in
    struct
        isp_async_subdev, which is made a pointer by the patch.

    Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isp.c       | 90 +++++++++++++++++++++--------
 drivers/media/platform/omap3isp/isp.h       |  2 +-
 drivers/media/platform/omap3isp/ispcsiphy.c |  2 +-
 3 files changed, 67 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 7419404..a1c3bdb 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2095,13 +2095,20 @@ static void isp_of_parse_node_csi2(struct device *dev,
 	buscfg->bus.csi2.crc = 1;
 }
 
-static int isp_of_parse_node(struct device *dev, struct device_node *node,
-			     struct isp_async_subdev *isd)
+static int isp_of_parse_node_endpoint(struct device *dev,
+				      struct device_node *node,
+				      struct isp_async_subdev *isd)
 {
-	struct isp_bus_cfg *buscfg = &isd->bus;
+	struct isp_bus_cfg *buscfg;
 	struct v4l2_of_endpoint vep;
 	int ret;
 
+	isd->bus = devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);
+	if (!isd->bus)
+		return -ENOMEM;
+
+	buscfg = isd->bus;
+
 	ret = v4l2_of_parse_endpoint(node, &vep);
 	if (ret)
 		return ret;
@@ -2144,10 +2151,48 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
 	return 0;
 }
 
+static int isp_of_parse_node(struct device *dev, struct device_node *node,
+			     struct v4l2_async_notifier *notifier, bool link)
+{
+	struct isp_async_subdev *isd;
+
+	isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
+	if (!isd) {
+		of_node_put(node);
+		return -ENOMEM;
+	}
+
+	notifier->subdevs[notifier->num_subdevs] = &isd->asd;
+
+	if (link) {
+		if (isp_of_parse_node_endpoint(dev, node, isd)) {
+			of_node_put(node);
+			return -EINVAL;
+		}
+
+		isd->asd.match.of.node = of_graph_get_remote_port_parent(node);
+		of_node_put(node);
+	} else {
+		isd->asd.match.of.node = node;
+	}
+
+	if (!isd->asd.match.of.node) {
+		dev_warn(dev, "bad remote port parent\n");
+		return -EINVAL;
+	}
+
+	isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
+	notifier->num_subdevs++;
+
+	return 0;
+}
+
 static int isp_of_parse_nodes(struct device *dev,
 			      struct v4l2_async_notifier *notifier)
 {
 	struct device_node *node = NULL;
+	int ret;
+	unsigned int flash = 0;
 
 	notifier->subdevs = devm_kcalloc(
 		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
@@ -2156,30 +2201,25 @@ static int isp_of_parse_nodes(struct device *dev,
 
 	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
 	       (node = of_graph_get_next_endpoint(dev->of_node, node))) {
-		struct isp_async_subdev *isd;
-
-		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
-		if (!isd) {
-			of_node_put(node);
-			return -ENOMEM;
-		}
-
-		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
-
-		if (isp_of_parse_node(dev, node, isd)) {
-			of_node_put(node);
-			return -EINVAL;
-		}
+		ret = isp_of_parse_node(dev, node, notifier, true);
+		if (ret)
+			return ret;
+	}
 
-		isd->asd.match.of.node = of_graph_get_remote_port_parent(node);
-		of_node_put(node);
-		if (!isd->asd.match.of.node) {
-			dev_warn(dev, "bad remote port parent\n");
+	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
+	       (node = of_parse_phandle(dev->of_node, "ti,camera-flashes",
+					flash++))) {
+		struct device_node *sensor_node =
+			of_parse_phandle(dev->of_node, "ti,camera-flashes",
+					 flash++);
+		unsigned int i;
+
+		if (!sensor_node)
 			return -EINVAL;
-		}
 
-		isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
-		notifier->num_subdevs++;
+		ret = isp_of_parse_node(dev, node, notifier, false);
+		if (ret)
+			return ret;
 	}
 
 	return notifier->num_subdevs;
@@ -2193,7 +2233,7 @@ static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
 		container_of(asd, struct isp_async_subdev, asd);
 
 	isd->sd = subdev;
-	isd->sd->host_priv = &isd->bus;
+	isd->sd->host_priv = isd->bus;
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 7e6f663..c0b9d1d 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -228,7 +228,7 @@ struct isp_device {
 
 struct isp_async_subdev {
 	struct v4l2_subdev *sd;
-	struct isp_bus_cfg bus;
+	struct isp_bus_cfg *bus;
 	struct v4l2_async_subdev asd;
 };
 
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index 495447d..750ce93 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -177,7 +177,7 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 		struct isp_async_subdev *isd =
 			container_of(pipe->external->asd,
 				     struct isp_async_subdev, asd);
-		buscfg = &isd->bus;
+		buscfg = isd->bus;
 	}
 
 	if (buscfg->interface == ISP_INTERFACE_CCP2B_PHY1
-- 
2.1.4


--azLHFNyN32YCQGCU
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0004-omap3isp-Assign-a-group-ID-for-sensor-and-flash-enti.patch"

>From 568ea9c5c8aa61ee44e30aa4134d2b59e55a5b45 Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@iki.fi>
Date: Sat, 23 May 2015 15:24:55 +0300
Subject: [PATCH 4/5] omap3isp: Assign a group ID for sensor and flash entities

Starting from zero, assign a group ID for each sensor. Look for the
associated flash device node and based on nodes found, assign the same group
ID for them.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isp.c | 42 ++++++++++++++++++++++++++++++++---
 drivers/media/platform/omap3isp/isp.h |  1 +
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index a1c3bdb..f89abea 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2152,7 +2152,8 @@ static int isp_of_parse_node_endpoint(struct device *dev,
 }
 
 static int isp_of_parse_node(struct device *dev, struct device_node *node,
-			     struct v4l2_async_notifier *notifier, bool link)
+			     struct v4l2_async_notifier *notifier,
+			     u32 group_id, bool link)
 {
 	struct isp_async_subdev *isd;
 
@@ -2182,6 +2183,7 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
 	}
 
 	isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
+	isd->group_id = group_id;
 	notifier->num_subdevs++;
 
 	return 0;
@@ -2193,6 +2195,7 @@ static int isp_of_parse_nodes(struct device *dev,
 	struct device_node *node = NULL;
 	int ret;
 	unsigned int flash = 0;
+	u32 group_id = 0;
 
 	notifier->subdevs = devm_kcalloc(
 		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
@@ -2201,7 +2204,7 @@ static int isp_of_parse_nodes(struct device *dev,
 
 	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
 	       (node = of_graph_get_next_endpoint(dev->of_node, node))) {
-		ret = isp_of_parse_node(dev, node, notifier, true);
+		ret = isp_of_parse_node(dev, node, notifier, group_id++, true);
 		if (ret)
 			return ret;
 	}
@@ -2213,11 +2216,43 @@ static int isp_of_parse_nodes(struct device *dev,
 			of_parse_phandle(dev->of_node, "ti,camera-flashes",
 					 flash++);
 		unsigned int i;
+		u32 flash_group_id;
 
 		if (!sensor_node)
 			return -EINVAL;
 
-		ret = isp_of_parse_node(dev, node, notifier, false);
+		for (i = 0; i < notifier->num_subdevs; i++) {
+			struct isp_async_subdev *isd = container_of(
+				notifier->subdevs[i], struct isp_async_subdev,
+				asd);
+
+			if (!isd->bus)
+				continue;
+
+			dev_dbg(dev, "match \"%s\", \"%s\"\n",sensor_node->name,
+				isd->asd.match.of.node->name);
+
+			if (sensor_node != isd->asd.match.of.node)
+				continue;
+
+			dev_dbg(dev, "found\n");
+
+			flash_group_id = isd->group_id;
+			break;
+		}
+
+		/*
+		 * No sensor was found --- complain and allocate a new
+		 * group ID.
+		 */
+		if (i == notifier->num_subdevs) {
+			dev_warn(dev, "no device node \"%s\" was found",
+				 sensor_node->name);
+			flash_group_id = group_id++;
+		}
+
+		ret = isp_of_parse_node(dev, node, notifier, flash_group_id,
+					false);
 		if (ret)
 			return ret;
 	}
@@ -2232,6 +2267,7 @@ static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
 	struct isp_async_subdev *isd =
 		container_of(asd, struct isp_async_subdev, asd);
 
+	subdev->entity.group_id = isd->group_id;
 	isd->sd = subdev;
 	isd->sd->host_priv = isd->bus;
 
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index c0b9d1d..639b3ca 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -230,6 +230,7 @@ struct isp_async_subdev {
 	struct v4l2_subdev *sd;
 	struct isp_bus_cfg *bus;
 	struct v4l2_async_subdev asd;
+	u32 group_id;
 };
 
 #define v4l2_dev_to_isp_device(dev) \
-- 
2.1.4


--azLHFNyN32YCQGCU
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0005-Fix-work-around-compilation.patch"

>From 70e7eada67a5a4170f2a9e268d8134a7c773e225 Mon Sep 17 00:00:00 2001
From: Pavel <pavel@ucw.cz>
Date: Fri, 29 Apr 2016 12:13:24 +0200
Subject: [PATCH 5/5] Fix (work around?) compilation.

---
 drivers/media/platform/omap3isp/isp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index f89abea..dd96a4b 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2267,7 +2267,7 @@ static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
 	struct isp_async_subdev *isd =
 		container_of(asd, struct isp_async_subdev, asd);
 
-	subdev->entity.group_id = isd->group_id;
+//	subdev->entity.group_id = isd->group_id;
 	isd->sd = subdev;
 	isd->sd->host_priv = isd->bus;
 
-- 
2.1.4


--azLHFNyN32YCQGCU--
