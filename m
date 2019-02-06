Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B961C282CC
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B8812080D
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YAeKfhAD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbfBFPNw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:13:52 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44644 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731152AbfBFPNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 10:13:52 -0500
Received: by mail-wr1-f68.google.com with SMTP id v16so6095562wrn.11
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 07:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L5/ZatHVS6k0zuueuC+fG2FGCCYEwoOCEErHC/rO77Q=;
        b=YAeKfhADmypgb/8xs1wtPchw3LdqgFpj2lLbQ7IWiWFTigqjze2tJm+FLUBmnAhSS3
         P4V4yvKyBgCw3pf8tBExKS1CAQlnECfdRTDfCX6/wJITlQu7s865IXU1sNY7I4VkZSo7
         oGALExIjyTdJ+KM5QRqdyylL1ZvdPYjdf2fYz/U7/VZtLYt95JDMYry1cTQBFyD7iSc5
         wM0fgh4bPzDI4HVwYPD0aVvi7Axnp4E/qdT5fyTJZJnFP8Vos1IG8XpmUXK5eSZy4C3f
         P4bQSWD/Y8idPj4m3VAiofC1KGA3ceNEw1J1maj7wtS2kYEKVJtdSmASLmHdMOVYmAMw
         HfQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L5/ZatHVS6k0zuueuC+fG2FGCCYEwoOCEErHC/rO77Q=;
        b=lAFgMxPSVB1AFkCvmFJTyvKYD8DYWxt8lINwHrHoA4QqjdZjUvKxUftRnKrrWGicno
         0y5Areb2y1jlC6tJ3bSYAjFnlg9eSmK4uItPNnFTKYy32/xhdMavoUbWTR2Aa6RWMCpX
         D+Av3odJIPYl0MSNsCGl9UDEyuQ0JWLcVtjeT9X1k0Es8AGy16n2MN9SoVGK2uwFm4gO
         7dLxxFDVL5wcq+i5dPA/QG2aflb6r/50T1PMkY4GYhP6wkkU2hrJgR5NUkNzbMOC1BMp
         W0RivyUtB7fobZRfT6uE6QCH+3Q6ulvUwuX1QIIznymynEW7ZXWmELtWu5/+bmFs3cN8
         KmLQ==
X-Gm-Message-State: AHQUAubJw2M3injiUseilRwT4RLbSsEayuRU+b9n8twLu6jhPpcXeJdR
        MeNu8+8SBygHEab8c3JaOD5YPw==
X-Google-Smtp-Source: AHgI3IYwDOvYRvoIVcHHdMYmZdFV0G7GBoyTALzK3NWWg9fPK/Nlhg3nyIPD6cUQZwBL7uXZN1nCPA==
X-Received: by 2002:adf:c505:: with SMTP id q5mr8155580wrf.84.1549466030285;
        Wed, 06 Feb 2019 07:13:50 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id f22sm11207836wmj.26.2019.02.06.07.13.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 07:13:49 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v14 06/13] ARM: dts: imx7s: add mipi phy power domain
Date:   Wed,  6 Feb 2019 15:13:21 +0000
Message-Id: <20190206151328.21629-7-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206151328.21629-1-rui.silva@linaro.org>
References: <20190206151328.21629-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add power domain index 0 related with mipi-phy to imx7s.

While at it rename pcie power-domain node to remove pgc prefix.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index e88f53a4c7f4..9a680d3d6424 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -606,7 +606,13 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					pgc_pcie_phy: pgc-power-domain@1 {
+					pgc_mipi_phy: power-domain@0 {
+						#power-domain-cells = <0>;
+						reg = <0>;
+						power-supply = <&reg_1p0d>;
+					};
+
+					pgc_pcie_phy: power-domain@1 {
 						#power-domain-cells = <0>;
 						reg = <1>;
 						power-supply = <&reg_1p0d>;
-- 
2.20.1

