Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97A6C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89EC32082B
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89EC32082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbeLEKUs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:20:48 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:35333 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727491AbeLEKUs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 05:20:48 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id UUIKgznz1aOW5UUIQgJehf; Wed, 05 Dec 2018 11:20:47 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 01/10] videodev2.h: add tag support
Date:   Wed,  5 Dec 2018 11:20:31 +0100
Message-Id: <20181205102040.11741-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfG3mIdY9eUAC3AkQ/eMG8VEtMpbIDQ7PH0bCQimHkJPpmxn55UspX/xgNkNrKz3PlGEVDLEtVBPjULh3fPVihksOMrWPGClue40r5aJDgGozbcx77qni
 7Cb24q4jjsNTlGVr4d4dD9JciPx7fybVNtz6iI5nXxJmM4uUtfEyxAw3b4sMUt0iH551uVagb399UAQgwjN3cPRCLKMm9x38SEuiMVccI+o5Eo5P7k+9+H0n
 GwUV7eJbc3fO5ZkaM7ZidMwelFbNeS7ru4HASO4U9drOJFpRRdIjx29HUViGenooxUsn2lDtvgt20ueOfAoHEL7FkfM/3BI1OO4EReW6jk13Cj+KmBj9+Ny8
 GEIe8k9D7+kyqsgWBBtltymviq5VFQ4Z04eDe4Ji/PAQUlv7/op1uH/apkSU3xj0j/W6ZuQZVpG+Y7y8ftM1C9/PcLeU/Q==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Add support for 'tags' to struct v4l2_buffer. These can be used
by m2m devices so userspace can set a tag for an output buffer and
this value will then be copied to the capture buffer(s).

This tag can be used to refer to capture buffers, something that
is needed by stateless HW codecs.

The new V4L2_BUF_CAP_SUPPORTS_TAGS capability indicates whether
or not tags are supported.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 include/uapi/linux/videodev2.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2db1635de956..9095d7abe10d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -881,6 +881,7 @@ struct v4l2_requestbuffers {
 #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
 #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
 #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
+#define V4L2_BUF_CAP_SUPPORTS_TAGS	(1 << 5)
 
 /**
  * struct v4l2_plane - plane info for multi-planar buffers
@@ -940,6 +941,7 @@ struct v4l2_plane {
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
  *		buffers (when type != *_MPLANE); number of elements in the
  *		planes array for multi-plane buffers
+ * @tag:	buffer tag
  * @request_fd: fd of the request that this buffer should use
  *
  * Contains data exchanged by application and driver using one of the Streaming
@@ -964,7 +966,10 @@ struct v4l2_buffer {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	union {
+		__u32		reserved2;
+		__u32		tag;
+	};
 	union {
 		__s32		request_fd;
 		__u32		reserved;
@@ -990,6 +995,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_IN_REQUEST		0x00000080
 /* timecode field is valid */
 #define V4L2_BUF_FLAG_TIMECODE			0x00000100
+/* tag field is valid */
+#define V4L2_BUF_FLAG_TAG			0x00000200
 /* Buffer is prepared for queuing */
 #define V4L2_BUF_FLAG_PREPARED			0x00000400
 /* Cache handling flags */
-- 
2.19.1

