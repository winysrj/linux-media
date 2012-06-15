Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:48515 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925Ab2FONox (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 09:44:53 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	snjw23@gmail.com, t.stanislaws@samsung.com
Subject: [PATCH v4 7/7] v4l: Correct conflicting V4L2 subdev selection API documentation
Date: Fri, 15 Jun 2012 16:44:40 +0300
Message-Id: <1339767880-8412-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4FDB3C2E.9060502@iki.fi>
References: <4FDB3C2E.9060502@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The API reference documents that the KEEP_CONFIG flag tells the
configuration should not be propatgated by the driver whereas the interface
documentation (dev-subdev.xml) categorically prohibited any changes to the
rest of the pipeline. The latter makes no sense, since it would severely
limit the usefulness of the KEEP_CONFIG flag.

Correct the documentation in dev-subddev.xml.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/dev-subdev.xml |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index 8c44b3f..95ebf87 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -361,11 +361,11 @@
       performed by the user: the changes made will be propagated to
       any subsequent stages. If this behaviour is not desired, the
       user must set
-      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag. This
-      flag causes no propagation of the changes are allowed in any
-      circumstances. This may also cause the accessed rectangle to be
-      adjusted by the driver, depending on the properties of the
-      underlying hardware.</para>
+      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag,
+      which tells the driver to make minimum changes to the rest of
+      the subdev's configuration. This may also cause the accessed
+      rectangle to be adjusted by the driver, depending on the
+      properties of the underlying hardware.</para>
 
       <para>The coordinates to a step always refer to the actual size
       of the previous step. The exception to this rule is the source
-- 
1.7.2.5

