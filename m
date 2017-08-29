Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34762
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752703AbdH2NSC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 09:18:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v6 3/7] media: open.rst: remove the minor number range
Date: Tue, 29 Aug 2017 10:17:52 -0300
Message-Id: <8846c154b00f146cd629e06ed59dffcad9a233cb.1504012579.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504012579.git.mchehab@s-opensource.com>
References: <cover.1504012579.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504012579.git.mchehab@s-opensource.com>
References: <cover.1504012579.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

minor numbers use to range between 0 to 255, but that
was changed a long time ago. While it still applies when
CONFIG_VIDEO_FIXED_MINOR_RANGES, when the minor number is
dynamically allocated, this may not be true. In any case,
this is not relevant, as udev will take care of it.

So, remove this useless misinformation.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
2.13.5
