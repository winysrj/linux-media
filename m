Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:36787 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLEKLP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 05:11:15 -0500
From: Javi Merino <javi.merino@kernel.org>
To: Javier Martinez Canillas <javier@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Javi Merino <javi.merino@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2] v4l: async: make v4l2 coexist with devicetree nodes in a dt overlay
Date: Mon,  5 Dec 2016 10:09:56 +0000
Message-Id: <1480932596-4108-1-git-send-email-javi.merino@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In asds configured with V4L2_ASYNC_MATCH_OF, the v4l2 subdev can be
part of a devicetree overlay, for example:

&media_bridge {
	...
	my_port: port@0 {
		#address-cells = <1>;
		#size-cells = <0>;
		reg = <0>;
		ep: endpoint@0 {
			remote-endpoint = <&camera0>;
		};
	};
};

/ {
	fragment@0 {
		target = <&i2c0>;
		__overlay__ {
			my_cam {
				compatible = "foo,bar";
				port {
					camera0: endpoint {
						remote-endpoint = <&my_port>;
						...
					};
				};
			};
		};
	};
};

Each time the overlay is applied, its of_node pointer will be
different.  We are not interested in matching the pointer, what we
want to match is that the path is the one we are expecting.  Change to
use of_node_cmp() so that we continue matching after the overlay has
been removed and reapplied.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Javi Merino <javi.merino@kernel.org>
---
 drivers/media/v4l2-core/v4l2-async.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 5bada20..d33a17c 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -42,7 +42,8 @@ static bool match_devname(struct v4l2_subdev *sd,
 
 static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	return sd->of_node == asd->match.of.node;
+	return !of_node_cmp(of_node_full_name(sd->of_node),
+			    of_node_full_name(asd->match.of.node));
 }
 
 static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
-- 
2.1.4

