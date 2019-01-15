Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43C3C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B3F620656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FRDj883S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfAOJjE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 04:39:04 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39688 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbfAOJjE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 04:39:04 -0500
Received: by mail-lf1-f68.google.com with SMTP id n18so1510837lfh.6
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 01:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tpvUpXfnE2jE0U2Fsg6oxHwUKxOhwEZ3IV1baKcfxGg=;
        b=FRDj883SGugXAje+92WG9jEECb+A/bULu9g9Y+wyUSWTPMmOkmMsDCCkfLMSN3HKvc
         0TcTEFbSWuuoLoZRvcKkcOm9q69cERqAKFwz8lKZsn/c0HWuY0KqvsM+fjCI0nni1sxj
         FdK9xz7MNsuNkzVGpciu37vfwI9k5bPUg9YJWXwOUa9v5u4kPsqymCkUj3/sM3E/LU8F
         njHd/u+fSE9j1Bj3QrSIaj3/ktyGsTC4L+NPxZI9yTLRvOmtRNNooB64eh5Wxa0gRDz7
         mm6TMmj11DU2t9UDM+h/3xlQVyAfUpcqMvt9qOJKjeEs8Tvsu7YnBJZNd/i7wGAzzr2h
         6vBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tpvUpXfnE2jE0U2Fsg6oxHwUKxOhwEZ3IV1baKcfxGg=;
        b=mYPqKxMM9MskeXi7AzTM1a1+OVO6uW058O6JugphqIRAscEN7C7usbS6pi6zk5H8ok
         KY5XfdukTpyFmV1ccJI/iM4XqoMAn9osnMiEPKNt6pn+Q0y1U02Mre5EAeJf1Cr9xLj2
         /iRKgXeQ5a5mkSapYUdIn2EL3Hogf+e8DoVRpEWgY2l2l6L1nqy3g/pP+1zTFwnp/346
         0riFvJBfDWSiayq3webgclizYV1tXsXKTXe99uE8LYLk7/NQgVj7VvhDsfN1cVnum8Zs
         MCEXyp64iw1oA3i/Koe9RLOVKzyWNuu7i6dwL8Mi1LkztULvrVg0pTv2CqhkEACuroum
         YhZA==
X-Gm-Message-State: AJcUukdRV7ez1MiM5pBlEKgYZKju42Ypv6PaZ1uhH4m/ukznZJcS5fHs
        uJI/Rk3kf5kwmmaWPGxE7sA=
X-Google-Smtp-Source: ALg8bN7XiA7VeOge0XP9r+R+pK13AecQx3+d9YhUhs6fv4VRLVKg4DYXtxZckW5IDyn8R816hGu77w==
X-Received: by 2002:a19:ee08:: with SMTP id g8mr2188904lfb.72.1547545141997;
        Tue, 15 Jan 2019 01:39:01 -0800 (PST)
Received: from a2k-HP-ProDesk-600-G2-SFF.kyiv.epam.com (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id l3-v6sm490935ljg.21.2019.01.15.01.39.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 15 Jan 2019 01:39:01 -0800 (PST)
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
To:     xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com, hverkuil@xs4all.nl
Cc:     Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [Xen-devel][PATCH v4 0/1] cameraif: add ABI for para-virtual camera
Date:   Tue, 15 Jan 2019 11:38:52 +0200
Message-Id: <20190115093853.15495-1-andr2000@gmail.com>
X-Mailer: git-send-email 2.20.1
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

 xen/include/public/io/cameraif.h | 1364 ++++++++++++++++++++++++++++++
 1 file changed, 1364 insertions(+)
 create mode 100644 xen/include/public/io/cameraif.h

-- 
2.20.1

