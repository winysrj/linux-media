Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:56700 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753072AbeGJIpP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:45:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv6 11/12] media-ioc-enum-links.rst: improve pad index description
Date: Tue, 10 Jul 2018 10:45:11 +0200
Message-Id: <20180710084512.99238-12-hverkuil@xs4all.nl>
In-Reply-To: <20180710084512.99238-1-hverkuil@xs4all.nl>
References: <20180710084512.99238-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Make it clearer that the index starts at 0, and that it won't change
since future new pads will never renumber existing pad indices.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 Documentation/media/uapi/mediactl/media-ioc-enum-links.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index 17abdeed1a9c..f5cd75b42b69 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -92,7 +92,9 @@ returned during the enumeration process.
 
     *  -  __u16
        -  ``index``
-       -  0-based pad index.
+       -  Pad index, starts at 0. Pad indices are stable. So if new pads are added
+	  for an entity in the future, then the indices of the existing pads will
+	  never be renumbered, they will remain the same.
 
     *  -  __u32
        -  ``flags``
-- 
2.18.0
