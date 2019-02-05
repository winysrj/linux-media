Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8CBC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 16:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CEDC217FA
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 16:23:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="YB+fZnvT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbfBEQXx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 11:23:53 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39156 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728688AbfBEQXx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 11:23:53 -0500
Received: by mail-pl1-f193.google.com with SMTP id 101so1700123pld.6
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 08:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=l91hmHctASBMUrDNUCoa8lHpDTPLNtfagzDOkY+C7PU=;
        b=YB+fZnvT0Pft6Yrp8J+b12ckWKjrGCgWpRoc/yLiqPePPcCFi+roShfq+QZkwUrPul
         14atC+Ano3OYyvrmbMvvPphcYCSxV2U/I15uAxXn9jOkq9C3DAJFbdagzBrAY8TWwnh3
         32iGDsd5+UdTxGq1MH6xiZR6tGjA809m2kE6MnU7xRg8lP2uS8HMQfY0iI8whLmzPC/B
         9tIFF+yCAYFY0O6fThQ80SlKXBlQJXkn3OmxeaEEEuCxktm0b+6fexQ7EMvNsH0YmLhW
         4f87cyc4vkcpVifbn7wrePuDtfM91KRS8MK3pwr2ffHPWyEt2TqOx++vYJlc8Jwroehx
         JTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l91hmHctASBMUrDNUCoa8lHpDTPLNtfagzDOkY+C7PU=;
        b=Nyo66bvhvIrVbRFj5qa9KZqO1ML1tEhEbGbpTKLzsSypOim0Dd5vloe+Gs1WsHGPjh
         ye5/wBK5+6jdZqUOHZXBzbbiBw4UAn7GJN42DEvwRTgIOslm86dd6Qo0TPj5GvVF63PA
         550LQHSD1SAb40Vlo4xTggVbohNwOJvIKFq3RJywEcy1ITxuzE3awQCusjCTNZ7rH4AK
         19FN4wwetQW1pmDo9kanGp+VMPUkKzbi90Z96AauM7GsqrKn4RGI/DKyoh1RQADl7CZd
         PVF4X/XC/CzdgzUdfXoe8/dkec9MF9m1nWlvH1RLpQzpsABbUM/7Lt1M+OG2rldXZ6o/
         zSxw==
X-Gm-Message-State: AHQUAuZzYnWvhuLnVwi5YwBBIvAqownCKe2jp2pJL5ufS2ujn1VFj9QU
        szj6Fqvy6nIKHPLU3RgOUaPA1aUTD1A=
X-Google-Smtp-Source: AHgI3IanDjEaocl2awg1UWFv7iFZosLZB7UE+TnGRZ6zN8fEA+DKkN3vasyhdKKCK01Z3XMRbKMiGw==
X-Received: by 2002:a17:902:2c03:: with SMTP id m3mr5711249plb.6.1549383832252;
        Tue, 05 Feb 2019 08:23:52 -0800 (PST)
Received: from tharvey.pdc.gateworks.com (68-189-91-139.static.snlo.ca.charter.com. [68.189.91.139])
        by smtp.gmail.com with ESMTPSA id y16sm12247859pgk.22.2019.02.05.08.23.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 08:23:51 -0800 (PST)
From:   Tim Harvey <tharvey@gateworks.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH] media: tda1997: fix get-edid
Date:   Tue,  5 Feb 2019 08:23:36 -0800
Message-Id: <20190205162336.13490-1-tharvey@gateworks.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/media/i2c/tda1997x.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index c4c2a6134e1e..73451e9bbc41 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -1884,6 +1884,10 @@ static int tda1997x_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	for (i = 0; i < 128; i++)
 		io_write(sd, REG_EDID_IN_BYTE128 + i, edid->edid[i+128]);
 
+	/* store state */
+	memcpy(state->edid.edid, edid->edid, 256);
+	state->edid.blocks = edid->blocks;
+
 	tda1997x_enable_edid(sd);
 
 	return 0;
-- 
2.17.1

