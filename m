Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B34E1C282C4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 11:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BCE420879
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 11:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfAVL1e (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 06:27:34 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:35442 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727825AbfAVL1e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 06:27:34 -0500
Received: from cobaltpc1.rd.cisco.com ([IPv6:2001:420:44c1:2579:b98b:fd77:97a1:d7fe])
        by smtp-cloud8.xs4all.net with ESMTPA
        id luDHgEkLRNR5yluDMggn5J; Tue, 22 Jan 2019 12:27:32 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 1/3] dev-effect.rst: remove unused Effect Interface chapter
Date:   Tue, 22 Jan 2019 12:27:25 +0100
Message-Id: <20190122112727.12662-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl>
References: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfK+BLhzTay+qM/EJVDBLM9OIozE9QYHLnYKt4RUAive1o3HB8/djI/0OwUVj/rRUwjzZMfWT5+N5HtODFONPSOW1qSrcw5fIc/iz7I/gtVz8LCpOwtlx
 IHIgOFWqmL7Jkt1Wy1qOJTob5MFRuZN2JNf2PgmKvQa3Adc5RVSTki4CLT16qZUDmh6/NOHtQdJyoqw47JXC7Mi5XeBG6kSIKHZAxt4xA4mWXJWyS1xJgLK9
 Ozkethwcd0FypCOOIq3BDq8yl6SmZJwggrXvt3W9c4CeMbtX76JxwUXTX7qopIFuElynXBy1KaQwRkernaS/jb1p0DEUgpmJ0MNS8FaHiSshPOh5MFeu2SCU
 iGs/DMHYj1t2Jk3zg94sk5tSu9V8cQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

We never had an effect interface, and if you want to do such
things you use the mem2mem interface instead.

Just drop this from the spec.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 Documentation/media/uapi/v4l/dev-effect.rst | 28 ---------------------
 Documentation/media/uapi/v4l/devices.rst    |  1 -
 2 files changed, 29 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/dev-effect.rst

diff --git a/Documentation/media/uapi/v4l/dev-effect.rst b/Documentation/media/uapi/v4l/dev-effect.rst
deleted file mode 100644
index b165e2c20910..000000000000
--- a/Documentation/media/uapi/v4l/dev-effect.rst
+++ /dev/null
@@ -1,28 +0,0 @@
-.. Permission is granted to copy, distribute and/or modify this
-.. document under the terms of the GNU Free Documentation License,
-.. Version 1.1 or any later version published by the Free Software
-.. Foundation, with no Invariant Sections, no Front-Cover Texts
-.. and no Back-Cover Texts. A copy of the license is included at
-.. Documentation/media/uapi/fdl-appendix.rst.
-..
-.. TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
-
-.. _effect:
-
-************************
-Effect Devices Interface
-************************
-
-.. note::
-    This interface has been be suspended from the V4L2 API.
-    The implementation for such effects should be done
-    via mem2mem devices.
-
-A V4L2 video effect device can do image effects, filtering, or combine
-two or more images or image streams. For example video transitions or
-wipes. Applications send data to be processed and receive the result
-data either with :ref:`read() <func-read>` and
-:ref:`write() <func-write>` functions, or through the streaming I/O
-mechanism.
-
-[to do]
diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
index 5dbe9d13b6e6..c959c0443c2f 100644
--- a/Documentation/media/uapi/v4l/devices.rst
+++ b/Documentation/media/uapi/v4l/devices.rst
@@ -22,7 +22,6 @@ Interfaces
     dev-output
     dev-osd
     dev-codec
-    dev-effect
     dev-raw-vbi
     dev-sliced-vbi
     dev-teletext
-- 
2.20.1

