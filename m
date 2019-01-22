Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D60C282C5
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 11:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D005A20879
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 11:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfAVL1g (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 06:27:36 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:45740 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727919AbfAVL1f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 06:27:35 -0500
Received: from cobaltpc1.rd.cisco.com ([IPv6:2001:420:44c1:2579:b98b:fd77:97a1:d7fe])
        by smtp-cloud8.xs4all.net with ESMTPA
        id luDHgEkLRNR5yluDNggn5W; Tue, 22 Jan 2019 12:27:33 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 3/3] Documentation/media: rename "Codec Interface"
Date:   Tue, 22 Jan 2019 12:27:27 +0100
Message-Id: <20190122112727.12662-4-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl>
References: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfG5q6KP95KxXngEDXX5VMAl59mpvVfTx5XWQPoXPmeCM9sdfED7+4qWRlqMyaXdzK9RK6144e6ZolMGDNrX3Y+HpgSsk5asQF3unHrzFLlVqbculImga
 3SpYzyQe1FEMScdz7cZl6wBGxd7WKD0HLnPasXwOOhZGVo7DmTBeXkU5QCSUi5s5a18xALT2jTqUSPb1ANfAvnh7uEpDndUFEmROP/GHs07zPKpSfg0ROyne
 gJU3gwdlUxNQgfTpOSfbROiYsH3eNi0CGHapViCFaQYksClsi6KryvAoHViyUoEPAPW8re9RwlVK7OIZre+wN55YNQMRJiAXKGbOevD5FTbDvzVz5t8AkOGO
 8qmejmQ6DLvT9bm277gASxD+ERgVfg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The "Codec Interface" chapter is poorly named since codecs are just one
use-case of the Memory-to-Memory Interface. Rename it and clean up the
text a bit.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 .../media/uapi/mediactl/request-api.rst       |  4 ++--
 .../v4l/{dev-codec.rst => dev-mem2mem.rst}    | 21 +++++++------------
 Documentation/media/uapi/v4l/devices.rst      |  2 +-
 .../media/uapi/v4l/pixfmt-compressed.rst      |  2 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  2 +-
 5 files changed, 13 insertions(+), 18 deletions(-)
 rename Documentation/media/uapi/v4l/{dev-codec.rst => dev-mem2mem.rst} (79%)

diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
index 4b25ad03f45a..1ad631e549fe 100644
--- a/Documentation/media/uapi/mediactl/request-api.rst
+++ b/Documentation/media/uapi/mediactl/request-api.rst
@@ -91,7 +91,7 @@ A request must contain at least one buffer, otherwise ``ENOENT`` is returned.
 A queued request cannot be modified anymore.
 
 .. caution::
-   For :ref:`memory-to-memory devices <codec>` you can use requests only for
+   For :ref:`memory-to-memory devices <mem2mem>` you can use requests only for
    output buffers, not for capture buffers. Attempting to add a capture buffer
    to a request will result in an ``EACCES`` error.
 
@@ -152,7 +152,7 @@ if it had just been allocated.
 Example for a Codec Device
 --------------------------
 
-For use-cases such as :ref:`codecs <codec>`, the request API can be used
+For use-cases such as :ref:`codecs <mem2mem>`, the request API can be used
 to associate specific controls to
 be applied by the driver for the OUTPUT buffer, allowing user-space
 to queue many such buffers in advance. It can also take advantage of requests'
diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-mem2mem.rst
similarity index 79%
rename from Documentation/media/uapi/v4l/dev-codec.rst
rename to Documentation/media/uapi/v4l/dev-mem2mem.rst
index b5e017c17834..69efcc747588 100644
--- a/Documentation/media/uapi/v4l/dev-codec.rst
+++ b/Documentation/media/uapi/v4l/dev-mem2mem.rst
@@ -7,11 +7,11 @@
 ..
 .. TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
 
-.. _codec:
+.. _mem2mem:
 
-***************
-Codec Interface
-***************
+********************************
+Video Memory To Memory Interface
+********************************
 
 A V4L2 codec can compress, decompress, transform, or otherwise convert
 video data from one format into another format, in memory. Typically
@@ -25,19 +25,14 @@ memory) stream I/O. An application will have to setup the stream I/O for
 both sides and finally call :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
 for both capture and output to start the codec.
 
-Video compression codecs use the MPEG controls to setup their codec
-parameters
-
-.. note::
-
-   The MPEG controls actually support many more codecs than
-   just MPEG. See :ref:`mpeg-controls`.
+Video compression codecs use codec controls to setup their codec parameters.
+See :ref:`mpeg-controls`.
 
 Memory-to-memory devices function as a shared resource: you can
 open the video node multiple times, each application setting up their
-own codec properties that are local to the file handle, and each can use
+own properties that are local to the file handle, and each can use
 it independently from the others. The driver will arbitrate access to
-the codec and reprogram it whenever another file handler gets access.
+the hardware and reprogram it whenever another file handler gets access.
 This is different from the usual video node behavior where the video
 properties are global to the device (i.e. changing something through one
 file handle is visible through another file handle).
diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
index d6fcf3db5909..07f8d047662b 100644
--- a/Documentation/media/uapi/v4l/devices.rst
+++ b/Documentation/media/uapi/v4l/devices.rst
@@ -21,7 +21,7 @@ Interfaces
     dev-overlay
     dev-output
     dev-osd
-    dev-codec
+    dev-mem2mem
     dev-raw-vbi
     dev-sliced-vbi
     dev-radio
diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index e4c5e456df59..2675bef3eefe 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -73,7 +73,7 @@ Compressed Formats
       - 'MG2S'
       - MPEG-2 parsed slice data, as extracted from the MPEG-2 bitstream.
 	This format is adapted for stateless video decoders that implement a
-	MPEG-2 pipeline (using the :ref:`codec` and :ref:`media-request-api`).
+	MPEG-2 pipeline (using the :ref:`mem2mem` and :ref:`media-request-api`).
 	Metadata associated with the frame to decode is required to be passed
 	through the ``V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS`` control and
 	quantization matrices can optionally be specified through the
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 3259168a7358..c138d149faea 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -123,7 +123,7 @@ then ``EINVAL`` will be returned.
    :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or calling :ref:`VIDIOC_REQBUFS`
    the check for this will be reset.
 
-   For :ref:`memory-to-memory devices <codec>` you can specify the
+   For :ref:`memory-to-memory devices <mem2mem>` you can specify the
    ``request_fd`` only for output buffers, not for capture buffers. Attempting
    to specify this for a capture buffer will result in an ``EACCES`` error.
 
-- 
2.20.1

