Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54193 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbcD2OGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 10:06:54 -0400
Date: Fri, 29 Apr 2016 16:06:49 +0200
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
Message-ID: <20160429140649.GE21251@amd>
References: <20160428084546.GA9957@amd>
 <20160429071525.GA4823@amd>
 <57230DE7.3020701@xs4all.nl>
 <20160429075649.GG32125@valkosipuli.retiisi.org.uk>
 <20160429095002.GA22743@amd>
 <20160429105944.GH32125@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160429105944.GH32125@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > > This seems to be mostly in line with what has been discussed in the meeting,
> > > except that the patches add a device specific property. Please ignore the
> > > led patches in that tree for now (i.e. four patches on the top are the
> > > relevant ones here).
> > > 
> > 
> > I'm currently trying to apply them to v4.6, but am getting rather ugly
> > rejects :-(.
> 
> :-\
> 
> There have been patches applied to the omap3isp driver since that I suppose.
> These aren't overly complex, feel free to take the patches if they're still
> useful.

Ok, I got it to work. I can split it back, if needed. I've got patches
on camera-fm3 branch. And yes, that gets flash to work.

(I don't know how to turn flash into torch, which is what I really
wanted, but I guess I'll figure it out.)

									Pavel

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 640d409..a6b9fac 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -239,6 +239,7 @@
 
 	pinctrl-names = "default";
 	pinctrl-0 = <&camera_pins>;
+	ti,camera-flashes = <&adp1653 &cam1>;
 
 	ports {
 		port@1 {
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 6361fde..23d484c 100644
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
@@ -2144,10 +2151,51 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
 	return 0;
 }
 
+static int isp_of_parse_node(struct device *dev, struct device_node *node,
+			     struct v4l2_async_notifier *notifier,
+			     u32 group_id, bool link)
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
+	isd->group_id = group_id;
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
+	u32 group_id = 0;
 
 	notifier->subdevs = devm_kcalloc(
 		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
@@ -2156,30 +2204,57 @@ static int isp_of_parse_nodes(struct device *dev,
 
 	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
 	       (node = of_graph_get_next_endpoint(dev->of_node, node))) {
-		struct isp_async_subdev *isd;
+		ret = isp_of_parse_node(dev, node, notifier, group_id++, true);
+		if (ret)
+			return ret;
+	}
 
-		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
-		if (!isd) {
-			of_node_put(node);
-			return -ENOMEM;
-		}
+	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
+	       (node = of_parse_phandle(dev->of_node, "ti,camera-flashes",
+					flash++))) {
+		struct device_node *sensor_node =
+			of_parse_phandle(dev->of_node, "ti,camera-flashes",
+					 flash++);
+		unsigned int i;
+		u32 flash_group_id;
+
+		if (!sensor_node)
+			return -EINVAL;
 
-		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
+		for (i = 0; i < notifier->num_subdevs; i++) {
+			struct isp_async_subdev *isd = container_of(
+				notifier->subdevs[i], struct isp_async_subdev,
+				asd);
 
-		if (isp_of_parse_node(dev, node, isd)) {
-			of_node_put(node);
-			return -EINVAL;
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
 		}
 
-		isd->asd.match.of.node = of_graph_get_remote_port_parent(node);
-		of_node_put(node);
-		if (!isd->asd.match.of.node) {
-			dev_warn(dev, "bad remote port parent\n");
-			return -EINVAL;
+		/*
+		 * No sensor was found --- complain and allocate a new
+		 * group ID.
+		 */
+		if (i == notifier->num_subdevs) {
+			dev_warn(dev, "no device node \"%s\" was found",
+				 sensor_node->name);
+			flash_group_id = group_id++;
 		}
 
-		isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
-		notifier->num_subdevs++;
+		ret = isp_of_parse_node(dev, node, notifier, flash_group_id,
+					false);
+		if (ret)
+			return ret;
 	}
 
 	return notifier->num_subdevs;
@@ -2192,8 +2267,9 @@ static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
 	struct isp_async_subdev *isd =
 		container_of(asd, struct isp_async_subdev, asd);
 
+//	subdev->entity.group_id = isd->group_id;
 	isd->sd = subdev;
-	isd->sd->host_priv = &isd->bus;
+	isd->sd->host_priv = isd->bus;
 
 	return 0;
 }
@@ -2396,12 +2472,15 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_register_entities;
 
-	isp->notifier.bound = isp_subdev_notifier_bound;
-	isp->notifier.complete = isp_subdev_notifier_complete;
+	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
+		isp->notifier.bound = isp_subdev_notifier_bound;
+		isp->notifier.complete = isp_subdev_notifier_complete;
 
-	ret = v4l2_async_notifier_register(&isp->v4l2_dev, &isp->notifier);
-	if (ret)
-		goto error_register_entities;
+		ret = v4l2_async_notifier_register(&isp->v4l2_dev,
+						   &isp->notifier);
+		if (ret)
+			goto error_register_entities;
+	}
 
 	isp_core_init(isp, 1);
 	omap3isp_put(isp);
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 7e6f663..639b3ca 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -228,8 +228,9 @@ struct isp_device {
 
 struct isp_async_subdev {
 	struct v4l2_subdev *sd;
-	struct isp_bus_cfg bus;
+	struct isp_bus_cfg *bus;
 	struct v4l2_async_subdev asd;
+	u32 group_id;
 };
 
 #define v4l2_dev_to_isp_device(dev) \
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
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
