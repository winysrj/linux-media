Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17080C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3E1C206C2
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391763AbfAPMBV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:01:21 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:35357 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732739AbfAPMBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 07:01:20 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:74b9:e8d0:a90b:6427])
        by smtp-cloud7.xs4all.net with ESMTPA
        id jjsjgM1cgBDyIjjskg25EF; Wed, 16 Jan 2019 13:01:18 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: [PATCHv4 0/5] vb2: add buf_out_validate callback
Date:   Wed, 16 Jan 2019 13:01:12 +0100
Message-Id: <20190116120117.115497-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfBj8lAB0oiU2KUkh3EW3EDB3KSZYkuyY+QTIamDtCj+ZAvkhTG2KB1Xvp/nnp1waQUxHrhHoSUODVOyzW/u0YuItTYVUZc9RvAiOCvigq6i18+DRjsbd
 fi5SthN7q0hxFo2l3/Hu4v7iQrI9LT6yTXbd3+HNlJbzaD432opb2xOEqOoU31iw+C6CWCIMwCj4xUdnbhMHmXFqwU+WC8wy0yeOIFGcQ7Bg5q6XzSTk7AhI
 /prHJetH/DnFI6s27uoroCNs8kURJctglfG8T1+D7ODR7twaU+jiLQ2aB88Lk6QI2pU/tWcCvsydKk1FPDg0xhft5YQiZTI3sfehrm3LOnA=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

When queueing a buffer to a request the 'field' value is not validated.
That field is only validated when the _buf_prepare() is called,
which happens when the request is queued.

However, this validation should happen at QBUF time, since you want
to know about this as soon as possible. Also, the spec requires that
the 'field' value is validated at QBUF time.

This patch adds a new buf_out_validate callback to validate the
output buffer at buf_prepare time or when QBUF queues an unprepared
buffer to a request. This callback is mandatory for output queues
that support requests.

This issue was found by v4l2-compliance since it failed to replace
V4L2_FIELD_ANY by a proper field value when testing the vivid video
output in combination with requests.

This patch series adds a new buf_out_validate callback and implements
it for the three drivers that support requests for output queues:
vivid, vim2m and cedrus.

The final patch adds a check that this new callback is implemented
for output queues supporting requests since it is easy to forget.

Regards,

	Hans

Changes since v3:

- Implement the callback for the cedrus driver, add check that the
  callback is implemented when it is required.
- Previous versions claimed that there was also a problem when
  requests are not in use, but that turned out to be wrong. This is
  request specific.
- Call the new callback as well when preparing a buffer.
- When calling it from qbuf, only call it when queueing an unprepared
  buffer to a request. This is the actual fix.

Changes since v2:

- drop test whether the queue is an output queue. This callback is only
  called for output queues, so this test is not needed anymore.

Changes since v1:

- Renamed buf_validate to buf_out_validate since this is output
  specific.
- Clarify in the commit log of the first patch that this isn't
  request API specific, but fixes a long standing problem that
  just wasn't noticed until now.

Hans Verkuil (5):
  vb2: add buf_out_validate callback
  vim2m: add buf_out_validate callback
  vivid: add buf_out_validate callback
  cedrus: add buf_out_validate callback
  vb2: check that buf_out_validate is present

 .../media/common/videobuf2/videobuf2-core.c   | 22 ++++++++++++---
 .../media/common/videobuf2/videobuf2-v4l2.c   |  7 +++++
 drivers/media/platform/vim2m.c                | 27 +++++++++++--------
 drivers/media/platform/vivid/vivid-vid-out.c  | 23 +++++++++++-----
 .../staging/media/sunxi/cedrus/cedrus_video.c |  9 +++++++
 include/media/videobuf2-core.h                |  5 ++++
 6 files changed, 72 insertions(+), 21 deletions(-)

-- 
2.20.1

