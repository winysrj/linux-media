Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA251C7113C
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 17:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D78120861
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 17:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="w6NPWqVk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfATRR0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 12:17:26 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:46029 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfATRR0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 12:17:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BI1Y9HKtBqhz8rasYIQuBx0TdPaxTwM3bEu4IAwNBuk=; b=w6NPWqVk2iNvev0BPJiq0znxpj
        KWivTR46guEuA7MQrgs8VVVh7Vhcx5XuyBTur+V+Z/d41K4aogWOve3Cuympi//P5EU+AgoMlvJWP
        5Qs+Fwy76WVbcRlV20cdBs2l5wAjhaGWSRUovUVkvng2nqh3MfKnYw/7fByCEENgvLtImcySgsJ6Q
        cP/8cNSDgFmEYGArlSUU6bTDqqHP6bHU83Ktg4GtNg5mGV+l8Qx5gM2ywLEHVm6OG+tcXx3hpsX6Z
        nZ/Of7M4nXYwhJlaJU2Pl5Kqu05IVUnfyfcYXaQKsPTmWLAxJmM4lDu7Wt4KDcsHH5MXzf9ZOYvkU
        5WW1k64w==;
Received: from 87-92-92-105.bb.dnainternet.fi ([87.92.92.105] helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <crope@iki.fi>)
        id 1glGio-0004jY-Oh; Sun, 20 Jan 2019 19:17:22 +0200
Subject: Re: [PATCH 04/13] si2157: Add clock and pin setup for si2141
To:     Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@kernel.org
References: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
 <1546105882-15693-5-git-send-email-brad@nextdimension.cc>
From:   Antti Palosaari <crope@iki.fi>
Message-ID: <a0798756-26a2-ad91-9d29-ec314bbb50b9@iki.fi>
Date:   Sun, 20 Jan 2019 19:17:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1546105882-15693-5-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 87.92.92.105
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 12/29/18 7:51 PM, Brad Love wrote:
> Include some missing setup for si2141
> 
> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
>   drivers/media/tuners/si2157.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index f3a60a1..1ad2d42 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -236,6 +236,23 @@ static int si2157_init(struct dvb_frontend *fe)
>   	dev_info(&client->dev, "firmware version: %c.%c.%d\n",
>   			cmd.args[6], cmd.args[7], cmd.args[8]);
>   
> +	if (dev->chiptype == SI2157_CHIPTYPE_SI2141) {
> +		/* set clock */
> +		memcpy(cmd.args, "\xc0\x00\x0d", 3);
> +		cmd.wlen = 3;
> +		cmd.rlen = 1;
> +		ret = si2157_cmd_execute(client, &cmd);
> +		if (ret)
> +			goto err;
> +		/* setup PIN */
> +		memcpy(cmd.args, "\x12\x80\x80\x85\x00\x81\x00", 7);
> +		cmd.wlen = 7;
> +		cmd.rlen = 7;
> +		ret = si2157_cmd_execute(client, &cmd);
> +		if (ret)
> +			goto err;
> +	}
> +
>   	/* enable tuner status flags */
>   	memcpy(cmd.args, "\x14\x00\x01\x05\x01\x00", 6);
>   	cmd.wlen = 6;
> 

Si2141 is working in my understanding, why these are required?


regards
Antti



-- 
http://palosaari.fi/
