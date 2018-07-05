Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39237 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753495AbeGEQDn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 12:03:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv16 04/34] media: doc: Add media-request.h header to documentation build
Date: Thu,  5 Jul 2018 18:03:07 +0200
Message-Id: <20180705160337.54379-5-hverkuil@xs4all.nl>
In-Reply-To: <20180705160337.54379-1-hverkuil@xs4all.nl>
References: <20180705160337.54379-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

media-request.h has been recently added; add it to the documentation build
as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/kapi/mc-core.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index 0c05503eaf1f..69362b3135c2 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -262,3 +262,5 @@ in the end provide a way to use driver-specific callbacks.
 .. kernel-doc:: include/media/media-devnode.h
 
 .. kernel-doc:: include/media/media-entity.h
+
+.. kernel-doc:: include/media/media-request.h
-- 
2.18.0
