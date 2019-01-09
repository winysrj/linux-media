Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A840C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 17:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69D78214C6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 17:26:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PEAT+dLA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfAIR0q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 12:26:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40017 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbfAIR0p (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 12:26:45 -0500
Received: by mail-wm1-f66.google.com with SMTP id f188so9134011wmf.5;
        Wed, 09 Jan 2019 09:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=AnunFOoNxnEJmU+FNN7KCIuhxpIQkCZn8JHGbLCsl1w=;
        b=PEAT+dLAkQ5toeyje8cEz3ubIKF2QhjQisj5S/RiCNcRwwTff1FRtPzdX7Q1nn0h9X
         odiyeyw9PQL3ku2enHgvcRStsUqz8qCUqVEnrMC8HTASFtUgEaebLSXaFaRshveWVndv
         mrCmYOsXF50gd9Q4e2Y+GcJVUfu9/n+8UtnaKAZ34bT/CTysMxcBd1ZoZxleFtoJ9rtL
         OcKTGcMKmBYOZDz23I67zyh9vaNhgvNPeLBHS5bnrAFS+x0SFxitKplwixHTcJ3Q5z7c
         DrgHN7K7K0VFzM4jmPqQL3SRYfOjprDnDUhoUP+EBOt4kmmhl5eCqpETNjJzOFrlKxFG
         +T1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AnunFOoNxnEJmU+FNN7KCIuhxpIQkCZn8JHGbLCsl1w=;
        b=B1z3gYX15XnYlzNwH2+VEa3GXdcijPIE3FGYokJLrNtyASCjKTt2knT4XaKEU46DFP
         oq/EJeg6TmtQWA1nu5zuogO4SEeknd7VmvKO8BPggydioUd3U5MCKbMazaRmbx8HGACW
         lICna0KhtVfPFiNVUKGwe2o/9FqmqLxsNTxGBlEG6rylpWQIDhdsM2d5kzUsKu3lGRe7
         Ax6u0nej2zTHZGWlJ6fSdMbSPi0z55NpzEX48v30xt41ui1U2pQjeinNxMtfdLLlueS8
         MD8MUCVnjkAf5BnqdmzvQCIvEPweonBEf6O4TN7pExsxae4RSfadJ8r97BAt5TasbjhF
         KQLw==
X-Gm-Message-State: AJcUukftb0r6La79sbWHODTkEltsL1U7ffIWKD+gILqWP+yPJowSK24G
        78v10b9IlMoAPGqHsfLhN2RvI+7A
X-Google-Smtp-Source: ALg8bN5sdaAJzrcWA41rxkb8Dq20amC5HWdaWz0OCrfNRbU8B5Ka6iVdy648IieQFLrvyZO4Lby59g==
X-Received: by 2002:a1c:2902:: with SMTP id p2mr6446227wmp.19.1547054803514;
        Wed, 09 Jan 2019 09:26:43 -0800 (PST)
Received: from [172.30.90.141] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id a6sm12638966wmh.10.2019.01.09.09.26.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 09:26:42 -0800 (PST)
Subject: Re: [PATCH v6 05/12] media: imx-csi: Input connections to CSI should
 be optional
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
 <20190109001551.16113-6-slongerbeam@gmail.com>
 <1547032417.4160.2.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <a68dc0db-a37c-2976-9d48-b9da4619aa33@gmail.com>
Date:   Wed, 9 Jan 2019 09:26:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1547032417.4160.2.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/9/19 3:13 AM, Philipp Zabel wrote:
> On Tue, 2019-01-08 at 16:15 -0800, Steve Longerbeam wrote:
>> Some imx platforms do not have fwnode connections to all CSI input
>> ports, and should not be treated as an error. This includes the
>> imx6q SabreAuto, which has no connections to ipu1_csi1 and ipu2_csi0.
>> Return -ENOTCONN in imx_csi_parse_endpoint() so that v4l2-fwnode
>> endpoint parsing will not treat an unconnected endpoint as an error.
>>
>> Fixes: c893500a16baf ("media: imx: csi: Register a subdev notifier")
>>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> ---
>>   drivers/staging/media/imx/imx-media-csi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index e3a4f39dbf73..b276672cae1d 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -1815,7 +1815,7 @@ static int imx_csi_parse_endpoint(struct device *dev,
>>   				  struct v4l2_fwnode_endpoint *vep,
>>   				  struct v4l2_async_subdev *asd)
>>   {
>> -	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -EINVAL;
>> +	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -ENOTCONN;
>>   }
>>   
>>   static int imx_csi_async_register(struct csi_priv *priv)
> Is this something that should be applied as a fix, separately from this
> series?

Yes. I'll submit it separately and send a v7 of this series without it.

Steve


