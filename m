Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:41890 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbeBIGc7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 01:32:59 -0500
Received: by mail-pg0-f67.google.com with SMTP id t4so1953209pgp.8
        for <linux-media@vger.kernel.org>; Thu, 08 Feb 2018 22:32:58 -0800 (PST)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v10 3/8] media: add digital video decoder entity functions
Date: Thu,  8 Feb 2018 22:32:31 -0800
Message-Id: <1518157956-14220-4-git-send-email-tharvey@gateworks.com>
In-Reply-To: <1518157956-14220-1-git-send-email-tharvey@gateworks.com>
References: <1518157956-14220-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new media entity function definition for digital TV decoders:
MEDIA_ENT_F_DTV_DECODER

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 Documentation/media/uapi/mediactl/media-types.rst | 11 +++++++++++
 include/uapi/linux/media.h                        |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 8d64b0c..195400e 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -321,6 +321,17 @@ Types and flags used to represent the media graph elements
          MIPI CSI-2, ...), and outputs them on its source pad to an output
          video bus of another type (eDP, MIPI CSI-2, parallel, ...).
 
+    -  ..  row 31
+
+       ..  _MEDIA-ENT-F-DTV-DECODER:
+
+       -  ``MEDIA_ENT_F_DTV_DECODER``
+
+       -  Digital video decoder. The basic function of the video decoder is
+	  to accept digital video from a wide variety of sources
+	  and output it in some digital video standard, with appropriate
+	  timing signals.
+
 ..  tabularcolumns:: |p{5.5cm}|p{12.0cm}|
 
 .. _media-entity-flag:
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index b9b9446..2f12328 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -110,6 +110,11 @@ struct media_device_info {
 #define MEDIA_ENT_F_VID_IF_BRIDGE		(MEDIA_ENT_F_BASE + 0x5002)
 
 /*
+ * Digital video decoder entities
+ */
+#define MEDIA_ENT_F_DTV_DECODER			(MEDIA_ENT_F_BASE + 0x6001)
+
+/*
  * Connectors
  */
 /* It is a responsibility of the entity drivers to add connectors and links */
-- 
2.7.4
