Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752216AbcH3XVF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 19:21:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/3] [media] v4l2-dv-timings.h: let kernel-doc parte the typedef argument
Date: Tue, 30 Aug 2016 20:20:59 -0300
Message-Id: <1807d855ee078e00f5dd1fb6e001eacf976d075b.1472598859.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1472598859.git.mchehab@s-opensource.com>
References: <cover.1472598859.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1472598859.git.mchehab@s-opensource.com>
References: <cover.1472598859.git.mchehab@s-opensource.com>
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


