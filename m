Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49469 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbbBMW6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:21 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Antti Palosaari <crope@iki.fi>, linux-doc@vger.kernel.org
Subject: [PATCHv4 05/25] [media] DocBook: Document the DVB API devnodes at the media controller
Date: Fri, 13 Feb 2015 20:57:48 -0200
Message-Id: <36759260b831a0625805fd6ec044a447140405cd.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVB API is actually several different APIs bundled together, each
using its own device node.

Fix the media controller DVB API to actually reflect what's there at the
DVB subsystem.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 19ab836b2651..6f1b1cf172b7 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -181,8 +181,24 @@
 	    <entry>ALSA card</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB</constant></entry>
-	    <entry>DVB card</entry>
+	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_FE</constant></entry>
+	    <entry>DVB frontend devnode</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_DEMUX</constant></entry>
+	    <entry>DVB demux devnode</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_DVR</constant></entry>
+	    <entry>DVB DVR devnode</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_CA</constant></entry>
+	    <entry>DVB CAM devnode</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_NET</constant></entry>
+	    <entry>DVB network devnode</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV</constant></entry>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 3a16ac1f67d0..408e1068ffe6 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -156,7 +156,7 @@ applications. -->
 	<revnumber>3.21</revnumber>
 	<date>2015-02-13</date>
 	<authorinitials>mcc</authorinitials>
-	<revremark>Fix documentation for media controller device nodes.
+	<revremark>Fix documentation for media controller device nodes and add support for DVB device nodes.
 	</revremark>
       </revision>
       <revision>
-- 
2.1.0

