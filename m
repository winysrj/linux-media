Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AEDC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EAF1206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O69PUZ4g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EAF1206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbeLEPtH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 10:49:07 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44988 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbeLEPs7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 10:48:59 -0500
Received: by mail-lj1-f193.google.com with SMTP id k19-v6so18745650lji.11;
        Wed, 05 Dec 2018 07:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ivIcikaxHVAK7mUKBs+IidxAX11DCTBttjZ73Q5l9Y0=;
        b=O69PUZ4gEz81Z978y6YF0z07HixXdnrjTLNBxLcDTwIOkOLYfoQ+QwX1xwdGdymEdn
         XpuR+a9Y+UXUR0Kr51odq75tI7kzPQ+Y9ygYK0cInubYZlWZAA1hFfq+9slQEaj/deU1
         H9IiBupU5BDw/aPOhXTlQAGfSWOb7gzRodajpxpTJYTJFSLR+0U3Y+oGMby5iSIH3sLT
         FcjTaKEga3PoRNBMwK1d+2g531tn4y6uW6y97E4ZeGTbABSRzvALGHlkHs6vz1I6FdTY
         5OZvUKVp1NFd7YE+IKzvG/5zwP6PgNaGq1kVRwn0rhJBottvkHihVNG/oRNlH9mUY9G4
         ySzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ivIcikaxHVAK7mUKBs+IidxAX11DCTBttjZ73Q5l9Y0=;
        b=Ua4kc+PVUaBwzqmeZK8uAc0BYuYzs91SBDs4Hx8xusDO5i4+yknEzBNCIfM+XXOyXY
         Mlb3viEDLtGrYcBPwgpW9+nT2WPQuNwAfdg0pN2KFb5Iif6Tc4ml1p6fO0J9Gmyx0ala
         nvdJW026AvXIRSkWtxlpkE6oc+nqgacayO8NCGVbiuYCM3gpYwS9oFnQF67P6DYz+3C1
         hVonotAg75oZufBvA/7i1Bmnqvt3q4ZkqPXry1JhEZoacIlzmQ4bBxvcgsfZ2LKS0AWr
         /VE1HOeKIDihKhK2Y5akj3J2OIB0Nlk2x3GAPNdkJnx2a3T0XqwcrlxMBandNxpKucgS
         AN1w==
X-Gm-Message-State: AA+aEWbqwRPspNBUVGd0Yy1JOQMR32rD0JJVh2g429yXdI68/Ghx8ac4
        bl+qH1VoZiP8/GYMFqm/xFQ=
X-Google-Smtp-Source: AFSGD/WGM9LTKHZgWDG//XgKnLvPaK6vCCJF/1q1SDmuxWStclNijb5F5Db/zu+1Z56dBXo5wNw+Eg==
X-Received: by 2002:a2e:8045:: with SMTP id p5-v6mr15643880ljg.87.1544024937047;
        Wed, 05 Dec 2018 07:48:57 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:41e8:260c:942a:b736])
        by smtp.googlemail.com with ESMTPSA id t18sm3592517lft.93.2018.12.05.07.48.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 07:48:56 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH 5/5] media: dt-bindings: si470x: Document new reset-gpios property
Date:   Wed,  5 Dec 2018 16:47:50 +0100
Message-Id: <20181205154750.17996-6-pawel.mikolaj.chmiel@gmail.com>
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

Add information about new reset-gpios property to driver documentation

Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 Documentation/devicetree/bindings/media/si470x.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/si470x.txt b/Documentation/devicetree/bindings/media/si470x.txt
index 9294fdfd3aae..a9403558362e 100644
--- a/Documentation/devicetree/bindings/media/si470x.txt
+++ b/Documentation/devicetree/bindings/media/si470x.txt
@@ -10,6 +10,7 @@ Required Properties:
 
 Optional Properties:
 - interrupts : The interrupt number
+- reset-gpios: GPIO specifier for the chips reset line
 
 Example:
 
@@ -20,5 +21,6 @@ Example:
 
                 interrupt-parent = <&gpj2>;
                 interrupts = <4 IRQ_TYPE_EDGE_FALLING>;
+                reset-gpios = <&gpj2 5 GPIO_ACTIVE_HIGH>;
         };
 };
-- 
2.17.1

