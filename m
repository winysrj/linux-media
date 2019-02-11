Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0FFC282DA
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08ED720838
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfBKKOF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:14:05 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:60941 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726259AbfBKKOE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:14:04 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id t8b7gs8zWRO5Zt8bCg3GoS; Mon, 11 Feb 2019 11:14:02 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna3@gmail.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 6/6] v4l2-ctrls: mark MPEG2 stateless controls as REQUIRES_REQUESTS
Date:   Mon, 11 Feb 2019 11:13:57 +0100
Message-Id: <20190211101357.48754-7-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
References: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfILXQ21QWdN518UubjzY7T0Hc9Ytel25nuxzv+aOnmKb0BccoT+pkCqto4R/Nb66sd0h08xYr6JhALpUkXpLKTxkq22Qg19gtdp2bictf4CL8WsJeQrr
 SuYQ73GdjoI2CrZYz2Od5Qqz+flbJWIZDuzFuYyZHYe1AUqIBpIe9p0kM+bGTDBx5e1zUF+wXqG6y1Nq9oYRs++s+HsrxNbgnDPtmbxnhBD95ep4rWa2bDWb
 T77R0tvedbHOYI6jr0KR/RgLQlown2l6KjTQO0qUNrqU3SA+0l0KcM808+xqQDnX8dG4s+vY+yZbMDmoNFCM5r2wyZwg2OLmHzgKd09gMu0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

These stateless codec controls can only be used in combination with
a request. So mark them as such.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 25f80f0eba69..7825c8d66498 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1299,9 +1299,11 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		break;
 	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS:
 		*type = V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS;
+		*flags |= V4L2_CTRL_FLAG_REQUIRES_REQUESTS;
 		break;
 	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:
 		*type = V4L2_CTRL_TYPE_MPEG2_QUANTIZATION;
+		*flags |= V4L2_CTRL_FLAG_REQUIRES_REQUESTS;
 		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
-- 
2.20.1

