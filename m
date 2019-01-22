Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0D2C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 11:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3310E21019
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 11:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfAVL1g (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 06:27:36 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:53268 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727883AbfAVL1f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 06:27:35 -0500
Received: from cobaltpc1.rd.cisco.com ([IPv6:2001:420:44c1:2579:b98b:fd77:97a1:d7fe])
        by smtp-cloud8.xs4all.net with ESMTPA
        id luDHgEkLRNR5yluDMggn5Q; Tue, 22 Jan 2019 12:27:33 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 2/3] dev-teletext.rst: remove obsolete teletext interface
Date:   Tue, 22 Jan 2019 12:27:26 +0100
Message-Id: <20190122112727.12662-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl>
References: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfG5q6KP95KxXngEDXX5VMAl59mpvVfTx5XWQPoXPmeCM9sdfED7+4qWRlqMyaXdzK9RK6144e6ZolMGDNrX3Y+HpgSsk5asQF3unHrzFLlVqbculImga
 3SpYzyQe1FEMScdz7cZl6wBGxd7WKD0HLnPasXwOOhZGVo7DmTBeXkU5QCSUi5s5a18xALT2jTqUSPb1ANfAvnh7uEpDndUFEmROP/GHs07zPKpSfg0ROyne
 gJU3gwdlUxNQgfTpOSfbROiYsH3eNi0CGHapViCFaQYksClsi6KryvAoHViyUoEPAPW8re9RwlVK7OIZre+wN55YNQMRJiAXKGbOevD5FTbDvzVz5t8AkOGO
 8qmejmQ6DLvT9bm277gASxD+ERgVfg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The teletext interface has been dead for years now, just
remove it.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 Documentation/media/uapi/v4l/dev-teletext.rst | 41 -------------------
 Documentation/media/uapi/v4l/devices.rst      |  1 -
 2 files changed, 42 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/dev-teletext.rst

diff --git a/Documentation/media/uapi/v4l/dev-teletext.rst b/Documentation/media/uapi/v4l/dev-teletext.rst
deleted file mode 100644
index 35e8c4b35458..000000000000
--- a/Documentation/media/uapi/v4l/dev-teletext.rst
+++ /dev/null
@@ -1,41 +0,0 @@
-.. Permission is granted to copy, distribute and/or modify this
-.. document under the terms of the GNU Free Documentation License,
-.. Version 1.1 or any later version published by the Free Software
-.. Foundation, with no Invariant Sections, no Front-Cover Texts
-.. and no Back-Cover Texts. A copy of the license is included at
-.. Documentation/media/uapi/fdl-appendix.rst.
-..
-.. TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
-
-.. _ttx:
-
-******************
-Teletext Interface
-******************
-
-This interface was aimed at devices receiving and demodulating Teletext
-data [:ref:`ets300706`, :ref:`itu653`], evaluating the Teletext
-packages and storing formatted pages in cache memory. Such devices are
-usually implemented as microcontrollers with serial interface
-(I\ :sup:`2`\ C) and could be found on old TV cards, dedicated Teletext
-decoding cards and home-brew devices connected to the PC parallel port.
-
-The Teletext API was designed by Martin Buck. It was defined in the
-kernel header file ``linux/videotext.h``, the specification is available
-from
-`ftp://ftp.gwdg.de/pub/linux/misc/videotext/ <ftp://ftp.gwdg.de/pub/linux/misc/videotext/>`__.
-(Videotext is the name of the German public television Teletext
-service.)
-
-Eventually the Teletext API was integrated into the V4L API with
-character device file names ``/dev/vtx0`` to ``/dev/vtx31``, device
-major number 81, minor numbers 192 to 223.
-
-However, teletext decoders were quickly replaced by more generic VBI
-demodulators and those dedicated teletext decoders no longer exist. For
-many years the vtx devices were still around, even though nobody used
-them. So the decision was made to finally remove support for the
-Teletext API in kernel 2.6.37.
-
-Modern devices all use the :ref:`raw <raw-vbi>` or
-:ref:`sliced` VBI API.
diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
index c959c0443c2f..d6fcf3db5909 100644
--- a/Documentation/media/uapi/v4l/devices.rst
+++ b/Documentation/media/uapi/v4l/devices.rst
@@ -24,7 +24,6 @@ Interfaces
     dev-codec
     dev-raw-vbi
     dev-sliced-vbi
-    dev-teletext
     dev-radio
     dev-rds
     dev-sdr
-- 
2.20.1

