Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F1EC26640
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 19:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91EB120880
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 19:09:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="Cwbg9Dex"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfATTJt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 14:09:49 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:44211 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbfATTJt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 14:09:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pzw1uk1EIzKdw1Ie2lxsXsuUThkuI8uLHe+0hj0Yqbk=; b=Cwbg9DexUyyalRmy8Bgnc9Rkjp
        AYBLl1NDZ/x9z1nMevQVIE1zi7dqicn/i4yYJffqPQ8MSCfMhCrEWYnHvs3hFqT4n5iHYktTOH/Mp
        ZedN1kmbaBIZwAd4jJZy6/tdHVl5sq4kJan/c4WU7XxoChcCSsHyHOHdi2C2PH7fjZh2yeufmO5Mu
        w5u2T7/YGVHTMtUyB27rSuiPsyhB7t6mSZs8LW3FzRgiLQDlrgiXzgUsK/r4JJ2zB95OeTe7JmAqA
        VH3cl8jUo2Y0fK/dEBDEeLO+Cr23Z5yRvoKrPd9GEqa33qmx42Rw/Ux1thvoE8lXEj/oWUwBqrNXz
        f0/Gdrlg==;
Received: from 87-92-92-105.bb.dnainternet.fi ([87.92.92.105] helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <crope@iki.fi>)
        id 1glITa-0002Xu-So; Sun, 20 Jan 2019 21:09:46 +0200
Subject: Re: [PATCH 12/13] si2157: add on-demand rf strength func
To:     Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@kernel.org
References: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
 <1546105882-15693-13-git-send-email-brad@nextdimension.cc>
From:   Antti Palosaari <crope@iki.fi>
Message-ID: <64dd23af-a84c-0bf0-0877-fb71fc005bb5@iki.fi>
Date:   Sun, 20 Jan 2019 21:09:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1546105882-15693-13-git-send-email-brad@nextdimension.cc>
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
> Add get_rf_strength callback to get RSSI from the tuner. DVBv5
> stat cache is updated.
> 
> Signed-off-by: Brad Love <brad@nextdimension.cc>


> ---
>   drivers/media/tuners/si2157.c | 38 +++++++++++++++++++++++++++++++++++++-
>   1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 1737007..f28bf7f 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -752,6 +752,40 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
>   	return 0;
>   }
>   
> +static int si2157_get_rf_strength(struct dvb_frontend *fe, u16 *rssi)
> +{
> +	struct i2c_client *client = fe->tuner_priv;
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	struct si2157_cmd cmd;
> +	int ret;
> +	int strength;
> +
> +	dev_dbg(&client->dev, "\n");
> +
> +	memcpy(cmd.args, "\x42\x00", 2);
> +	cmd.wlen = 2;
> +	cmd.rlen = 12;
> +	ret = si2157_cmd_execute(client, &cmd);
> +	if (ret)
> +		goto err;
> +
> +	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
> +	c->strength.stat[0].svalue = (s8) cmd.args[3] * 1000;
> +
> +	strength = (s8)cmd.args[3];
> +	strength = (strength > -80) ? (u16)(strength + 100) : 0;
> +	strength = strength > 80 ? 100 : strength;
> +
> +	*rssi = (u16)(strength * 0xffff / 100);
> +	dev_dbg(&client->dev, "%s: strength=%d rssi=%u\n",
> +		__func__, (s8)cmd.args[3], *rssi);
> +
> +	return 0;
> +err:
> +	dev_dbg(&client->dev, "failed=%d\n", ret);
> +	return ret;
> +}
> +
>   static const struct dvb_tuner_ops si2157_ops = {
>   	.info = {
>   		.name             = "Silicon Labs Si2141/Si2146/2147/2148/2157/2158",
> @@ -765,7 +799,9 @@ static const struct dvb_tuner_ops si2157_ops = {
>   	.set_analog_params = si2157_set_analog_params,
>   	.get_frequency     = si2157_get_frequency,
>   	.get_bandwidth     = si2157_get_bandwidth,
> -	.get_if_frequency = si2157_get_if_frequency,
> +	.get_if_frequency  = si2157_get_if_frequency,
> +
> +	.get_rf_strength   = si2157_get_rf_strength,
>   };
>   
>   static void si2157_stat_work(struct work_struct *work)
> 

Where that is called from?

It is also hard to read how you convert dBm RSSI value to some other 
scale. There is various clamp() macros for limiting value to desired range.

__func__ should not be passed to dev_ macros, check some manual how to use.

Driver already polls rssi for digital tv, but I assume that is somehow 
related to analog.


regards
Antti

-- 
http://palosaari.fi/
