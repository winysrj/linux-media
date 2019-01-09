Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C1AC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54556214C6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:01:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="DuH/z6td"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbfAISBV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:01:21 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:50987 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbfAISBV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 13:01:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4fwfpNo4mnsEOkkhdg/Mt1BrDPaLo8eUx2NCvEJC3/E=; b=DuH/z6tdK7qjyJl5m80PCa6ijS
        ZsGvwsIQyRpup+bh3Sx83uRfvmSRClBdfYl1bCXHkvDaeakau5xg7GpbU9UKymGfcVadZwyw/Fgyp
        Xjba5L4hTNX7s6JSPi8zQiGYWYZBD014c7NzZKQ7k5XXj7DOc+ckGgvGtKIAap/gOvnG1XUtkKJUF
        zCCZysLzyJ7gT7c5Xhkl2B/eimtFCFh9ULr1msTm21ZFX+LVt+vLH46yfJMacA4TTrVxIMzUyr8w5
        mwinnK3fczy6wX9ElSJK7rN+7/Fh8CtUuZ6fwb98ZtwTQLTOCsKZq5uh/wvfHfLxMvo67M/5SQg9D
        uyj5ZIJQ==;
Received: from 87-92-92-105.bb.dnainternet.fi ([87.92.92.105] helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <crope@iki.fi>)
        id 1ghIAH-0004yO-Mp; Wed, 09 Jan 2019 20:01:17 +0200
Subject: Re: [PATCH 02/13] si2157: Check error status bit on cmd execute
To:     Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@kernel.org
References: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
 <1546105882-15693-3-git-send-email-brad@nextdimension.cc>
From:   Antti Palosaari <crope@iki.fi>
Message-ID: <6828d081-1f4a-16bd-07cb-292021450197@iki.fi>
Date:   Wed, 9 Jan 2019 20:01:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1546105882-15693-3-git-send-email-brad@nextdimension.cc>
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
> Check error status bit on command execute, if error bit is
> set return -EAGAIN. Ignore -EAGAIN in probe during device check.
> 
> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
>   drivers/media/tuners/si2157.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 4855448..3924c42 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -56,14 +56,20 @@ static int si2157_cmd_execute(struct i2c_client *client, struct si2157_cmd *cmd)
>   				break;
>   		}
>   
> -		dev_dbg(&client->dev, "cmd execution took %d ms\n",
> +		dev_dbg(&client->dev, "cmd execution took %d ms, status=%x\n",
>   				jiffies_to_msecs(jiffies) -
> -				(jiffies_to_msecs(timeout) - TIMEOUT));
> +				(jiffies_to_msecs(timeout) - TIMEOUT),
> +				cmd->args[0]);
>   
>   		if (!((cmd->args[0] >> 7) & 0x01)) {
>   			ret = -ETIMEDOUT;
>   			goto err_mutex_unlock;
>   		}
> +		/* check error status bit */
> +		if (cmd->args[0] & 0x40) {
> +			ret = -EAGAIN;
> +			goto err_mutex_unlock;
> +		}
>   	}
>   
>   	mutex_unlock(&dev->i2c_mutex);
> @@ -477,7 +483,7 @@ static int si2157_probe(struct i2c_client *client,
>   	cmd.wlen = 0;
>   	cmd.rlen = 1;
>   	ret = si2157_cmd_execute(client, &cmd);
> -	if (ret)
> +	if (ret && (ret != -EAGAIN))
>   		goto err_kfree;
>   
>   	memcpy(&fe->ops.tuner_ops, &si2157_ops, sizeof(struct dvb_tuner_ops));
> 

So you added check if firmware returns error during command execution, 
but that error is still skipped during probe, which does not feel 
correct. Chip should work during probe and ideally driver should ensure 
it is correct chip. At least you should read some property value or 
execute some other command without failure.

regards
Antti

-- 
http://palosaari.fi/
