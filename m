Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB78C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33E1D2084E
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33E1D2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbeLLMjH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 07:39:07 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:45072 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727427AbeLLMjG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 07:39:06 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id X3n3gidc5uDWoX3n6gHoXZ; Wed, 12 Dec 2018 13:39:04 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv5 8/8] extended-controls.rst: update the mpeg2 compound controls
Date:   Wed, 12 Dec 2018 13:39:01 +0100
Message-Id: <20181212123901.34109-9-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDHd6ERTK7RM32mc/MX3BgW/wGw99H95hHfgKIRdh3CyUZZovlctbVhEYqH7W2vjqq7A32lp9ID7ZyLat76rU2FrjlMNCfqCnh+kJMKTiQeb1PVI7zxb
 zCjex5ZMBOIRzEk5cOr33huvyXZNtxNxQKETKmFhfYyypwSd6iHPPjr24HSEkeFh5ez2HHbifQuMLB8GBWouJ6nS0ID757dnDHN9G4rcsx9vAI8HahNMuXaM
 WAzGSqjB/qWw/P8pS4Re8djKKqKJkeajEqwU09haqaFijTb9/vqz1kg8nZMigom+hV1mEtfgjLZfYHp/HmkimZl1ED9XFbdzNAb14x5Zyf7A8XhtQjFby1CV
 JxmtVLaN5pTNu4NN0yzNGR1UouOM0TgvfA5OD4DcuFFk+A0mIDOXQAH4gnFo/oK/gUKvSUqQdlvP1jTjrN7MaNiara5XVZVTC1T3bjlwBiFHEZG49yc=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The layout of the compound controls has changed to fix
32/64 bit alignment issues and the use of timestamps instead of
buffer indices to refer to buffers.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 .../media/uapi/v4l/extended-controls.rst      | 28 +++++++++++--------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 0b302413ab3a..cc986002bfc9 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1541,17 +1541,23 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
       - ``picture``
       - Structure with MPEG-2 picture metadata, merging relevant fields from
 	the picture header and picture coding extension parts of the bitstream.
-    * - __u8
+    * - __u64
+      - ``backward_ref_ts``
+      - Timestamp of the V4L2 capture buffer to use as backward reference, used
+        with B-coded and P-coded frames. The timestamp refers to the
+	``timestamp`` field in struct :c:type:`v4l2_buffer`. Use the
+	:c:func:`v4l2_timeval_to_ns()` function to convert the struct
+	:c:type:`timeval` in struct :c:type:`v4l2_buffer` to a __u64.
+    * - __u64
+      - ``forward_ref_ts``
+      - Timestamp for the V4L2 capture buffer to use as forward reference, used
+        with B-coded frames. The timestamp refers to the ``timestamp`` field in
+	struct :c:type:`v4l2_buffer`. Use the :c:func:`v4l2_timeval_to_ns()`
+	function to convert the struct :c:type:`timeval` in struct
+	:c:type:`v4l2_buffer` to a __u64.
+    * - __u32
       - ``quantiser_scale_code``
       - Code used to determine the quantization scale to use for the IDCT.
-    * - __u8
-      - ``backward_ref_index``
-      - Index for the V4L2 buffer to use as backward reference, used with
-	B-coded and P-coded frames.
-    * - __u8
-      - ``forward_ref_index``
-      - Index for the V4L2 buffer to use as forward reference, used with
-	B-coded frames.
 
 .. c:type:: v4l2_mpeg2_sequence
 
@@ -1572,7 +1578,7 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
       - ``vbv_buffer_size``
       - Used to calculate the required size of the video buffering verifier,
 	defined (in bits) as: 16 * 1024 * vbv_buffer_size.
-    * - __u8
+    * - __u16
       - ``profile_and_level_indication``
       - The current profile and level indication as extracted from the
 	bitstream.
@@ -1630,7 +1636,7 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
     * - __u8
       - ``repeat_first_field``
       - This flag affects the decoding process of progressive frames.
-    * - __u8
+    * - __u16
       - ``progressive_frame``
       - Indicates whether the current frame is progressive.
 
-- 
2.19.2

