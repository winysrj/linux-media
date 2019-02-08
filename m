Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246F3C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB14E2070B
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:28:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MokDRUqk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfBHT2v (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:28:51 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43152 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfBHT2v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 14:28:51 -0500
Received: by mail-pg1-f194.google.com with SMTP id v28so2000053pgk.10
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 11:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9JBeS/K8cRnbmBu/HqU6G+d3s7iJbGjUh+rhKgMxOJw=;
        b=MokDRUqkM1gIOIENUUshLMQlFRZS5DMmg1SA1zG/G3+KWjtl2001MiQQG7Wt2smQFH
         TCglgT+Bxo7ZTotcNWsEss8bWG+j3BS3rNnu6ybRb0dUfzL05c1KtoaVRMjxZIRoFvv+
         mNn5MC4VIRXpjOoN+uN2/WzSz4ii6Cvs9ammozOyHiYjPEpRxMuqyBfDaIpmLh9HF7PN
         hP7k+3PbEJDbUwNUwoaZcby9/43Pi4xbe/SRVyGcsGGNmbD9n82kd39THSTfrrw8g2Sb
         Jq+spjX/RMnyqgjNYvtbtzuVfDHT6meA0prrzq2ayKAuqMw1Yo4yVB32EoFlxFU79AS0
         Z9Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9JBeS/K8cRnbmBu/HqU6G+d3s7iJbGjUh+rhKgMxOJw=;
        b=NJmwiC4o+r5YqxMlo3yWTMIT9Kz7kubQ65ShQJx0yhi2HTQLP4VQ99VE+MUAKb10nU
         0OVKPnWFMO6m25k4PDq213gIzfinEzosDQLgC5VVGkUNCqsRzfn3nQiuZbNxBI6SJ5Pk
         +f16M4RvcUEW9qCBXdadwzbMQAQ6cv9Luh1MBfrqr4Bdf3bBWY0/uF1FjtyOZfvMEfzq
         3pOeMUnB6mK4xgW6Ej6I8hOpnOUH/hZdxiF2QCRP663v7I66O59tGguIFOtDzWPOIQl8
         BnwZtFC2q2Z0eL4BpwD/L4u/lzqdJpYZleuJMT+KPSy8lJwvSeKXL5Ggx9Wc46H63rSs
         9YQQ==
X-Gm-Message-State: AHQUAuYxKfyO8DxAqyElIAGP2Z3a1uvgZcwxivicZ8y9YhwECzEK5Rq6
        EUv+ERjQOLSTcjjvnUJRVD8MsuCN
X-Google-Smtp-Source: AHgI3IZDMfhYE9JpUkNDaXEilPFPNsIDgNYvl/tIhjnkhn7EQYZclOiIGr6LA+R8mPJE7s5oQn5tZA==
X-Received: by 2002:a63:b81a:: with SMTP id p26mr22283986pge.433.1549654129676;
        Fri, 08 Feb 2019 11:28:49 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id e128sm4443129pfe.67.2019.02.08.11.28.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 11:28:48 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v3 0/4] media: imx: Add support for BT.709 encoding
Date:   Fri,  8 Feb 2019 11:28:40 -0800
Message-Id: <20190208192844.13930-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patchset adds support for the BT.709 encoding and inverse encoding
matrices to the ipu_ic task init functions. The imx-media driver can
now support both BT.601 and BT.709 encoding.

History:
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

Steve Longerbeam (4):
  gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding matrices
  gpu: ipu-v3: ipu-ic: Simplify selection of encoding matrix
  gpu: ipu-v3: ipu-ic: Add support for BT.709 encoding
  media: imx: Allow BT.709 encoding for IC routes

 drivers/gpu/ipu-v3/ipu-ic.c                 | 94 +++++++++++++++++----
 drivers/gpu/ipu-v3/ipu-image-convert.c      |  1 +
 drivers/staging/media/imx/imx-ic-prpencvf.c |  4 +-
 drivers/staging/media/imx/imx-media-utils.c | 20 +++--
 include/video/imx-ipu-v3.h                  |  5 +-
 5 files changed, 97 insertions(+), 27 deletions(-)

-- 
2.17.1

