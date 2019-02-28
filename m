Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09404C43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 12:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D654F2083D
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 12:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731795AbfB1Mft (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 07:35:49 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:50874 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731389AbfB1Mft (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 07:35:49 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id zKuggBTbGLMwIzKuhgcTAF; Thu, 28 Feb 2019 13:35:47 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Subject: [PATCH 0/2] vb2: remove VB2_BUF_STATE_REQUEUEING
Date:   Thu, 28 Feb 2019 13:35:44 +0100
Message-Id: <20190228123546.76270-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfGDv3lcSAipOMnayQFgYMK638BjNGZdIQd+bZqjuP6AHmgsbUC3VOc9VrS5P5yDMoF2q/N2DOutNH3mN4VMPGA8spYfXmtg7hVr45lDuUipg8K7KU332
 YlpaY/kfvFMymu61xX1L6Sm8eRL/ScnJmYoFlSrOiroK49krdR1KxXcBSFWXSvHtvUAhimywX7NavLvOCdza+7lsquAkjY3+eXVG7YI9+YQQaFd11bO1tNk6
 WVMydlRJCCVWWs3NKOoGcw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The VB2_BUF_STATE_REQUEUEING leads to unordered behavior in vb2.
The only driver that used it was the cobalt driver, and replacing
VB2_BUF_STATE_REQUEUEING by VB2_BUF_STATE_ERROR is sufficient.

In addition, VB2_BUF_STATE_REQUEUEING can't be used with the Request
API, so removing support for this state altogether simplifies matters.

Regards,

	Hans

Hans Verkuil (2):
  cobalt: replace VB2_BUF_STATE_REQUEUEING by _ERROR
  vb2: drop VB2_BUF_STATE_REQUEUEING

 .../media/common/videobuf2/videobuf2-core.c   | 15 +++----------
 .../media/common/videobuf2/videobuf2-v4l2.c   |  1 -
 drivers/media/pci/cobalt/cobalt-irq.c         |  2 +-
 include/media/videobuf2-core.h                | 21 ++++++-------------
 4 files changed, 10 insertions(+), 29 deletions(-)

-- 
2.20.1

