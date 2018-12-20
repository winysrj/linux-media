Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A53C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC3A0218A6
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:54:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="cHT6eHFT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732608AbeLTMyu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:54:50 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39242 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728966AbeLTMyu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 07:54:50 -0500
Received: by mail-wm1-f67.google.com with SMTP id f81so2046944wmd.4
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 04:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eTbaK90WQbfaV86T27wpc68Wcf5FjOqAAxWvucI8Kwc=;
        b=cHT6eHFTKRMSSmC421Kco6NQ1QX4vsq6K5+HUDiXg8z5znbqlXxDHiznjoZmYzhbJO
         e4+IYmMLcG/yiP4VG34PRvoLhv1+pjIG1AfJpxLElkp/YP5Vh/N/dS1nGEl3toDZwQiH
         0eK2r05nscjebi2TAOlq3F5csiKlPMCsYZAro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eTbaK90WQbfaV86T27wpc68Wcf5FjOqAAxWvucI8Kwc=;
        b=tqdPLbzi8NfNGQYebFQzAqV4zu2U6Bpk7nSt/nWSg62bnFGAmuhaHTJjTLC8oqaK5w
         fKWR/8Y/ZWHu6Wq4G4wUC0ymozvipsy7ge+K2NPDLTyYk+Zwn/03HLAqtdrX4QNrkh8Q
         4/PgNZugYQ4G+8sNH1l8vuX5OiXf5ZqM6K+OzOarfmm0OXAI9zc4z7G68pCL01rQFyjx
         NpgmLpQ1UN7RZ7MvYKS3FE62cuM37+vEqIMrRwgb2sEcXJ5+AVlP2FUdILdy+wFlVjXN
         wYMrf01sh1AcfSBxIkpp2IKoQRZNTmXktFtQ0PS5Mv4dpxaZl9gqB0I+jt2+l0k3i4Id
         AVIQ==
X-Gm-Message-State: AA+aEWbie50a8PgaV5nMYuef2GsWBHheHbi9Q2/rKiv5Z1/nQgiyvG73
        j6cDRP5hMsPCKdUSzQf/3uUZHQ==
X-Google-Smtp-Source: AFSGD/XuheZcpZNUP84fKqUeymPOQ+YAc84cBD+JTnB3+xV6FvRUC1v6/b/HsdST6zhmycH6IQM4HA==
X-Received: by 2002:a1c:83c8:: with SMTP id f191mr11334134wmd.134.1545310488444;
        Thu, 20 Dec 2018 04:54:48 -0800 (PST)
Received: from localhost.localdomain (ip-163-240.sn-213-198.clouditalia.com. [213.198.163.240])
        by smtp.gmail.com with ESMTPSA id o4sm8732756wrq.66.2018.12.20.04.54.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Dec 2018 04:54:47 -0800 (PST)
From:   Jagan Teki <jagan@amarulasolutions.com>
To:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>
Cc:     Jagan Teki <jagan@amarulasolutions.com>
Subject: [PATCH v5 0/6] media/sun6i: Allwinner A64 CSI support 
Date:   Thu, 20 Dec 2018 18:24:32 +0530
Message-Id: <20181220125438.11700-1-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This series support CSI on Allwinner A64.

Tested 640x480, 320x240, 720p, 1080p resolutions UYVY8_2X8 format.

Changes for v5:
- Add mod_rate quirk for better handling clk_set code
Changes for v4:
- update the compatible string order
- add proper commit message
- included BPI-M64 patch
- skipped amarula-a64 patch
Changes for v3:
- update dt-bindings for A64
- set mod clock via csi driver
- remove assign clocks from dtsi
- remove i2c-gpio opendrian
- fix avdd and dovdd supplies
- remove vcc-csi pin group supply

Note:
- This series created on top of H3 changes [1]
- Tested on top of Maxim's ov5640 changes[2] along with
  the change I praposed wrt 15fps change on this patch[3]
- Here is the test log[4], for anyone's information.

[4] https://paste.ubuntu.com/p/pC9ZQKNzQf/
[3] https://patchwork.kernel.org/patch/10708931/
[2] https://patchwork.kernel.org/cover/10708911/
[1] https://patchwork.kernel.org/cover/10705905/

Jagan Teki (6):
  dt-bindings: media: sun6i: Add A64 CSI compatible
  media: sun6i: Add mod_rate quirk
  media: sun6i: Add A64 CSI block support
  arm64: dts: allwinner: a64: Add A64 CSI controller
  arm64: dts: allwinner: a64: Add pinmux setting for CSI MCLK on PE1
  [DO NOT MERGE] arm64: dts: allwinner: bananapi-m64: Add HDF5640 camera module

 .../devicetree/bindings/media/sun6i-csi.txt   |  1 +
 .../dts/allwinner/sun50i-a64-bananapi-m64.dts | 65 +++++++++++++++++++
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 25 +++++++
 .../platform/sunxi/sun6i-csi/sun6i_csi.c      | 39 +++++++++--
 4 files changed, 124 insertions(+), 6 deletions(-)

-- 
2.18.0.321.gffc6fa0e3

