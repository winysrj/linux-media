Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44805 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbcGDLrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 37/51] Documentation: rw.rst fix a warning
Date: Mon,  4 Jul 2016 08:46:58 -0300
Message-Id: <47e7192366dffeeac1522610f29210d1bb51a30f.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this Sphinx warning:
	Documentation/linux_tv/media/v4l/rw.rst:31: WARNING: Literal block ends without a blank line; unexpected unindent.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/rw.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/rw.rst b/Documentation/linux_tv/media/v4l/rw.rst
index c840ee0fd14c..beab37eccb1a 100644
--- a/Documentation/linux_tv/media/v4l/rw.rst
+++ b/Documentation/linux_tv/media/v4l/rw.rst
@@ -23,11 +23,11 @@ setup to exchange data. It permits command line stunts like this (the
 vidctrl tool is fictitious):
 
 
+.. code-block:: none
 
-::
+    $ vidctrl /dev/video --input=0 --format=YUYV --size=352x288
+    $ dd if=/dev/video of=myimage.422 bs=202752 count=1
 
-    > vidctrl /dev/video --input=0 --format=YUYV --size=352x288
-    > dd if=/dev/video of=myimage.422 bs=202752 count=1
 To read from the device applications use the :ref:`read() <func-read>`
 function, to write the :ref:`write() <func-write>` function. Drivers
 must implement one I/O method if they exchange data with applications,
-- 
2.7.4


