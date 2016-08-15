Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbcHOVXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 17:23:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH RFC v2 7/9] [media] vidioc-enumstd.rst: remove bullets from sound carrier
Date: Mon, 15 Aug 2016 18:21:58 -0300
Message-Id: <b10e340b3dcaa88fe07755e99278069df81b5bc0.1471294965.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471294965.git.mchehab@s-opensource.com>
References: <cover.1471294965.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1471294965.git.mchehab@s-opensource.com>
References: <cover.1471294965.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The items at the sound carrier had a bullet. Those are not needed.

So, get rid of them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-enumstd.rst | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index a936fe32ce9c..f61f0c6b0723 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -330,8 +330,7 @@ support digital TV. See also the Linux DVB API at
 
        -  4433618.75 ± 1
 
-       -  :cspan:`3` f\ :sub:`OR` = 4406250 ± 2000, f\ :sub:`OB` = 4250000
-	  ± 2000
+       -  :cspan:`3` f\ :sub:`OR` = 4406250 ± 2000, f\ :sub:`OB` = 4250000 ± 2000
 
     -  .. row 5
 
@@ -363,27 +362,27 @@ support digital TV. See also the Linux DVB API at
 
        -  Sound carrier relative to vision carrier (MHz)
 
-       -  + 4.5
+       -  4.5
 
-       -  + 4.5
+       -  4.5
 
-       -  + 4.5
+       -  4.5
 
-       -  + 5.5 ± 0.001  [#f4]_  [#f5]_  [#f6]_  [#f7]_
+       -  5.5 ± 0.001  [#f4]_  [#f5]_  [#f6]_  [#f7]_
 
-       -  + 6.5 ± 0.001
+       -  6.5 ± 0.001
 
-       -  + 5.5
+       -  5.5
 
-       -  + 5.9996 ± 0.0005
+       -  5.9996 ± 0.0005
 
-       -  + 5.5 ± 0.001
+       -  5.5 ± 0.001
 
-       -  + 6.5 ± 0.001
+       -  6.5 ± 0.001
 
-       -  + 6.5
+       -  6.5
 
-       -  + 6.5  [#f8]_
+       -  6.5 [#f8]_
 
 
 Return Value
-- 
2.7.4


