Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41643 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936203AbeF2Lnh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 07:43:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv5 11/12] media-ioc-enum-links.rst: improve pad index description
Date: Fri, 29 Jun 2018 13:43:30 +0200
Message-Id: <20180629114331.7617-12-hverkuil@xs4all.nl>
In-Reply-To: <20180629114331.7617-1-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Make it clearer that the index starts at 0, and that it won't change
since future new pads will be added at the end.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 Documentation/media/uapi/mediactl/media-ioc-enum-links.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index 17abdeed1a9c..4cceeb8a6f73 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -92,7 +92,9 @@ returned during the enumeration process.
 
     *  -  __u16
        -  ``index``
-       -  0-based pad index.
+       -  Pad index, starts at 0. Pad indices are stable. If new pads are added
+	  for an entity in the future, then those will be added at the end of the
+	  entity's pad array.
 
     *  -  __u32
        -  ``flags``
-- 
2.17.0
