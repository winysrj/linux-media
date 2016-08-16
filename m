Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbcHPQrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:47:42 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/9] [media] vidioc-enumstd.rst: fix a broken reference
Date: Tue, 16 Aug 2016 13:47:30 -0300
Message-Id: <fa4a1e4446a74e688de38d9405d27c6a75e5c3e4.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Somehow, the conversion broke a reference here. Re-add it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-enumstd.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index 6699b26cdeb4..a936fe32ce9c 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -269,7 +269,7 @@ support digital TV. See also the Linux DVB API at
 
 .. _video-standards:
 
-.. flat-table:: Video Standards (based on [])
+.. flat-table:: Video Standards (based on :ref:`itu470`)
     :header-rows:  1
     :stub-columns: 0
 
-- 
2.7.4


