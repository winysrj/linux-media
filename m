Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAB8C10F0D
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C7D92133F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfCESv7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:51:59 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:46799 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbfCESv6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:51:58 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D96DF20000E;
        Tue,  5 Mar 2019 18:51:55 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 20/31] v4l: subdev: Take routing information into account in link validation
Date:   Tue,  5 Mar 2019 19:51:39 +0100
Message-Id: <20190305185150.20776-21-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The routing information is essential in link validation for multiplexed
links: the pads at the ends of a multiplexed link have no single format
defined for them. Instead, the format is accessible in the sink (or
source) pads of the sub-devices at both ends of that link.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Tested-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 220 ++++++++++++++++++++++++--
 1 file changed, 206 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index f845b0658913..9b4f3528a4da 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -651,12 +651,17 @@ static int
 v4l2_subdev_link_validate_get_format(struct media_pad *pad,
 				     struct v4l2_subdev_format *fmt)
 {
+	dev_dbg(pad->entity->graph_obj.mdev->dev,
+		"obtaining format on \"%s\":%u\n", pad->entity->name,
+		pad->index);
+
 	if (is_media_entity_v4l2_subdev(pad->entity)) {
 		struct v4l2_subdev *sd =
 			media_entity_to_v4l2_subdev(pad->entity);
 
 		fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
 		fmt->pad = pad->index;
+
 		return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
 	}
 
@@ -667,31 +672,218 @@ v4l2_subdev_link_validate_get_format(struct media_pad *pad,
 	return -EINVAL;
 }
 
-int v4l2_subdev_link_validate(struct media_link *link)
+static int v4l2_subdev_link_validate_one(struct media_link *link,
+					 struct v4l2_subdev_format *source_fmt,
+					 struct v4l2_subdev_format *sink_fmt)
 {
 	struct v4l2_subdev *sink;
-	struct v4l2_subdev_format sink_fmt, source_fmt;
 	int rval;
 
-	rval = v4l2_subdev_link_validate_get_format(
-		link->source, &source_fmt);
-	if (rval < 0)
-		return 0;
-
-	rval = v4l2_subdev_link_validate_get_format(
-		link->sink, &sink_fmt);
-	if (rval < 0)
-		return 0;
-
 	sink = media_entity_to_v4l2_subdev(link->sink->entity);
 
 	rval = v4l2_subdev_call(sink, pad, link_validate, link,
-				&source_fmt, &sink_fmt);
+				source_fmt, sink_fmt);
 	if (rval != -ENOIOCTLCMD)
 		return rval;
 
 	return v4l2_subdev_link_validate_default(
-		sink, link, &source_fmt, &sink_fmt);
+		sink, link, source_fmt, sink_fmt);
+}
+
+/* How many routes to assume there can be per a sub-device? */
+#define LINK_VALIDATE_ROUTES	8
+
+#define R_SRC	0
+#define R_SINK	1
+#define NR_R	2
+
+int v4l2_subdev_link_validate(struct media_link *link)
+{
+	struct v4l2_subdev *sink;
+	struct route_info {
+		struct v4l2_subdev_route routes[LINK_VALIDATE_ROUTES];
+		struct v4l2_subdev_krouting routing;
+		bool has_route;
+		struct media_pad *pad;
+		/* Format for a non-multiplexed pad. */
+		struct v4l2_subdev_format fmt;
+	} r[NR_R] = {
+		{
+			/* Source end of the link */
+			.routing = {
+				.routes = r[R_SRC].routes,
+				.num_routes = ARRAY_SIZE(r[R_SRC].routes),
+			},
+			.pad = link->source,
+		},
+		{
+			/* Sink end of the link */
+			.routing = {
+				.routes = r[R_SINK].routes,
+				.num_routes = ARRAY_SIZE(r[R_SINK].routes),
+			},
+			.pad = link->sink,
+		},
+	};
+	unsigned int i, j;
+	int rval;
+
+	sink = media_entity_to_v4l2_subdev(link->sink->entity);
+
+	dev_dbg(sink->entity.graph_obj.mdev->dev,
+		"validating link \"%s\":%u -> \"%s\":%u\n",
+		link->source->entity->name, link->source->index,
+		sink->entity.name, link->sink->index);
+
+	for (i = 0; i < NR_R; i++) {
+		struct route_info *ri = &r[i];
+
+		ri->has_route = true;
+
+		rval = v4l2_subdev_call(
+			media_entity_to_v4l2_subdev(ri->pad->entity),
+			pad, get_routing, &ri->routing);
+
+		switch (rval) {
+		case 0:
+			break;
+		case -ENOIOCTLCMD:
+			dev_dbg(sink->entity.graph_obj.mdev->dev,
+				"no routing information on \"%s\":%u\n",
+				ri->pad->entity->name, ri->pad->index);
+			ri->has_route = false;
+			break;
+		default:
+			dev_dbg(sink->entity.graph_obj.mdev->dev,
+				"error %d in get_routing() on \"%s\":%u\n",
+				rval, ri->pad->entity->name, ri->pad->index);
+			return rval;
+		}
+
+		rval = v4l2_subdev_link_validate_get_format(ri->pad,
+							    &ri->fmt);
+
+		if (!rval) {
+			dev_dbg(sink->entity.graph_obj.mdev->dev,
+				"format information available on \"%s\":%u\n",
+				ri->pad->entity->name, ri->pad->index);
+			ri->has_route = false;
+		}
+
+		if (!ri->has_route) {
+			ri->routing.num_routes = 1;
+		} else {
+			dev_dbg(sink->entity.graph_obj.mdev->dev,
+				"routes on \"%s\":%u:\n",
+				ri->pad->entity->name, ri->pad->index);
+			for (j = 0; j < ri->routing.num_routes; j++)
+				dev_dbg(sink->entity.graph_obj.mdev->dev,
+					"\t%u: %u/%u -> %u/%u [%s]\n", j,
+					ri->routing.routes[j].sink_pad,
+					ri->routing.routes[j].sink_stream,
+					ri->routing.routes[j].source_pad,
+					ri->routing.routes[j].source_stream,
+					ri->routing.routes[j].flags &
+					V4L2_SUBDEV_ROUTE_FL_ACTIVE ? "1" : "0"
+					);
+		}
+	}
+
+	for (i = 0, j = 0;
+	     i < r[R_SRC].routing.num_routes &&
+		     j < r[R_SINK].routing.num_routes; ) {
+		unsigned int *ro[] = { &i, &j };
+		unsigned int k;
+
+		/* Get the first active route for the sink pad. */
+		if (r[R_SINK].has_route &&
+		    (r[R_SINK].routes[j].sink_pad != link->sink->index ||
+		     !(r[R_SINK].routes[j].flags
+		       & V4L2_SUBDEV_ROUTE_FL_ACTIVE))) {
+			dev_dbg(sink->entity.graph_obj.mdev->dev,
+				"skipping route %u/%u -> %u/%u[%u]\n",
+				r[R_SINK].routes[j].sink_pad,
+				r[R_SINK].routes[j].sink_stream,
+				r[R_SINK].routes[j].source_pad,
+				r[R_SINK].routes[j].source_stream,
+				(bool)(r[R_SINK].routes[j].flags
+				       & V4L2_SUBDEV_ROUTE_FL_ACTIVE));
+			j++;
+			continue;
+		}
+
+		/*
+		 * Get the corresponding route for the source pad.
+		 * It's ok for the source pad to have routes active
+		 * where the sink pad does not, but the routes that
+		 * are active on the sink pad have to be active on
+		 * the source pad as well.
+		 */
+		if (r[R_SRC].has_route &&
+		    (r[R_SRC].routes[i].source_pad != link->source->index ||
+		     r[R_SRC].routes[i].source_stream
+		     != r[R_SINK].routes[j].sink_stream)) {
+			dev_dbg(sink->entity.graph_obj.mdev->dev,
+				"skipping source route %u/%u -> %u/%u\n",
+				r[R_SRC].routes[i].sink_pad,
+				r[R_SRC].routes[i].sink_stream,
+				r[R_SRC].routes[i].source_pad,
+				r[R_SRC].routes[i].source_stream);
+			i++;
+			continue;
+		}
+
+		/* The source route must be active. */
+		if (r[R_SRC].has_route &&
+		    !(r[R_SRC].routes[i].flags
+		      & V4L2_SUBDEV_ROUTE_FL_ACTIVE)) {
+			dev_dbg(sink->entity.graph_obj.mdev->dev,
+				"source route not active\n");
+			return -EINVAL;
+		}
+
+		for (k = 0; k < NR_R; k++) {
+			if (r[k].has_route) {
+				dev_dbg(sink->entity.graph_obj.mdev->dev,
+					"validating %s route \"%s\": %u/%u -> %u/%u\n",
+					k == R_SINK ? "sink" : "source",
+					r[k].pad->entity->name,
+					r[k].routes[*ro[k]].sink_pad,
+					r[k].routes[*ro[k]].sink_stream,
+					r[k].routes[*ro[k]].source_pad,
+					r[k].routes[*ro[k]].source_stream);
+				rval = v4l2_subdev_link_validate_get_format(
+					&r[k].pad->entity->pads[
+						k == R_SINK
+						? r[k].routes[*ro[k]].source_pad
+						: r[k].routes[*ro[k]].sink_pad],
+					&r[k].fmt);
+			} else {
+				dev_dbg(sink->entity.graph_obj.mdev->dev,
+					"routing not supported by \"%s\":%u",
+					r[k].pad->entity->name,
+					r[k].pad->index);
+			}
+		}
+
+		rval = v4l2_subdev_link_validate_one(
+			link, &r[R_SRC].fmt, &r[R_SINK].fmt);
+		if (rval) {
+			dev_dbg(sink->entity.graph_obj.mdev->dev,
+				"error %d in link validation\n", rval);
+			return rval;
+		}
+
+		i++, j++;
+	}
+
+	if (j < r[R_SINK].routing.num_routes) {
+		dev_dbg(sink->entity.graph_obj.mdev->dev,
+			"not all sink routes verified; out of source routes\n");
+		return -EINVAL;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate);
 
-- 
2.20.1

