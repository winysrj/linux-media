Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADAAC282CB
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D8812087C
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="b9Aq0POy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbfBDMBT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 07:01:19 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53092 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729651AbfBDMBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 07:01:18 -0500
Received: by mail-wm1-f68.google.com with SMTP id m1so12882283wml.2
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 04:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bL95piKtKJ1oK5p0damKdK3neuLbv23/U+PKHUTj97E=;
        b=b9Aq0POy7sBEIviivaUGU8WgEMVhilmzd1aU0xTtvNki9ckwzeqVHkFIpW+aJ5Dm8q
         NBYvn6qxSvwOnUjAJwi2pEATEJ+obRqzO3A7pQZfRkURQKk7xereI+l1i2qIHH6orqMb
         5pT4IH6dEgXg49jGkNg91u2QLcLuMBplMNPI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bL95piKtKJ1oK5p0damKdK3neuLbv23/U+PKHUTj97E=;
        b=UxtskZkDp+DCAhCiMhQQlAyS5oIS0KGcS7gUa8nHRyV3WKdrKZPIgHjqZgxG2CvUs6
         adchYrEmQKoTOW2zCrTkoZyQbCZPYUPp2Oi9Ilc9+BtNu4oKCUAxNuTJjIjH5St2sseE
         j3TTagH9l5ayphI5aSRQT5csyEt1QbbCbvuEAPr5l4mLTkis6U2NBthB88TOcONz0ibc
         cUrlAZvRI8qrdJOncZEjHS1wIai2pRXJR0ehpw8rm7k+UWKtqs/JJLHTHI/jN4U4dGDL
         PrvGFjpEmJBnn/HB/AXcy8JwXxNbRXaw9CpomeaBzzx43/bZHAtjGK6YNmWjQ63so6R1
         EwDQ==
X-Gm-Message-State: AHQUAuYapLgbfZ79AnAwDYXxveLP7KZdzNFu96nmGR+MYIQ+kvPT++Bd
        LvLhKFsxqHQ8ItgVdtIy4brvVWxUG84=
X-Google-Smtp-Source: AHgI3IZJsYlO2KQywA4iBI2t2hueAZVPAi3zCtOMqWIotyjJe5NvyPTcdiN4TvE6VAK/SuAlLK9ogg==
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr13007428wmi.61.1549281677080;
        Mon, 04 Feb 2019 04:01:17 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id s8sm15404543wrn.44.2019.02.04.04.01.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 04:01:16 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v12 13/13] media: MAINTAINERS: add entry for Freescale i.MX7 media driver
Date:   Mon,  4 Feb 2019 12:00:39 +0000
Message-Id: <20190204120039.1198-14-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190204120039.1198-1-rui.silva@linaro.org>
References: <20190204120039.1198-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add maintainer entry for the imx7 media csi, mipi csis driver,
dt-bindings and documentation.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51029a425dbe..ad267b3dd18b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9350,6 +9350,17 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/platform/imx-pxp.[ch]
 
+MEDIA DRIVERS FOR FREESCALE IMX7
+M:	Rui Miguel Silva <rmfrfs@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/imx7-csi.txt
+F:	Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
+F:	Documentation/media/v4l-drivers/imx7.rst
+F:	drivers/staging/media/imx/imx7-media-csi.c
+F:	drivers/staging/media/imx/imx7-mipi-csis.c
+
 MEDIA DRIVERS FOR HELENE
 M:	Abylay Ospan <aospan@netup.ru>
 L:	linux-media@vger.kernel.org
-- 
2.20.1

