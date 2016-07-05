Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbcGEBb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 26/41] Documentation: userp.rst: re-add the missing captions
Date: Mon,  4 Jul 2016 22:31:01 -0300
Message-Id: <1727148fb56cd3a175a7b1599fe508ddd1991172.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion from DocBook removed them. Re-add.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/userp.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/linux_tv/media/v4l/userp.rst b/Documentation/linux_tv/media/v4l/userp.rst
index f372d39512a8..6db760d3d725 100644
--- a/Documentation/linux_tv/media/v4l/userp.rst
+++ b/Documentation/linux_tv/media/v4l/userp.rst
@@ -28,6 +28,7 @@ indexed and cannot be queried like mapped buffers with the
 
 
 .. code-block:: c
+    :caption: Example 3.3. Initiating streaming I/O with user pointers
 
     struct v4l2_requestbuffers reqbuf;
 
-- 
2.7.4

