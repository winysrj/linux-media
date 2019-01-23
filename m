Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCC5C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6D8C20861
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:53:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="gI07MRMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfAWKxD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:53:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37709 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbfAWKxC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:53:02 -0500
Received: by mail-wr1-f68.google.com with SMTP id s12so1863626wrt.4
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PZIgvxbRSp4W/ltSJos2CgWWjWg2sGcAUX9XqZxaGQg=;
        b=gI07MRMZ38Q0EFDhZ3LKRqk9tDUhlMS2MoqS31K55ynwl+sQObP4Sv2/R6Qcocy8FC
         B12IZ/L2+/QydtfZSqFXK1Nz/SNPdEuMNXEHK/8QOcQXYxumC6RJgQjpvqRZ3WNXcyKO
         ra1mAxpAGZpa151ad1+Zj0WFhLzhedcD223fM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZIgvxbRSp4W/ltSJos2CgWWjWg2sGcAUX9XqZxaGQg=;
        b=aHntztokhqNfQjwMOYHCiL67F6nGMJ8npsyLTz5ucipr2iYLChzmWcaYqzdNK8Whuk
         QSxwsEwn/gIuuncRZ6LYQALNXDPtOgqIyFZyZxvHvoxRw+73H0ihpaf79EfdEo86H5ai
         z349EtckiSgPB62jxd5gmUCNSFND5shSEwtz2NtPVrYVroTIf1pAv4Xu3Sm3Ri3ZT8TC
         7WnNs1bheBfDrmiPxKchb1VLfZhrVNFpTG9Ed94zuiRilxRXmuVoSZ7M5cSHGr1GKVEq
         5CxKzj9q/3paqzs7/KI1QslvlBCPTE+wmQhLmvDSuhJM4Evrnx3BLzV1Dj/gcqO6mk9q
         lCNA==
X-Gm-Message-State: AJcUukd7yVWopUktw789ninJyuzjGEwKqbdan/90U0H1AV3j4/tBz8+j
        7mSZIGRLLplsbYonYqSluzxM1w==
X-Google-Smtp-Source: ALg8bN72YnTr+bRwu1ejjwXZ4lZZ3j66Wp3nJlhNw7TCx6MlMX7sNl0/JxuPvqBstjVk+p2jh9p1dg==
X-Received: by 2002:adf:fd81:: with SMTP id d1mr2191466wrr.105.1548240780763;
        Wed, 23 Jan 2019 02:53:00 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id 143sm120717646wml.14.2019.01.23.02.52.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:53:00 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v10 07/13] ARM: dts: imx7s: add multiplexer controls
Date:   Wed, 23 Jan 2019 10:52:16 +0000
Message-Id: <20190123105222.2378-8-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190123105222.2378-1-rui.silva@linaro.org>
References: <20190123105222.2378-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The IOMUXC General Purpose Register has bitfield to control video bus
multiplexer to control the CSI input between the MIPI-CSI2 and parallel
interface. Add that register and mask.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/boot/dts/imx7s.dtsi | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 9a680d3d6424..792efcd2caa1 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -497,8 +497,15 @@
 
 			gpr: iomuxc-gpr@30340000 {
 				compatible = "fsl,imx7d-iomuxc-gpr",
-					"fsl,imx6q-iomuxc-gpr", "syscon";
+					"fsl,imx6q-iomuxc-gpr", "syscon",
+					"simple-mfd";
 				reg = <0x30340000 0x10000>;
+
+				mux: mux-controller {
+					compatible = "mmio-mux";
+					#mux-control-cells = <0>;
+					mux-reg-masks = <0x14 0x00000010>;
+				};
 			};
 
 			ocotp: ocotp-ctrl@30350000 {
-- 
2.20.1

