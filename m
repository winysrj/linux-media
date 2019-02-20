Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9871C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 742CC21738
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bqE3xlTX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfBTAFd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:05:33 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38935 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfBTAFd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 19:05:33 -0500
Received: by mail-pl1-f196.google.com with SMTP id 101so11225951pld.6
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2019 16:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4IPlFsHy9k4TLVU9knFNQ8+oKcyViemb/hXujnAh9Hw=;
        b=bqE3xlTXrt217rS/qKUWbp6ihTtTM4aRgWMijCVQqD6mPnvBmHWk1QmWIE7YAHFGls
         +TRLIE4kj46Et+I+5Tor3kptRb+1y/YT0DX3OUK+hiZ2rhigIQ3XnL2AZtPTInI71If9
         iyPMx3RyiKyD/e3xSm2TdpGaoZUzvs2H125JGLFk4INxxfYd9W5upaetJ/fQvBsp0uxX
         iLqowbszSBXQBxvAYsuDgIcfIMidmPnlaGre0F+ZvQd9AU0XJzxMdudWpLH8JGcum59v
         m+s55IUSWYimujFu6mKGm2zj4y2NJRNklRmT5Oei4c3eY+BlSgPKRXvfWnARENnHymKP
         laVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4IPlFsHy9k4TLVU9knFNQ8+oKcyViemb/hXujnAh9Hw=;
        b=sJpaWszGuaYnJVcnixl7csS0oARRF+jRaAmWVfrWzGmZk0bwGC9sdBAd1dR6ZM4+iu
         SxC7JsHLJL/3NgHVklDRAGhqu1pZ7+5RJ7T8qJ2h+VxvnFQ0l8H1yWY+YvEyZMb9h0oV
         VG7omtXgvaTaMEKhuM3T40kKSIuznZN2wjTEoxglK3HFFNWv29zuPWW4jTO7YjoRUuu6
         z82b4MINzIFUKUe+e2cUWeZzFVEeyaYa2roMPMkUKCDrik9fQZDNs+K1h0+ahgZS1UJ/
         t+36OqMpd88lOcC09L2Wy9ZXts2InQeVedB1yzA/hJa7PV/0RffkIFmGX/j0btCXncCY
         go/g==
X-Gm-Message-State: AHQUAua9RrwscEeitRwfrS4a8J/X+sVqElqKAIg82fm7bvLrXOZ1+2tN
        5Kek1UdP0+gGTJ+aO3o6XhEyziXi
X-Google-Smtp-Source: AHgI3IZRhU92b6TCFZMyQ2gmlo7Ty8un9DLRc0iSvCD7UIY3KQqZQRRFjPkPANGsfTI0YfbGe8PKqA==
X-Received: by 2002:a17:902:6a83:: with SMTP id n3mr7652698plk.313.1550621131996;
        Tue, 19 Feb 2019 16:05:31 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id f14sm19159083pgv.23.2019.02.19.16.05.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 16:05:30 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v5 0/7] media: imx: Add support for BT.709 encoding
Date:   Tue, 19 Feb 2019 16:05:14 -0800
Message-Id: <20190220000521.31130-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patchset adds support for the BT.709 encoding and inverse encoding
matrices to the ipu_ic task init functions. The imx-media driver can
now support both BT.601 and BT.709 encoding.

History:
v5:
- the hard-coded encode coefficients now convert only between
  full-range quantization. A new function is aded to transform the
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

 drivers/gpu/ipu-v3/ipu-ic.c                 | 489 +++++++++++++++++---
 drivers/gpu/ipu-v3/ipu-image-convert.c      |  27 +-
 drivers/staging/media/imx/imx-ic-prp.c      |   6 +-
 drivers/staging/media/imx/imx-ic-prpencvf.c |  30 +-
 drivers/staging/media/imx/imx-media-csi.c   |  19 +-
 drivers/staging/media/imx/imx-media-utils.c |  70 +--
 drivers/staging/media/imx/imx-media-vdic.c  |   5 +-
 drivers/staging/media/imx/imx-media.h       |   5 +-
 drivers/staging/media/imx/imx7-media-csi.c  |   8 +-
 include/video/imx-ipu-v3.h                  |  37 +-
 10 files changed, 548 insertions(+), 148 deletions(-)

-- 
2.17.1

