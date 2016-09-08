Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56856 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936614AbcIHVhs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        linux-doc@vger.kernel.org
Subject: [PATCH 06/15] [media] conf_nitpick.py: ignore an opaque struct from v4l2-mem2mem.h
Date: Thu,  8 Sep 2016 18:37:32 -0300
Message-Id: <32c72d1ca04a6637ce8dae7c9e2fea6461ed2075.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_m2m_dev is opaque: its meaning is only known by
v4l2-mem2mem.c. Ignore it on nitpick mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/conf_nitpick.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
index 1f3ef3ded2d4..f71bb947eb15 100644
--- a/Documentation/media/conf_nitpick.py
+++ b/Documentation/media/conf_nitpick.py
@@ -98,4 +98,8 @@ nitpick_ignore = [
     ("c:type", "usb_interface"),
     ("c:type", "v4l2_std_id"),
     ("c:type", "video_system_t"),
+
+    # Opaque structures
+
+    ("c:type", "v4l2_m2m_dev"),
 ]
-- 
2.7.4


