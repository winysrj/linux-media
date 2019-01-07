Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77267C43444
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 523FD2089F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfAGLes (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:34:48 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:42990 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727003AbfAGLer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:34:47 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gTB4gFRVhBDyIgTB8gNVGb; Mon, 07 Jan 2019 12:34:46 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv6 4/8] buffer.rst: clean up timecode documentation
Date:   Mon,  7 Jan 2019 12:34:37 +0100
Message-Id: <20190107113441.21569-5-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
References: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfCjeMOvf+KPq2SN08QQfqMB40uPoMr67uJG9k85tQ3R4NRmBt5/LrAa+muRz7CHkIv4KbpVduYj/tu52c0iILKo7c6VG3tDuZgzuEb0an6OWKxmORBmo
 IsmMnd5Rc8M3Baxu9MRucDOaJQ4OenGr0qeHX10dTFs46ZxjpcyNqGVdNy3Ia2pPTy9BJ9fueZ8ugNWcrSGEjO8iR90ENaMEWSXMboH8OE5W6MMmb8uSQrMf
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
index c5013adaa44d..3a31f308f136 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -230,8 +230,7 @@ struct v4l2_buffer
     * - struct :c:type:`v4l2_timecode`
       - ``timecode``
       -
-      - When ``type`` is ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` and the
-	``V4L2_BUF_FLAG_TIMECODE`` flag is set in ``flags``, this
+      - When the ``V4L2_BUF_FLAG_TIMECODE`` flag is set in ``flags``, this
 	structure contains a frame timecode. In
 	:c:type:`V4L2_FIELD_ALTERNATE <v4l2_field>` mode the top and
 	bottom field contain the same timecode. Timecodes are intended to
@@ -711,10 +710,10 @@ enum v4l2_memory
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
2.19.2

