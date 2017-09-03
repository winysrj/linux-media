Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52282
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751640AbdICTEB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 15:04:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/7] media: format.rst: use the right markup for important notes
Date: Sun,  3 Sep 2017 16:03:47 -0300
Message-Id: <635fbe9cd54183944368f5f94106e35e1ddfff9c.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's an important note there, but it is not using the
ReST markup. So, it doesn't get any visual highlight on
the output.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/format.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/format.rst b/Documentation/media/uapi/v4l/format.rst
index 452c6d59cad5..3e3efb0e349e 100644
--- a/Documentation/media/uapi/v4l/format.rst
+++ b/Documentation/media/uapi/v4l/format.rst
@@ -78,7 +78,7 @@ output devices is available. [#f1]_
 The :ref:`VIDIOC_ENUM_FMT` ioctl must be supported
 by all drivers exchanging image data with applications.
 
-    **Important**
+.. important::
 
     Drivers are not supposed to convert image formats in kernel space.
     They must enumerate only formats directly supported by the hardware.
-- 
2.13.5
