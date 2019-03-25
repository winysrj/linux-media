Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE484C4360F
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 17:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 805EE205C9
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 17:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="Fex4pV/W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbfCYRfI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 13:35:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44788 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729473AbfCYRfH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 13:35:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id y7so7073693wrn.11
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 10:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IXlGPOBwp//uKNJa434eOkLrClSnsgj56Ngvzlundr4=;
        b=Fex4pV/W8FZ7zM1+mvDX7aFNrxVQ0fvfVQ/tuyoMWe+HW2joBx8VPHo6PFe79v8bX2
         B93VcniUw1rX7zNw8KT408MKK4oNiS6OquFwPNqmpGyscjI2J60LYK1J6cYs4nqEdf/S
         kA40GYYZ/IRUSx5nMYE+6OrTH+kvL+2R1uLJPC95NP6Q6ssEm3fOGPUtTPtEpMHIOq/c
         2wSQFp3vaW020tM1wtDCDTmIJ+6wdF+PknWsuuoKErFcsgbxBwAmSB9vN6AXDAKBjhhj
         3/zV3TdrOuOkDnOfxcfIiVlBOJjwJnrNvqs1BP8qjudrjBbkkvoBYg+2+l+w/mOpEh1G
         JxTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IXlGPOBwp//uKNJa434eOkLrClSnsgj56Ngvzlundr4=;
        b=t6Ac17SlbGDUpWKiZHnjRNTc3Rls6Xu53w2RMJh1Upvv/wdk2zYACCEZrWpvtR1Dv7
         55ipNMQzSNKXBxoZoMK1xpMWdtOEL2pS5n7FzbzV4rBQ3BMZ+MnpVTu13D390ISqeQPS
         RQe5HHdZjrZB2jbqg+4dJLrn7qC8hgHimd2qtdOgvIV7ee8z17tK7Mhdx7XAU/Doo3Mk
         p0PcUpcVuuon8btRRClGxZYmpJrgb8SC/nv+wisr+XSvMsJmVMPJCrF4JMLOSVJPg/yN
         wXZBXUmGwK7+ea7TCEKUhL7SI+gt3yNkJFU5KgJwAKQMzaF1hlTrdIQVe2IIzbxKiNO8
         3CIw==
X-Gm-Message-State: APjAAAVHR6B9j6+ru1nJLbbnUuatmYQmpMmbC7lpLovSUBY+aUCbCRAI
        G+ZngmYuM9W6hWJzeDqEPjj2nQ==
X-Google-Smtp-Source: APXvYqzIEKV0+Wttnn+Y6TxMdCzyreipXSORa22STjIeFFmPStP6jn1djkcf5aOlJP1npioffi3IPw==
X-Received: by 2002:adf:eb84:: with SMTP id t4mr17732631wrn.100.1553535305536;
        Mon, 25 Mar 2019 10:35:05 -0700 (PDT)
Received: from localhost.localdomain (176-150-251-154.abo.bbox.fr. [176.150.251.154])
        by smtp.gmail.com with ESMTPSA id o15sm16003227wrj.59.2019.03.25.10.35.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 25 Mar 2019 10:35:05 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     hverkuil@xs4all.nl, mchehab@kernel.org, devicetree@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] media: dt-bindings: media: meson-ao-cec: Add G12A AO-CEC-B Compatible
Date:   Mon, 25 Mar 2019 18:34:59 +0100
Message-Id: <20190325173501.22863-2-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190325173501.22863-1-narmstrong@baylibre.com>
References: <20190325173501.22863-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The Amlogic G12A embeds a second CEC controller named AO-CEC-B, and
the other one is AO-CEC-A described by the current bindings.

The registers interface is very close but the internal architecture
is totally different.

The other difference is the closk source, the AO-CEC-B takes the
"oscin", the Always-On Oscillator clock, as input and embeds a
dual-divider clock divider to provide the precise 32768Hz base
clock for CEC communication.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 .../devicetree/bindings/media/meson-ao-cec.txt    | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/meson-ao-cec.txt b/Documentation/devicetree/bindings/media/meson-ao-cec.txt
index 8671bdb08080..d6e2f9cf0aaf 100644
--- a/Documentation/devicetree/bindings/media/meson-ao-cec.txt
+++ b/Documentation/devicetree/bindings/media/meson-ao-cec.txt
@@ -4,16 +4,23 @@ The Amlogic Meson AO-CEC module is present is Amlogic SoCs and its purpose is
 to handle communication between HDMI connected devices over the CEC bus.
 
 Required properties:
-  - compatible : value should be following
-	"amlogic,meson-gx-ao-cec"
+  - compatible : value should be following depending on the SoC :
+  	For GXBB, GXL, GXM and G12A (AO_CEC_A module) :
+  	"amlogic,meson-gx-ao-cec"
+	For G12A (AO_CEC_B module) :
+	"amlogic,meson-g12a-ao-cec"
 
   - reg : Physical base address of the IP registers and length of memory
 	  mapped region.
 
   - interrupts : AO-CEC interrupt number to the CPU.
   - clocks : from common clock binding: handle to AO-CEC clock.
-  - clock-names : from common clock binding: must contain "core",
-		  corresponding to entry in the clocks property.
+  - clock-names : from common clock binding, must contain :
+		For GXBB, GXL, GXM and G12A (AO_CEC_A module) :
+		- "core"
+		For G12A (AO_CEC_B module) :
+		- "oscin"
+		corresponding to entry in the clocks property.
   - hdmi-phandle: phandle to the HDMI controller
 
 Example:
-- 
2.21.0

