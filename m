Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbcGDLrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 35/51] Documentation: vidioc-g-edid.rst remove a duplicate declaration
Date: Mon,  4 Jul 2016 08:46:56 -0300
Message-Id: <c778a451340694fc2a6bf7f86ee0d1dcccf03624.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ioctl is declared twice. This causes the following warning:
	/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst:7:

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
index b7d56ba0032a..26332ceb8b94 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
@@ -19,8 +19,6 @@ Synopsis
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_edid *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_edid *argp )
-
 Arguments
 =========
 
-- 
2.7.4


