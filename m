Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A35C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 23:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 359A520989
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 23:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEfl8gJ9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 359A520989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbeLEXNT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 18:13:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37380 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727628AbeLEXNS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 18:13:18 -0500
Received: by mail-wr1-f66.google.com with SMTP id j10so21379995wru.4
        for <linux-media@vger.kernel.org>; Wed, 05 Dec 2018 15:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=GMJ9CrANV1RqIvdWW19l/QdPtJIXXTqV7fhsSYBDOg4=;
        b=HEfl8gJ9gIoou+tETzgnGPBeOMgPCdu8nEmrGJbY0lFds9IL6/LoIwtu0YufR+Eknz
         wQ7cJtpB/XAzhWtQjYHV8Q5jnvze7JBV5QaqK/7YrF3m4SdufN3OxlCT4MLHcyOjT9MJ
         yT39KHmTInXScaITSmWeW04+xtS56BYM25RRF2BLG55HDjeftzNcxTXBrNyRiilbFbFH
         9KNxp/2uP4NhLkzewXuDOAytA9BsHbw8B+0WMgiEVzxGb5zRATqYuw+Ev8JNDftv4wcC
         9gF2DPCnJaxosubpjYJ63IVdSv1TTq/Gq3FPpJKaBmv7oQRDicRiUISoC4aFtD2YrRzI
         oduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GMJ9CrANV1RqIvdWW19l/QdPtJIXXTqV7fhsSYBDOg4=;
        b=ISz4TVeuuK3Amx5DRVaYO2qcNiyGHl1UpoHWQijsFI7t1V2oRs/BwBjnB6EQfoU564
         5HzGIJUB9XvTo+Q8nkMlu1/WMmZRR+IL5M4ETkeviRjHuFJ/KtyswlI8R6wraX6dTH0n
         iwDWvJyM5xW3w0KAUj0VJhUGIAELtQ+hyG9AI6Mt1jL+PQHJ84UFQcorXdPEXmPvI5OZ
         m0uk0HONGgI1s2hjYflujhdx6qyk+JmDLAN2vMxMnlOp45AbkSdXNUJD5RhIvBcjCxt7
         gKU36gJnC+y5Bxp8xeB8TbVwcddo9LdWgOXvuHkTYT5DXBY2p2c+rPE12J+buEBWpDh/
         2ljQ==
X-Gm-Message-State: AA+aEWaj7tmtdlbUTQXOoJHt4wpVukERwX9lwWo351NCXpSWlUFSkMHA
        D4Rdi6PeqY36WIFCqYRY1lY=
X-Google-Smtp-Source: AFSGD/UktIdLTwuTlJ64HCDEDDk5OP1Ia+WfRF+V8Pg8+2GFCmbP6kS8aCG2Y0ihYCIU0+l5Xh8ndg==
X-Received: by 2002:adf:f211:: with SMTP id p17mr22933065wro.293.1544051596887;
        Wed, 05 Dec 2018 15:13:16 -0800 (PST)
Received: from [172.30.89.147] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id x81sm14204752wmg.17.2018.12.05.15.13.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 15:13:15 -0800 (PST)
Subject: Re: [PATCH v5] media: imx: add mem2mem device
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
 <a8d3a554-aef8-b8e0-b8ad-f9116bcc3f39@xs4all.nl>
 <73ba2b0c-2776-5aec-193d-408dfcae6ebf@gmail.com>
 <1e246083-7e97-646c-8602-c36507879b2d@xs4all.nl>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <b93de9f7-0ef7-6b13-594f-c8ef750554ea@gmail.com>
Date:   Wed, 5 Dec 2018 15:13:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1e246083-7e97-646c-8602-c36507879b2d@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 12/5/18 10:50 AM, Hans Verkuil wrote:
> On 12/05/2018 02:20 AM, Steve Longerbeam wrote:
>> Hi Hans, Philipp,
>>
>> One comment on my side...
>>
>> On 12/3/18 7:21 AM, Hans Verkuil wrote:
>>> <snip>
>>>> +void imx_media_mem2mem_device_unregister(struct imx_media_video_dev *vdev)
>>>> +{
>>>> +	struct mem2mem_priv *priv = to_mem2mem_priv(vdev);
>>>> +	struct video_device *vfd = priv->vdev.vfd;
>>>> +
>>>> +	mutex_lock(&priv->mutex);
>>>> +
>>>> +	if (video_is_registered(vfd)) {
>>>> +		video_unregister_device(vfd);
>>>> +		media_entity_cleanup(&vfd->entity);
>>> Is this needed?
>>>
>>> If this is to be part of the media controller, then I expect to see a call
>>> to v4l2_m2m_register_media_controller() somewhere.
>>>
>> Yes, I agree there should be a call to
>> v4l2_m2m_register_media_controller(). This driver does not connect with
>> any of the imx-media entities, but calling it will at least make the
>> mem2mem output/capture device entities (and processing entity) visible
>> in the media graph.
>>
>> Philipp, can you pick/squash the following from my media-tree github fork?
>>
>> 6fa05f5170 ("media: imx: mem2mem: Add missing media-device header")
>> d355bf8b15 ("media: imx: Add missing unregister and remove of mem2mem
>> device")
>> 6787a50cdc ("media: imx: mem2mem: Register with media control")
>>
>> Steve
>>
> Why is this driver part of the imx driver? Since it doesn't connect with
> any of the imx-media entities, doesn't that mean that this is really a
> stand-alone driver?

It is basically a stand-alone m2m driver, but it makes use of some 
imx-media utility functions like imx_media_enum_format(). Also making it 
a true stand-alone driver would require creating a second /dev/mediaN 
device.

Steve

