Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38626 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 29/41] Documentation: dmabuf.rst: re-add the missing captions
Date: Mon,  4 Jul 2016 22:31:04 -0300
Message-Id: <323f8893a2813c1ade9fa506cfb0abf3633c5e39.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion from DocBook removed them. Re-add.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/dmabuf.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/linux_tv/media/v4l/dmabuf.rst b/Documentation/linux_tv/media/v4l/dmabuf.rst
index 148e05e4c731..86cdc255e447 100644
--- a/Documentation/linux_tv/media/v4l/dmabuf.rst
+++ b/Documentation/linux_tv/media/v4l/dmabuf.rst
@@ -38,6 +38,7 @@ driver must be switched into DMABUF I/O mode by calling the
 
 
 .. code-block:: c
+    :caption: Example 3.4. Initiating streaming I/O with DMABUF file descriptors
 
     struct v4l2_requestbuffers reqbuf;
 
@@ -63,6 +64,7 @@ a different DMABUF descriptor at each ``VIDIOC_QBUF`` call.
 
 
 .. code-block:: c
+    :caption: Example 3.5. Queueing DMABUF using single plane API
 
     int buffer_queue(int v4lfd, int index, int dmafd)
     {
@@ -84,6 +86,7 @@ a different DMABUF descriptor at each ``VIDIOC_QBUF`` call.
 
 
 .. code-block:: c
+    :caption: Example 3.6. Queueing DMABUF using multi plane API
 
     int buffer_queue_mp(int v4lfd, int index, int dmafd[], int n_planes)
     {
-- 
2.7.4

