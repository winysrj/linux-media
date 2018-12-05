Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D9FC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 19:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF18420850
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 19:14:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N8OXg0jI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF18420850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbeLETOf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 14:14:35 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40805 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbeLETOe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 14:14:34 -0500
Received: by mail-wr1-f66.google.com with SMTP id p4so20851515wrt.7
        for <linux-media@vger.kernel.org>; Wed, 05 Dec 2018 11:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=7aZOC+eW5TaOko0xUUh3YKp/5XEbfXYlDh/kSbqg2J0=;
        b=N8OXg0jIaSU6y8ogfPO5ktMUR0qGmjtb9Ng0Ql1Xn/fne0MhshBf3/CIg0gkZoFKAa
         HXmVs0LmEiZ8dLStq1feW6CpGjJdw1/R6p0Pp5in2ScJqfHEa8KBrPmsiIUVtujuEtCS
         viyHvw3qtMMp0p7RTEtRphdnShfiCrOgfYYbjsk2D9ewGOr0tFt2FTHZuE5s+qxep+DO
         pAiD5GUtOOzF/ctnZuHqQqcqbEaatufA8PuTjO6He/jRX3xWxhlheUdsL32wfwLPtROK
         5/2XaL4v6LlK3Hj11C/zBcilnUMkE5rRnUUO776DWJzyPBshMjQSPfVyFXecQmw0Q6rV
         pxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=7aZOC+eW5TaOko0xUUh3YKp/5XEbfXYlDh/kSbqg2J0=;
        b=MQirGIBZE7sdGcofVmYhmBHP6+MPpPvC86yyDF3P3GE4EQt+JGYj4kolod/xL90luG
         InvztVA3h4VPOk9cpBLP95W+19uetV2Zw7jgFE8tz5qr4606bz1snCqV8fZxYmVS1LSM
         mpoo9o5fNNQ5zr9BHENTuPdOEOflCqZyIgPhdf66AnqB0ZtI735EAfsgqp/WlpM404g9
         3gvtB0CBUH/t0GD/m3ZuZgO9xI/Aca+/RbwfPwWNcWEbPtiERxTr54pUpMsOw9YUv0hu
         6RVnTG2TjjjkSCKh9J6idlmGjJBJSNVcIjkVWHDzcAyLM4QMKSRp3325UNITwhY+lz4d
         U1AQ==
X-Gm-Message-State: AA+aEWaGYPJA+ymaXdkxEuqoZAaiPJafuCl4lDDY1S1z26cpm565z9n7
        y0J9rxAALuU3rhYwBxwK5Ri8UsPI
X-Google-Smtp-Source: AFSGD/UR76qL03HyHYTfM8doOAYq+j1oIwIGyt13ov35Dibd/occ3sp7iODkkCXEu7QCsDp9x6L+zQ==
X-Received: by 2002:adf:83a7:: with SMTP id 36mr23016535wre.13.1544037273102;
        Wed, 05 Dec 2018 11:14:33 -0800 (PST)
Received: from [192.168.43.227] (92.40.248.24.threembb.co.uk. [92.40.248.24])
        by smtp.gmail.com with ESMTPSA id n17sm8900015wmc.5.2018.12.05.11.14.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 11:14:32 -0800 (PST)
From:   Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 2/2] media: lmedm04: Move interrupt buffer to priv buffer.
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <3c964ad4-cefd-bed0-1317-9ae3d3450b47@gmail.com>
Date:   Wed, 5 Dec 2018 19:14:31 +0000
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

Interrupt is always present throughout life time of driver and
there is no dma element move this buffer to private area of driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
v2 removed the need for DMA transfer flags as per Sean 

 drivers/media/usb/dvb-usb-v2/lmedm04.c | 28 +++++++++-----------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index cba782261a6f..602013cf3e69 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -134,7 +134,7 @@ struct lme2510_state {
 	u8 stream_on;
 	u8 pid_size;
 	u8 pid_off;
-	void *buffer;
+	u8 int_buffer[128];
 	struct urb *lme_urb;
 	u8 usb_buffer[64];
 	/* Frontend original calls */
@@ -388,20 +388,14 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 	if (lme_int->lme_urb == NULL)
 			return -ENOMEM;
 
-	lme_int->buffer = usb_alloc_coherent(d->udev, 128, GFP_ATOMIC,
-					&lme_int->lme_urb->transfer_dma);
-
-	if (lme_int->buffer == NULL)
-			return -ENOMEM;
-
 	usb_fill_int_urb(lme_int->lme_urb,
-				d->udev,
-				usb_rcvintpipe(d->udev, 0xa),
-				lme_int->buffer,
-				128,
-				lme2510_int_response,
-				adap,
-				8);
+			 d->udev,
+			 usb_rcvintpipe(d->udev, 0xa),
+			 lme_int->int_buffer,
+			 sizeof(lme_int->int_buffer),
+			 lme2510_int_response,
+			 adap,
+			 8);
 
 	/* Quirk of pipe reporting PIPE_BULK but behaves as interrupt */
 	ep = usb_pipe_endpoint(d->udev, lme_int->lme_urb->pipe);
@@ -409,8 +403,6 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 	if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_BULK)
 		lme_int->lme_urb->pipe = usb_rcvbulkpipe(d->udev, 0xa),
 
-	lme_int->lme_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-
 	usb_submit_urb(lme_int->lme_urb, GFP_ATOMIC);
 	info("INT Interrupt Service Started");
 
@@ -1225,10 +1217,8 @@ static void lme2510_exit(struct dvb_usb_device *d)
 		lme2510_kill_urb(&adap->stream);
 	}
 
-	if (st->lme_urb != NULL) {
+	if (st->lme_urb) {
 		usb_kill_urb(st->lme_urb);
-		usb_free_coherent(d->udev, 128, st->buffer,
-				  st->lme_urb->transfer_dma);
 		usb_free_urb(st->lme_urb);
 		info("Interrupt Service Stopped");
 	}
-- 
2.19.1
