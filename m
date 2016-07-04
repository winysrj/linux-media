Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44892 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbcGDLrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 20/51] Documentation: extended-controls.rst: use reference for VIDIOC_S_CTRL
Date: Mon,  4 Jul 2016 08:46:41 -0300
Message-Id: <627dd61695f8d2774fda689b4b42f94772362c05.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using a constant, use references, just like the
other references for ioctl's.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/extended-controls.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/extended-controls.rst b/Documentation/linux_tv/media/v4l/extended-controls.rst
index 38b85d7b1022..d5efb5bbf5bf 100644
--- a/Documentation/linux_tv/media/v4l/extended-controls.rst
+++ b/Documentation/linux_tv/media/v4l/extended-controls.rst
@@ -54,9 +54,9 @@ contains a pointer to the control array, a count of the number of
 controls in that array and a control class. Control classes are used to
 group similar controls into a single class. For example, control class
 ``V4L2_CTRL_CLASS_USER`` contains all user controls (i. e. all controls
-that can also be set using the old ``VIDIOC_S_CTRL`` ioctl). Control
-class ``V4L2_CTRL_CLASS_MPEG`` contains all controls relating to MPEG
-encoding, etc.
+that can also be set using the old :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>`
+ioctl). Control class ``V4L2_CTRL_CLASS_MPEG`` contains all controls
+relating to MPEG encoding, etc.
 
 All controls in the control array must belong to the specified control
 class. An error is returned if this is not the case.
-- 
2.7.4


