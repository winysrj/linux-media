Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbcGDLrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 36/51] Documentation: open.rst: fix some warnings
Date: Mon,  4 Jul 2016 08:46:57 -0300
Message-Id: <b00619a54c53ea739228c0339ab777902039f3f3.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those warnings:
	Documentation/linux_tv/media/v4l/open.rst:38: WARNING: Literal block ends without a blank line; unexpected unindent.
	Documentation/linux_tv/media/v4l/open.rst:45: WARNING: Literal block ends without a blank line; unexpected unindent.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/open.rst | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/open.rst b/Documentation/linux_tv/media/v4l/open.rst
index 963d2923aaa3..83f406957cf4 100644
--- a/Documentation/linux_tv/media/v4l/open.rst
+++ b/Documentation/linux_tv/media/v4l/open.rst
@@ -30,18 +30,16 @@ of leaving it to chance. When the driver supports multiple devices of
 the same type more than one device node number can be assigned,
 separated by commas:
 
+.. code-block:: none
 
+   # modprobe mydriver video_nr=0,1 radio_nr=0,1
 
-::
-
-    > modprobe mydriver video_nr=0,1 radio_nr=0,1
 In ``/etc/modules.conf`` this may be written as:
 
-
-
 ::
 
     options mydriver video_nr=0,1 radio_nr=0,1
+
 When no device node number is given as module option the driver supplies
 a default.
 
-- 
2.7.4


