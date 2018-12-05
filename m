Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF19C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62680206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62680206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbeLEKUv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:20:51 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:55171 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726909AbeLEKUv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 05:20:51 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id UUIKgznz1aOW5UUISgJeiw; Wed, 05 Dec 2018 11:20:48 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 05/10] buffer.rst: clean up timecode documentation
Date:   Wed,  5 Dec 2018 11:20:35 +0100
Message-Id: <20181205102040.11741-6-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKI+hqaJArCk5zM7Bxic5lRQOtyIAXP+4YvHkyTK/PmIsza2iHo4UwfCZUp8Xk6KoF6T73y0rIKZzR17eKB5MgMkPYCoyIZA5qIM6U/m6ctruywdwH8x
 hIxblW1A4tYWTWEtDbkOHelC6om+Y8XF+jaxqJS9H6n5Nyy8gZXRqZBrMZTMOwO6f7E0Y4VLM+kmC/5/9c/3rU2ecMWo2wKfrYfPw9fOA6QE+u3pZLTzp7ZS
 GHNfvVy3E+U2U0deDjNJZ9lBIEefsU/KXrnVhpJjPFeNUA16Mb75j1HFU84ja3V9hiUeOXq77jEYwiY6rd4haqPDFvt/fCs+MjjN6C747AyHENW06ennG0+H
 WSRnC3lb7dOrVI300N0hlqK/vZ+PlsJNa9flJOQIYSRIW9thwP/sNlAblfD0jTfKrCSScYFvMNeFRT8SsSCowK/SipxCRA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

V4L2_BUF_FLAG_TIMECODE is not video capture specific, so drop that
part.

The 'Timecodes' section was a bit messy, so that's cleaned up.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 Documentation/media/uapi/v4l/buffer.rst | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index f83ee00cb30b..359b131a212d 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -223,8 +223,7 @@ struct v4l2_buffer
     * - struct :c:type:`v4l2_timecode`
       - ``timecode``
       -
-      - When ``type`` is ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` and the
-	``V4L2_BUF_FLAG_TIMECODE`` flag is set in ``flags``, this
+      - When the ``V4L2_BUF_FLAG_TIMECODE`` flag is set in ``flags``, this
 	structure contains a frame timecode. In
 	:c:type:`V4L2_FIELD_ALTERNATE <v4l2_field>` mode the top and
 	bottom field contain the same timecode. Timecodes are intended to
@@ -715,10 +714,10 @@ enum v4l2_memory
 Timecodes
 =========
 
-The struct :c:type:`v4l2_timecode` structure is designed to hold a
-:ref:`smpte12m` or similar timecode. (struct
-struct :c:type:`timeval` timestamps are stored in struct
-:c:type:`v4l2_buffer` field ``timestamp``.)
+The :c:type:`v4l2_buffer_timecode` structure is designed to hold a
+:ref:`smpte12m` or similar timecode.
+(struct :c:type:`timeval` timestamps are stored in the struct
+:c:type:`v4l2_buffer` ``timestamp`` field.)
 
 
 .. c:type:: v4l2_timecode
-- 
2.19.1

