Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F27CC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 470622146D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:58:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RfD+Ls38"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 470622146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbeLGN6e (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:58:34 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44995 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbeLGN6b (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:58:31 -0500
Received: by mail-lj1-f193.google.com with SMTP id k19-v6so3603446lji.11;
        Fri, 07 Dec 2018 05:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OSWn7aqP5LZdpXIQkIta8Y8DiZPEYX5x20H6MavbjYc=;
        b=RfD+Ls3868tv2WU7tUqWFDJV3FBoG660b+7Ejk0D/Rgml/ezBKZWaK181IpssZcLyn
         XecUU/CobBFhTrd8HT+iMZsV8lyhvdp/Hn2LeT3WlQfeVsFJ5h5+4PabAqkES+17IkOU
         xazaGqfGMp8bICbT8p19/sAEAhTEXA3bjcGlhEOQ6GE6aHUfUy9r7YqSzWB58gKNh4Ka
         9N5842pjJmlpIBZj3X0RWDm7hx+tmy7mdwQDGkIE5/+/C3jSwuBqekTMWpdnj+AKMWLC
         wqOIYNsio0QdKW2/aqhxhgyw8exTZ9z3OEjAGE16sbhk/M0XpY1VMtOnCVj2yWMk8EO2
         ldvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OSWn7aqP5LZdpXIQkIta8Y8DiZPEYX5x20H6MavbjYc=;
        b=QCMwf16oF1IAB2Px+yk4VVNqwa2PFWBTE+W96lFDWXyBgkNzyPuyzHmz4ttUxJwnZF
         VqXYBJqX/1IpvmH2i43rodP6rrqxKn6DyZEy/8PPqoIs9tVIun6GhvtZLo+8FnOl/MTn
         V9qJ/bgGMeCMIMCz1E8ej8xWjm4UHFHRylfCkO02+3pdFZOoJEwQHzCouSxi7AZmIbEi
         ftGt0RpR292mLiU9tSYeQ9+sySp9T+QjV6sjAqlNmJiYPyqajOeRsHHK5e8rZy2xqXFv
         ghY2xsmou8IXWApH8JqIlB/L2TKShBtNgyi5SFlycuOrJJ0FXRRgXyBRFoiRQWOYMSdw
         9dxg==
X-Gm-Message-State: AA+aEWb3bhG9C9mqtKQEsK6g59vYc0lIcRnmaye9wbnCcueck4WJTpwH
        Pm52TLyqQ6Aowfrn6XOvSIY=
X-Google-Smtp-Source: AFSGD/WneZ/lKYaRlIaa7YZpGFKa4dJbSurAm57JMBwIuYL6ZLtaHO6sSwhd2JL6INzc4891pwhKow==
X-Received: by 2002:a2e:2d4:: with SMTP id y81-v6mr1459152lje.62.1544191108345;
        Fri, 07 Dec 2018 05:58:28 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:74d5:51ba:2673:f3f4])
        by smtp.googlemail.com with ESMTPSA id i143sm624609lfg.74.2018.12.07.05.58.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 05:58:27 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH v2 4/4] media: dt-bindings: Add binding for si470x radio
Date:   Fri,  7 Dec 2018 14:58:12 +0100
Message-Id: <20181207135812.12842-5-pawel.mikolaj.chmiel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181207135812.12842-1-pawel.mikolaj.chmiel@gmail.com>
References: <20181207135812.12842-1-pawel.mikolaj.chmiel@gmail.com>
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
Changes from v1:
	- squashed with patch adding reset-gpio documentation
---
 .../devicetree/bindings/media/si470x.txt      | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/si470x.txt

diff --git a/Documentation/devicetree/bindings/media/si470x.txt b/Documentation/devicetree/bindings/media/si470x.txt
new file mode 100644
index 000000000000..a9403558362e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/si470x.txt
@@ -0,0 +1,26 @@
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
+- reset-gpios: GPIO specifier for the chips reset line
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
+                reset-gpios = <&gpj2 5 GPIO_ACTIVE_HIGH>;
+        };
+};
-- 
2.17.1

