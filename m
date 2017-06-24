Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35953
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751377AbdFXQTA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 12:19:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH] media: imx.rst: add it to v4l-drivers book
Date: Sat, 24 Jun 2017 13:18:14 -0300
Message-Id: <cc7036633839dfd82e3123fa025dd44b009910a8.1498321073.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid the following warning when building documentation:
	checking consistency... /devel/v4l/patchwork/Documentation/media/v4l-drivers/imx.rst:: WARNING: document isn't included in any toctree

While here, avoid placing all driver authors at just one line at
the html/pdf output.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/imx.rst   | 7 ++++---
 Documentation/media/v4l-drivers/index.rst | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
index e0ee0f1aeb05..3c4f58bda178 100644
--- a/Documentation/media/v4l-drivers/imx.rst
+++ b/Documentation/media/v4l-drivers/imx.rst
@@ -607,8 +607,9 @@ References
 
 Authors
 -------
-Steve Longerbeam <steve_longerbeam@mentor.com>
-Philipp Zabel <kernel@pengutronix.de>
-Russell King <linux@armlinux.org.uk>
+
+- Steve Longerbeam <steve_longerbeam@mentor.com>
+- Philipp Zabel <kernel@pengutronix.de>
+- Russell King <linux@armlinux.org.uk>
 
 Copyright (C) 2012-2017 Mentor Graphics Inc.
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 2e24d6806052..10f2ce42ece2 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -41,6 +41,7 @@ For more details see the file COPYING in the source distribution of Linux.
 	cx88
 	davinci-vpbe
 	fimc
+	imx
 	ivtv
 	max2175
 	meye
-- 
2.9.4
