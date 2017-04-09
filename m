Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53019
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752067AbdDIK4O (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 06:56:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] vidioc-queryctrl.rst: fix menu/int menu references
Date: Sun,  9 Apr 2017 07:56:08 -0300
Message-Id: <c8027c4d4c667a0ff406261e948252a94d1c5e7b.1491735360.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation incorrectly mentions MENU and INTEGER_MENU
at struct v4l2_querymenu table as if they were flags. They're
not: they're types.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 82769de801b1..80842983eb12 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -301,12 +301,12 @@ See also the examples in :ref:`control`.
       - ``name``\ [32]
       - Name of the menu item, a NUL-terminated ASCII string. This
 	information is intended for the user. This field is valid for
-	``V4L2_CTRL_FLAG_MENU`` type controls.
+	``V4L2_CTRL_TYPE_MENU`` type controls.
     * -
       - __s64
       - ``value``
       - Value of the integer menu item. This field is valid for
-	``V4L2_CTRL_FLAG_INTEGER_MENU`` type controls.
+	``V4L2_CTRL_TYPE_INTEGER_MENU`` type controls.
     * - __u32
       -
       - ``reserved``
-- 
2.9.3
