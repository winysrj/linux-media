Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927DCC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64EC821872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:10:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="gocyzJd4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfAXQKC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:10:02 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42138 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbfAXQKB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 11:10:01 -0500
Received: by mail-wr1-f65.google.com with SMTP id q18so7064690wrx.9
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 08:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3sV1A3N/a1F5D/MYRzaWG6owylM4PpGRVE/W1x/9VYE=;
        b=gocyzJd4ByiJ84+qQmzRcGsh51iT+FZQk6SSvItYuLJU9WfSkwdhvaqaUPiYOtZ0jO
         hNmSgcrhsl8ZJytl8WW5JKP/fx4Jim+5YIhNCQOjoYhy78JsZsDEHmsiPP6PCCR4k5fQ
         T7E7mBFbVqtxYqZviPwq+VUNQRM3jz+3XT19Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3sV1A3N/a1F5D/MYRzaWG6owylM4PpGRVE/W1x/9VYE=;
        b=qyzXyxITI2cGKIKzM7DdrbSorOrmhlGw3SWqZykn5pQo0nzTPGyFLI6cq9l2iyBNlB
         BPnGK2ugivFn5Z2TOUs+ivsx15bYycjOxdtIa8KBlXwpFH6eqzypUELfTanyGZPfQ8/J
         HtyICvYSOckMaFNVGpSvRiBIeQA/93zYvJNdzPNiSRWvdthTIcrpMb0yYOAgj9PxiP+k
         5ftF0r9JOB/JDqUjhaeNq1F6bQ0N5gt3+3tzRIS3ME+X24yMOLW1VgU12tU/JoczB/Ji
         fso/8u2b/iyAZtHA4LAB9xD35i4V9B6lhYxvDT7cESzLtos9ZVOWVbnvGxeEWEyI3+B2
         EpkA==
X-Gm-Message-State: AJcUuken/m5/cEoSdA+8S9lqO3EkuQ1yMngeajzlmkUydl3RzoQX0DAo
        gAu9i6sTuu1rTTbC8T1y1hwSNQ==
X-Google-Smtp-Source: ALg8bN46Hqu8+yknjXYF5KI+T5CuQTaRWOFSX1Zkf5eGiu/lxyE3EXM/kUGM8loeLP49L89Z1pfijA==
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr7430996wrs.7.1548346200102;
        Thu, 24 Jan 2019 08:10:00 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id e16sm179880299wrn.72.2019.01.24.08.09.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 08:09:59 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v11 11/13] media: staging/imx: add i.MX7 entries to TODO file
Date:   Thu, 24 Jan 2019 16:09:26 +0000
Message-Id: <20190124160928.31884-12-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190124160928.31884-1-rui.silva@linaro.org>
References: <20190124160928.31884-1-rui.silva@linaro.org>
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

