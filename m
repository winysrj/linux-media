Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbcGDLrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 21/51] Documentation: vidioc-queryctl.rst: change the title of this chapter
Date: Mon,  4 Jul 2016 08:46:42 -0300
Message-Id: <0627906e7141050290a0936b3920cbe8e8a1ca99.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This chapter is referenced on several parts of the extended
controls. Change the title to make it nicer where it is
referenced.

Ok, we might, instead, just change the name for the references
to only mention the oldest ioctl, but IMHO, it is better to
keep the name of all ioctls where it is referenced.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
index 7d38a51c4f73..2e93caeafe9e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
@@ -2,9 +2,9 @@
 
 .. _VIDIOC_QUERYCTRL:
 
-***************************************************************
-ioctl VIDIOC_QUERYCTRL, VIDIOC_QUERY_EXT_CTRL, VIDIOC_QUERYMENU
-***************************************************************
+*******************************************************************
+ioctls VIDIOC_QUERYCTRL, VIDIOC_QUERY_EXT_CTRL and VIDIOC_QUERYMENU
+*******************************************************************
 
 *man VIDIOC_QUERYCTRL(2)*
 
-- 
2.7.4


