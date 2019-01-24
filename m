Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AAEC282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F71F217D7
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:09:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="I1gg/fj6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfAXQJx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:09:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37372 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbfAXQJx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 11:09:53 -0500
Received: by mail-wr1-f65.google.com with SMTP id s12so7091740wrt.4
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 08:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PZIgvxbRSp4W/ltSJos2CgWWjWg2sGcAUX9XqZxaGQg=;
        b=I1gg/fj6wSkjMVbnQV3f/voVph+RSRA53helsBqtCoHeH+Bv9mhb63ryrfZbqgZy+P
         xKAJ/OdM7UgPK+2mIz5vBdUpJWJ9TPkT0Po1sy8t8ehGoVrv3I+D0BLKJJJ7vdP89ysB
         bS2aR3jgg8txDl30LX7XDnO1Km8ILfyMxpz0k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZIgvxbRSp4W/ltSJos2CgWWjWg2sGcAUX9XqZxaGQg=;
        b=mvz/Vrljeqhq7v9spmFFEFjH2VmCpnx1uy40+HZB43N9o1ShrBjB2T86dSqZTDsMPK
         8arUbVUA0wCNk86hUGUOg5+9KoWH0pU3ejMZVYhwVYj57QES3cjO3mM8kDMOEAxMFDSg
         cX/dQElP0DokKu4+2P8NYkn82Y3P90Qhakn4ODyfd/JRAEzL3Gwm2dfY8Omem0a4BFAc
         tOPlc4SgB43dQ2p2kytB8wIokzIVyj0GPo6d2uJgJVLODbH1o3xhWDPN7hLMNcDtK4Y6
         Jl4OQAMJFeu2rcTe3myrElz5vjL6HoWMYoyuU5gvjrGoufwMDkBZHgHD/NobedjBguWj
         PEkQ==
X-Gm-Message-State: AJcUukfEF1UzqC2bFxYLTEwXs2Xg3PIBCKezLXgSQvq/Z6iweb/ZnqhJ
        5ROmLJfBnDr83FFd//pxOZCnYw==
X-Google-Smtp-Source: ALg8bN5OHkNzCoKHC3pV6FqRVF99YBU+n3LcBq2GlReOzsStu+5ratHV8qYVaq/qZgvAigu3TBXqUA==
X-Received: by 2002:a5d:4ac7:: with SMTP id y7mr7425811wrs.196.1548346191386;
        Thu, 24 Jan 2019 08:09:51 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id e16sm179880299wrn.72.2019.01.24.08.09.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 08:09:50 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v11 07/13] ARM: dts: imx7s: add multiplexer controls
Date:   Thu, 24 Jan 2019 16:09:22 +0000
Message-Id: <20190124160928.31884-8-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190124160928.31884-1-rui.silva@linaro.org>
References: <20190124160928.31884-1-rui.silva@linaro.org>
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

