Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578FDC2F3A0
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E06420870
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfAUNck (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:32:40 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36095 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728810AbfAUNcg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 08:32:36 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lZgjgZ95MBDyIlZgogPCKA; Mon, 21 Jan 2019 14:32:35 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5/8] stkwebcam: use u64 for the timestamp internally
Date:   Mon, 21 Jan 2019 14:32:26 +0100
Message-Id: <20190121133229.33893-6-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
References: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHJdqdM1aTPcvwsYFeS1YIfWDZyUwcw8+6+3C10VZjMgiB1NYCQaaZdB3EM5Vks01ujzzVO1btt2s3w23lmHEvZiXmmR4ur0yUk1nVo0blSobiou3XUK
 4X86fdHlekNmBTfVQF/VZBqrKNguy8PocBz33ChDpjj9ULDfE6Kh0WSbK+LUFV+JnmoN0mqYOAajJQvsr13D6zS8BxF+nbUVUQWfps7v8JFqCl1rYGZGIEzL
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Just like vb2 does, use u64 internally to store the timestamps
of the buffers. Only convert to timeval when interfacing with
userspace.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/usb/stkwebcam/stk-webcam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index b8ec74d98e8d..03f5e12b13a5 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1144,7 +1144,7 @@ static int stk_vidioc_dqbuf(struct file *filp,
 	sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_QUEUED;
 	sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_DONE;
 	sbuf->v4lbuf.sequence = ++dev->sequence;
-	v4l2_get_timestamp(&sbuf->v4lbuf.timestamp);
+	sbuf->v4lbuf.timestamp = ns_to_timeval(ktime_get_ns());
 
 	*buf = sbuf->v4lbuf;
 	return 0;
-- 
2.20.1

