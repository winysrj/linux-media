Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:34681 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755854AbeCSPna (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 11:43:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/8] media-ioc-g-topology.rst: document new 'index' field
Date: Mon, 19 Mar 2018 16:43:21 +0100
Message-Id: <20180319154324.37799-6-hverkuil@xs4all.nl>
In-Reply-To: <20180319154324.37799-1-hverkuil@xs4all.nl>
References: <20180319154324.37799-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new struct media_v2_pad 'index' field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index fca4a22f6a45..b9be6b5a1985 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -334,7 +334,17 @@ desired arrays with the media graph elements.
 
        -  __u32
 
-       -  ``reserved``\ [5]
+       -  ``index``
+
+       -  0-based pad index. Only valid if ``MEDIA_V2_PAD_HAS_INDEX(media_version)``
+          returns true. The ``media_version`` is defined in struct
+	  :c:type:`media_device_info`.
+
+    -  .. row 5
+
+       -  __u32
+
+       -  ``reserved``\ [4]
 
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
-- 
2.15.1
