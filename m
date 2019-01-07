Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F129C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE9372089F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfAGLeu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:34:50 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36126 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726953AbfAGLes (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:34:48 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gTB4gFRVhBDyIgTB9gNVHE; Mon, 07 Jan 2019 12:34:47 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv6 8/8] extended-controls.rst: update the mpeg2 compound controls
Date:   Mon,  7 Jan 2019 12:34:41 +0100
Message-Id: <20190107113441.21569-9-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
References: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfFZ3slH76hek523k12CG4IMVgfnuhXJzPsVwaalZnU9IUIg4yIFGNs+5I5A1jCtzW+wMuh0ZtJ1LIkoMIyEq2HUdMasXhrdNjiKw8P9Ee1Ci3rwdoKKL
 CfkWsxY7USwjiyr0N3LTIITyZwa4yicTiFk4/h9H5G205Jaue0U2SRqnZO9GvSymTIaO4RBLWAxlnkkkrpoVblkeRzT2ML1W/kISWhjlBYE9hjl3JfF3nIrp
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
index c471408d9bf9..78d042755322 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1546,17 +1546,23 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
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
 
@@ -1577,7 +1583,7 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
       - ``vbv_buffer_size``
       - Used to calculate the required size of the video buffering verifier,
 	defined (in bits) as: 16 * 1024 * vbv_buffer_size.
-    * - __u8
+    * - __u16
       - ``profile_and_level_indication``
       - The current profile and level indication as extracted from the
 	bitstream.
@@ -1635,7 +1641,7 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
     * - __u8
       - ``repeat_first_field``
       - This flag affects the decoding process of progressive frames.
-    * - __u8
+    * - __u16
       - ``progressive_frame``
       - Indicates whether the current frame is progressive.
 
-- 
2.19.2

