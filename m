Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049F8C282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 10:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA3C62081B
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 10:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfBDKLi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 05:11:38 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:42228 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbfBDKLi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 05:11:38 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id qbDyg7eyqNR5yqbDzgiMR6; Mon, 04 Feb 2019 11:11:36 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: [PATCHv2 0/3] Improve vb2_find_buffer
Date:   Mon,  4 Feb 2019 11:11:31 +0100
Message-Id: <20190204101134.56283-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfC1OsLAdqq3aBt0icglNKZhLnBKRD635orEa9uWyBL4AHKqi+8rwESeYlpema3gVNcboYst5RNf1xVZpax0YkIoBeEWd+3y9CN0OmGk0JX90vgZAhK7X
 3TwD3xRDqHJuYGkeK4b7B2f3dWWKohmaWNmz4vMCnmQW2j8zXsqFbr7B5Qn0HjCG6SAsCsqqKOz+u100ppE7yIstSRCf3KFwrYlP9GDgHfKhH8UXtCSAeUs3
 pT/QRon4zMQWVeYrUw3Cf0t/kBIbK7Wm7hM8qtxiBigPqlNMCYCYbyHN/OUMhDsKi2+4eANtKqtOEoR85IMrNTZFvL8PSTZEozkr4PX8TP0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

This supersedes my previous patch:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg144099.html

Rather than marking a timestamp of 0 as 'special', I add a bitfield
to keep track of the validity of the timestamp.

The last patch also adds extra checks to verify that the found buffer
matches what is expected w.r.t. the number of planes and the size of
the planes.

I still think vb2_find_timestamp should increase some refcount for
the buffer since it is possible that the application requeues the
found buffer with a different dmabuf fd, thus potentially freeing the
buffer memory while it is still being processed.

But to be honest, I'm not sure how that should be done.

Regards,

	Hans

Hans Verkuil (3):
  vb2: replace bool by bitfield in vb2_buffer
  vb2: keep track of timestamp status
  vb2: add 'match' arg to vb2_find_buffer()

 drivers/media/common/videobuf2/videobuf2-core.c  | 15 +++++++++------
 drivers/media/common/videobuf2/videobuf2-v4l2.c  | 16 +++++++++++++---
 drivers/media/v4l2-core/v4l2-mem2mem.c           |  1 +
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c    |  8 ++++----
 include/media/videobuf2-core.h                   |  7 +++++--
 include/media/videobuf2-v4l2.h                   |  3 ++-
 6 files changed, 34 insertions(+), 16 deletions(-)

-- 
2.20.1

