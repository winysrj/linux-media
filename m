Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED53DC282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 11:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB92321019
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 11:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfAVL1e (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 06:27:34 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:60499 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727777AbfAVL1e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 06:27:34 -0500
Received: from cobaltpc1.rd.cisco.com ([IPv6:2001:420:44c1:2579:b98b:fd77:97a1:d7fe])
        by smtp-cloud8.xs4all.net with ESMTPA
        id luDHgEkLRNR5yluDLggn53; Tue, 22 Jan 2019 12:27:32 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH 0/3] Documentation cleanups
Date:   Tue, 22 Jan 2019 12:27:24 +0100
Message-Id: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfK+BLhzTay+qM/EJVDBLM9OIozE9QYHLnYKt4RUAive1o3HB8/djI/0OwUVj/rRUwjzZMfWT5+N5HtODFONPSOW1qSrcw5fIc/iz7I/gtVz8LCpOwtlx
 IHIgOFWqmL7Jkt1Wy1qOJTob5MFRuZN2JNf2PgmKvQa3Adc5RVSTki4CLT16qZUDmh6/NOHtQdJyoqw47JXC7Mi5XeBG6kSIKHYPkEKZx8Jgk4YNAu6x9lWP
 BBWakjrzTUAGtZRKmB/hkCkjdZoQkslIBvbnEdDiVrFcCcnqy87c8TOx6d5S8KFZlJBb5QLz0m3B+nmiHC5WyZ4MPqpeEXOABNKw7RcJa8A=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Drop the obsolete Effect and Teletext interfaces. Rename the
Codec Interface to Video Memory To Memory Interface, which is
more accurate.

This also makes more sense when the detailed codec APIs are
added.

Regards,

	Hans

Hans Verkuil (3):
  dev-effect.rst: remove unused Effect Interface chapter
  dev-teletext.rst: remove obsolete teletext interface
  Documentation/media: rename "Codec Interface"

 .../media/uapi/mediactl/request-api.rst       |  4 +-
 Documentation/media/uapi/v4l/dev-effect.rst   | 28 -------------
 .../v4l/{dev-codec.rst => dev-mem2mem.rst}    | 21 ++++------
 Documentation/media/uapi/v4l/dev-teletext.rst | 41 -------------------
 Documentation/media/uapi/v4l/devices.rst      |  4 +-
 .../media/uapi/v4l/pixfmt-compressed.rst      |  2 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  2 +-
 7 files changed, 13 insertions(+), 89 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/dev-effect.rst
 rename Documentation/media/uapi/v4l/{dev-codec.rst => dev-mem2mem.rst} (79%)
 delete mode 100644 Documentation/media/uapi/v4l/dev-teletext.rst

-- 
2.20.1

