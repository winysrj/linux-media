Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:51615 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab2F3RFi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 13:05:38 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: sylwester.nawrocki@gmail.com, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH 8/8] v4l: Correct conflicting V4L2 subdev selection API documentation
Date: Sat, 30 Jun 2012 20:03:59 +0300
Message-Id: <1341075839-18586-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120630170506.GE19384@valkosipuli.retiisi.org.uk>
References: <20120630170506.GE19384@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The API reference documents that the KEEP_CONFIG flag tells the
configuration should not be propagated by the driver whereas the interface
documentation (dev-subdev.xml) prohibited any changes to the rest of the
pipeline. Resolve the conflict by changing the API reference to disallow
changes.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 .../DocBook/media/v4l/selections-common.xml        |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/selections-common.xml b/Documentation/DocBook/media/v4l/selections-common.xml
index 7cec5c1..007e0c5 100644
--- a/Documentation/DocBook/media/v4l/selections-common.xml
+++ b/Documentation/DocBook/media/v4l/selections-common.xml
@@ -148,7 +148,7 @@
 	  <row>
 	    <entry><constant>V4L2_SEL_FLAG_KEEP_CONFIG</constant></entry>
 	    <entry>(1 &lt;&lt; 2)</entry>
-	    <entry>The configuration should not be propagated to any
+	    <entry>The configuration must not be propagated to any
 	    further processing steps. If this flag is not given, the
 	    configuration is propagated inside the subdevice to all
 	    further processing steps.</entry>
-- 
1.7.2.5

