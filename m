Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874A1C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 07:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4614220869
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 07:03:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="C6OGDMqb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbeLTHDv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 02:03:51 -0500
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:34770 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbeLTHDv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 02:03:51 -0500
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2018 02:03:50 EST
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 30A7393C
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 06:58:12 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id f6NbRp4p-4r0 for <linux-media@vger.kernel.org>;
        Thu, 20 Dec 2018 00:58:12 -0600 (CST)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 07116C14
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 00:58:12 -0600 (CST)
Received: by mail-io1-f69.google.com with SMTP id y5so738504ion.16
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 22:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=KMYQEMyyybUcQQyBJoB5ewVLk/EnSbZoz+SUWx1zAAQ=;
        b=C6OGDMqbJOiddAkIhfXdDAtudXouRc7ncV0itJNexjnUu6FAbi+XtR4T3FWSd53csG
         t2UC6H0gU5Q/ixH1auCZbTx3CFqqTG3O3q7wYhZZ+YgeB+BGuDxdYl4zvyBmGUzt+qBG
         prUvX2BF4yldU3BhUHfSXGUlSr63qKfrAEP7boZ+s3n6OA3BgfRg4P4Et8uUCrpBswqG
         meuetEy4cQHqCrICGXjX3qAmDZW+BJOh/sn+rbe+3y+quJnwgJXZdx/L8x8oTCRhOgyX
         bG2BN6115YQr2L5DC5UoQ6dL1aOp83Zz5nbxNNg6n1k5YMfERPadmxWbYqECYlnO4KXr
         dGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KMYQEMyyybUcQQyBJoB5ewVLk/EnSbZoz+SUWx1zAAQ=;
        b=O6HrQgPaepfMMuy9vrrhhCX4LXPFhC6YKL8OxZ/iutECB40/oRU3C+tQYXGzO9lHxY
         DFDKfMnIYomQ9IxgWAFSOHYzjUz4KRuuGR++5A8XtjWPcu5dOAxY0x6t5qLFC/gWZYOT
         u2i8T206ROhdV5Ln3lPZv+Adrf4zC1hqLi55ykimmYdCMcgQFv2Td8brVDzPhbQI7W6A
         8C4o9EYUv5KhQOsqF7mMTHr9rJ0VcbfCFqxMeNGRN/GUUOkJubXzfCUbmZGbxWNLihD1
         XiknXPY8l7zKgQjrMLZwMZOIx0M4tJnJbs/thV1XmL+v91yw8pCF/QTHEnuw8lk7cHIx
         O+/A==
X-Gm-Message-State: AA+aEWaM7fKA3oXkrQX60usbxtg+vW1eUBYyj40OgSnbrROS5TbtVSZn
        Gnd+hwXmM8Tms2JyftewOniifKQ8y20dGCeE/ZqxMN0rcQgOs9bupBq71+TqA9c0qktjPh1Rm7Y
        n4LuacZPnxZ+7B1i8en4A0/SZEFw=
X-Received: by 2002:a05:660c:914:: with SMTP id s20mr9015062itj.160.1545289091608;
        Wed, 19 Dec 2018 22:58:11 -0800 (PST)
X-Google-Smtp-Source: AFSGD/VbQC14M/r9MEHUWy44St4FxV3kKHO/z/lhW/e0xyq1tOyYDkaFmea2jjufxGk2AR4Incmwyw==
X-Received: by 2002:a05:660c:914:: with SMTP id s20mr9015055itj.160.1545289091304;
        Wed, 19 Dec 2018 22:58:11 -0800 (PST)
Received: from localhost.localdomain (host-173-230-104-24.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.24])
        by smtp.gmail.com with ESMTPSA id m37sm4558529iti.6.2018.12.19.22.58.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Dec 2018 22:58:10 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: drx: fix a missing check of return value
Date:   Thu, 20 Dec 2018 00:57:44 -0600
Message-Id: <20181220065747.40379-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Function drxj_dap_write_reg16(), which writes data to buffer, may fail.
We need to check if it fails, and if so, we should goto error.
Otherwise, the buffer will have incorrect data.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 551b7d65fa66..d105125bc1c3 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -2136,9 +2136,13 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 
 			word = ((u16) data[2 * i]);
 			word += (((u16) data[(2 * i) + 1]) << 8);
-			drxj_dap_write_reg16(dev_addr,
+			rc = drxj_dap_write_reg16(dev_addr,
 					     (DRXJ_HI_ATOMIC_BUF_START + i),
 					    word, 0);
+			if (rc) {
+				pr_err("error %d\n", rc);
+				goto rw_error;
+			}
 		}
 	}
 
-- 
2.17.2 (Apple Git-113)

