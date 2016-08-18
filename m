Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35643 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754321AbcHSDqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:46:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 11/20] [media] dev-overlay.rst: don't ident a note
Date: Thu, 18 Aug 2016 13:15:40 -0300
Message-Id: <4f52641358cc2b5c8c658e2cddd87e8f22b26b8f.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's one note there that it is indented for no good reason.
Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/dev-overlay.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/v4l/dev-overlay.rst b/Documentation/media/uapi/v4l/dev-overlay.rst
index d47a6bbc2e98..50e2d52fcae6 100644
--- a/Documentation/media/uapi/v4l/dev-overlay.rst
+++ b/Documentation/media/uapi/v4l/dev-overlay.rst
@@ -238,12 +238,12 @@ exceeded are undefined. [#f3]_
     :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`,
     :ref:`framebuffer-flags`).
 
-    .. note::
+.. note::
 
-       This field was added in Linux 2.6.23, extending the
-       structure. However the :ref:`VIDIOC_[G|S|TRY]_FMT <VIDIOC_G_FMT>`
-       ioctls, which take a pointer to a :ref:`v4l2_format <v4l2-format>`
-       parent structure with padding bytes at the end, are not affected.
+   This field was added in Linux 2.6.23, extending the
+   structure. However the :ref:`VIDIOC_[G|S|TRY]_FMT <VIDIOC_G_FMT>`
+   ioctls, which take a pointer to a :ref:`v4l2_format <v4l2-format>`
+   parent structure with padding bytes at the end, are not affected.
 
 
 .. _v4l2-clip:
-- 
2.7.4


