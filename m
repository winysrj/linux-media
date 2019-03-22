Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A68C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 07:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AD65218D3
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 07:37:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F4xoTm/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfCVHhw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 03:37:52 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41869 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfCVHhw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 03:37:52 -0400
Received: by mail-lf1-f66.google.com with SMTP id 10so691178lfr.8
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 00:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lElo5EN6awGyjMKAR5SKmr8/mQFR8gq0aQRuwBDnzSM=;
        b=F4xoTm/Pr2eAaSyUntFMI5hAjRl0SFeiOefuWTW5ifbK9kkJzPIY57ITMcWQ+S1m5Z
         66P+EFX880URAuKWgocUQGNBJu7Rm9qJ1XTL9xHGafWEeYK8COhoHSNqIoXwTfvtTd58
         RsWUke5vGm+JnlT5BxMUhDoAn1xucziN4sN6YsWYssF6BLlD7UaGDtb02UMWJC6dE7Tk
         Y4ZBXtOp450B+GaIT8WOw2ZeBeuzfhiB6NA+65yVIcU9vhu5Cu6zj/+JtQBuwXoSKVCq
         Lu2Xw6ppJm8VO8wNbv0ZNBRnD3AFNZ3IiZYk0w/BIy2QZpJnPVrC6frolcDhSAWlcfUs
         jgqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lElo5EN6awGyjMKAR5SKmr8/mQFR8gq0aQRuwBDnzSM=;
        b=KAzGzly6KXEAppO6uola54zRh2tA4OQ76/13jElWGqg4bHFrbFoB1Z2oQFUjmNXS0A
         afDqMHzKRScGUKfVvhgOplqPXdEqlNOGQPI5+ZbkGhkYnyY+pVz+D+q3MvP2vjTFbv6o
         RJ3MjgVYbh9DHvnAMfvoXw8iympazFVCG2VUYJBHaCAZOXrxolsG/yH74WMBBPrVBdcB
         R0LIk4zNWwcSN9Ilz9D76qXYwM++8JIR9llIZPXaqjYF18kOjSJqXQaI8JtMogwd3nrN
         2xNP9FPRVIsboGpY9Vjpn25EREqt2moJBtOX/n4SviqymRGFJ6KRmHhwUf+E0uf7BCYt
         k6xw==
X-Gm-Message-State: APjAAAXpOGvE3kS6aWxC/hBCgFWsqlr5wJQR6usko7dOzpWaMZRB1ILB
        iwWEeSlPtrR0U8ozLM2R+2M=
X-Google-Smtp-Source: APXvYqzOqcli2W9OLk4jKwHR9So5HOYvaxAwvncCjWhwJK6sBnfMivwviQrUZKE+tKUAnJAH3j9Xig==
X-Received: by 2002:ac2:5966:: with SMTP id h6mr1488467lfp.86.1553240270113;
        Fri, 22 Mar 2019 00:37:50 -0700 (PDT)
Received: from a2k-HP-ProDesk-600-G2-SFF.kyiv.epam.com (ll-74.141.223.85.sovam.net.ua. [85.223.141.74])
        by smtp.gmail.com with ESMTPSA id h1sm1372477ljb.87.2019.03.22.00.37.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 22 Mar 2019 00:37:49 -0700 (PDT)
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
To:     xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com, hverkuil@xs4all.nl
Cc:     Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [Xen-devel][PATCH v6 0/1] cameraif: add ABI for para-virtual camera
Date:   Fri, 22 Mar 2019 09:37:41 +0200
Message-Id: <20190322073742.14639-1-andr2000@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Hello!

At the moment Xen [1] already supports some virtual multimedia
features [2] such as virtual display, sound. It supports keyboards,
pointers and multi-touch devices all allowing Xen to be used in
automotive appliances, In-Vehicle Infotainment (IVI) systems
and many more.

Frontend implementation is available at [3] and the corresponding
backend at [4]. These are work in progress, but frontend already
passes v4l2-compliance test for V4L2 drivers. libxl preliminary
changes are available at [5].

This work adds a new Xen para-virtualized protocol for a virtual
camera device which extends multimedia capabilities of Xen even
farther: video conferencing, IVI, high definition maps etc.

The initial goal is to support most needed functionality with the
final idea to make it possible to extend the protocol if need be:

1. Provide means for base virtual device configuration:
 - pixel formats
 - resolutions
 - frame rates
2. Support basic camera controls:
 - contrast
 - brightness
 - hue
 - saturation
3. Support streaming control

I would like to thank Hans Verkuil <hverkuil@xs4all.nl> for valuable
comments and help.

Thank you,
Oleksandr Andrushchenko

Changes since v5:
=================

1. Minor cleanup of the XENCAMERA_OP_BUF_REQUEST description

Changes since v4:
=================

1. Removed unused XENCAMERA_EVT_CFG_FLG_RESOL flag
2. Re-worded a bit description for num_buffers

Changes since v3:
=================

1. Add trimming example for short FOURCC labels, e.g. Y16 and Y16-BE
2. Remove from XENCAMERA_OP_CONFIG_XXX requests colorspace, xfer_func,
   ycbcr_enc, quantization and move those into the corresponding response
3. Extend description of XENCAMERA_OP_BUF_REQUEST.num_bufs: limit to
   maximum buffers and num_bufs == 0 case
4. Extend decription of XENCAMERA_OP_BUF_CREATE.index and specify its
   range
5. Make XENCAMERA_EVT_FRAME_AVAIL.seq_num 32-bit instead of 64-bit

Changes since v2:
=================

1. Add "max-buffers" frontend configuration entry, e.g.
   the maximum number of camera buffers a frontend may use.
2. Add big-endian pixel-format support:
 - "formats" configuration string length changed from 4 to 7
   octets, so we can also manage BE pixel-formats
 - add corresponding comments to FOURCC mappings description
3. New commands added to the protocol and documented:
 - XENCAMERA_OP_CONFIG_VALIDATE
 - XENCAMERA_OP_FRAME_RATE_SET
 - XENCAMERA_OP_BUF_GET_LAYOUT
4.-Add defaults for colorspace, xfer, ycbcr_enc and quantization
5. Remove XENCAMERA_EVT_CONFIG_CHANGE event
6. Move plane offsets to XENCAMERA_OP_BUF_REQUEST as offsets
   required for the frontend might not be known at the configuration time
7. Clean up and address comments to v2 of the protocol

Changes since v1:
=================

1. Added XenStore entries:
 - frame-rates
2. Do not require the FOURCC code in XenStore to be upper case only
3. Added/changed command set:
 - configuration get/set
 - buffer queue/dequeue
 - control get
4. Added control flags, e.g. read-only etc.
5. Added colorspace configuration support, relevant constants
6. Added events:
 - configuration change
 - control change
7. Changed control values to 64-bit
8. Added sequence number to frame avail event
9. Coding style cleanup

[1] https://www.xenproject.org/
[2] https://xenbits.xen.org/gitweb/?p=xen.git;a=tree;f=xen/include/public/io
[3] https://github.com/andr2000/linux/tree/camera_front_v1/drivers/media/xen
[4] https://github.com/andr2000/camera_be
[5] https://github.com/andr2000/xen/tree/vcamera

Oleksandr Andrushchenko (1):
  cameraif: add ABI for para-virtual camera

 xen/include/public/io/cameraif.h | 1374 ++++++++++++++++++++++++++++++
 1 file changed, 1374 insertions(+)
 create mode 100644 xen/include/public/io/cameraif.h

-- 
2.21.0

