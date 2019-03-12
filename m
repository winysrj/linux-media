Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1DFC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 175C7214AE
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DIbGbrk3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfCLIUK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:20:10 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:46663 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbfCLIUJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 04:20:09 -0400
Received: by mail-lj1-f178.google.com with SMTP id v16so1426295ljg.13
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 01:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pgpjvB7aemyMyL+ZZdmxaUDyF2aUpwJ6JN02CMH/IH4=;
        b=DIbGbrk3Se7h+pdcOZxRnuTLU0ly8iHWF8wfNuoVQF5/KtMxD8rCX8+yeRRQpLZ59y
         2j0SshBVPCH6mNjdD0wMGZ7sTeUZm8oL1glYqFdpF5eyXhOVJDRxtt2jUPDUsIJmXYAu
         vwQr8WxMGkXefKyu7pO2jLqCs/29DmhF2Czi5p/DddG//e7WRwsw/EY6wkQgoa6LzDF3
         WzpSwl/czrnkPBPfB5UFgyAl4TWSpIcRGyR2dS/IxGo3cotDzpIhkA4oRd/KZpysc+3h
         UqOfrABmCcfV6n3tPfAraqGlm2bD2skrILbB011VQICkNE9utLptvbh6iZNW9JXGir9E
         rKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pgpjvB7aemyMyL+ZZdmxaUDyF2aUpwJ6JN02CMH/IH4=;
        b=OIQw+fTp4egelRfZJthkLukNkFehGKvDAv8b0GqMPE0PKmMX2qCH491mRZ4hTLyHvQ
         bcI7AYEAwihzHQEDr2jPv0a/e3ZDtYi7GQDEEQQVSWgqDMyyWfxJ81d/KHV+/T17OW1s
         TTElvDLT0/Jg3ecU3H+2y6Of0ZoaDp5Y4+EwoN1Ac35pz5GF2uKGQR6xCHJ7WrlBVUmh
         4Qmjjf7xqTXrXpTZ37bGTpPq1oP3c1dHpjcWckRwIFGj0R5HI9Lp0wFfIp7bwFO7jWgT
         QMoGbC0P9eYfE1BhdVj8ZXQlm2HOJWNFatOzGc0eEbjNycsKlrcpMyEpk9srIFs9c5RR
         FIMg==
X-Gm-Message-State: APjAAAVyJcbcUThAgRyLzClCiHQoygDQjmigpaxb18MoyUDshqKasuTk
        3nCdKWjKpPq+oNd6JsMaxwM=
X-Google-Smtp-Source: APXvYqxga6+imdNEUHeSe4G2IYA2i8PSZZgcQmJFVHJxv1Dp9r/WmceIftin4ZPiCyBN2ELKJKcnJw==
X-Received: by 2002:a2e:9b99:: with SMTP id z25mr18574069lji.106.1552378807209;
        Tue, 12 Mar 2019 01:20:07 -0700 (PDT)
Received: from a2k-HP-ProDesk-600-G2-SFF.kyiv.epam.com (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id j1sm55539lfk.26.2019.03.12.01.20.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 12 Mar 2019 01:20:06 -0700 (PDT)
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
To:     xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com, hverkuil@xs4all.nl
Cc:     Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [Xen-devel][PATCH v5 0/1] cameraif: add ABI for para-virtual camera
Date:   Tue, 12 Mar 2019 10:19:59 +0200
Message-Id: <20190312082000.32181-1-andr2000@gmail.com>
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

 xen/include/public/io/cameraif.h | 1370 ++++++++++++++++++++++++++++++
 1 file changed, 1370 insertions(+)
 create mode 100644 xen/include/public/io/cameraif.h

-- 
2.21.0

