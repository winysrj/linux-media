Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63533 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751574AbdJJLpq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 07:45:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v8 7/7] media: open.rst: add a notice about subdev-API on vdev-centric
Date: Tue, 10 Oct 2017 08:45:23 -0300
Message-Id: <dafe58f00487efc85bab5004918711f168e1a9a5.1507635716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507635716.git.mchehab@s-opensource.com>
References: <cover.1507635716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507635716.git.mchehab@s-opensource.com>
References: <cover.1507635716.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation doesn't mention if vdev-centric hardware
control would have subdev API or not.

Add a notice about that, reflecting the current status, where
three drivers use it, in order to support some subdev-specific
controls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/open.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index 58ab75959584..ccdf53ab347c 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -62,6 +62,13 @@ typically involves configuring the links using the **Media controller**
 interface and the media bus formats on pads (at both ends of the links)
 using the **V4L2 sub-device** interface.
 
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
2.13.6
