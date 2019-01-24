Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF16C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0080218AF
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="YdDWcSws"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbfAXSJC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:09:02 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41381 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbfAXSIS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 13:08:18 -0500
Received: by mail-pg1-f196.google.com with SMTP id m1so2989368pgq.8
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 10:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aLdT+u4Gxzzx90j2NuIsLStcS5jPDAhiHJriLgQ53lI=;
        b=YdDWcSwst38VE/NhrrMoRhY7ccNdzKffPGiIoiwy2ZkaVL05lQGL4t/n/xBe4XURAL
         GLxYPbhv3Jmo6IeoeDRasUdiQlB5ygpzp3fqTeQZUcO6WqjHOsaejwGnzpeZf8bnCOzV
         AEhcp2y7uSicfcsG8fDuI6spNYWzNCqRfsycw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aLdT+u4Gxzzx90j2NuIsLStcS5jPDAhiHJriLgQ53lI=;
        b=s9iedsVmKzfeTb6nA9Ew2hrY9ouZtypxcNPQ7D/GHy7pzfyHTuJTZTMa4wm3eZ/8x7
         szcKBo2mvEyhVfEN43xaCPuOiBCWUZvVyK4Jdf0KuoOaJG8Gn6rxq1zPg5+VgfYVc35e
         8gDxHZOsuLFYcvBF+jJyytrjueAqqdl6iunxdfF9+3LApKYMkOgXco5GEVJ7yUR3it1M
         FxM9ZmOLhA/5roxWdFLpvzYYgZsZbwLgnRwafo5IJBqe2dpYEiy7mJpLtw36RdT1fF58
         52BWi2DlZpgRUJRSFNB9atBpyM/EroUM0RehzPJbhzyHp6ufkw3/b2SMQ18e8YXMc5O7
         nLzQ==
X-Gm-Message-State: AJcUukdJd0GmgUcsyDa68NryWFbc6OBoDB3tV282Boe/ruX+On5jdi3x
        tBnPJZWn0R09xddOSYm9BK/y5g==
X-Google-Smtp-Source: ALg8bN7BikrYw4LzC4CV4SwXTjP19kXInmHQpg4bu9ttD9uHyCnZPQF3ok+cTLCp/iPcmFW6LLWAwg==
X-Received: by 2002:a62:a209:: with SMTP id m9mr7636807pff.218.1548353296431;
        Thu, 24 Jan 2019 10:08:16 -0800 (PST)
Received: from localhost.localdomain ([115.97.179.75])
        by smtp.gmail.com with ESMTPSA id k15sm36141551pfb.147.2019.01.24.10.08.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 10:08:15 -0800 (PST)
From:   Jagan Teki <jagan@amarulasolutions.com>
To:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Jagan Teki <jagan@amarulasolutions.com>
Subject: [PATCH v7 0/5] media/sun6i: Allwinner A64 CSI support 
Date:   Thu, 24 Jan 2019 23:37:31 +0530
Message-Id: <20190124180736.28408-1-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add CSI support for Allwinner A64. Here is previous series[1]

Changes for v7:
- Drop quirk change, and add as suggusted by Maxime
- Use csi instead csi0 in pinctrl function
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

[1] https://patchwork.kernel.org/cover/10771163/

Any inputs?
Jagan.

Jagan Teki (5):
  dt-bindings: media: sun6i: Add A64 CSI compatible
  media: sun6i: Add A64 CSI block support
  arm64: dts: allwinner: a64: Add A64 CSI controller
  arm64: dts: allwinner: a64: Add pinmux setting for CSI MCLK on PE1
  [DO NOT MERGET] arm64: dts: allwinner: bananapi-m64: Add HDF5640 camera module

 .../devicetree/bindings/media/sun6i-csi.txt   |  1 +
 .../dts/allwinner/sun50i-a64-bananapi-m64.dts | 65 +++++++++++++++++++
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 25 +++++++
 .../platform/sunxi/sun6i-csi/sun6i_csi.c      | 13 +++-
 4 files changed, 103 insertions(+), 1 deletion(-)

-- 
2.18.0.321.gffc6fa0e3

