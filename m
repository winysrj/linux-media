Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38210 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaLOVLj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 16:11:39 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: [PATCH 3/3] media-doc: Fix MFC display delay control doc
Date: Mon, 15 Dec 2014 16:10:59 -0500
Message-Id: <1418677859-31440-4-git-send-email-nicolas.dufresne@collabora.com>
In-Reply-To: <1418677859-31440-1-git-send-email-nicolas.dufresne@collabora.com>
References: <1418677859-31440-1-git-send-email-nicolas.dufresne@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE control
is a boolean but was documented as a integer. The documentation was
also slightly miss-leading.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index e013e4b..4e9462f 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2692,12 +2692,11 @@ in the S5P family of SoCs by Samsung.
 	      <row><entry></entry></row>
 	      <row>
 		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE</constant>&nbsp;</entry>
-		<entry>integer</entry>
-	      </row><row><entry spanname="descr">If the display delay is enabled then the decoder has to return a
-CAPTURE buffer after processing a certain number of OUTPUT buffers. If this number is low, then it may result in
-buffers not being dequeued in display order. In addition hardware may still use those buffers as reference, thus
-application should not write to those buffers. This feature can be used for example for generating thumbnails of videos.
-Applicable to the H264 decoder.
+		<entry>boolean</entry>
+	      </row><row><entry spanname="descr">If the display delay is enabled then the decoder is forced to return a
+CAPTURE buffer (decoded frame) after processing a certain number of OUTPUT buffers. The delay can be set through
+<constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY</constant>. This feature can be used for example
+for generating thumbnails of videos. Applicable to the H264 decoder.
 	      </entry>
 	      </row>
 	      <row><entry></entry></row>
-- 
2.1.0

