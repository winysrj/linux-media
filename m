Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:58348 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728998AbeGYOhr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 10:37:47 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.19] media-types.rst: codec entities can have more than
 one source pad
Message-ID: <50f8081f-e9cc-6bc5-2e21-53867cdedd87@xs4all.nl>
Date: Wed, 25 Jul 2018 15:26:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some decoders and encoders can potentially have more than one source pad,
so update the description to say 'at least one source pad'.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 7b17acc049cf..0e9adc7869b8 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -192,12 +192,13 @@ Types and flags used to represent the media graph elements

     *  -  ``MEDIA_ENT_F_PROC_VIDEO_ENCODER``
        -  Video (MPEG, HEVC, VPx, etc.) encoder. An entity capable of
-          compressing video frames. Must have one sink pad and one source pad.
+          compressing video frames. Must have one sink pad and at least
+	  one source pad.

     *  -  ``MEDIA_ENT_F_PROC_VIDEO_DECODER``
        -  Video (MPEG, HEVC, VPx, etc.) decoder. An entity capable of
           decompressing a compressed video stream into uncompressed video
-	  frames. Must have one sink pad and one source pad.
+	  frames. Must have one sink pad and at least one source pad.

     *  -  ``MEDIA_ENT_F_VID_MUX``
        - Video multiplexer. An entity capable of multiplexing must have at
