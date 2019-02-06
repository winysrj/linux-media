Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4833FC169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13DD22083B
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r4lDcVNT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfBFK0G (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 05:26:06 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39222 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729393AbfBFK0F (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 05:26:05 -0500
Received: by mail-wr1-f67.google.com with SMTP id t27so6894452wra.6
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 02:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PZIgvxbRSp4W/ltSJos2CgWWjWg2sGcAUX9XqZxaGQg=;
        b=r4lDcVNTjvknTqzUaXnaOuK0xVjaXCSPSujK0IQCcAnfEQGfhxxYS0/d7w/mlgOY7i
         zZ/qAWx70TM+cXmUNRHqEztfHGCN6b/8gyhqMmKDtatdD6YUf1pDSaE3rtCYdVWqtRVo
         AKYrlK5kuzvmXRBhiy8xq1S/eZq6FQS5wZaH6Q6x3HtYujMt8ii7rUlOEYTAIY9EVFWq
         MEzgZE3uCasYiFQNgJnJIxEMMfvjk0uFtudiVIeUfCgCfYsD9n3s07iu+gsO3rg7IoXv
         P1DY6uKvmSPh6eCSWD/7xjDlYsLuklrlvFMM4HMvdCyCS+1UR1b/Z2CIF28Xjm5V3zYH
         Fhmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZIgvxbRSp4W/ltSJos2CgWWjWg2sGcAUX9XqZxaGQg=;
        b=LL5xmiyJBJzoKkNXNGzJ+C+GP8wuWYOuw05rnnBLFciUB/2JivxyjtEV2esq+zDhtS
         quMwBFcmk7EcEhgqtP42CHhJFjylCqmrRYYX/V1dy8qcSI8s/B/sCzR5YwjRWjOzmGi8
         nsI6GdBiUAQ1j1nM9XKFy11qCY5bc9ilBoKATpeb+4vw4fD9Eu+v0IB9JkSXL9sBFDBK
         CRRsjuAiMlchCHI2hTdL35Z85JupPBXHZdkD9z7zs7aLB9S0ygRwmOMmOK7qjOBcyiVy
         KMLUPii7m8AhB14qQavXF2sAir9MytL9DSpWcjkY2zhUTokTuxT9iyoMERmbQR9oNHr2
         v6Eg==
X-Gm-Message-State: AHQUAub+WSjGf4UmnDzwx4IBxIofBzdeLS0cDDX2Guy+NMBuGscf4AZ5
        EArptKAf73ThP3efbSt8jfXwpA==
X-Google-Smtp-Source: AHgI3Iajijs8lhilxyX+9vrxQ/2A55H3NsNUp6as+qDuiyJcsUmNgZCm5IMliguAFGnKVip8N/qX+g==
X-Received: by 2002:adf:e589:: with SMTP id l9mr6988959wrm.312.1549448764101;
        Wed, 06 Feb 2019 02:26:04 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id i192sm18149631wmg.7.2019.02.06.02.26.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 02:26:03 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v13 07/13] ARM: dts: imx7s: add multiplexer controls
Date:   Wed,  6 Feb 2019 10:25:16 +0000
Message-Id: <20190206102522.29212-8-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206102522.29212-1-rui.silva@linaro.org>
References: <20190206102522.29212-1-rui.silva@linaro.org>
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

