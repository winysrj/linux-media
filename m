Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCA6C282CC
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 611562087C
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="HIdE7695"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfBDMBP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 07:01:15 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41583 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbfBDMBO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 07:01:14 -0500
Received: by mail-wr1-f65.google.com with SMTP id x10so14082672wrs.8
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 04:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GWBv8TFqzFxnlkNvYBhlA0CSDp04MBjWsOjyfNPbaXc=;
        b=HIdE7695C37MBhX5mGqE+eWhj2G55XftjcSyMN2jfMQFlPhOBQ6A2g3dPrKnaIyN5p
         aAxDmFkMe4Ur5mRcUu5JaCyEsixWXGJGZe7eJdsGPGdFA6+mV3rRxqs9BSNAPnqdLMJc
         MW8Ojfd4RHXOTIrroudvX9XMq9YBE0M5CY9B8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GWBv8TFqzFxnlkNvYBhlA0CSDp04MBjWsOjyfNPbaXc=;
        b=RCJGUtqM9LA4TNTetfE2OkWn4nUckAh2qFh0Az/kE1EIAEJct/QNBntj+tymIoL9I0
         WJuon2YpmXc2SY+nVrt0efhu8BSArxh0UhWtebBw7ODStr+cD6x6tQid/LjhE1UkK9Pt
         3BL3RX5sfejIRBAswSaIzdREVWHBdDffD4CFZ4MmzmIk20UctZCUz/KR/zK/qBJp5+mW
         3qmFEmN+chXoAICsYT63dOO4vmfWwhG3l8X/DMIXFsIeKpHFDexpJcdNh1vgCK80EqxG
         lgnqkbDZSncddicJLWPbxU50GSXOOvpdFcre1bBS0WWV8aWDTsa6ZZhPL5PBDwnx8f9D
         NLYA==
X-Gm-Message-State: AHQUAuYebbZXv3PaqZFrY4wWQuvc/y5qfF+0VouIDoIPEur1NQFPxym6
        BcZJn1b6gefJ6yo9qkhB6BscXg==
X-Google-Smtp-Source: AHgI3IakBWCRvyrQz9TIGMyggG62boBKa8pGW9x3avL+6eWj2txh2/r+DSvoNX8wZ0onERS+ahCiiA==
X-Received: by 2002:adf:a743:: with SMTP id e3mr25241907wrd.56.1549281673001;
        Mon, 04 Feb 2019 04:01:13 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id s8sm15404543wrn.44.2019.02.04.04.01.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 04:01:12 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v12 11/13] media: staging/imx: add i.MX7 entries to TODO file
Date:   Mon,  4 Feb 2019 12:00:37 +0000
Message-Id: <20190204120039.1198-12-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190204120039.1198-1-rui.silva@linaro.org>
References: <20190204120039.1198-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add some i.MX7 related entries to TODO file.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
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

