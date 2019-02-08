Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556C1C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21AC82075C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:53:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ufRRKnge"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfBHOxH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:53:07 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42277 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbfBHOxH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 09:53:07 -0500
Received: by mail-pg1-f195.google.com with SMTP id d72so1668567pga.9
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 06:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/S7xeBAaTJUtky1AToQ6NgqeQkJGdgz6lYT//XDxgf0=;
        b=ufRRKngeZ5mfglrH9Ye72o6My8gonAxiiactzSxEqPWKL8Qd9AoBhKkXUfCKDymXUA
         BdyRVcmaIdHHJYINee8NxLxgu2jEYjA9ojkoVbOz/Pq/awDsNWsPMeG79fjaIbvel2t4
         ba1GfAw9UUmpHf5jY8x3LfZ/sEYoP01Py5FPOl2ydKDjGEM3xBMFCmbpo/Uw96Uil/9y
         MYsOfx0JBupJZJqoLL2yaieDq/thrPkmsSTonG7JAbhkLYTuMg0Nr+6v3LdiFgARMGj4
         JUcAZZYZbUh4ozCOt/fb8KG2Bsl5uZ7w9YHB5PTkILSdjQKrkxtQupwVBAYDqUJvDPbz
         HZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/S7xeBAaTJUtky1AToQ6NgqeQkJGdgz6lYT//XDxgf0=;
        b=g9M9gCudzBpk4aIyizWoC+7/71ZWsC3bMngw7F7tu6TXtkYZOcMTJLdeLKDzf37J6Y
         O+qm+juig4GOxt58mZy1d7qQu3cb4Q1ic0cPSApL6sNRDv67TtjJgaVF5NRhd17lR2/4
         /1B7NlI0GqwIUqTk+9D25vcGT5kF0frfv6PLfW0uU4d3GUYa+6J+1h7N6f0Fl5cLtbRy
         VDNZDdb+PSJ7HS+9dMgm5hU5Ln8MZD7CPmwXnBBOU53OvKDaKPHNeyIVEnI5gi0rm/FB
         hH7Ee32re4CiUzKB12BuXvDL33DOtBGXMgNHqNvLZx6MfPMw1+OGlFFQwvEfS0Qaq9/y
         N7WQ==
X-Gm-Message-State: AHQUAubPnwMob6tcHpZCk7vA0sO4GUrU/y24LBEj5gnEK065oLGZv6U1
        NNZkYEPegQ41SmGnLAqaAIhvoxx3FCo=
X-Google-Smtp-Source: AHgI3IYqcVuy84X1HFsNkCQllkZlc1zyQ1lX/jsB4lizN0bwIT5XA2JmabkufpAOE9zE8nsKFySvvA==
X-Received: by 2002:a63:fd07:: with SMTP id d7mr5404686pgh.163.1549637586049;
        Fri, 08 Feb 2019 06:53:06 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:9dad:5819:2ad0:da6f])
        by smtp.gmail.com with ESMTPSA id s79sm3425216pgs.50.2019.02.08.06.53.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Feb 2019 06:53:05 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/4] media: i2c: add missing MEDIA_CAMERA_SUPPORT
Date:   Fri,  8 Feb 2019 23:52:44 +0900
Message-Id: <1549637565-32096-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1549637565-32096-1-git-send-email-akinobu.mita@gmail.com>
References: <1549637565-32096-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The camera sensor drivers should depend on MEDIA_CAMERA_SUPPORT so that
we don't see unnecessary menu options.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/Kconfig        | 4 ++++
 drivers/media/i2c/et8ek8/Kconfig | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 71c7433..73eeb17 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -823,6 +823,7 @@ config VIDEO_OV7740
 config VIDEO_OV9650
 	tristate "OmniVision OV9650/OV9652 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	select REGMAP_SCCB
 	---help---
 	  This is a V4L2 sensor driver for the Omnivision
@@ -877,6 +878,7 @@ config VIDEO_MT9M032
 config VIDEO_MT9M111
 	tristate "mt9m111, mt9m112 and mt9m131 support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	help
 	  This driver supports MT9M111, MT9M112 and MT9M131 cameras from
@@ -986,6 +988,7 @@ config VIDEO_S5K6A3
 config VIDEO_S5K4ECGX
 	tristate "Samsung S5K4ECGX sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	select CRC32
 	---help---
 	  This is a V4L2 sensor driver for Samsung S5K4ECGX 5M
@@ -994,6 +997,7 @@ config VIDEO_S5K4ECGX
 config VIDEO_S5K5BAF
 	tristate "Samsung S5K5BAF sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	---help---
 	  This is a V4L2 sensor driver for Samsung S5K5BAF 2M
diff --git a/drivers/media/i2c/et8ek8/Kconfig b/drivers/media/i2c/et8ek8/Kconfig
index 9fe409e..14b6732 100644
--- a/drivers/media/i2c/et8ek8/Kconfig
+++ b/drivers/media/i2c/et8ek8/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_ET8EK8
 	tristate "ET8EK8 camera sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
 	select V4L2_FWNODE
 	---help---
 	  This is a driver for the Toshiba ET8EK8 5 MP camera sensor.
-- 
2.7.4

