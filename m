Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D68BC04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 22:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 076CF20868
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 22:57:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UUd9zHI4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 076CF20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbeLFW5X (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 17:57:23 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42997 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbeLFW5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 17:57:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id q18so2058754wrx.9
        for <linux-media@vger.kernel.org>; Thu, 06 Dec 2018 14:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=G5VM1eny04vSObA3AMPAKuQNZePV5RReifE3nKoTK1o=;
        b=UUd9zHI4mNTXFnvlsL3OoC33QZGH7zQGGrCbQUwmpyyNfzBkwZf2rOjixDJadW59b6
         pGil/Vqmsw4MjEEL9XdmZ0WrnPjqRPpMPiOoMjtV5Onn0f3S4JOadH+LHr2UR0/BcPgc
         Lcg0W9dkBPFdW1OapGLP/3o/uElSzW4jVGA9GgaP1MG9s/nVBAIihoYEzDIdzm4+xUsu
         LclaR1Hq+yBGb656XY4s0mLWBkbKLlOHEFaC0ujS54a5+XKUbvC2AnxgBAMZVO96EBqM
         qXsvaSzbjrRlTPAa8IT1D3fJ92AikrAkF3bGhy4hlInmDLpHrXQ75IWFC6oLTsvQmkwt
         I9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=G5VM1eny04vSObA3AMPAKuQNZePV5RReifE3nKoTK1o=;
        b=TC6sZKqxeyGE8xfk8SE2riG2wh5AR6BVDPW4sqoTAo6OmwPM1AbNzoR3qCYbjhx2WY
         yKWaz84TyV5/QMkU4T5FHtNsbl+XTOZlqC44xdMYTQXqTL9exM+OWJgbFQP7UJ2x/o+y
         4nkVPbOGpzK54uhgQ6a3Lk7KbeIg28Q8vhINOan2v/XkTf+FN7zF25l/kNjwYgCkmMgu
         /1OjTJdCQrpZ1kJYzZePqtvLi8XGTIroIwgYAhJg95oOcZObSgCXdw/TRDyTsbaDVOHv
         GyEH4BuTRb/K1aXCzInSLFXp2BzcqB3MzB054UUvXW+J6oxR8EUiP+ecccjVodMELhBC
         tCCw==
X-Gm-Message-State: AA+aEWbzW+Pr6BL7pafj4ml9KHoyGk4oyAa1FLbv4rfl03MEsCX8RJRP
        8PY1qyaHcnJALUqZZqhuiMc=
X-Google-Smtp-Source: AFSGD/WVUOuBqzKU1/8SnY4MLDPLp1OZugEp8CS95nmvdFjeBpZl6r++HapegZyMAVFH/8xnqUlA+w==
X-Received: by 2002:adf:a357:: with SMTP id d23mr27934655wrb.195.1544137040352;
        Thu, 06 Dec 2018 14:57:20 -0800 (PST)
Received: from [172.30.89.157] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id m4sm1543697wmc.3.2018.12.06.14.57.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Dec 2018 14:57:19 -0800 (PST)
Subject: Re: [PATCH v5] media: imx: add mem2mem device
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
 <a8d3a554-aef8-b8e0-b8ad-f9116bcc3f39@xs4all.nl>
 <73ba2b0c-2776-5aec-193d-408dfcae6ebf@gmail.com>
 <1e246083-7e97-646c-8602-c36507879b2d@xs4all.nl>
 <b93de9f7-0ef7-6b13-594f-c8ef750554ea@gmail.com>
 <6f0d8d9b-1609-a610-57f0-27223ddcc942@xs4all.nl>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <789e84a6-b8c8-1674-61e2-2b454b7ae3ac@gmail.com>
Date:   Thu, 6 Dec 2018 14:57:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <6f0d8d9b-1609-a610-57f0-27223ddcc942@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On 12/6/18 4:32 AM, Hans Verkuil wrote:
> On 12/06/18 00:13, Steve Longerbeam wrote:
>>
>> On 12/5/18 10:50 AM, Hans Verkuil wrote:
>>> On 12/05/2018 02:20 AM, Steve Longerbeam wrote:
>>>> Hi Hans, Philipp,
>>>>
>>>> One comment on my side...
>>>>
>>>> On 12/3/18 7:21 AM, Hans Verkuil wrote:
>>>>> <snip>
>>>>>> +void imx_media_mem2mem_device_unregister(struct imx_media_video_dev *vdev)
>>>>>> +{
>>>>>> +	struct mem2mem_priv *priv = to_mem2mem_priv(vdev);
>>>>>> +	struct video_device *vfd = priv->vdev.vfd;
>>>>>> +
>>>>>> +	mutex_lock(&priv->mutex);
>>>>>> +
>>>>>> +	if (video_is_registered(vfd)) {
>>>>>> +		video_unregister_device(vfd);
>>>>>> +		media_entity_cleanup(&vfd->entity);
>>>>> Is this needed?
>>>>>
>>>>> If this is to be part of the media controller, then I expect to see a call
>>>>> to v4l2_m2m_register_media_controller() somewhere.
>>>>>
>>>> Yes, I agree there should be a call to
>>>> v4l2_m2m_register_media_controller(). This driver does not connect with
>>>> any of the imx-media entities, but calling it will at least make the
>>>> mem2mem output/capture device entities (and processing entity) visible
>>>> in the media graph.
>>>>
>>>> Philipp, can you pick/squash the following from my media-tree github fork?
>>>>
>>>> 6fa05f5170 ("media: imx: mem2mem: Add missing media-device header")
>>>> d355bf8b15 ("media: imx: Add missing unregister and remove of mem2mem
>>>> device")
>>>> 6787a50cdc ("media: imx: mem2mem: Register with media control")
>>>>
>>>> Steve
>>>>
>>> Why is this driver part of the imx driver? Since it doesn't connect with
>>> any of the imx-media entities, doesn't that mean that this is really a
>>> stand-alone driver?
>> It is basically a stand-alone m2m driver, but it makes use of some
>> imx-media utility functions like imx_media_enum_format(). Also making it
>> a true stand-alone driver would require creating a second /dev/mediaN
>> device.
> If it is standalone, is it reused in newer iMX versions? (7 or 8)

No, this driver makes use of the Image Converter in IPUv3, so it will 
only run on iMX 5/6. The IPU has been dropped in iMX 7 and 8.

> And if it is just a regular m2m device, then it doesn't need to create a
> media device either (doesn't hurt, but it is not required).

Ok, I'll leave that up to Philipp. I don't mind either way whether it is 
folded into imx-media device, or whether it is made stand-alone with or 
without a new media device.

Steve


