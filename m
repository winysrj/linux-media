Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF3DC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDC09206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDC09206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbeLEKUu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:20:50 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:35963 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727491AbeLEKUu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 05:20:50 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id UUIKgznz1aOW5UUISgJeib; Wed, 05 Dec 2018 11:20:48 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 04/10] buffer.rst: document the new buffer tag feature.
Date:   Wed,  5 Dec 2018 11:20:34 +0100
Message-Id: <20181205102040.11741-5-hverkuil-cisco@xs4all.nl>
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

Document V4L2_BUF_FLAG_TAG.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 Documentation/media/uapi/v4l/buffer.rst         | 17 ++++++++++++++---
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst |  4 ++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 2e266d32470a..f83ee00cb30b 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -301,10 +301,13 @@ struct v4l2_buffer
 	elements in the ``planes`` array. The driver will fill in the
 	actual number of valid elements in that array.
     * - __u32
-      - ``reserved2``
+      - ``tag``
       -
-      - A place holder for future extensions. Drivers and applications
-	must set this to 0.
+      - When the ``V4L2_BUF_FLAG_TAG`` flag is set in ``flags``, this
+	field contains a user-specified tag value.
+
+	It is used by stateless codecs where this tag can be used to
+	refer to buffers that contain reference frames.
     * - __u32
       - ``request_fd``
       -
@@ -567,6 +570,14 @@ Buffer Flags
 	when the ``VIDIOC_DQBUF`` ioctl is called. Applications can set
 	this bit and the corresponding ``timecode`` structure when
 	``type`` refers to an output stream.
+    * .. _`V4L2-BUF-FLAG-TAG`:
+
+      - ``V4L2_BUF_FLAG_TAG``
+      - 0x00000200
+      - The ``tag`` field is valid. Applications can set
+	this bit and the corresponding ``tag`` field. If tags are
+	supported then the ``V4L2_BUF_CAP_SUPPORTS_TAGS`` capability
+	is also set.
     * .. _`V4L2-BUF-FLAG-PREPARED`:
 
       - ``V4L2_BUF_FLAG_PREPARED``
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index e62a15782790..38a7d0aee483 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -118,6 +118,7 @@ aborting or finishing any DMA in progress, an implicit
 .. _V4L2-BUF-CAP-SUPPORTS-DMABUF:
 .. _V4L2-BUF-CAP-SUPPORTS-REQUESTS:
 .. _V4L2-BUF-CAP-SUPPORTS-ORPHANED-BUFS:
+.. _V4L2-BUF-CAP-SUPPORTS-TAGS:
 
 .. cssclass:: longtable
 
@@ -143,6 +144,9 @@ aborting or finishing any DMA in progress, an implicit
       - The kernel allows calling :ref:`VIDIOC_REQBUFS` while buffers are still
         mapped or exported via DMABUF. These orphaned buffers will be freed
         when they are unmapped or when the exported DMABUF fds are closed.
+    * - ``V4L2_BUF_CAP_SUPPORTS_TAGS``
+      - 0x00000020
+      - This buffer type supports ``V4L2_BUF_FLAG_TAG``.
 
 Return Value
 ============
-- 
2.19.1

