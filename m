Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50733
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932414AbdHYPMH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 11:12:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 7/7] media: open.rst: add a notice about subdev-API on vdev-centric
Date: Fri, 25 Aug 2017 12:11:57 -0300
Message-Id: <141468a790ecffd1d5cf53a0985ef266ea70077d.1503673702.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503673702.git.mchehab@s-opensource.com>
References: <cover.1503673702.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503673702.git.mchehab@s-opensource.com>
References: <cover.1503673702.git.mchehab@s-opensource.com>
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
index 3257a0527ac9..547d191dcef2 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -43,6 +43,13 @@ the application to know with device nodes are available
 For **MC-centric** hardware peripheral control, before using the
 peripheral, it is required to set the pipelines via the
 
+.. note::
+
+   A **vdev-centric** may optionally expose V4L2 sub-devices via
+   :ref:`sub-device API <subdev>`. In that case, it has to implement
+   the :ref:`media controller API <media_controller>` as well.
+
+
 :ref:`media controller API <media_controller>`. For those devices, the
 sub-devices' configuration can be controlled via the
 :ref:`sub-device API <subdev>`, whith creates one device node
-- 
2.13.3
