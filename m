Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58223
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751269AbdH1MyI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 08:54:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v5 7/7] media: open.rst: add a notice about subdev-API on vdev-centric
Date: Mon, 28 Aug 2017 09:54:01 -0300
Message-Id: <8d6faa89187bb49730a5e046d9cdf3f2446b9266.1503924361.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503924361.git.mchehab@s-opensource.com>
References: <cover.1503924361.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503924361.git.mchehab@s-opensource.com>
References: <cover.1503924361.git.mchehab@s-opensource.com>
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
index 275d934d2659..ceffc87d7ca3 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -47,6 +47,13 @@ the periferal can be used. For such devices, the sub-devices' configuration
 can be controlled via the :ref:`sub-device API <subdev>`, which creates one
 device node per sub-device.
 
+.. note::
+
+   A **vdev-centric** may also optionally expose V4L2 sub-devices via
+   :ref:`sub-device API <subdev>`. In that case, it has to implement
+   the :ref:`media controller API <media_controller>` as well.
+
+
 .. attention::
 
    Devices that require **MC-centric** hardware peripheral control should
-- 
2.13.5
