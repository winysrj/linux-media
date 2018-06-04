Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:33458 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751933AbeFDLrA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 03/35] media: doc: Add media-request.h header to documentation build
Date: Mon,  4 Jun 2018 13:46:16 +0200
Message-Id: <20180604114648.26159-4-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
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
2.17.0
