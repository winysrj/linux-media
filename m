Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50963
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752860AbdICCfM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 22:35:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/12] media: vidioc-querycap: use a more realistic value for KERNEL_VERSION
Date: Sat,  2 Sep 2017 23:34:54 -0300
Message-Id: <c8277bfa629487d9df553bbe2e11af5496bd4b44.1504405125.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the past, V4L2 versions were 0.x.y, but that changed years
ago. Since Kernel 3.1, however, the numbering schema was changed
to match the Kernel version.

However, the presented example still uses the old numerating
schema, with is a misleading information.

So, update it to the new schema.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-querycap.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 9494af96bae7..7553b44692b4 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -92,12 +92,13 @@ specification the ioctl returns an ``EINVAL`` error code.
 	stack from a newer kernel.
 
 	The version number is formatted using the ``KERNEL_VERSION()``
-	macro:
+	macro. For example if the media stack corresponds to the V4L2
+	version shipped with Kernel 4.14, it would be equivalent to:
     * - :cspan:`2`
 
 	``#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))``
 
-	``__u32 version = KERNEL_VERSION(0, 8, 1);``
+	``__u32 version = KERNEL_VERSION(4, 14, 0);``
 
 	``printf ("Version: %u.%u.%u\\n",``
 
-- 
2.13.5
