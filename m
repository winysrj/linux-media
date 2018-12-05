Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E78C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2780920661
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:33:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2780920661
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbeLEKd6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:33:58 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:42703 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbeLEKd6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 05:33:58 -0500
Received: from [IPv6:2001:420:44c1:2579:69e7:fb8a:bb15:8970] ([IPv6:2001:420:44c1:2579:69e7:fb8a:bb15:8970])
        by smtp-cloud7.xs4all.net with ESMTPA
        id UUV6gzuVGaOW5UUV9gJiuF; Wed, 05 Dec 2018 11:33:56 +0100
Subject: [PATCHv4 11/10] extended-controls.rst: update the mpeg2 compound
 controls
To:     hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
 <20181205102040.11741-11-hverkuil-cisco@xs4all.nl>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <87840d0c-15a8-21f3-7c9c-a46e6b548bad@xs4all.nl>
Date:   Wed, 5 Dec 2018 11:33:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181205102040.11741-11-hverkuil-cisco@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBhHr1WfLDWZH8npsrXoeu2SfrtstB6cveivOfbddfl0cXbokKyeE6wb3VR3cnkm/YBV3yOSMCelcO5s2M1LH7qOSupHPrd0LsRXvS/HXDR6G3MVsoRi
 n9okNJk9ug8Y4ouDw2EqWqyQZZrNxU1SDxU2ixTtvOHYLuDDfKkyS5WVLIySov72SS9/cBu3Cm1jQiTRuiry+adc0VQMtzYyHIDqwj1j48ExAbFweJn6KGhw
 OxKmlQ5nTrdiCa9LoJTsVOufJy5s/mU9d/9Wd8MrKQ4x3EzNlCITiH8W/XAGEQuAxSvzfkUV9l2CcT5dd1vooSwb2jdcAnM2G98AffzdAyuoz//W1DpnnOWE
 V056zu9//pvWamRuj4i8s7FYpJEhvMJutnmAoXy9+u+kK1IGKoV0ooqK9Y4RzS0vOQwidj+/eupX2dGmDpBGOHMNF+EqyFP+OxWeC2E4KeV2cVqtV2AnBkAU
 TxwwioZ0s3XMpLUc2E85E8cw/L+0MhbAI7BSI57A/kqsaBAc5/NwpQtApOXt86AuM1CsIK9iAPjV1zaN
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The layout of the compound controls has changed to fix
32/64 bit alignment issues and the use of tags instead of
buffer indices to refer to buffers. Note that these controls
are only used by the cedrus staging driver.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 .../media/uapi/v4l/extended-controls.rst      | 24 ++++++++++---------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 65a1d873196b..b9e3af29a704 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1528,17 +1528,19 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
       - ``picture``
       - Structure with MPEG-2 picture metadata, merging relevant fields from
 	the picture header and picture coding extension parts of the bitstream.
-    * - __u8
+    * - __u32
+      - ``backward_ref_tag``
+      - Tag for the V4L2 buffer to use as backward reference, used with
+	B-coded and P-coded frames. The tag refers to the ``tag`` field in
+	struct :c:type:`v4l2_buffer`.
+    * - __u32
+      - ``forward_ref_tag``
+      - Tag for the V4L2 buffer to use as forward reference, used with
+	B-coded frames. The tag refers to the ``tag`` field in
+	struct :c:type:`v4l2_buffer`.
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

@@ -1559,7 +1561,7 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
       - ``vbv_buffer_size``
       - Used to calculate the required size of the video buffering verifier,
 	defined (in bits) as: 16 * 1024 * vbv_buffer_size.
-    * - __u8
+    * - __u16
       - ``profile_and_level_indication``
       - The current profile and level indication as extracted from the
 	bitstream.
@@ -1617,7 +1619,7 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
     * - __u8
       - ``repeat_first_field``
       - This flag affects the decoding process of progressive frames.
-    * - __u8
+    * - __u16
       - ``progressive_frame``
       - Indicates whether the current frame is progressive.

-- 
2.19.1


