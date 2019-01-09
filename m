Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EC3C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBDC220665
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:30:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fs+hrtL8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfAISa2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:30:28 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46704 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfAISa1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:30:27 -0500
Received: by mail-pl1-f193.google.com with SMTP id t13so3945009ply.13
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 10:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r1k/PYn3+gws0bcviq8o+0K/ZLeumOsPJFHXhCgxgYw=;
        b=fs+hrtL8c2xDxG52uPfqiH2bAezTK7TTaonmhy6wZqGJ8OPP9qWeqZwLrd+cRFY+hj
         z5o8RHiUFzf1jQpjMrN6csl89xFGINrcPmrwmzkpvRsZt8nhqltVXasqHgvE6lBl7RHQ
         F+MoDOT91gUjFsU9cQFDTiYT3qu+tNvFsTj3K8NWltIeo1Igmys/VL9wCz8TLGi9bFIq
         aWjqPmGnhrtTE2xpTZblDMu/XlN3j3ftWLAbqdLBNthSgnzAX7MOmEP4cVZAKNjsY2iU
         FUw8RV902kWqUCbIqwEFrNvHiYaI0/aZ2i2YiRYjZ3tdd7vxeNTC3H/xx9cntm8y2v3i
         wuuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r1k/PYn3+gws0bcviq8o+0K/ZLeumOsPJFHXhCgxgYw=;
        b=EzMgKN+Ydqa+9AyAeZcgy2K6RoekCh808Pq3HhX7+OetKOXlE1quCd6TEo9I0ZeJDD
         MGQXksR7kpAik2EPo1yaY8AiyCJXSGU45ThoHt5Mr+tI61Fb/xbRPWR1ICeFN90g1c5K
         Q6RodDkCIX1p7RRMhfYibB1CFXMmeneqa6SDDKhq5gGYEPbMPtfTRbPoXSl2NB0Tv2uL
         EKh84laj+BBPV5woEYjdKRf90kvcVwTk50XfGjk6XNQ2Rzt3kOQK2gyAf4q9zJgrBIgR
         zSepMXb05WZdfki85GDflBuqx8Sz/k+PoJgWCr/RP8EVBkLC+dC7FOkpfCf5sm8M78In
         iWaA==
X-Gm-Message-State: AJcUukdP6c/fl5/57e9ms9PBzzrArjoyNZ5ehAtfkGu9wz7txsLNaF9D
        xEsdkAwlMHRnIYY7c9Fy5EN+XFd/
X-Google-Smtp-Source: ALg8bN5sk7oKYYFPkXlfdEJmJ6a7UKGaCq8AzXmfh103LyKzPeuDfk20qWHFICtzlMlW41RM+VBguQ==
X-Received: by 2002:a17:902:a5c3:: with SMTP id t3mr7009315plq.117.1547058626492;
        Wed, 09 Jan 2019 10:30:26 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id v191sm157551056pgb.77.2019.01.09.10.30.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:30:25 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v8 00/11] imx-media: Fixes for interlaced capture
Date:   Wed,  9 Jan 2019 10:30:03 -0800
Message-Id: <20190109183014.20466-1-slongerbeam@gmail.com>
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
v8:
- Add some missing sign-offs. No functional changes.

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

