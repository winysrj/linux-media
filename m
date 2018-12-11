Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB320C5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D5F820811
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sW3yMvhL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D5F820811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbeLKJss (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 04:48:48 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42889 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbeLKJss (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 04:48:48 -0500
Received: by mail-ed1-f68.google.com with SMTP id j6so11941352edp.9;
        Tue, 11 Dec 2018 01:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GqU6pNUYHzxH0die0BGgLenfoTDN7Hdqraqi7UbiBCk=;
        b=sW3yMvhLYuOAYHcXu0njqt2dlYVNC1OOSSDLhY6YCGmyT9KCaSQA/a74pSmBmFXcgu
         EdIvrXq1w7TR9MheyWZ0ssRXwUm+EQxg25dFOh7U1jYL2ji8L/dPvzXo/HQLbIzFn8XS
         66IKfKeyqCBqGb8Vzs6rfzo6wfHWpro5q6z4SYBwhn6sZr8BlVFDGFIDOc7oHlan2Qga
         X8oBEaCcklZ8QrZ/re+zL84IuywdALyuO94dkBGclaON2nc1mNAgBTRF/NV5pyGoxYCh
         DdC7o0TrczTVY9uN4nPcMHTkoDN/KOJ4Ew08CVIYWkFTp9GOQwKREItyJsZ/Dlr4C3k5
         7xUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GqU6pNUYHzxH0die0BGgLenfoTDN7Hdqraqi7UbiBCk=;
        b=JIN/cipHt2r7zwJc8sreCo/FLqlqCD9soVcFc7UqZcwWDQ2EVt4aBhBI4XVb20u9P8
         Zq4YXtooaDpF8Obo7Dp24DwCddbkuezg7x/tDHvvXumqgF6qpPSoL/VdNW6ceTS9sTv9
         /VKi12AMXrYuJIreNynaz47onN4TdiiGOCKj9SHgECmTt2Hw0UOVb2h5IO1XznI+C9V9
         o4jRHxPc3YK61/q434xQekk+Wv0HOjLE+UwxAIBSPJejS+Tsfa7t4LcBANGySrUVD8Kq
         nBv41sEKr3FHHptRslvhUGHoSvFE1x39q911WSzY4OFwnIQghBryp1yFh+yn7VLyKU3p
         qc+Q==
X-Gm-Message-State: AA+aEWYA5xyC8vn0kKfjr/eE11OmpuPq0SyQwT/tvgazs2iPVw82golo
        y2bmBLqdWXTAUGp52eO+q+A=
X-Google-Smtp-Source: AFSGD/VXS442KJHnRYYNFQrwygk7ICe/kVyDdRQcqvr7My3ZquONGNc8IpxOZOth9MNZevd2EyrWHg==
X-Received: by 2002:a50:8863:: with SMTP id c32mr13856670edc.156.1544521725928;
        Tue, 11 Dec 2018 01:48:45 -0800 (PST)
Received: from localhost (pD9E51040.dip0.t-ipconnect.de. [217.229.16.64])
        by smtp.gmail.com with ESMTPSA id s46sm4060179edd.9.2018.12.11.01.48.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Dec 2018 01:48:45 -0800 (PST)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v2 3/3] media: tegra-cec: Export OF device ID match table
Date:   Tue, 11 Dec 2018 10:48:41 +0100
Message-Id: <20181211094841.16027-3-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181211094841.16027-1-thierry.reding@gmail.com>
References: <20181211094841.16027-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Exporting the OF device ID match table allows udev to automatically load
the module upon receiving an "ADD" uevent for the CEC controller device.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/media/platform/tegra-cec/tegra_cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
index 8a1e10d008d0..4e9f91528f77 100644
--- a/drivers/media/platform/tegra-cec/tegra_cec.c
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
@@ -476,6 +476,7 @@ static const struct of_device_id tegra_cec_of_match[] = {
 	{ .compatible = "nvidia,tegra194-cec", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tegra_cec_of_match);
 
 static struct platform_driver tegra_cec_driver = {
 	.driver = {
-- 
2.19.1

