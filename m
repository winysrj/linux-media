Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53602
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752322AbdHZLxf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 07:53:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v4 7/7] media: open.rst: add a notice about subdev-API on vdev-centric
Date: Sat, 26 Aug 2017 08:53:25 -0300
Message-Id: <a77ff374ebde22ea20e1cec7c94026db817ed89d.1503747774.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503747774.git.mchehab@s-opensource.com>
References: <cover.1503747774.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503747774.git.mchehab@s-opensource.com>
References: <cover.1503747774.git.mchehab@s-opensource.com>
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
index d0930fc170f0..48f628bbabc7 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -46,6 +46,13 @@ the periferal can be used. For such devices, the sub-devices' configuration
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
 
    Devices that require **mc-centric** hardware peripheral control should
-- 
2.13.3
