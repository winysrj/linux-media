Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8931C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77A3B2080D
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J4jd8CaJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731206AbfBFPON (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:14:13 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55086 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731183AbfBFPOE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 10:14:04 -0500
Received: by mail-wm1-f66.google.com with SMTP id a62so2851913wmh.4
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 07:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GWBv8TFqzFxnlkNvYBhlA0CSDp04MBjWsOjyfNPbaXc=;
        b=J4jd8CaJmvidCN+EqYP/RhBImDCO8XDEFQ3SkWa5wWs2LlBFEszBTAO7ggNlpEMkyE
         NRvzPjfdL6qbLwREBzRm8YSG6aI5YtiPhD/nSFCwmDd/PBtBQpGsEFceN/l4Nl9o7MaW
         zRfr3DsFaiYxIyS8IamnrqSIUTbZ37qO9igd7auoMjBt91K1nS1ZY3e3peruPVd4uNP1
         Gqwd5arL7ciQQMg0t4zhIwb9k9ZKRVoXBSfeWUcqdbpxnJEirjEkXKdnCTW1sRc2OHrV
         UUDbaT0UVkPy+64N+CwZrQjJxSmfguyEysG77OaiuUxv7o3J6QYe1SxxweTBnUJch16F
         GoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GWBv8TFqzFxnlkNvYBhlA0CSDp04MBjWsOjyfNPbaXc=;
        b=IM6wFwRF4A2ZJeIWp+JXTdkn0goaHObTqDfw/Ojp3DHqm70MtcUezSlnoC5OD0fT5Q
         oyosg1A9c98bFPrp9AqGvPyuvKIPea9t4szGNaN0gw2wbgGA05BAviF5ULBE7ZN9lKUC
         zltUgHO55Vb6mmurNC7s2DvwIhaMD6xUnD0DQIoA/d6qFd+UQhv8Ggbhb4GWhwxsKu3a
         wOxF8kLb5xcYaa1fdPiCyy4LOcYPSa3OFRdyKx9drufOQ7QuyfSgWTABnQHWAKY1yTWB
         fSx6AvZMg23I/yJyYsSBfpVW9+/8bgjXVe7ct3vtWmhB43VDKANMmNO4KK7eYaCbXp92
         DXSQ==
X-Gm-Message-State: AHQUAuZgA9uiQQFYo3jDj3sPKKgpr7guAohnxN5ExQN3fY1cJfcXc5jk
        L8r3DSXb06qIEJGD7NNQE6nWwA==
X-Google-Smtp-Source: AHgI3IZ6VOLwZPcheSCljTP9bQFztq0JLMtRONKBkIi5S7m6MCjMNTX+b9xEzvC9WboXjLjo2eesaQ==
X-Received: by 2002:a1c:a401:: with SMTP id n1mr3760706wme.101.1549466043134;
        Wed, 06 Feb 2019 07:14:03 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id f22sm11207836wmj.26.2019.02.06.07.14.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 07:14:02 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v14 11/13] media: staging/imx: add i.MX7 entries to TODO file
Date:   Wed,  6 Feb 2019 15:13:26 +0000
Message-Id: <20190206151328.21629-12-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206151328.21629-1-rui.silva@linaro.org>
References: <20190206151328.21629-1-rui.silva@linaro.org>
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

