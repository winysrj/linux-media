Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58258 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754232Ab3JMK6t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 06:58:49 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sylwester.nawrocki@gmail.com,
	a.hajda@samsung.com
Subject: [PATCH v2.1 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Date: Sun, 13 Oct 2013 13:58:43 +0300
Message-Id: <1381661924-26365-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <524DEC22.5090107@gmail.com>
References: <524DEC22.5090107@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pads that set this flag must be connected by an active link for the entity
to stream.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/DocBook/media/v4l/media-ioc-enum-links.xml |   10 ++++++++++
 include/uapi/linux/media.h                               |    1 +
 2 files changed, 11 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
index 355df43..e357dc9 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
@@ -134,6 +134,16 @@
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
+	    flag doesn't imply there is none. The flag has no effect on pads
+	    without connected links.</entry>
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

