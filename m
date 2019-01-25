Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C9EC282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 13:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E0BE218DE
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 13:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfAYNLc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 08:11:32 -0500
Received: from turbocat.net ([88.99.82.50]:50724 "EHLO mail.turbocat.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbfAYNLc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 08:11:32 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2019 08:11:31 EST
Received: from hps2016.home.selasky.org (unknown [176.74.212.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.turbocat.net (Postfix) with ESMTPSA id F159B26024E;
        Fri, 25 Jan 2019 14:04:08 +0100 (CET)
Subject: [PATCH] strscpy() returns a negative value on failure unlike
 strlcpy().
From:   Hans Petter Selasky <hps@selasky.org>
To:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
References: <506c194b-1dcf-b616-4b33-5fed3394a3a0@selasky.org>
Message-ID: <1973b9cd-9138-fc85-7aff-391cb0f42e71@selasky.org>
Date:   Fri, 25 Jan 2019 14:01:46 +0100
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <506c194b-1dcf-b616-4b33-5fed3394a3a0@selasky.org>
Content-Type: multipart/mixed;
 boundary="------------81678AFFA7D61D17BDAE3DD7"
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This is a multi-part message in MIME format.
--------------81678AFFA7D61D17BDAE3DD7
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

--HPS

--------------81678AFFA7D61D17BDAE3DD7
Content-Type: text/x-patch;
 name="0001-strscpy-returns-a-negative-value-on-failure-unlike-s.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-strscpy-returns-a-negative-value-on-failure-unlike-s.pa";
 filename*1="tch"

From dbdd6c5833103880337e23d56d08f44741589a19 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hps@selasky.org>
Date: Fri, 25 Jan 2019 13:59:01 +0100
Subject: [PATCH] strscpy() returns a negative value on failure unlike
 strlcpy().

Signed-off-by: Hans Petter Selasky <hps@selasky.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index c63746968fa3..5cf2d5d91999 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1354,7 +1354,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	}
 
 	if (descr)
-		WARN_ON(strscpy(fmt->description, descr, sz) >= sz);
+		WARN_ON(strscpy(fmt->description, descr, sz) < 0);
 	fmt->flags = flags;
 }
 
-- 
2.20.1


--------------81678AFFA7D61D17BDAE3DD7--
