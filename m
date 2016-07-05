Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbcGEBb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 24/41] Documentation: mmap.rst: re-add the missing captions
Date: Mon,  4 Jul 2016 22:30:59 -0300
Message-Id: <72c3fef52993e00d716df63035060b463431f23e.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion from DocBook removed them. Re-add.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/mmap.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/linux_tv/media/v4l/mmap.rst b/Documentation/linux_tv/media/v4l/mmap.rst
index 1ed17fa3368a..976bd2cf247b 100644
--- a/Documentation/linux_tv/media/v4l/mmap.rst
+++ b/Documentation/linux_tv/media/v4l/mmap.rst
@@ -54,6 +54,7 @@ possible with the :ref:`munmap() <func-munmap>` function.
 
 
 .. code-block:: c
+    :caption: Example 3.1. Mapping buffers in the single-planar API
 
     struct v4l2_requestbuffers reqbuf;
     struct {
@@ -122,6 +123,7 @@ possible with the :ref:`munmap() <func-munmap>` function.
 
 
 .. code-block:: c
+    :caption: Example 3.2. Mapping buffers in the multi-planar API
 
     struct v4l2_requestbuffers reqbuf;
     /* Our current format uses 3 planes per buffer */
-- 
2.7.4

