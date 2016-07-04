Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbcGDLrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 06/51] Documentation: app-pri.rst: Fix a bad reference
Date: Mon,  4 Jul 2016 08:46:27 -0300
Message-Id: <3004c977622c24d9b7443346b41427fc06bbe8fa.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What should be a reference to VIDIOC_S_PRIORITY was incorrectly
defined as a constant at the DocBook. Fix it on the rst version.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/app-pri.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/app-pri.rst b/Documentation/linux_tv/media/v4l/app-pri.rst
index 9716437ae14d..7f034852ae1f 100644
--- a/Documentation/linux_tv/media/v4l/app-pri.rst
+++ b/Documentation/linux_tv/media/v4l/app-pri.rst
@@ -21,8 +21,8 @@ defines the :ref:`VIDIOC_G_PRIORITY <vidioc-g-priority>` and
 query the access priority associate with a file descriptor. Opening a
 device assigns a medium priority, compatible with earlier versions of
 V4L2 and drivers not supporting these ioctls. Applications requiring a
-different priority will usually call ``VIDIOC_S_PRIORITY`` after
-verifying the device with the
+different priority will usually call :ref:`VIDIOC_S_PRIORITY
+<vidioc-g-priority>` after verifying the device with the
 :ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl.
 
 Ioctls changing driver properties, such as
-- 
2.7.4


