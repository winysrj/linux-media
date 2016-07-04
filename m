Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbcGDLrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 27/51] Documentation: selection-api-006.rst: add missing captions
Date: Mon,  4 Jul 2016 08:46:48 -0300
Message-Id: <ca56797719bd1e8b0e535dc6afa1ac3fecc1ba02.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The example captions got stripped by the conversion to ReST.
Re-add.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/selection-api-006.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/linux_tv/media/v4l/selection-api-006.rst b/Documentation/linux_tv/media/v4l/selection-api-006.rst
index 61160b6be4f6..a7c04879cb5d 100644
--- a/Documentation/linux_tv/media/v4l/selection-api-006.rst
+++ b/Documentation/linux_tv/media/v4l/selection-api-006.rst
@@ -10,6 +10,7 @@ Examples
 
 
 .. code-block:: c
+	:caption: Example 1.15. Resetting the cropping parameters
 
         struct v4l2_selection sel = {
             .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
@@ -28,6 +29,7 @@ placed at a center of a display.
 
 
 .. code-block:: c
+   :caption: Example 1.16. Simple downscaling
 
         struct v4l2_selection sel = {
             .type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
@@ -55,6 +57,7 @@ for other devices
 
 
 .. code-block:: c
+   :caption: Example 1.17. Querying for scaling factors
 
         struct v4l2_selection compose = {
             .type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
-- 
2.7.4


