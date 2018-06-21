Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52277 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753725AbeFUHTU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 03:19:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 4/8] media-ioc-g-topology.rst: document new 'flags' field
Date: Thu, 21 Jun 2018 09:19:10 +0200
Message-Id: <20180621071914.28729-5-hverkuil@xs4all.nl>
In-Reply-To: <20180621071914.28729-1-hverkuil@xs4all.nl>
References: <20180621071914.28729-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new struct media_v2_entity 'flags' field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/uapi/mediactl/media-ioc-g-topology.rst       | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 24ab34b22df2..86d1f7d577c8 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -142,7 +142,15 @@ desired arrays with the media graph elements.
        -  Entity main function, see :ref:`media-entity-functions` for details.
 
     *  -  __u32
-       -  ``reserved``\ [6]
+       -  ``flags``
+       -  Entity flags, see :ref:`media-entity-flag` for details.
+	  Only valid if ``MEDIA_V2_ENTITY_HAS_FLAGS(media_version)``
+	  returns true. The ``media_version`` is defined in struct
+	  :c:type:`media_device_info` and can be retrieved using
+	  :ref:`MEDIA_IOC_DEVICE_INFO`.
+
+    *  -  __u32
+       -  ``reserved``\ [5]
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
 
-- 
2.17.0
