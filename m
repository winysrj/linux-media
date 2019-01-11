Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1520DC43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAE0C20700
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:50:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=agner.ch header.i=@agner.ch header.b="AknvFcU9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbfAKPt5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:49:57 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:56628 "EHLO
        mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730850AbfAKPt4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 10:49:56 -0500
Received: from trochilidae.toradex.int (unknown [46.140.72.82])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id B5EB65C05C9;
        Fri, 11 Jan 2019 16:49:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1547221793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=r7DDOojwlnwrGz8EicKv4OUNVb68wMuhfmDhMS5ievo=;
        b=AknvFcU926pgplcWL2iZXPGX2xSd8UuIb3TEfATCM4bo5iLhkdQC7FefkIh/lp++mz0BKC
        zmTDuN+3CU62NnuPk8tVqE66BzccL++VpbGLmzk/5duvFoNCr6fxiUBUlmiLo2g/BPzVKv
        3z0G4NK3I9RpyjH+kkxU1pUn4Ri35DU=
From:   Stefan Agner <stefan@agner.ch>
To:     mchehab@redhat.com
Cc:     hans.verkuil@cisco.com, arnd@arndb.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH] media: Kconfig: allow to select drivers if EMBEDDED
Date:   Fri, 11 Jan 2019 16:49:51 +0100
Message-Id: <20190111154951.21974-1-stefan@agner.ch>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Embedded systems often connect to sensors or other multimedia
subdevices directly. Currently, to be able to select such a
subdevice (e.g. CONFIG_VIDEO_OV5640) disabling of the auto-
select config option is needed (CONFIG_MEDIA_SUBDRV_AUTOSELECT).

This is inconvenient as the ancillary drivers for a particular
device then need to be selected manually.

Allow to select drivers manually while keeping the auto-select
feature in case EXPERT (selected by EMBEDDED) is enabled.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/media/dvb-frontends/Kconfig | 2 +-
 drivers/media/i2c/Kconfig           | 4 ++--
 drivers/media/spi/Kconfig           | 2 +-
 drivers/media/tuners/Kconfig        | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 847da72d1256..ea5450fcb616 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -1,5 +1,5 @@
 menu "Customise DVB Frontends"
-	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST
+	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST || EXPERT
 
 comment "Multistandard (satellite) frontends"
 	depends on DVB_CORE
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 4c936e129500..4b28dbe1535c 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -5,7 +5,7 @@
 if VIDEO_V4L2
 
 config VIDEO_IR_I2C
-	tristate "I2C module for IR" if !MEDIA_SUBDRV_AUTOSELECT
+	tristate "I2C module for IR" if !MEDIA_SUBDRV_AUTOSELECT || EXPERT
 	depends on I2C && RC_CORE
 	default y
 	---help---
@@ -22,7 +22,7 @@ config VIDEO_IR_I2C
 #
 
 menu "I2C Encoders, decoders, sensors and other helper chips"
-	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST
+	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST || EXPERT
 
 comment "Audio decoders, processors and mixers"
 
diff --git a/drivers/media/spi/Kconfig b/drivers/media/spi/Kconfig
index b07ac86fc53c..bf7965a9be73 100644
--- a/drivers/media/spi/Kconfig
+++ b/drivers/media/spi/Kconfig
@@ -1,7 +1,7 @@
 if VIDEO_V4L2
 
 menu "SPI helper chips"
-	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST
+	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST || EXPERT
 
 config VIDEO_GS1662
 	tristate "Gennum Serializers video"
diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 147f3cd0bb95..97c46e7368e1 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -15,7 +15,7 @@ config MEDIA_TUNER
 	select MEDIA_TUNER_MC44S803 if MEDIA_SUBDRV_AUTOSELECT
 
 menu "Customize TV tuners"
-	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST
+	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST || EXPERT
 	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
 
 config MEDIA_TUNER_SIMPLE
-- 
2.20.1

