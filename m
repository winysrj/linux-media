Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33664 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753140AbcHXNxq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 09:53:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        linux-doc@vger.kernel.org
Subject: [PATCH] [media] extended-controls.rst: fix a build warning
Date: Wed, 24 Aug 2016 10:52:55 -0300
Message-Id: <2ba775d0f643a070ff0820a3059572871d947e6a.1472046767.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

/devel/v4l/patchwork/Documentation/media/uapi/v4l/extended-controls.rst:2116: WARNING: Inline literal start-string without end-string.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 9c6aff3e97c1..1f1518e4859d 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -2112,8 +2112,8 @@ enum v4l2_mpeg_video_h264_sei_fp_arrangement_type -
 
 .. _v4l2-mpeg-video-h264-fmo-map-type:
 
-``V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE`` ````
-    (enum)
+``V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE``
+   (enum)
 
 enum v4l2_mpeg_video_h264_fmo_map_type -
     When using FMO, the map type divides the image in different scan
-- 
2.7.4

