Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9D1C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62371218A3
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Lyq5RsbF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfBFK0F (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 05:26:05 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55757 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbfBFK0D (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 05:26:03 -0500
Received: by mail-wm1-f68.google.com with SMTP id y139so1844364wmc.5
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 02:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L5/ZatHVS6k0zuueuC+fG2FGCCYEwoOCEErHC/rO77Q=;
        b=Lyq5RsbF7EAsvL/qiDGSlS1lxDxmuXawb5SyP7lV9OUP9XqW6rzjKZEti8vCymXI72
         tF1txbxtfEzLZlMsf5C1jCXkLQrzPKePj44IjVj+cbuNvHsIIu+1V5BPhUrHZmqiSMux
         DP+4xqlZgSqvVsbqhvVw7eVyO28kUCGLuGVD+mWOpNWstEWv8xhWUd0Zmqv25bFJVz5N
         3Ya5ZOCHjQae2plkqahqf4VwIAsopN+dPnQ3gomTCuoNfpFEmEHdfDoJOAxNrj7DDKDl
         tX9XjbBu8TqluRI0QMWUAD2ktOKtSkzx0E1yTLNi4BrbO663Ipzjl/UegeNeqjmuJsnc
         XhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L5/ZatHVS6k0zuueuC+fG2FGCCYEwoOCEErHC/rO77Q=;
        b=PnnIxcQsoR1vAkCTxI85PYFFxXqPHMCDJiyRh22+zdWN8YqkF02eZEDdPb06XtBz2Z
         5UmHzSeJfHkIaWRKFpC4FumseNV3I4PzUPBYqVhODaP2r3QGwhHA09+gfw88GFV71naG
         Bj9tpvDjDGPvWwgUOeh689VChfUBwDQp+qZOEgr4Kn9JRK5+k+Fiukpr/yuKsD0u36rQ
         rUQIGfarc0CKywi7FyyPrCGsOa3d//E1eH/tFpC06JuXcCtjUhwRB+JJ+e0Tc1KL1mgo
         aoW0enggyk6eCYwv3NC5mWftHINcl2RPU3X6tXarvO+UJl97nTPVoes6Gn3UKQWDFCJU
         AB4w==
X-Gm-Message-State: AHQUAuY7efW2JV6OmpnB9gMms4Ohp/4ocQ6SW+Xwk+XLoBkJoMAal8KF
        ltwMICEaJZ/jGiAYrW8rEFOwUGwuinA=
X-Google-Smtp-Source: AHgI3Ibdw3SdDUXkLGT1l5Ugg7JvFaREajwbFOXRnRl2B9A6l202lXaeR2LN6QYarBK2syn6v2laPg==
X-Received: by 2002:a05:600c:2143:: with SMTP id v3mr1362503wml.120.1549448761453;
        Wed, 06 Feb 2019 02:26:01 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id i192sm18149631wmg.7.2019.02.06.02.26.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 02:26:01 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v13 06/13] ARM: dts: imx7s: add mipi phy power domain
Date:   Wed,  6 Feb 2019 10:25:15 +0000
Message-Id: <20190206102522.29212-7-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206102522.29212-1-rui.silva@linaro.org>
References: <20190206102522.29212-1-rui.silva@linaro.org>
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

