Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED17BC04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B130E2084E
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:49:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bdOAJTc/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B130E2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbeLLJtm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 04:49:42 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36316 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbeLLJtl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 04:49:41 -0500
Received: by mail-lf1-f68.google.com with SMTP id a16so13041110lfg.3
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2018 01:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ee4e9h4obom3AxnF28P/ovAaoE/Ar6N4pBEvcZnIvs=;
        b=bdOAJTc/+BPb5V6L69SrKuIi8gN3mfRudMDN2qlOQ6TLdgM3GiiOqazwVeJ4Wy68j8
         EA75n1dVKSIbA9XRAeHOmyQkxjeXom5Yr+J9gA+g9IQUOVMCoOw7MiK3CxoxNckTAaqM
         blwc7c/37mNdmWFAPDczaMe66T64hE5qdkH0zoMYSWvOnsCZjB2GvNla/9eucyR+4QVI
         WUhMaEp33jqFoWajgQDolnce5TOJsc4fhg5z8TJoJ9fbG1AtxKqVcWs6bYtDv2uZ909Y
         CqTEMlTybxaVkatWXOBKoRj1/mr2vlqAqRjrNYh0iTanJnt/TEaC2ODF16iKXo4JlLF2
         qlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ee4e9h4obom3AxnF28P/ovAaoE/Ar6N4pBEvcZnIvs=;
        b=iunlptvLI/8dO/KVgvBGZOmaDWwx9+uKR3rJ9pGCwkbvDDmg2yCeGTsojpr2EWbBKh
         BG18yo0my6vykad4o9T4gZ8TX6UuUknwJZcDopDljtU59kee2nefBGuN1VtOy8nAyuaC
         BPPavlkEAWypvAq15GPI4FcdR2iOM3qRaeGPgbeavG9OfQfhvrhXEzvYSEYB/bi8T8sV
         htc7AiEnOxsk9pgFMwDrQ9vbyMAdGAKm9cLpdU+FMA/D+2AtXPdlw0Y/krl5MaaRqd5l
         zvyddLpRdfeqZB7ajDRwttCQIeHcEtj5s+PKdBjakFv1DZGYuL2ueS8m7drCdomz+SeI
         Jb4w==
X-Gm-Message-State: AA+aEWaOgxPS5Dy4eVbxlMzMR7RyEjXtJBFMyVdEYaK13SKIhwnUWh3W
        re0mm1BfNJD8UsYT1YAUEV8=
X-Google-Smtp-Source: AFSGD/WWwHMwf65AhbL6si3t6gsHGD5CSQYykd0Du58mBQnCX+JTH5bmZAFsaF/nAR91IhLwekWmzA==
X-Received: by 2002:a19:f115:: with SMTP id p21mr2960416lfh.20.1544608178145;
        Wed, 12 Dec 2018 01:49:38 -0800 (PST)
Received: from a2k-HP-ProDesk-600-G2-SFF.kyiv.epam.com (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id t19-v6sm3188680lje.23.2018.12.12.01.49.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Dec 2018 01:49:37 -0800 (PST)
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
To:     xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com, hverkuil@xs4all.nl
Cc:     Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [Xen-devel][PATCH v3 0/1] cameraif: add ABI for para-virtual camera
Date:   Wed, 12 Dec 2018 11:49:28 +0200
Message-Id: <20181212094929.4709-1-andr2000@gmail.com>
X-Mailer: git-send-email 2.19.2
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
passes v4l2-compliance test for V4L2 drivers. libxl changes are
available at [5].

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
2.19.2

