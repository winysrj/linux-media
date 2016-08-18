Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46304 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754588AbcHSBEr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 21:04:47 -0400
Date: Thu, 18 Aug 2016 23:28:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv6] support for AD5820 camera auto-focus coil
Message-ID: <20160818212845.GA30383@amd>
References: <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
 <20160527205140.GA26767@amd>
 <20160805102611.GA13116@amd>
 <20160808080955.GA3182@valkosipuli.retiisi.org.uk>
 <20160808214132.GB2946@xo-6d-61-c0.localdomain>
 <20160810120105.GP3182@valkosipuli.retiisi.org.uk>
 <20160808232323.GC2946@xo-6d-61-c0.localdomain>
 <20160811111633.GR3182@valkosipuli.retiisi.org.uk>
 <20160818104539.GA7427@amd>
 <20160818202559.GF3182@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160818202559.GF3182@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > Heh. Basically anything is easier to develop for than n900 :-(.
> 
> Is it?
> 
> I actually find the old Nokia devices very practical. It's easy to boot your
> own kernel and things just work... until musb broke a bit recently. It
> requires reconnecting the usb cable again to function.
> 
> I have to admit I mostly use an N9.

Well, yes, I guess it sucks less than most phones, but...

I wish I had working .5TB drive, and CPU fast enough to compile kernel
in say hour, and enough memory to run emacs and g++ at the same time,
ethernet connection, working RTC and real keyboard and monitor...

Development would be way easier if I could just disconnect the N900
peripherals and connect them to the PC. Ok, I can dream, right?


> > I guess subdevs for omap3 should be merged at this point. Do you have
> > any plans to do that, or should I take a look?
> 
> What's still missing? I think I've yet to check the et8ek8 driver and the
> device tree description is missing. That's what comes to mind right now.

et8ek8 driver is important, yes. But there's the support for parsing
sub-devices from the dt missing, too. This stuff (I believe it is
originally from you).

Best regards,
								Pavel

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 5d54e2c..23d484c 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2098,10 +2151,51 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
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
@@ -2110,30 +2204,57 @@ static int isp_of_parse_nodes(struct device *dev,
 
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
@@ -2146,8 +2267,9 @@ static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
 	struct isp_async_subdev *isd =
 		container_of(asd, struct isp_async_subdev, asd);
 
+//	subdev->entity.group_id = isd->group_id;
 	isd->sd = subdev;
-	isd->sd->host_priv = &isd->bus;
+	isd->sd->host_priv = isd->bus;
 
 	return 0;
 }
@@ -2350,12 +2472,15 @@ static int isp_probe(struct platform_device *pdev)
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



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
