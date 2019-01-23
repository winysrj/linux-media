Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC09AC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 08:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AC6321019
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 08:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfAWIH1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 03:07:27 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:57248 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726029AbfAWIH0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 03:07:26 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id mDZAg0bgyBDyImDZDgXqOW; Wed, 23 Jan 2019 09:07:24 +0100
Subject: [PATCHv2 3/3] Documentation/media: rename "Codec Interface"
To:     linux-media@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
References: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl>
 <20190122112727.12662-4-hverkuil-cisco@xs4all.nl>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <4792b823-6eb1-536b-08d6-5cad28bb2f24@xs4all.nl>
Date:   Wed, 23 Jan 2019 09:07:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190122112727.12662-4-hverkuil-cisco@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGEgyrKRuwPVukSW+Z9ii8APjsUyWS37ljml6vHxOI/OewytX/DSnMnFT6fPoAzZL1jYNfAfKKNvnyhkblJSCEouEnrPE7P+wLNnjpZvNs0sxjBmmMpo
 TwGDHbUQgeXsrztL+1G9+eBPzcp9AHKYGIU0YonRB45hAtY6vfJF94smZ6TRSWiHZZo7F97oKpCbJHyMgWXgA7dMWVnOTtXbbAKSLWjQ0Pdk9V/fbJhqRWmE
 rUvD4H1xRDSuABExFbXVHQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The "Codec Interface" chapter is poorly named since codecs are just one
use-case of the Memory-to-Memory Interface. Rename it and clean up the
text a bit.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
Incorporated Tomasz' comments.

Note that I moved the section about codec controls to the end. The idea
is that when we add the codec specs this section is updated and the
links to those specs is added there.
---
 .../media/uapi/mediactl/request-api.rst       |  4 +-
 .../v4l/{dev-codec.rst => dev-mem2mem.rst}    | 41 +++++++++----------
 Documentation/media/uapi/v4l/devices.rst      |  2 +-
 .../media/uapi/v4l/pixfmt-compressed.rst      |  2 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  2 +-
 5 files changed, 25 insertions(+), 26 deletions(-)
 rename Documentation/media/uapi/v4l/{dev-codec.rst => dev-mem2mem.rst} (50%)

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
similarity index 50%
rename from Documentation/media/uapi/v4l/dev-codec.rst
rename to Documentation/media/uapi/v4l/dev-mem2mem.rst
index b5e017c17834..67a980818dc8 100644
--- a/Documentation/media/uapi/v4l/dev-codec.rst
+++ b/Documentation/media/uapi/v4l/dev-mem2mem.rst
@@ -7,37 +7,36 @@
 ..
 .. TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections

-.. _codec:
+.. _mem2mem:

-***************
-Codec Interface
-***************
+********************************
+Video Memory-To-Memory Interface
+********************************

-A V4L2 codec can compress, decompress, transform, or otherwise convert
-video data from one format into another format, in memory. Typically
-such devices are memory-to-memory devices (i.e. devices with the
-``V4L2_CAP_VIDEO_M2M`` or ``V4L2_CAP_VIDEO_M2M_MPLANE`` capability set).
+A V4L2 memory-to-memory device can compress, decompress, transform, or
+otherwise convert video data from one format into another format, in memory.
+Such memory-to-memory devices set the ``V4L2_CAP_VIDEO_M2M`` or
+``V4L2_CAP_VIDEO_M2M_MPLANE`` capability. Examples of memory-to-memory
+devices are codecs, scalers, deinterlacers or format converters (i.e.
+converting from YUV to RGB).

 A memory-to-memory video node acts just like a normal video node, but it
-supports both output (sending frames from memory to the codec hardware)
-and capture (receiving the processed frames from the codec hardware into
+supports both output (sending frames from memory to the hardware)
+and capture (receiving the processed frames from the hardware into
 memory) stream I/O. An application will have to setup the stream I/O for
 both sides and finally call :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
-for both capture and output to start the codec.
-
-Video compression codecs use the MPEG controls to setup their codec
-parameters
-
-.. note::
-
-   The MPEG controls actually support many more codecs than
-   just MPEG. See :ref:`mpeg-controls`.
+for both capture and output to start the hardware.

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
+
+One of the most common memory-to-memory device is the codec. Codecs
+are more complicated than most and require additional setup for
+their codec parameters. This is done through codec controls.
+See :ref:`mpeg-controls`.
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


