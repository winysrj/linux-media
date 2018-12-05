Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E55DC04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24261206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vqljcg9/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24261206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbeLEPtT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 10:49:19 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39781 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbeLEPsz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 10:48:55 -0500
Received: by mail-lf1-f67.google.com with SMTP id n18so15085207lfh.6;
        Wed, 05 Dec 2018 07:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9L2+CVANdZAcHlH3j7zugmIYOp+Qy1cAg2SLh+SXYOo=;
        b=Vqljcg9/X5XMvKKqk1gZMEUyHr2uWAm8DQhvwQn0AH+dzwVQ1DucFwdLifgMaKXEce
         4syv101e+skm0a6Vm2ovzEhQYIQCt8iFSil2FI4mEbCwNWn8wvxe4ZX7sKXWRu9cRtva
         zpNgKO2zBfQx+Krjc2fySg2URI3x99UQbE/JmWWdHmt7+2PkdQe1geITHUYQrS6xm7rz
         EBGtw7LqtlUF8uTsixsbvdoEFPO7VIWF5XodXWlQ7TRMCf3gHleB2uenyWAm6wouf7jM
         tEbqrt39O+oSkNnWc16152kLZFgn+AHEMhvS2KlFKZCK2w1gEOzrnqAamCdpHexHdPVA
         untg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9L2+CVANdZAcHlH3j7zugmIYOp+Qy1cAg2SLh+SXYOo=;
        b=bg/NywASOd0c6WvQ5ZazOyz91dDPNJgh1WAgamV+QHZ2HdxtiUNpdAKgnqMbv8VShj
         H5B0525hk/FwX+KFHP1g7an5dhuxYDJ5A3++b8Tun2Ta61/+NEUIo7NWvooN4BBHSzdc
         lKhgxPmsiYquYlpVnIRVPhES0FJrjHsKVPVQ/QGbrw2FRfqxyKy6y263UiWivsL1RXAS
         41W0lWn7Y9jC1+8MItLRMihSlOSw2Xx7zEi5ZrA7MNtTQ4Mw8Ej7zn0okjQnU/pnidXD
         pxBNHQ8BPF3Oph3rYVCwRS1J/3JJovcfzUw5iT6yXhQFAzq/lQmVr/WyPCwKxaVxmOoV
         U32Q==
X-Gm-Message-State: AA+aEWYEEQICTWPWWBZvhoUQdZ3WUFlx31c7uxN1CnrLzyicyddQZ+tr
        gfhL5MXViw6xM8TO84VxItM=
X-Google-Smtp-Source: AFSGD/UmkQ6ktc0sR5RmMRLoBJNDU4jkhAi8d2EWCndMUfHsjeSWYaSG724O1pYs+07Thvh7N/43Vg==
X-Received: by 2002:a19:a84e:: with SMTP id r75mr15316352lfe.45.1544024932799;
        Wed, 05 Dec 2018 07:48:52 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:41e8:260c:942a:b736])
        by smtp.googlemail.com with ESMTPSA id t18sm3592517lft.93.2018.12.05.07.48.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 07:48:52 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH 2/5] media: dt-bindings: Add binding for si470x radio
Date:   Wed,  5 Dec 2018 16:47:47 +0100
Message-Id: <20181205154750.17996-3-pawel.mikolaj.chmiel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181205154750.17996-1-pawel.mikolaj.chmiel@gmail.com>
References: <20181205154750.17996-1-pawel.mikolaj.chmiel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add device tree bindings for si470x family radio receiver driver.

Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 .../devicetree/bindings/media/si470x.txt      | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/si470x.txt

diff --git a/Documentation/devicetree/bindings/media/si470x.txt b/Documentation/devicetree/bindings/media/si470x.txt
new file mode 100644
index 000000000000..9294fdfd3aae
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/si470x.txt
@@ -0,0 +1,24 @@
+* Silicon Labs FM Radio receiver
+
+The Silicon Labs Si470x is family of FM radio receivers with receive power scan
+supporting 76-108 MHz, programmable through an I2C interface.
+Some of them includes an RDS encoder.
+
+Required Properties:
+- compatible: Should contain "silabs,si470x"
+- reg: the I2C address of the device
+
+Optional Properties:
+- interrupts : The interrupt number
+
+Example:
+
+&i2c2 {
+        si470x@63 {
+                compatible = "silabs,si470x";
+                reg = <0x63>;
+
+                interrupt-parent = <&gpj2>;
+                interrupts = <4 IRQ_TYPE_EDGE_FALLING>;
+        };
+};
-- 
2.17.1

