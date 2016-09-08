Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43881 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965316AbcIHMET (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:19 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 24/47] [media] v4l2-dv-timings.h: let kernel-doc parte the typedef argument
Date: Thu,  8 Sep 2016 09:03:46 -0300
Message-Id: <4d2bc4d5e5f70ec9e9fd02f2d67ebb2e3e8d1fe3.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that scripts/kernel-doc was fixed to parse the typedef
argument used here, let it produce documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-dv-timings.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 65caadf13eec..0a7d9e1fc8c8 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -28,8 +28,8 @@
  */
 extern const struct v4l2_dv_timings v4l2_dv_timings_presets[];
 
-/*
- * v4l2_check_dv_timings_fnc - timings check callback
+/**
+ * typedef v4l2_check_dv_timings_fnc - timings check callback
  *
  * @t: the v4l2_dv_timings struct.
  * @handle: a handle from the driver.
-- 
2.7.4


