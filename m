Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbcGHTF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 15:05:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH] [media] doc-rst: mention the memory type to be set for all streaming I/O
Date: Fri,  8 Jul 2016 16:05:52 -0300
Message-Id: <071dedfead28ff4cd2d2faf56054ed1c46584ae1.1468004189.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset 8c9f46095176 ("[media] DocBook: mention the memory type to
be set for all streaming I/O") updated the media DocBook to mention
the need of filling the memory types. We need to keep the ReST
doc updated to such change.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/mmap.rst  | 4 ++--
 Documentation/media/uapi/v4l/userp.rst | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/mmap.rst b/Documentation/media/uapi/v4l/mmap.rst
index 2171b18c1aab..f7fe26e7ca43 100644
--- a/Documentation/media/uapi/v4l/mmap.rst
+++ b/Documentation/media/uapi/v4l/mmap.rst
@@ -11,8 +11,8 @@ Input and output devices support this I/O method when the
 :ref:`v4l2_capability <v4l2-capability>` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl is set. There are two
 streaming methods, to determine if the memory mapping flavor is
-supported applications must call the
-:ref:`VIDIOC_REQBUFS` ioctl.
+supported applications must call the :ref:`VIDIOC_REQBUFS` ioctl
+with the memory type set to ``V4L2_MEMORY_MMAP``.
 
 Streaming is an I/O method where only pointers to buffers are exchanged
 between application and driver, the data itself is not copied. Memory
diff --git a/Documentation/media/uapi/v4l/userp.rst b/Documentation/media/uapi/v4l/userp.rst
index 0ecf7a13a7af..2f0002bfbc3f 100644
--- a/Documentation/media/uapi/v4l/userp.rst
+++ b/Documentation/media/uapi/v4l/userp.rst
@@ -11,8 +11,8 @@ Input and output devices support this I/O method when the
 :ref:`v4l2_capability <v4l2-capability>` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl is set. If the
 particular user pointer method (not only memory mapping) is supported
-must be determined by calling the
-:ref:`VIDIOC_REQBUFS` ioctl.
+must be determined by calling the :ref:`VIDIOC_REQBUFS` ioctl
+with the memory type set to ``V4L2_MEMORY_USERPTR``.
 
 This I/O method combines advantages of the read/write and memory mapping
 methods. Buffers (planes) are allocated by the application itself, and
-- 
2.7.4

