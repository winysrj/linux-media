Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD86C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5F1320859
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:16:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h9nwtKny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfAISQw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:16:52 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41790 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfAISQv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:16:51 -0500
Received: by mail-pf1-f195.google.com with SMTP id b7so4027374pfi.8
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 10:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5a25Fb/EJTRupEnZRZueuX0sFv4t9Gjd7lMAKPJ9AyY=;
        b=h9nwtKnyajxiUE0VW1raAqZEjoFNm7mcy8Dbd6/l+YtwZN4wCyQp/voAwdwhkS3jPO
         qEj7BOHIQ2jzcueP7gh58RQ0nF1nZF7csXKkftGUolPqsAzUGiZKn6LG/xbewjfofN+R
         /o6gchzGTiZKGI9yOAsn5APudKqhQJXt1EF8PUpb/btYIAC+e79mSp2DisXYodPuyxAG
         yi7RMpDm/0xRfMTg+X759MG1+sO4UqiTOlewQ2oF2n+bD+5y23XEaEUPan09A6kLQE/V
         lf1gUT5wrDTKCIUn9lntIVICG3lz38OmobLvXN6zGhi3rtr+EL4y0wWSP0+6DA7mV2Ce
         yrgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5a25Fb/EJTRupEnZRZueuX0sFv4t9Gjd7lMAKPJ9AyY=;
        b=BB94WbPEOiFxYK0lReWcfEbRQylauztFEBV/pDGBtJQlG+rlYAdRd92yYcZ3c3Ey3b
         Gc0+7PBI17Tb6RhkVPWy9eU9NlUtor64m/seabRiH+dAZ7rWERMzX8knDoyGRd5Szwes
         kVGdfLVR/XZCzBX6fL9DSX8qAZKMpSPBG6u2M7oPKXO7uSYKxpHqRluMPVl9OzeZY1BM
         /fd8us+Ru5++kH80JQGWcpMc1FXAOtnUrQVMMaeCsGo8oJrnK94eoczgqeNYx3eNn2Tg
         q128wrAqDAasz65PF4CzphpEOKL+BGy4P6A+dBXtHF+mo4WHqZbWzCitSIujF9A9jMAQ
         LSiw==
X-Gm-Message-State: AJcUukeoInMTWNtJTaHvqcPvTlYVzMc4+Hp+P6agtctaf3ABZG0jTVX8
        BMwmEdFqIoTsgsXsfDqd2bppIbpM
X-Google-Smtp-Source: ALg8bN6deaYtpW/sQn/oJ1iFJuXP7881Ek/+Sgyr1SnHyuUrNdE+hY4P0FDhafPuqS3ZWeJv2R2yFg==
X-Received: by 2002:a62:4886:: with SMTP id q6mr7197817pfi.182.1547057809756;
        Wed, 09 Jan 2019 10:16:49 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id h19sm97030004pfn.114.2019.01.09.10.16.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:16:48 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v7 00/11] imx-media: Fixes for interlaced capture
Date:   Wed,  9 Jan 2019 10:16:30 -0800
Message-Id: <20190109181642.19378-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

A set of patches that fixes some bugs with capturing from an
interlaced source, and incompatibilites between IDMAC interlace
interweaving and 4:2:0 data write reduction.

History:
v7:
- Remove regression-fix patch "media: imx-csi: Input connections to CSI
  should be optional" which will be submitted separately.

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


Steve Longerbeam (11):
  media: videodev2.h: Add more field helper macros
  gpu: ipu-csi: Swap fields according to input/output field types
  gpu: ipu-v3: Add planar support to interlaced scan
  media: imx: Fix field negotiation
  media: imx-csi: Double crop height for alternate fields at sink
  media: imx: interweave and odd-chroma-row skip are incompatible
  media: imx-csi: Allow skipping odd chroma rows for YVU420
  media: imx: vdic: rely on VDIC for correct field order
  media: imx-csi: Move crop/compose reset after filling default mbus
    fields
  media: imx: Allow interweave with top/bottom lines swapped
  media: imx.rst: Update doc to reflect fixes to interlaced capture

 Documentation/media/v4l-drivers/imx.rst       | 103 +++++++-----
 drivers/gpu/ipu-v3/ipu-cpmem.c                |  26 ++-
 drivers/gpu/ipu-v3/ipu-csi.c                  | 126 +++++++++-----
 drivers/staging/media/imx/imx-ic-prpencvf.c   |  46 ++++--
 drivers/staging/media/imx/imx-media-capture.c |  14 ++
 drivers/staging/media/imx/imx-media-csi.c     | 156 +++++++++++++-----
 drivers/staging/media/imx/imx-media-vdic.c    |  12 +-
 include/uapi/linux/videodev2.h                |   7 +
 include/video/imx-ipu-v3.h                    |   8 +-
 9 files changed, 354 insertions(+), 144 deletions(-)

-- 
2.17.1

