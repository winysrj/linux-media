Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FD3C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B8032177B
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:56:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D6jZrmqF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfBHO45 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:56:57 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38363 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfBHO45 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 09:56:57 -0500
Received: by mail-pl1-f195.google.com with SMTP id e5so1802774plb.5
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 06:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WxOIHq/oecrKakuHNyhnA31hcNRw/WjER8yFvsWver0=;
        b=D6jZrmqFzOLioaH/fmBNSmN7VVMK770bB6W8bpBZDjRZ66zQOmuvSF8bbpZWYcp4nI
         YZ42mGWxj/dqZay4DsJ2+rjY+ZZlbvba2MAKBcEjQfrd/Lqsj3tWPwg1NpkZsirIsY8S
         YQtW+SDblkZ+HwmpvJh35HUOpxEh6hK2YxsESEvli684iFd4JP1xYn1+SLuFupWUVG5G
         FNXptP/Dhm2AdatzU+ZpkfFEJfHoEOsMRb/N7yhKtTqA0t/gip21S6/ZvQ2skA3M8EAJ
         48NxBLsGEK5k0wQYRoRw3dLtIStqnMWOpK7xSjXggq5UtistS/BtvrG2oiTOzgirmuZN
         qJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WxOIHq/oecrKakuHNyhnA31hcNRw/WjER8yFvsWver0=;
        b=iNmH5lAfUIlRu7RbgG81QizZqvpd60scakyQDNI2AYkH2/OuB1UB6zDNCELPbh3ZBO
         gugTSwKOhRBRJPcWE/BF2i7kuPar59qIoUXP87m4WM5EeTvyj3XaFypoTS5ilqkIFUoO
         T/EqY5Bmfu160PomEXR3s72UksID9tgiaym7hNzXh3uuBdPUHepQN8qsqBHW4cT4G+rk
         fx+JssjiNN9/CzwSwKswmvcV9MvgDWP7XqXuwP807TxM2I4WjonFaJMjgA39oorPn8m1
         AK1ANuhSffaGK40nc83+n+iaR5R4HE2Id67mUbQwUxo4We0rS0m12Q/QtUsrRGAi8Um7
         i53Q==
X-Gm-Message-State: AHQUAuaBP/B+O72CdDn7XS4aAUZsPEoib43PeT4S0CMOlQjxEuOnxoaC
        I5MTJ2aSiCRSuCcYjd/Deb+lvqzckpU=
X-Google-Smtp-Source: AHgI3IatZT1SQQOH6plnohEHRAUR4JKDbRxNUOQeEvMyZe+GUoX8aWOuyHqu/fKbKNgG62kO+50DRg==
X-Received: by 2002:a17:902:6909:: with SMTP id j9mr22616197plk.196.1549637816821;
        Fri, 08 Feb 2019 06:56:56 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:9dad:5819:2ad0:da6f])
        by smtp.gmail.com with ESMTPSA id g128sm4101089pfc.164.2019.02.08.06.56.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Feb 2019 06:56:56 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] MAINTAINERS: media: add entries for mt9m001 and mt9m111 drivers
Date:   Fri,  8 Feb 2019 23:56:36 +0900
Message-Id: <1549637796-32271-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20190206132428.hayenukr2cyk3od6@valkosipuli.retiisi.org.uk>
References: <20190206132428.hayenukr2cyk3od6@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As long as I have these two sensors, I can review and test the patches.

Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 MAINTAINERS | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8c68de3c..ca995d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10270,6 +10270,15 @@ L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/devices/docg3*
 
+MT9M001 CAMERA SENSOR
+M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+R:	Akinobu Mita <akinobu.mita@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/i2c/mt9m001.txt
+F:	drivers/media/i2c/mt9m001.c
+
 MT9M032 APTINA SENSOR DRIVER
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
@@ -10278,6 +10287,15 @@ S:	Maintained
 F:	drivers/media/i2c/mt9m032.c
 F:	include/media/i2c/mt9m032.h
 
+MT9M111 CAMERA SENSOR
+M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+R:	Akinobu Mita <akinobu.mita@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/i2c/mt9m111.txt
+F:	drivers/media/i2c/mt9m111.c
+
 MT9P031 APTINA CAMERA SENSOR
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
-- 
2.7.4

