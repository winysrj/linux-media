Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A95C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 041BC2080D
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:13:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LkN+Kb7F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbfBFPNz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:13:55 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45520 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730099AbfBFPNz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 10:13:55 -0500
Received: by mail-wr1-f68.google.com with SMTP id q15so7909433wro.12
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 07:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PZIgvxbRSp4W/ltSJos2CgWWjWg2sGcAUX9XqZxaGQg=;
        b=LkN+Kb7Fur06Ajase4MCvAu4Vbra/Kwr+LiU2KvoGcW8OVevSCcvo83bFwQuOB2ZPE
         vCauKlVpKhEv+jE7LqCkMKvDkLuZXehna8VH2TMBp7c89pU1DvOBZ27RRp48CZija2sp
         BTMyKEZlqYVf+2NvUyXde3U3gWM0pKik4gd/ThA7QpZSEDpKvBS7fEx7jRb86IGkoegZ
         WqZMb2JhwVhe+CHX+PJpTcaKsx043UQP6ZUnO6sfOEU7UdKJvU8Kc8ePUMj2rhuEvpct
         g2PUDbXtgb1t0VBDcDDKv6ujdp48ftDhjaHQJTG/C+IXokw2HhM/SkgOJLi+u9xoFCaq
         UGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZIgvxbRSp4W/ltSJos2CgWWjWg2sGcAUX9XqZxaGQg=;
        b=OxmF5kqaTJ6A4ldjm35jmRDJC+oUCmDnEnKusuQkY3cjfF1QMlhNEuNquvdYTwBx8q
         0aQastSUCj5H7MViPXhjNBkURPVpJTaM9C3IP8GGgdO72mnF2VIX9TfwDV1mRXfO7nHk
         Y//dO0qEeWFv9vjAIvJAnrgJgDK5Ikzgfl1DRmcgBeaVNPxXE15dMOEgcdI8gU9mAf1V
         kdf/e6y85pzA8uaj1eld9kS5wmwjakV1oGimjCwaZnHOOrkDJyEdEjxwLdtr3Zi1hGnt
         9sdAVRDpTwcLH4EyI3UH7LaO1TmbPDDZsQFP5rYj39nuJDiyu1/+GuvQwDs+sJjS2qjk
         JH7w==
X-Gm-Message-State: AHQUAuZoBqs/YADA8RBisQLWK1EPCvZVBpflkCDZpS6pL7vlketQGYCJ
        pIg7+ZdQt8WhXbMtclV6iv2z9g==
X-Google-Smtp-Source: AHgI3IaNKvRqyP7P7xwtt5yjlhDZc8ELuUzbCcyfSiiBNFe7pr5nDzG+H4jmwT6E2QbF3bubc7mtcQ==
X-Received: by 2002:adf:c70f:: with SMTP id k15mr8246715wrg.155.1549466033639;
        Wed, 06 Feb 2019 07:13:53 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id f22sm11207836wmj.26.2019.02.06.07.13.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 07:13:53 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v14 07/13] ARM: dts: imx7s: add multiplexer controls
Date:   Wed,  6 Feb 2019 15:13:22 +0000
Message-Id: <20190206151328.21629-8-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206151328.21629-1-rui.silva@linaro.org>
References: <20190206151328.21629-1-rui.silva@linaro.org>
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

