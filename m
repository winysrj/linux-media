Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F54FC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 13:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD27220645
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 13:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfAGNMO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:12:14 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:54556 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730812AbfAGNEn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 08:04:43 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gUa5gGVcvBDyIgUa9gNvGq; Mon, 07 Jan 2019 14:04:41 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCHv2 0/3] vb2: add buf_out_validate callback
Date:   Mon,  7 Jan 2019 14:04:34 +0100
Message-Id: <20190107130437.23732-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDCmRx3XpwoRyhsCu+I6BOjpwOPbiD9WkNw+/WsSfupulCB+iENqYf43Ic7HhaXqJoItpo/ckeEkyBGiyKgpQtT3FPCMlCXFCJ3dPj9DKtgT/skZw9TP
 Acxfif5kN3yNE+peOl76pG5Gp6UfDcwD8Uv563RoJdixkJAuEnL4IkHIR7dEYN0yPDDTu1dc/eM3kuv6NaYnUS1SCmpeCgoGK9xceEGDnCJuK0AVI55uQOnS
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Adding the request API uncovered a pre-existing problem with
validating output buffers.

The problem is that for output buffers the driver has to validate
the 'field' field of struct v4l2_buffer. This is critical when
encoding or deinterlacing interlaced video.

Drivers always did this in the buf_prepare callback, but that is
not called from VIDIOC_QBUF in two situations: when queueing a
buffer to a request and if VIDIOC_PREPARE_BUF has been called
earlier for that buffer.

As a result of this the 'field' value is not validated.

While the first case (queueing a buffer to a request) is request
API specific, the second case (VIDIOC_PREPARE_BUF has been called
earlier for that buffer) was always wrong.

This patch series adds a new buf_out_validate callback to validate
the output buffer at QBUF time.

Note that PREPARE_BUF doesn't need to validate the field: it just
locks the buffer memory and doesn't need nor want to know about
how this buffer is actually going to be used. It's the QBUF ioctl
that determines this.

This issue was found by v4l2-compliance since vivid failed to replace
V4L2_FIELD_ANY by a proper field value when testing the vivid video
output in combination with requests.

There never was a test before for the PREPARE_BUF/QBUF case, so even
though this bug has been present for quite some time, it was never
noticed. This test has now been added to v4l2-compliance as well.

Regards,

	Hans

Changes since v1:

- Renamed buf_validate to buf_out_validate since this is output
  specific.
- Clarify in the commit log of the first patch that this isn't
  request API specific, but fixes a long standing problem that
  just wasn't noticed until now.

Hans Verkuil (3):
  vb2: add buf_out_validate callback
  vim2m: add buf_out_validate callback
  vivid: add buf_out_validate callback

 .../media/common/videobuf2/videobuf2-core.c   | 14 ++++++++---
 drivers/media/platform/vim2m.c                | 16 ++++++++++---
 drivers/media/platform/vivid/vivid-vid-out.c  | 23 +++++++++++++------
 include/media/videobuf2-core.h                |  5 ++++
 4 files changed, 45 insertions(+), 13 deletions(-)

-- 
2.19.2

