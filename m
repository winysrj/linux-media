Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8B8C67839
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32F852084E
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:17:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=konsulko.com header.i=@konsulko.com header.b="CDmk7o+4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32F852084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=konsulko.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbeLKPRq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:17:46 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37197 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbeLKPRp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:17:45 -0500
Received: by mail-lf1-f66.google.com with SMTP id p17so11077214lfh.4
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2018 07:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+TA/yY5xWLU60pjU0uIdYa5LK/N0RaxslTopQ3hTYZg=;
        b=CDmk7o+4nnGzlw8djVN2LCgoObfb7ODgcDzF/AERzpwO+sj/OvrjcU2vQQrORam/u3
         MVVn+QfCyF/fQGrkgxZ7hjYCVJMpceNkuy0Pj5bKGgf6gvjTGvBodFRllOtfd7xU1ENy
         XXBKwnkoDqvoUEhuAT0rU0djAFpMSoGtGICtg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+TA/yY5xWLU60pjU0uIdYa5LK/N0RaxslTopQ3hTYZg=;
        b=tR9v32gk7uBiZc+GfPeOlVNgKJv8qwbqiekYvNu2OtnVl7asKTcu/EMJn9z+mYKrS3
         EPlrbR8A2UmRvCN84bFD0nxG9minTTnCj9WwBj4pqfyCxqrUklir2c3LMVGduu01KltQ
         Ehi+TXsbEhKz7vHBoxDtLU1Vgq6oU3fhCRVS/AWRZKJWtoIfTZZtiW0sJrZils04jDRc
         o0rfbj3BpIBHcrp6fQKJ3rLvWHlCjhRFLCu9nSMlsQgkAAingvoHXsDRc+SezS/pQhYN
         7lvfNFcXajt3U6WssvgTEcI3XLd/VAwgRyjhug0YZfDdJypgIH6UHz0t1bGQAYBY4wxU
         PbLw==
X-Gm-Message-State: AA+aEWao15RvOoRg46coOzgX+9Neoe5YXfUhxt+BVzKgwyEbt1UYNwVD
        /FtYRgLaqHl5kVQEiEcmrk8pcS1dK48=
X-Google-Smtp-Source: AFSGD/Vy0ba6tX2TuHRucE/h+Btxw8wpvSQZ0xeuUg1cMvuS2kjjCbtqiXbL/Pb53OOW+l0NxVTBqA==
X-Received: by 2002:a19:24c6:: with SMTP id k189mr10138695lfk.77.1544541462795;
        Tue, 11 Dec 2018 07:17:42 -0800 (PST)
Received: from virtualbox.ipredator.se (anon-49-167.vpn.ipredator.se. [46.246.49.167])
        by smtp.gmail.com with ESMTPSA id g12-v6sm2712158lja.74.2018.12.11.07.17.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 07:17:42 -0800 (PST)
From:   Matt Ranostay <matt.ranostay@konsulko.com>
To:     linux-media@vger.kernel.org
Cc:     Matt Ranostay <matt.ranostay@konsulko.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v4 1/2] media: dt-bindings: media: video-i2c: add melexis mlx90640 documentation
Date:   Tue, 11 Dec 2018 07:17:00 -0800
Message-Id: <20181211151701.10002-2-matt.ranostay@konsulko.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181211151701.10002-1-matt.ranostay@konsulko.com>
References: <20181211151701.10002-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Cc: devicetree@vger.kernel.org
Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
---
 .../bindings/media/i2c/melexis,mlx90640.txt   | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt b/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
new file mode 100644
index 000000000000..060d2b7a5893
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
@@ -0,0 +1,20 @@
+* Melexis MLX90640 FIR Sensor
+
+Melexis MLX90640 FIR sensor support which allows recording of thermal data
+with 32x24 resolution excluding 2 lines of coefficient data that is used by
+userspace to render processed frames.
+
+Required Properties:
+ - compatible : Must be "melexis,mlx90640"
+ - reg : i2c address of the device
+
+Example:
+
+	i2c0@1c22000 {
+		...
+		mlx90640@33 {
+			compatible = "melexis,mlx90640";
+			reg = <0x33>;
+		};
+		...
+	};
-- 
2.17.1

