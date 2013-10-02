Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51770 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753184Ab3JBXLG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 19:11:06 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: sylwester.nawrocki@gmail.com, laurent.pinchart@ideasonboard.com,
	a.hajda@samsung.com
Subject: [PATCH v2 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Date: Thu,  3 Oct 2013 02:17:50 +0300
Message-Id: <1380755873-25835-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1380755873-25835-1-git-send-email-sakari.ailus@iki.fi>
References: <1380755873-25835-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pads that set this flag must be connected by an active link for the entity
to stream.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
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

