Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:41954 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbaLEOUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 09:20:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.19 4/4] vivid.txt: document new controls
Date: Fri,  5 Dec 2014 15:19:24 +0100
Message-Id: <1417789164-28468-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl>
References: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new 'Y'CbCr Encoding' and 'Quantization' controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/vivid.txt | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/video4linux/vivid.txt b/Documentation/video4linux/vivid.txt
index e5a940e..6cfc854 100644
--- a/Documentation/video4linux/vivid.txt
+++ b/Documentation/video4linux/vivid.txt
@@ -640,6 +640,21 @@ Colorspace: selects which colorspace should be used when generating the image.
 	Changing the colorspace will result in the V4L2_EVENT_SOURCE_CHANGE
 	to be sent since it emulates a detected colorspace change.
 
+Y'CbCr Encoding: selects which Y'CbCr encoding should be used when generating
+	a Y'CbCr image.	This only applies if the CSC Colorbar test pattern is
+	selected, and if the format is set to a Y'CbCr format as opposed to an
+	RGB format.
+
+	Changing the Y'CbCr encoding will result in the V4L2_EVENT_SOURCE_CHANGE
+	to be sent since it emulates a detected colorspace change.
+
+Quantization: selects which quantization should be used for the RGB or Y'CbCr
+	encoding when generating the test pattern. This only applies if the CSC
+	Colorbar test pattern is selected.
+
+	Changing the quantization will result in the V4L2_EVENT_SOURCE_CHANGE
+	to be sent since it emulates a detected colorspace change.
+
 Limited RGB Range (16-235): selects if the RGB range of the HDMI source should
 	be limited or full range. This combines with the Digital Video 'Rx RGB
 	Quantization Range' control and can be used to test what happens if
-- 
2.1.3

