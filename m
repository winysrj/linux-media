Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43804 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941746AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 44/47] [media] dev-sliced-vbi.rst: fix reference for v4l2_mpeg_vbi_ITV0
Date: Thu,  8 Sep 2016 09:04:06 -0300
Message-Id: <0f824cfc1135f86a0da50c2803f47ad1d3b326d1.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct v4l2_mpeg_vbi_ITV0 is identical to struct v4l2_mpeg_vbi_itv0,
except by its size, and it is documented at the same place at the
book.

Fix cross reference for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index 7f159c3d4942..019cac7e90e4 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -672,8 +672,10 @@ Magic Constants for struct v4l2_mpeg_vbi_fmt_ivtv magic field
 
 .. c:type:: v4l2_mpeg_vbi_itv0
 
-struct v4l2_mpeg_vbi_itv0
--------------------------
+.. c:type:: v4l2_mpeg_vbi_ITV0
+
+structs v4l2_mpeg_vbi_itv0 and v4l2_mpeg_vbi_ITV0
+-------------------------------------------------
 
 .. tabularcolumns:: |p{4.4cm}|p{2.4cm}|p{10.7cm}|
 
-- 
2.7.4


