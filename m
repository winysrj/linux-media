Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48385
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752438AbdIATiD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:38:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 03/14] media: gen-errors.rst: document ENXIO error code
Date: Fri,  1 Sep 2017 16:37:39 -0300
Message-Id: <5847e375f1bacc37558b44946e025ab326721b11.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This error can be produced at least at the DVB subsystem.

As it is generic enough, document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/gen-errors.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/media/uapi/gen-errors.rst b/Documentation/media/uapi/gen-errors.rst
index d51f672021c4..689d3b101ede 100644
--- a/Documentation/media/uapi/gen-errors.rst
+++ b/Documentation/media/uapi/gen-errors.rst
@@ -80,6 +80,11 @@ Generic Error Codes
           a hardware device. This could indicate broken or flaky hardware.
 	  It's a 'Something is wrong, I give up!' type of error.
 
+    -  - ``ENXIO``
+
+       -  No device corresponding to this device special file exists.
+
+
 .. note::
 
   #. This list is not exhaustive; ioctls may return other error codes.
-- 
2.13.5
