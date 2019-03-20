Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8360AC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A1602184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfCTMdK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 08:33:10 -0400
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:40204 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727914AbfCTMdI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 08:33:08 -0400
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 6aP3hd3OKeXb86aP4hCEUD; Wed, 20 Mar 2019 13:33:06 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Subject: [PATCH v5.1 0/2] add requires_requests bit for stateless codecs
Date:   Wed, 20 Mar 2019 13:33:03 +0100
Message-Id: <20190320123305.5224-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfFyHJoj8MpaET1Wn/JKYnvOayg0QoUYoWtmhrbXrn1YD4YU0dMveNnMc+HSxYEFu2C1YK53rOj8AxZ0wzAHXD6tAujhSRC3uoGgkoHLBsh9dw+n8NCSl
 XWkP4NNvMnF0Hdpw7qojx1J07Vx3sqHphRbDdfXYlwdFKoJTMqPsgcrkTmBQNtlXplDN3DbWMktLqg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

These two patches replace patches 1-3 of the vicodec v5 patch
series: https://www.spinics.net/lists/linux-media/msg147923.html

The original patch 2/23 (videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS)
was dropped. This needs a bit more thought.

Patch 1 now returns EBADR if an attempt is made to queue a buffer
without a request and requires_requests is set. This error code is
also documented.

Both patches have a better (hopefully) commit log.

The cedrus patch itself is unchanged from v5.

Regards,

	Hans

Hans Verkuil (2):
  vb2: add requires_requests bit for stateless codecs
  cedrus: set requires_requests

 Documentation/media/uapi/v4l/vidioc-qbuf.rst      | 4 ++++
 drivers/media/common/videobuf2/videobuf2-core.c   | 9 +++++++++
 drivers/media/common/videobuf2/videobuf2-v4l2.c   | 4 ++++
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 1 +
 include/media/videobuf2-core.h                    | 3 +++
 5 files changed, 21 insertions(+)

-- 
2.20.1

