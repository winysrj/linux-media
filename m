Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B95CC43444
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 11:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B7D7217D9
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 11:33:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="KXuf4HSt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbeLRLdb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 06:33:31 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54864 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbeLRLdb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 06:33:31 -0500
Received: by mail-wm1-f65.google.com with SMTP id a62so2294966wmh.4
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 03:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ZX3Vb1QocJF5KFof1FWVSsQ8WcfFPPJfBBeloD+g+g=;
        b=KXuf4HStRvXCEyx6ZBayeQl6dg5cvQ16H6xHY2cCoa2e94TRgzePTaaKnONf2qLhSl
         8EG78HZMizjmSuO0rPsrKtFPBU0LbrN+xDO98Lk8qYN7VD1gvFEKgWjTDW661Ql670tx
         lYc11TlkhfDyxs7Y1ef2xjTZGsbJ/tQ2g9VJ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ZX3Vb1QocJF5KFof1FWVSsQ8WcfFPPJfBBeloD+g+g=;
        b=tx7R7cFQH5KQimCyt1NuemuhasjBxUDLNvRRQtdK8VayNyq0CDuA9AKnGMhuy/TFci
         j20RCCcc7erG1loyrPTSb0iSVZyu1GnI9uRhVQI43rL4BRxkZ1p7aTQoG7+bl0D/ivgV
         h5w8wMU+XD0CmCYstdsbfCiB+F3p0xX8QnlnLIzU+CDw9yvbLxgXo2Ep3SEu+EIkhsEw
         n4RiCzTuYuqpmwYC4b/bryWx4RogamqI7TQHCXMzlC46WHoaLxBL2tH/OtuhdZd17RmQ
         WL2ixhvDC8Hvg9X7ZPKuiHruQOkVs9EDkOfQDmHRXwmkXvfzGNmRPcSlx3gbQzg+pTp7
         Sxag==
X-Gm-Message-State: AA+aEWavWuVhzKYtThhrFc3skTPvrN7IOqmWx0yoL+1I2D7j1eds9Jjm
        zE3okOyEgesteHMxbVEaqK08tw==
X-Google-Smtp-Source: AFSGD/W3uAyNuyhOjUpRNXHPgn0EQGx57zsT174w3nETaLsqzuERs0jH6Y/gj6dEh4NVCt1XlZVU7A==
X-Received: by 2002:a1c:6508:: with SMTP id z8mr2907356wmb.28.1545132808608;
        Tue, 18 Dec 2018 03:33:28 -0800 (PST)
Received: from jagan-XPS-13-9350.homenet.telecomitalia.it (host230-181-static.228-95-b.business.telecomitalia.it. [95.228.181.230])
        by smtp.gmail.com with ESMTPSA id h2sm4276184wrv.87.2018.12.18.03.33.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 03:33:27 -0800 (PST)
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
Subject: [PATCH v4 0/6] media/sun6i: Allwinner A64 CSI support 
Date:   Tue, 18 Dec 2018 17:03:14 +0530
Message-Id: <20181218113320.4856-1-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This series support CSI on Allwinner A64.

Tested 640x480, 320x240, 720p, 1080p resolutions UYVY8_2X8 format.

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

Note: This series created on top of H3 changes [1]

[1] https://patchwork.kernel.org/cover/10705905/

Any inputs,
Jagan. 

Jagan Teki (6):
  dt-bindings: media: sun6i: Add A64 CSI compatible
  media: sun6i: Add A64 compatible support
  media: sun6i: Update default CSI_SCLK for A64
  arm64: dts: allwinner: a64: Add A64 CSI controller
  arm64: dts: allwinner: a64: Add pinmux setting for CSI MCLK on PE1
  [DO NOT MERGE] arm64: dts: allwinner: bananapi-m64: Add HDF5640 camera module

 .../devicetree/bindings/media/sun6i-csi.txt   |  1 +
 .../dts/allwinner/sun50i-a64-bananapi-m64.dts | 65 +++++++++++++++++++
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 25 +++++++
 .../platform/sunxi/sun6i-csi/sun6i_csi.c      |  6 ++
 4 files changed, 97 insertions(+)

-- 
2.18.0.321.gffc6fa0e3

