Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60078 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbeIYSOc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 14:14:32 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 3/3] media: open.rst: remove the minor number range
Date: Tue, 25 Sep 2018 09:06:53 -0300
Message-Id: <ffdea9c7ca163ed41a11c9953bb86b835bd23dd9.1537876293.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537876293.git.mchehab+samsung@kernel.org>
References: <cover.1537876293.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537876293.git.mchehab+samsung@kernel.org>
References: <cover.1537876293.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

minor numbers use to range between 0 to 255, but that
was changed a long time ago. While it still applies when
CONFIG_VIDEO_FIXED_MINOR_RANGES, when the minor number is
dynamically allocated, this may not be true. In any case,
this is not relevant, as udev will take care of it.

So, remove this useless misinformation.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/uapi/v4l/open.rst | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index 7e7aad784388..18030131ef77 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -19,11 +19,10 @@ helper functions and a common application interface specified in this
 document.
 
 Each driver thus loaded registers one or more device nodes with major
-number 81 and a minor number between 0 and 255. Minor numbers are
-allocated dynamically unless the kernel is compiled with the kernel
-option CONFIG_VIDEO_FIXED_MINOR_RANGES. In that case minor numbers
-are allocated in ranges depending on the device node type (video, radio,
-etc.).
+number 81. Minor numbers are allocated dynamically unless the kernel
+is compiled with the kernel option CONFIG_VIDEO_FIXED_MINOR_RANGES.
+In that case minor numbers are allocated in ranges depending on the
+device node type.
 
 The existing V4L2 device node types are:
 
-- 
2.17.1
