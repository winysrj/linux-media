Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47651C282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BB5721872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:09:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q7yhwyyA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbfAXQJv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:09:51 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37547 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbfAXQJu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 11:09:50 -0500
Received: by mail-wm1-f67.google.com with SMTP id g67so3644271wmd.2
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 08:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L5/ZatHVS6k0zuueuC+fG2FGCCYEwoOCEErHC/rO77Q=;
        b=Q7yhwyyAuw1c7ZY59acJyn5odzaO0GdpchyyN5ZAfN5MSRkIvRpXnyB4YURj13bCIA
         wmsrAggdx+QNoGsVo/uKHA5U2ZYjWjfdE9pD8JAxAp5TK7mvKWAFHrXpc6k8YV4itW4i
         UAmVjqsDP50DOlpQeFlOwVbaFBZvfwyJzfoQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L5/ZatHVS6k0zuueuC+fG2FGCCYEwoOCEErHC/rO77Q=;
        b=n/IPck2rp05IbmZI4ZZhfp+wKikkA4H+NKpHh02CYKPMWVNkOv+sDtzXQ2Ic9hRUPE
         BLnxLwuVxJpuhjdqO81eiovnq48ygqvY6CHrdJBaImbcifBJd0B6SLGXXf8sZ12FrM2m
         OHeonSwNjaHoMYlhaoyYiX9gPL8DFVCQ/oVolyBKenIk6uOTWhXLQbLmN/5VF/9RtXXy
         SkSmX4LDzeAK6B0+B1q9p2qIDn0DzkwCDlZo3hZ/hcNf4s4uDxz93Nqay9BqfLEPNsOM
         +jwUfF2NY2gFfHwT3c/jg2KMfhc4XxkFcJijc20j7qjRUoe6Jt7uAkyG5jDmg5wYyN3F
         BdGw==
X-Gm-Message-State: AJcUukc0lUyt7Vk/kKloAAlwN8Yr7aq0FNwA6ZNcecgtSTFnqWHv1Use
        b4borS1ty6ZCVqVoMRjrcLJUmQ==
X-Google-Smtp-Source: ALg8bN7hZ8Wi5VBtew7bTj1lj43x4RQJzT5mC68r3JgEAyawSra571AgkmHnQn+PeyuNhJIusJOiuQ==
X-Received: by 2002:a1c:de57:: with SMTP id v84mr3233672wmg.55.1548346189333;
        Thu, 24 Jan 2019 08:09:49 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id e16sm179880299wrn.72.2019.01.24.08.09.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 08:09:48 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v11 06/13] ARM: dts: imx7s: add mipi phy power domain
Date:   Thu, 24 Jan 2019 16:09:21 +0000
Message-Id: <20190124160928.31884-7-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190124160928.31884-1-rui.silva@linaro.org>
References: <20190124160928.31884-1-rui.silva@linaro.org>
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

