Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1B1C282C2
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CD7420861
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:53:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Tc0u/eRk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfAWKxM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:53:12 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37725 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbfAWKxK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:53:10 -0500
Received: by mail-wr1-f67.google.com with SMTP id s12so1864177wrt.4
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3sV1A3N/a1F5D/MYRzaWG6owylM4PpGRVE/W1x/9VYE=;
        b=Tc0u/eRkEyTNep5Kvm3GDsE3frp+IUT1KpNduYoi6bWvEiu7po8/x0DlJ1IEn6nBtm
         hqCx2IE5+AUMZhhkFQUbcJSjHDmD99C5Fa7RX+0+AB7KN6bF1fIjT8LeXtEnsB5IgXAc
         GdTTp6enuQpHmwevqFkrxSTnO6MT0iiR/61Sk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3sV1A3N/a1F5D/MYRzaWG6owylM4PpGRVE/W1x/9VYE=;
        b=CFh+XgyL6Ol5UAnJ7YIJ/ceDtBIG56xws1ktDUgq7mnZXY+X/yOuXucA8tJ+H/qTSu
         /HB3lIREtezygB9JpiXEF0a/l+NY0+TOswBtTJEf6qth8HCH+w5uBgWtFmuyRhi6vJgv
         /bM7rIRe5XEWrNGHZ4+Wys1ge6wGy72uWHyTa0YZlTfh9Ii4iY9wGdhrGU9gYF7ObNj0
         ObMgFqgKNnBF0bQjLOWbWwUWLHg12iXoI4pQjq94rbMvuydzNKA36no7Er4ydeEzxYsI
         +gswkzUSQlaJgZPGw1hxgdkunuii5oGqI0Uc9q872DTcGqUy80MfEexy/B6a69csyEGZ
         xhmw==
X-Gm-Message-State: AJcUukfx7Q68UcF8AjhaLS6fVX8rLacDJhGvvbynT1Y1dvhqBve4C5ZW
        cO4lSz1u1KIewWvBC5lO0Ol87w==
X-Google-Smtp-Source: ALg8bN7oKaht93g6akpLsez3eStm0e0qHPaeRZPyly5e3afbPWQAm8IRFd1yiSS65OJAyO00B2RV8Q==
X-Received: by 2002:adf:bb8d:: with SMTP id q13mr2089401wrg.183.1548240789316;
        Wed, 23 Jan 2019 02:53:09 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id 143sm120717646wml.14.2019.01.23.02.53.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:53:08 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v10 11/13] media: staging/imx: add i.MX7 entries to TODO file
Date:   Wed, 23 Jan 2019 10:52:20 +0000
Message-Id: <20190123105222.2378-12-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190123105222.2378-1-rui.silva@linaro.org>
References: <20190123105222.2378-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add some i.MX7 related entries to TODO file.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/TODO | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/media/imx/TODO b/drivers/staging/media/imx/TODO
index aeeb15494a49..6f29b5ca5324 100644
--- a/drivers/staging/media/imx/TODO
+++ b/drivers/staging/media/imx/TODO
@@ -45,3 +45,12 @@
 
      Which means a port must not contain mixed-use endpoints, they
      must all refer to media links between V4L2 subdevices.
+
+- i.MX7: all of the above, since it uses the imx media core
+
+- i.MX7: use Frame Interval Monitor
+
+- i.MX7: runtime testing with parallel sensor, links setup and streaming
+
+- i.MX7: runtime testing with different formats, for the time only 10-bit bayer
+  is tested
-- 
2.20.1

