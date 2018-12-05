Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420D7C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 19:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F160E213A2
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 19:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EUDwsMmt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F160E213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbeLETMC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 14:12:02 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40536 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbeLETMC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 14:12:02 -0500
Received: by mail-wr1-f67.google.com with SMTP id p4so20844542wrt.7
        for <linux-media@vger.kernel.org>; Wed, 05 Dec 2018 11:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=mXk6PZRSEW2ms5wSh1NvG/k/XqAQ8jPINbXJUHwreTA=;
        b=EUDwsMmtBKnE4shshVYEf+waCfzNBrHUmbgPBxuajLOSLzXZZlUy9YZCUnzukIOuDy
         sLPu8NGrHdbjOgvtjzl09NzYfbCg4hBoCx9oebuZek1YnJJEcp4VaOjosfB4b4NvQ2rR
         nZA+P8TR5qWkadYsM95ljDd51oQXOAkQhgS0zOGgvwRnywLsNnaFmnYo7TGN+S0MHyTJ
         5H96nsR6wQhcej1tnvA2HY1GRI9n9hznAJi8usFZVWFceUzDRPGNCqlbbwvO+P62pk0G
         at+zVxcr9EUcryv3TQOh74JTKqgnCqY9ECfYUSrgXAELbtHn3sS4G+twAjjilBZLdwKN
         t/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=mXk6PZRSEW2ms5wSh1NvG/k/XqAQ8jPINbXJUHwreTA=;
        b=fnnO7a3nE7q0Y/lQ3NTd1T9An61mo8EDPfeq2T44wpDUXTmKpo1KjRFjbmCVVmE5S9
         hMb6/FhSPn9pKFqt82lZ8F0rB2WySRZouRSV//ewsydKAdcsvuBajLDzE/xGu4nnIylc
         S9QVgFZyL9TYw2DTXqV1OtOz7f5Bqr+3RfcY8FedQAm9Ku9iTnbPmOYHkxHWd2jO6ju9
         WwjEEcAf3lmyqgBDRGb40wdLgqia2nWywlZjDyK+WxN0r/r7N9vcaohUvh+gD8OC0COy
         bCfE37388wea6GFPvRcydaQE0HK4KJFEchLrL49UoOJhQ7QtbiE7Tnl9cNv35eyYogI0
         bErg==
X-Gm-Message-State: AA+aEWboVcBved2ZScYT9eHmVFp7iMIRRVOJpBKZimycKe7HR92pCZMf
        EZl9jF4j/uBWMocyjKhNs0hRbON9
X-Google-Smtp-Source: AFSGD/UcMU6BZLtGNSKS6cooFXj9sweDCXa9tT5p72/g7js7+nVO9yHDmORJozXIUB4iDXHJNHlQag==
X-Received: by 2002:adf:f5d1:: with SMTP id k17mr24530852wrp.59.1544037120199;
        Wed, 05 Dec 2018 11:12:00 -0800 (PST)
Received: from [192.168.43.227] (92.40.248.24.threembb.co.uk. [92.40.248.24])
        by smtp.gmail.com with ESMTPSA id j14sm18385259wrv.96.2018.12.05.11.11.58
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 11:11:59 -0800 (PST)
From:   Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 1/2] media: lmedm04: Add missing usb_free_urb to free
 interrupt urb.
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <17b98f82-c383-0adf-3430-dda449b4eee5@gmail.com>
Date:   Wed, 5 Dec 2018 19:11:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The interrupt urb is killed but never freed add the function

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
v2 avoiding stale pointer in usb_free_coherent as per sean

 drivers/media/usb/dvb-usb-v2/lmedm04.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index e9b149a26ce5..cba782261a6f 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -1229,6 +1229,7 @@ static void lme2510_exit(struct dvb_usb_device *d)
 		usb_kill_urb(st->lme_urb);
 		usb_free_coherent(d->udev, 128, st->buffer,
 				  st->lme_urb->transfer_dma);
+		usb_free_urb(st->lme_urb);
 		info("Interrupt Service Stopped");
 	}
 }
-- 
2.19.1
