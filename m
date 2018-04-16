Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:49791 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755117AbeDPNV2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 09:21:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 9/9] media-ioc-g-topology.rst: document new 'flags' field
Date: Mon, 16 Apr 2018 15:21:21 +0200
Message-Id: <20180416132121.46205-10-hverkuil@xs4all.nl>
In-Reply-To: <20180416132121.46205-1-hverkuil@xs4all.nl>
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new struct media_v2_entity 'flags' field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 459818c3490c..6521ab7c9b58 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -211,7 +211,18 @@ desired arrays with the media graph elements.
 
        -  __u32
 
-       -  ``reserved``\ [6]
+       -  ``flags``
+
+       -  Entity flags, see :ref:`media-entity-flag` for details.
+          Only valid if ``MEDIA_V2_ENTITY_HAS_FLAGS(media_version)``
+          returns true. The ``media_version`` is defined in struct
+	  :c:type:`media_device_info`.
+
+    -  .. row 5
+
+       -  __u32
+
+       -  ``reserved``\ [5]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
-- 
2.15.1
