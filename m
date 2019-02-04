Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA6CC282CB
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FA072176F
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="NS/ePAti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfBDMBH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 07:01:07 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34396 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729163AbfBDMBG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 07:01:06 -0500
Received: by mail-wr1-f67.google.com with SMTP id f7so14182333wrp.1
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 04:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PZIgvxbRSp4W/ltSJos2CgWWjWg2sGcAUX9XqZxaGQg=;
        b=NS/ePAtinqe7M6NXcLZCe9uQ5PNTdh2wfE4nHR5O5kp9yrRudEyokTb6dxR/sDjZZq
         rKBrJo2tjNYBXHR56QFypgDJcuRO4ru0ACX8ksD9Ef1ttSSWKSF/to9xSYbtsb6lYLzA
         lXenMQcIm22J9iDAiCaVTozqjgPtc7jOzaIHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZIgvxbRSp4W/ltSJos2CgWWjWg2sGcAUX9XqZxaGQg=;
        b=jYtQsGO3LHuElYTwWNEc3Yf80h8SbyzA5L7E6Yrui3kaKmF+A/qGAjWiEEDyQOUvjI
         0l0n8VeZOrz/x8ZbB9ER58JFmiAZiAeXloMg1V/O6jQeALmK/U36vri52ZE/2MWISBSl
         0cpAODRbeKmhgBnKKvMDxAJTZ2GjEZ+uB0gDlcaLT3mhw6WC6mMM3W0sTBQD+UJ3jr5x
         TT6yqibopNjmpQF+4nUJvoixI/A4tYehIo4WTexIIsaKqTytqt4fOhKcuWsTeAu4FBif
         vrnJN8H3rGcRGrTSmifAd8mnwZIGPLjVZ2uJtgANyVj8yy4WbeVuxkS1MrSVYd/S15vT
         b5Ww==
X-Gm-Message-State: AHQUAuYFjLGDqRAm+8Q6PCWRnTwZT3VbCymGD4IIfTwyCd+4DsFBJFoy
        +OS9Vc2hUKmRdEhdYwxlt0Oy2A==
X-Google-Smtp-Source: AHgI3IZVfFoSQEBatcQfl7T1CtjzDVwJeP7jYodyhcKajQ2U/NpElPyJrZABLQOt8AW3R3iH5wtKKg==
X-Received: by 2002:a5d:528d:: with SMTP id c13mr111690wrv.153.1549281664595;
        Mon, 04 Feb 2019 04:01:04 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id s8sm15404543wrn.44.2019.02.04.04.01.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 04:01:04 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v12 07/13] ARM: dts: imx7s: add multiplexer controls
Date:   Mon,  4 Feb 2019 12:00:33 +0000
Message-Id: <20190204120039.1198-8-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190204120039.1198-1-rui.silva@linaro.org>
References: <20190204120039.1198-1-rui.silva@linaro.org>
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

