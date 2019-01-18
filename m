Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43450C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14A7B20850
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:33:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="YPCZUcup"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfARQcK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 11:32:10 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43615 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728372AbfARQcJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 11:32:09 -0500
Received: by mail-pl1-f194.google.com with SMTP id gn14so6564746plb.10
        for <linux-media@vger.kernel.org>; Fri, 18 Jan 2019 08:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VJQVSYfjj+xbs/VVNFWJJ8UsMZ+mUtGQYZPt6JxkRhs=;
        b=YPCZUcupuz6x1zsmyyY3R6FK69GK1DwjQA9sJZHuZ6X9U16wbhVBAz6O7Crk93VXa9
         sq9HNEYM6X3+d28+ESDNVlesMNSaaWyzqc1uklue7DIMUUyOwYu0vl5SP4Nb+I1pY0sz
         0HYQ7Tb+vUrzzKrMmnUDq2Po3jzuzP4nUR4cc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VJQVSYfjj+xbs/VVNFWJJ8UsMZ+mUtGQYZPt6JxkRhs=;
        b=UHQ3qdfXhj0XtbqisgFX4CB2DQcbA5pVCDlgw0BfslDHjWUk7zhQr+7yWSg2wZssF3
         Pi439DZ7+VqxZeJZ4dda4gO0HTthXz6n1EjDrYI9I3PuDe+9ypTVujJdumpWanxA8uoe
         Vc/KMUKwbfPFYzw0sCSsiQnrqYN+QDkOLP/NviskCOf8xG9Tn1ji4QsV6k8UVqd12LsX
         tOuK4d/vIag1uONd3ksc9Zn4phrF8mT+kKnPdpZKbyzYua0h4Ve/H3KZ5z6O0p4Q+ixi
         /lb0KGZyi8eq1KI2rFqIcJwtNfpixw6eWwPoF0x1gqTsoe70KB6w7oPnI2UYAR8uKrEv
         pZnQ==
X-Gm-Message-State: AJcUukeYh7spOw18zu2IO0sWz3Rf4Nazy6eNXR1HIq0Cpcs7e+UwHaGH
        wNrdg7wysLu3LNwhr2eZt4Rdww==
X-Google-Smtp-Source: ALg8bN7p7RQXpMtYRpMmmnAWrcYEqtZTyPQ09dQsUPhIA0d/o9rQIj6+kab6ufgEJkQSut3svZt41g==
X-Received: by 2002:a17:902:4:: with SMTP id 4mr19958908pla.20.1547829128741;
        Fri, 18 Jan 2019 08:32:08 -0800 (PST)
Received: from jagan-XPS-13-9350.domain.name ([103.81.77.13])
        by smtp.gmail.com with ESMTPSA id z13sm13967086pgf.84.2019.01.18.08.32.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 08:32:07 -0800 (PST)
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
Subject: [PATCH v6 0/6] media/sun6i: Allwinner A64 CSI support 
Date:   Fri, 18 Jan 2019 22:01:52 +0530
Message-Id: <20190118163158.21418-1-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This is v6 set for previous version[1] series to support CSI on Allwinner A64.

Tested 640x480, 320x240, 720p, 1080p resolutions UYVY8_2X8 format.

Changes for v6:
- set the mod rate in seett_power instead of probe
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

[1] https://patchwork.kernel.org/cover/10738841/

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
 .../platform/sunxi/sun6i-csi/sun6i_csi.c      | 31 +++++++--
 4 files changed, 118 insertions(+), 4 deletions(-)

-- 
2.18.0.321.gffc6fa0e3

