Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81982C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C69721736
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfAGLeu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:34:50 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:37028 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727022AbfAGLes (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:34:48 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gTB4gFRVhBDyIgTB8gNVGn; Mon, 07 Jan 2019 12:34:46 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv6 5/8] videodev2.h: add v4l2_timeval_to_ns inline function
Date:   Mon,  7 Jan 2019 12:34:38 +0100
Message-Id: <20190107113441.21569-6-hverkuil-cisco@xs4all.nl>
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

We want to be able to uniquely identify buffers for stateless
codecs. The internal timestamp (a u64) as stored internally in the
kernel is a suitable candidate for that, but in struct v4l2_buffer
it is represented as a struct timeval.

Add a v4l2_timeval_to_ns() function that converts the struct timeval
into a u64 in the same way that the kernel does. This makes it possible
to use this u64 elsewhere as a unique identifier of the buffer.

Since timestamps are also copied from the output buffer to the
corresponding capture buffer(s) by M2M devices, the u64 can be
used to refer to both output and capture buffers.

The plan is that in the future we redesign struct v4l2_buffer and use
u64 for the timestamp instead of a struct timeval (which has lots of
problems with 32 vs 64 bit and y2038 layout changes), and then there
is no more need to use this function.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 include/uapi/linux/videodev2.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index d2e8b756e04d..c7da9af13543 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -971,6 +971,18 @@ struct v4l2_buffer {
 	};
 };
 
+/**
+ * v4l2_timeval_to_ns - Convert timeval to nanoseconds
+ * @ts:		pointer to the timeval variable to be converted
+ *
+ * Returns the scalar nanosecond representation of the timeval
+ * parameter.
+ */
+static inline __u64 v4l2_timeval_to_ns(const struct timeval *tv)
+{
+	return (__u64)tv->tv_sec * 1000000000ULL + tv->tv_usec * 1000;
+}
+
 /*  Flags for 'flags' field */
 /* Buffer is mapped (flag) */
 #define V4L2_BUF_FLAG_MAPPED			0x00000001
-- 
2.19.2

