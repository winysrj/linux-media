Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:24995 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751870AbdIMPIz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 11:08:55 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8DF58Bx023539
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 16:08:54 +0100
Received: from mail-wr0-f200.google.com (mail-wr0-f200.google.com [209.85.128.200])
        by mx07-00252a01.pphosted.com with ESMTP id 2cv5pysxmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 16:08:53 +0100
Received: by mail-wr0-f200.google.com with SMTP id k20so494779wre.6
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 08:08:53 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH v2 4/4] MAINTAINERS: Add entry for BCM2835 camera driver
Date: Wed, 13 Sep 2017 16:07:49 +0100
Message-Id: <26dd3226e90f6adaec834c27ada2bfcb573af913.1505314390.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1505140980.git.dave.stevenson@raspberrypi.org>
References: <cover.1505140980.git.dave.stevenson@raspberrypi.org>
MIME-Version: 1.0
In-Reply-To: <cover.1505314390.git.dave.stevenson@raspberrypi.org>
References: <cover.1505314390.git.dave.stevenson@raspberrypi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index eb930eb..b47ddaa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2713,6 +2713,13 @@ S:	Maintained
 N:	bcm2835
 F:	drivers/staging/vc04_services
 
+BROADCOM BCM2835 CAMERA DRIVER
+M:	Dave Stevenson <dave.stevenson@raspberrypi.org>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/platform/bcm2835/
+F:	Documentation/devicetree/bindings/media/bcm2835-unicam.txt
+
 BROADCOM BCM47XX MIPS ARCHITECTURE
 M:	Hauke Mehrtens <hauke@hauke-m.de>
 M:	Rafał Miłecki <zajec5@gmail.com>
-- 
2.7.4
