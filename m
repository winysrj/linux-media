Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA7FC282C2
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB52020861
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:53:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="WArNDcBc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfAWKxB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:53:01 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34554 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbfAWKxA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:53:00 -0500
Received: by mail-wr1-f65.google.com with SMTP id f7so1886803wrp.1
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L5/ZatHVS6k0zuueuC+fG2FGCCYEwoOCEErHC/rO77Q=;
        b=WArNDcBczbN80s3h4ONU6lYVsZcXDqg0Iw2nLxwXnZY11KvLc46YyrmmG6M2QW1hXU
         ZrYLhBYy3bMBVGQrrvWRpsfi6L7BdzRL9qhT56syrmpzA3eny7iiw+P6NGfPHzHeIuMs
         vgutgcEmj1ZwM/qffRc/FDF2hwOzqz9qXVZuc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L5/ZatHVS6k0zuueuC+fG2FGCCYEwoOCEErHC/rO77Q=;
        b=Z0bLmfDU/9o2UspXjpSWP6XJZ/E8RLJo8vYmgCsQVsxYWsuAcp74DODf7NyLSk6uG2
         fcTVK5MPD86Sp/wJ77Dfnc19DsOrLSTg56Au+Ef7oVs/JOI9FpEtN4U30dsZaDQKzq70
         RkVjpVsB0knuyE/x5cksVF9ChYE5nG6MsF1zPyH3HoIAj8spUh6DBgW4rYqkHWfB+QEm
         +jcVJcvEoe0s/mB+U+MPmVtVaRM7qFmwqKn9ODcaGflliB13kyMN+yBiY5UbL9ED44b7
         DyjET3qsfrWMLw0groJZozsnIwoNXCC2IwVyqFxAnGvz3KwQiMZYohYiQPB8aPbTVECS
         Polg==
X-Gm-Message-State: AJcUukdAUze7Qkyawrxo5jftEJmL++vBoT6F/40ypie15CtxKNyp0dcz
        YG/t3Bbkzrf7fU2dyt6hgChD6Q==
X-Google-Smtp-Source: ALg8bN5aPu7OxLpMgQ0hUzMrrQFYlFHXmITYMI4vK2BDEjJ8YFbYW8Zbt6xlridUYni4SUsVmgE0bQ==
X-Received: by 2002:adf:f984:: with SMTP id f4mr2157968wrr.234.1548240778537;
        Wed, 23 Jan 2019 02:52:58 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id 143sm120717646wml.14.2019.01.23.02.52.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:52:58 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v10 06/13] ARM: dts: imx7s: add mipi phy power domain
Date:   Wed, 23 Jan 2019 10:52:15 +0000
Message-Id: <20190123105222.2378-7-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190123105222.2378-1-rui.silva@linaro.org>
References: <20190123105222.2378-1-rui.silva@linaro.org>
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

