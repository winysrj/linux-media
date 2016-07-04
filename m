Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44879 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbcGDLrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 23/51] Documentation: planar-apis.rst: fix some conversion troubles
Date: Mon,  4 Jul 2016 08:46:44 -0300
Message-Id: <2ca68527e82542d258ed18518e2f744a6440b442.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a missing escape caracter, causing troubles at the
format of one of the paragraphs. Also, the ioctl description
was producing some warnings about wrong identation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/planar-apis.rst | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/planar-apis.rst b/Documentation/linux_tv/media/v4l/planar-apis.rst
index cf078650a0a8..db1e63bd691e 100644
--- a/Documentation/linux_tv/media/v4l/planar-apis.rst
+++ b/Documentation/linux_tv/media/v4l/planar-apis.rst
@@ -20,7 +20,7 @@ Some of the V4L2 API calls and structures are interpreted differently,
 depending on whether single- or multi-planar API is being used. An
 application can choose whether to use one or the other by passing a
 corresponding buffer type to its ioctl calls. Multi-planar versions of
-buffer types are suffixed with an `_MPLANE' string. For a list of
+buffer types are suffixed with an ``_MPLANE`` string. For a list of
 available multi-planar buffer types see enum
 :ref:`v4l2_buf_type <v4l2-buf-type>`.
 
@@ -39,29 +39,25 @@ handle multi-planar formats.
 Calls that distinguish between single and multi-planar APIs
 ===========================================================
 
-:ref:`VIDIOC_QUERYCAP`
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>`
     Two additional multi-planar capabilities are added. They can be set
     together with non-multi-planar ones for devices that handle both
     single- and multi-planar formats.
 
-:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`,
-:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`,
-:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`, :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`
     New structures for describing multi-planar formats are added: struct
     :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` and
     struct :ref:`v4l2_plane_pix_format <v4l2-plane-pix-format>`.
     Drivers may define new multi-planar formats, which have distinct
     FourCC codes from the existing single-planar ones.
 
-:ref:`VIDIOC_QBUF`,
-:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`,
-:ref:`VIDIOC_QUERYBUF`
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>`, :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`, :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>`
     A new struct :ref:`v4l2_plane <v4l2-plane>` structure for
     describing planes is added. Arrays of this structure are passed in
     the new ``m.planes`` field of struct
     :ref:`v4l2_buffer <v4l2-buffer>`.
 
-:ref:`VIDIOC_REQBUFS`
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`
     Will allocate multi-planar buffers as requested.
 
 
-- 
2.7.4


