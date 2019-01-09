Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD12EC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 991512146F
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uaBrSV6c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfAIAQB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:16:01 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39506 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfAIAQB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:16:01 -0500
Received: by mail-pg1-f195.google.com with SMTP id w6so2466095pgl.6
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2019 16:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bMNUpxRj4/pBRSVHw3woE1Ev0ED6tCM8PUguzRVtR94=;
        b=uaBrSV6cjGbE5/onGRsZJhjx0NiIbkGY0e9hq+A1Nf2zLaW7v9TSMQjaHARU0Z0RBt
         J+/ZsVcYwcL/NUS88NHC2k0UvkedgoGsJOJbdvc9QqSoC3agF4Mnp6vF4FWSl2EYwVX1
         H8h6D3qjhTg6liR5Sgen3ZyN02gvvAi934F7hZ32pOBIKlbN7P/9M8E4lb8v71lC69aa
         9WlXi/pbNMrkMhyhiAoDN67ZNRDEy8U4yyjfD7hP4eopDMPXH8pZUpdDMOEzhDcht4Dy
         R1moD+f+tb1+XGv8mf+cJbnklwk/sQJXM1Ww3dFhH81ldRII0HE7rlEXbBqiGmqdToUc
         nqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bMNUpxRj4/pBRSVHw3woE1Ev0ED6tCM8PUguzRVtR94=;
        b=uQV012vtdxlnnFjz6ZKfWuj9Hx6MNzPOanuA4i5qn1DFNYGz9MDAZ9FxcwO0uSrMEh
         yRYs/TDYcMFkM2cGh635KWunAiFiqf/xERHM2YrsDYJlD/fshZinN2kcyTQY7+TI56yn
         ra6u6Ngx28nckSAFf1mx40wALqjz5GHLlVaszCKWNRbzoL0Mds+e/Kj85G1eKfdDRlpd
         JRLmd4rF2hsIEQxJ6UG1cy8ocCGjmualv1E68us2mYXju4FstxrUCi5LkD77OLwbKtQ5
         PIJNKLYFjKXwi8BrXGFGOLaXLqHGVHxU6HM54PjTKwIR4BHk2Vzc3KecAakclePz5vrg
         N4sA==
X-Gm-Message-State: AJcUukejlbf/lvEHxn0lWGfRSkW5uoNO8LV3hz8FNx9Qgpnot9ZnlW3V
        uDf+jFOxT5MqJLgnjQUbKyD18S+o
X-Google-Smtp-Source: ALg8bN6Cz8OH4J0ywX4TyHe4tf5wFEnwK+5rtqhr3TsTLOZDy1SLGeZOeWSdaJa9rKGZNzdqYOa2Mw==
X-Received: by 2002:a62:3241:: with SMTP id y62mr3798553pfy.178.1546992959207;
        Tue, 08 Jan 2019 16:15:59 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id 134sm83978490pgb.78.2019.01.08.16.15.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 16:15:58 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v6 00/12] imx-media: Fixes for interlaced capture
Date:   Tue,  8 Jan 2019 16:15:39 -0800
Message-Id: <20190109001551.16113-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Steve Longerbeam <steve_longerbeam@mentor.com>

A set of patches that fixes some bugs with capturing from an
interlaced source, and incompatibilites between IDMAC interlace
interweaving and 4:2:0 data write reduction.

History:
v6:
- Changes to patch "gpu: ipu-csi: Swap fields according to input/output
  field types" suggested by Philipp Zabel.

v5:
- Added a regression fix to allow empty endpoints to CSI (fix for imx6q
  SabreAuto).
- Cleaned up some convoluted code in ipu_csi_init_interface(), suggested
  by Philipp Zabel.
- Fixed a regression in csi_setup(), caught by Philipp.
- Removed interweave_offset and replace with boolean interweave_swap,
  suggested by Philipp.
- Make clear that it is IDMAC channel that does pixel reordering and
  interweave, not the CSI, in the imx.rst doc, caught by Philipp.

v4:
- rebased to latest media-tree master branch.
- Make patch author and SoB email addresses the same.

v3:
- add support for/fix interweaved scan with YUV planar output.
- fix bug in 4:2:0 U/V offset macros.
- add patch that generalizes behavior of field swap in
  ipu_csi_init_interface().
- add support for interweaved scan with field order swap.
  Suggested by Philipp Zabel.
- in v2, inteweave scan was determined using field types of
  CSI (and PRPENCVF) at the sink and source pads. In v3, this
  has been moved one hop downstream: interweave is now determined
  using field type at source pad, and field type selected at
  capture interface. Suggested by Philipp.
- make sure to double CSI crop target height when input field
  type in alternate.
- more updates to media driver doc to reflect above.

v2:
- update media driver doc.
- enable idmac interweave only if input field is sequential/alternate,
  and output field is 'interlaced*'.
- move field try logic out of *try_fmt and into separate function.
- fix bug with resetting crop/compose rectangles.
- add a patch that fixes a field order bug in VDIC indirect mode.
- remove alternate field type from V4L2_FIELD_IS_SEQUENTIAL() macro
  Suggested-by: Nicolas Dufresne <nicolas@ndufresne.ca>.
- add macro V4L2_FIELD_IS_INTERLACED().


Steve Longerbeam (12):
  media: videodev2.h: Add more field helper macros
  gpu: ipu-csi: Swap fields according to input/output field types
  gpu: ipu-v3: Add planar support to interlaced scan
  media: imx: Fix field negotiation
  media: imx-csi: Input connections to CSI should be optional
  media: imx-csi: Double crop height for alternate fields at sink
  media: imx: interweave and odd-chroma-row skip are incompatible
  media: imx-csi: Allow skipping odd chroma rows for YVU420
  media: imx: vdic: rely on VDIC for correct field order
  media: imx-csi: Move crop/compose reset after filling default mbus
    fields
  media: imx: Allow interweave with top/bottom lines swapped
  media: imx.rst: Update doc to reflect fixes to interlaced capture

 Documentation/media/v4l-drivers/imx.rst       | 103 ++++++++----
 drivers/gpu/ipu-v3/ipu-cpmem.c                |  26 ++-
 drivers/gpu/ipu-v3/ipu-csi.c                  | 126 +++++++++-----
 drivers/staging/media/imx/imx-ic-prpencvf.c   |  46 +++--
 drivers/staging/media/imx/imx-media-capture.c |  14 ++
 drivers/staging/media/imx/imx-media-csi.c     | 158 +++++++++++++-----
 drivers/staging/media/imx/imx-media-vdic.c    |  12 +-
 include/uapi/linux/videodev2.h                |   7 +
 include/video/imx-ipu-v3.h                    |   8 +-
 9 files changed, 355 insertions(+), 145 deletions(-)

-- 
2.17.1

