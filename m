Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFDEC43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0699D20675
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bW5o9DDy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfCGXeJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 18:34:09 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38455 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbfCGXeI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 18:34:08 -0500
Received: by mail-pg1-f193.google.com with SMTP id m2so12514032pgl.5
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2019 15:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=w9UJu6G4WGVbN5HF8f8azxJU7mcpJYHZ3Hh+CDrQYLw=;
        b=bW5o9DDyr8cWARRJXxmf1sTmPO0tZ0RPJ1zwrKJNrgLbWRXj1qRHLYJoW1etTfelOI
         TUmmO5O+al+ZMG9gPCGV6PPaWtgzpwnVgq4wG4bU++8Ps9ruyDK+Fs7sBBzbap/5mThh
         ywtge12fnVaZZqjpVpkBWblbwWQ9mlrlAJ05Fx6pptXMa6Mtrx8kXKApYZNpfUwo2R6T
         NEIVjYIPCyLi58Rx/a8XJ1H4/VTGbRATicBs4Xz92SH1FxbDZKqpju9ENLMTBYo/xkxx
         G+ZQ/NXNHrZQFZA5DqM/KUNcL9jpxednV9ihnVPO3BiC3ux+/S2pnQxraiFcbG+fdPa1
         e7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=w9UJu6G4WGVbN5HF8f8azxJU7mcpJYHZ3Hh+CDrQYLw=;
        b=cxc3gWgCOXoMw//z9ey3qOV/cUj8xxRdfXfR1nIGTP6lJ8aGPd3S6YH+NusF0NzPhg
         RAIdT5Y3JWTVRCHtzQViDpUmesZnnGIPNrBy1SLyoLQuwWMRe15NHb0Z8NM17+34DBtP
         G3+UrZWAToDZAZmLWIC/HN8mD13h3sZUjZXDN6KNbtsu/sbt0UqOwACfg/CcJOn76q8F
         s2fqwY+M0pkX9+8gOJSb3SqPizmzaFCPRg++38i8VnolmgyXrm29oQBfeVrFxzUVavsT
         Nqah2PRBPhgn6czUR1uLedrsMf7i3K9YtqFdC/BAozBqkpV1hmbHWCZ5zUiq5xwLDZf6
         8Sig==
X-Gm-Message-State: APjAAAWKH2QUnrNMha484iE9b/XBUW42FvNC/52y7Zlodmn32OwOmosY
        tiYq/kdReCwb6+wOZt59SKSBKBmT
X-Google-Smtp-Source: APXvYqyTvVzv9mdmW5J4fM35y9+W2QSFIMOuloCzqpHhY35f/ZXbF9kgL9OYW7fPjafbygl2gkJL9Q==
X-Received: by 2002:a17:902:900a:: with SMTP id a10mr15813745plp.183.1552001647435;
        Thu, 07 Mar 2019 15:34:07 -0800 (PST)
Received: from localhost.localdomain ([2605:e000:d445:6a00:2097:f23b:3b8f:e255])
        by smtp.gmail.com with ESMTPSA id m21sm8684866pfa.14.2019.03.07.15.34.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 15:34:06 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v6 0/7] media: imx: Add support for BT.709 encoding
Date:   Thu,  7 Mar 2019 15:33:49 -0800
Message-Id: <20190307233356.23748-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patchset adds support for the BT.709 encoding and inverse encoding
matrices to the ipu_ic task init functions. The imx-media driver can
now support both BT.601 and BT.709 encoding.

History:
v6:
- tweak some of the coefficients slightly, they were not getting
  rounded correctly.
- move the introduction of calc_csc_coeffs() to an earlier patch for
  easier patch readability.

v5:
- the hard-coded encode coefficients now convert only between
  full-range quantization. A new function is added to transform the
  coefficients to limited-range at input or output.
- add a bug fix patch for saturation bit in TPMEM register.
- add a patch to fully describe input and output colorspace to
  the IC task init functions.
- add imx_media_try_colorimetry(), called at all sink/source pad try_fmt.

v4:
- fix a compile error in init_csc(), reported by Tim Harvey.

v3:
- fix some inconsistent From: and Signed-off-by:'s.
  No functional changes.

v2:
- rename ic_csc_rgb2rgb matrix to ic_csc_identity.
- only return "Unsupported YCbCr encoding" error if inf != outf,
  since if inf == outf, the identity matrix can be used. Reported
  by Tim Harvey.
- move ic_route check above default colorimetry checks, and fill default
  colorspace for ic_route, otherwise it's not possible to set BT.709
  encoding for ic routes.


Steve Longerbeam (7):
  gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM
  gpu: ipu-v3: ipu-ic: Fix BT.601 coefficients
  gpu: ipu-v3: ipu-ic: Fully describe colorspace conversions
  gpu: ipu-v3: ipu-ic: Add support for Rec.709 encoding
  gpu: ipu-v3: ipu-ic: Add support for limited range encoding
  media: imx: Try colorimetry at both sink and source pads
  media: imx: Allow BT.709 encoding for IC routes

 drivers/gpu/ipu-v3/ipu-ic.c                 | 487 +++++++++++++++++---
 drivers/gpu/ipu-v3/ipu-image-convert.c      |  27 +-
 drivers/staging/media/imx/imx-ic-prp.c      |   6 +-
 drivers/staging/media/imx/imx-ic-prpencvf.c |  30 +-
 drivers/staging/media/imx/imx-media-csi.c   |  19 +-
 drivers/staging/media/imx/imx-media-utils.c |  70 +--
 drivers/staging/media/imx/imx-media-vdic.c  |   5 +-
 drivers/staging/media/imx/imx-media.h       |   5 +-
 drivers/staging/media/imx/imx7-media-csi.c  |   8 +-
 include/video/imx-ipu-v3.h                  |  37 +-
 10 files changed, 547 insertions(+), 147 deletions(-)

-- 
2.17.1

