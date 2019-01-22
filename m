Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF449C37124
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 00:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F6192089F
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 00:21:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J0dkv+Il"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfAVAV2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 19:21:28 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50716 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfAVAV1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 19:21:27 -0500
Received: by mail-wm1-f67.google.com with SMTP id n190so12511973wmd.0;
        Mon, 21 Jan 2019 16:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Ga5mKc+N9aF/ZKFi1BNMR8WfCFt7DT0TXe677lxwRdw=;
        b=J0dkv+IlAadmMJz08R8Rl52PCzo1Ot0CAv6003f8plk4oZM8HUZuNu9RmTi0cpQJh1
         Yy+EcpSaM1Xd4LKhoextlfcNOE7JBPebTzLwjdAk+uJf6ZSfJEEtZmvba8sD5YOZ6wwh
         Q9iK/PDx88GwGjhoFEUUVX6nxyw90ESOe6oZI4A63aQbi6L47UeJDJg5TXlbLenRhjvP
         6ILiVHEMIfHyZLx8zrg+yVnG2hCMdaIEcDUGHHFPBhgyGec6jHpzj5f5DrtTdeIqtsol
         evIzlYMqJFNG5Azr2FViwRl5NoR2HYZzzCOS8r1QSXmc5qveLXl9q7P2kjJKoSS0xjNb
         mMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ga5mKc+N9aF/ZKFi1BNMR8WfCFt7DT0TXe677lxwRdw=;
        b=gUUdIB09yCqsl4YUQARcqjNQq25kEu+4MOfh1kAadFrIj/Y+/CrzDlczmHTY9EfYQY
         7y9h87RhmZP/dvFBn2RxEwly+7ERDzQ0REraAziH+NOqroElgMZVFXgE+dDEOs1437el
         B52APXF+T2t3MrBK+x+ZPV04g8n4jYGzef0B1iY93VEOx2sK5GfXRqD99smbvs78Fv3f
         5oEJpr21Nry8q6G0Piz9uvX6+K5MP/GsR6XhAzwsyUKcGb53rMSEqG+C8czFxe2RrWDa
         V1mP8kO0NqXlhQYfWqvxtNTLTYZiX5KBHrgZuJSn6JoZQGZ7p3vQJnConLNvBf2cOtpm
         1o6w==
X-Gm-Message-State: AJcUukcDNE4t2gI1UYfhhxIzTjef8rmrmm6FhcOaJg6WpXvpkDQgjYO+
        0juYHTmJp+oxU8++BOvTHvV3exGL
X-Google-Smtp-Source: ALg8bN7IgtPexo+HeHEXc/st/adt/MkebEtfEsjUQsELIpDyF82KVvtOaxRFPUf4K0keu3qfPTyJjA==
X-Received: by 2002:a1c:58ce:: with SMTP id m197mr1354638wmb.31.1548116484762;
        Mon, 21 Jan 2019 16:21:24 -0800 (PST)
Received: from [172.30.88.24] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id z9sm93245451wrs.63.2019.01.21.16.21.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 16:21:24 -0800 (PST)
Subject: Re: [PATCH 1/4] media: imx: csi: Allow unknown nearest upstream
 entities
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190119214600.30897-1-slongerbeam@gmail.com>
 <20190119214600.30897-2-slongerbeam@gmail.com>
 <1548089410.3287.16.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <5e2d614a-ee1e-1ebc-f874-6bf4db22d52c@gmail.com>
Date:   Mon, 21 Jan 2019 16:21:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1548089410.3287.16.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/21/19 8:50 AM, Philipp Zabel wrote:
> On Sat, 2019-01-19 at 13:45 -0800, Steve Longerbeam wrote:
>> On i.MX6, the nearest upstream entity to the CSI can only be the
>> CSI video muxes or the Synopsys DW MIPI CSI-2 receiver.
>>
>> However the i.MX53 has no CSI video muxes or a MIPI CSI-2 receiver.
>> So allow for the nearest upstream entity to the CSI to be something
>> other than those.
>>
>> Fixes: bf3cfaa712e5c ("media: staging/imx: get CSI bus type from nearest
>> upstream entity")
>>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   drivers/staging/media/imx/imx-media-csi.c | 18 ++++++++++++++----
>>   1 file changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index 555aa45e02e3..b9af7d3d4974 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -154,9 +154,10 @@ static inline bool requires_passthrough(struct v4l2_fwnode_endpoint *ep,
>>   /*
>>    * Parses the fwnode endpoint from the source pad of the entity
>>    * connected to this CSI. This will either be the entity directly
>> - * upstream from the CSI-2 receiver, or directly upstream from the
>> - * video mux. The endpoint is needed to determine the bus type and
>> - * bus config coming into the CSI.
>> + * upstream from the CSI-2 receiver, directly upstream from the
>> + * video mux, or directly upstream from the CSI itself. The endpoint
>> + * is needed to determine the bus type and bus config coming into
>> + * the CSI.
>>    */
>>   static int csi_get_upstream_endpoint(struct csi_priv *priv,
>>   				     struct v4l2_fwnode_endpoint *ep)
>> @@ -172,7 +173,8 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
>>   	if (!priv->src_sd)
>>   		return -EPIPE;
>>   
>> -	src = &priv->src_sd->entity;
>> +	sd = priv->src_sd;
>> +	src = &sd->entity;
>>   
>>   	if (src->function == MEDIA_ENT_F_VID_MUX) {
>>   		/*
>> @@ -186,6 +188,14 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
>>   			src = &sd->entity;
>>   	}
>>   
>> +	/*
>> +	 * If the source is neither the video mux nor the CSI-2 receiver,
>> +	 * get the source pad directly upstream from CSI itself.
>> +	 */
>> +	if (src->function != MEDIA_ENT_F_VID_MUX &&
> Will it work correctly if there's an external MUX connected to the CSI?

By external MUX are you referring to some MUX that's external to the SoC 
(e.g. not the CSI muxes which are external to the IPU but internal to 
the SoC)? If so then yes it will still work (and of course it works if 
the MUX in question is the CSI muxes).

The function csi_get_upstream_endpoint() is only looking for, and stops 
at, the first sub-device that is external to the SoC, in order to 
determine the bus type coming into the SoC of the currently enabled 
pipeline. And that sub-device could be anything, including another MUX.

Steve

>
>> +	    sd->grp_id != IMX_MEDIA_GRP_ID_CSI2)
>> +		src = &priv->sd.entity;
>> +
>>   	/* get source pad of entity directly upstream from src */
>>   	pad = imx_media_find_upstream_pad(priv->md, src, 0);
>>   	if (IS_ERR(pad))
> regards
> Philipp

