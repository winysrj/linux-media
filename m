Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59585C282CC
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C09A2087C
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="kn0SQuZI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfBDMBI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 07:01:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36318 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbfBDMBH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 07:01:07 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so3047314wrv.3
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 04:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L5/ZatHVS6k0zuueuC+fG2FGCCYEwoOCEErHC/rO77Q=;
        b=kn0SQuZIs5vQzTpREr1NTHPhA5vzQSCnzhCCKgBJxYj97M9xuEV8W1wbXZdrqmnQN/
         qKVqS5AnCTojJ8Nb3G4t1ZjPNDQOcQgvZ2qklPYccmnXRJK19xIVLs73Jzmh2u+2HHHj
         OmudQa9Jqa5btOg3yvzGYhTLsHIy0vVtcvCc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L5/ZatHVS6k0zuueuC+fG2FGCCYEwoOCEErHC/rO77Q=;
        b=nG8nnak4Nf0hfaHj9XeynndWtLPev+yYGFyaCCOz9qGSz/Y1Epy7NoI6mm/MXEAorA
         jIsoprAldBgvfHvQVjBY84Oj+uvmpGxnCNvWeV2qq2Y8lBNeDMQY7+/jsAOizPPTz90S
         ZXW4dAzS13LAj8rb+VlQoYX6NUvtWDX981sVk4lxng6kJwvLkaNKXk5Tubr/eDq6YUue
         +nmGx/t55f5S7k0qIx1CzPGce9VwJf0osyKzQ2FOYa724fN1ChaYA6hK4MXDZOgKHH6b
         p0ci/MpWN3s4SClPOPS10TEOB1vyIXRR/p3FHCdu5+hBTHnthAMbCiAphMTzIkEYqD16
         1Yig==
X-Gm-Message-State: AHQUAubuDsfnqJ6/K3+DD5YycPudNaU3huOemIOdt0GQRMXIt3s16s7s
        oTX5c5a7j9f8/vZMOR6EnCCbQw==
X-Google-Smtp-Source: AHgI3Ib7R21CzXzBKyv5QlRvex+T2lIk73ZK+67MCTWhFTxINrbkERlzwlRvz3h10kCqBBrsjENMhA==
X-Received: by 2002:adf:df08:: with SMTP id y8mr1129541wrl.23.1549281662756;
        Mon, 04 Feb 2019 04:01:02 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id s8sm15404543wrn.44.2019.02.04.04.01.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 04:01:02 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v12 06/13] ARM: dts: imx7s: add mipi phy power domain
Date:   Mon,  4 Feb 2019 12:00:32 +0000
Message-Id: <20190204120039.1198-7-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190204120039.1198-1-rui.silva@linaro.org>
References: <20190204120039.1198-1-rui.silva@linaro.org>
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

