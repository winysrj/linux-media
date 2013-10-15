Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38823 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933657Ab3JOVrb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 17:47:31 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sylwester.nawrocki@gmail.com,
	a.hajda@samsung.com
Subject: [PATCH v2.2 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Date: Wed, 16 Oct 2013 00:46:57 +0300
Message-Id: <1381873617-5481-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <3422963.Ua6Z8kTtzN@avalon>
References: <3422963.Ua6Z8kTtzN@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pads that set this flag must be connected by an active link for the entity
to stream.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/DocBook/media/v4l/media-ioc-enum-links.xml |    9 +++++++++
 include/uapi/linux/media.h                               |    1 +
 2 files changed, 10 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
index 355df43..cf85485 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
@@ -134,6 +134,15 @@
 	    <entry>Output pad, relative to the entity. Output pads source data
 	    and are origins of links.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_PAD_FL_MUST_CONNECT</constant></entry>
+	    <entry>If this flag is set and the pad is linked to any other
+	    pad, then at least one of those links must be enabled for the
+	    entity to be able to stream. There could be temporary reasons
+	    (e.g. device configuration dependent) for the pad to need
+	    enabled links even when this flag isn't set; the absence of the
+	    flag doesn't imply there is none.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index ed49574..d847c76 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -98,6 +98,7 @@ struct media_entity_desc {
 
 #define MEDIA_PAD_FL_SINK		(1 << 0)
 #define MEDIA_PAD_FL_SOURCE		(1 << 1)
+#define MEDIA_PAD_FL_MUST_CONNECT	(1 << 2)
 
 struct media_pad_desc {
 	__u32 entity;		/* entity ID */
-- 
1.7.10.4

