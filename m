Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44865 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759986Ab3GSRtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 13:49:49 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 873E860096
	for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 20:49:46 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [RFC 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Date: Fri, 19 Jul 2013 20:55:06 +0300
Message-Id: <1374256509-7850-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1374256509-7850-1-git-send-email-sakari.ailus@iki.fi>
References: <1374256509-7850-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pads that set this flag must be connected by an active link for the entity
to stream.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/media-ioc-enum-links.xml |    5 +++++
 include/uapi/linux/media.h                               |    1 +
 2 files changed, 6 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
index 355df43..4725a99 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
@@ -134,6 +134,11 @@
 	    <entry>Output pad, relative to the entity. Output pads source data
 	    and are origins of links.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_PAD_FL_MUST_CONNECT</constant></entry>
+	    <entry>A pad must be connected with an enabled link for
+	    the entity to be able to stream.</entry>
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

