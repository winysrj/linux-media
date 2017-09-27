Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33637
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752111AbdI0WX4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 18:23:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v7 7/7] media: open.rst: add a notice about subdev-API on vdev-centric
Date: Wed, 27 Sep 2017 19:23:49 -0300
Message-Id: <628a25e694c33ab6dd1ea061bc4d766ec4fe30ef.1506550930.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506550930.git.mchehab@s-opensource.com>
References: <cover.1506550930.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506550930.git.mchehab@s-opensource.com>
References: <cover.1506550930.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation doesn't mention if vdev-centric hardware
control would have subdev API or not.

Add a notice about that, reflecting the current status, where
three drivers use it, in order to support some subdev-specific
controls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/open.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index 75ccc9d6614d..ed011ed123cc 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -47,6 +47,13 @@ the periferal can be used. For such devices, the sub-devices' configuration
 can be controlled via the :ref:`sub-device API <subdev>`, which creates one
 device node per sub-device.
 
+.. note::
+
+   A **vdevnode-centric** may also optionally expose V4L2 sub-devices via
+   :ref:`sub-device API <subdev>`. In that case, it has to implement
+   the :ref:`media controller API <media_controller>` as well.
+
+
 .. attention::
 
    Devices that require **MC-centric** media hardware control should
-- 
2.13.5
