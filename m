Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA53C67839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 233FA2084E
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 233FA2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbeLLMjG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 07:39:06 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:51249 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727360AbeLLMjG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 07:39:06 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id X3n3gidc5uDWoX3n6gHoWg; Wed, 12 Dec 2018 13:39:04 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv5 5/8] videodev2.h: add v4l2_timeval_to_ns inline function
Date:   Wed, 12 Dec 2018 13:38:58 +0100
Message-Id: <20181212123901.34109-6-hverkuil-cisco@xs4all.nl>
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
index 2db1635de956..3580c1ea4fba 100644
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
+static inline u64 v4l2_timeval_to_ns(const struct timeval *tv)
+{
+	return (__u64)tv->tv_sec * 1000000000ULL + tv->tv_usec * 1000;
+}
+
 /*  Flags for 'flags' field */
 /* Buffer is mapped (flag) */
 #define V4L2_BUF_FLAG_MAPPED			0x00000001
-- 
2.19.2

