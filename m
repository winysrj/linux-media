Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A139C10F00
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 13:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B0452075C
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 13:37:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IUox1IqO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfBVNhI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 08:37:08 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35681 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVNhI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 08:37:08 -0500
Received: by mail-wr1-f66.google.com with SMTP id t18so2422445wrx.2;
        Fri, 22 Feb 2019 05:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TLD8Jbo8UIYeGocg7FuQzap+U6xM4x3R3ICS0R5hStU=;
        b=IUox1IqO893hWKH8DrIOUGRsLBC3MDkURIll2//AofGSIx0GSwgwDesxvtLIImO8GC
         /ecD1eiFEymWePcZC0UYIxpR4hYQo020ztguZSiSuKa3cbTE5eI43Dgw6Lg2t0Yxnvou
         0AOgfjJLFYx6jZVK+SOz/G5jlcurClInhqMdOR3U6UjbnpGse66tbR6x8/rta5ZQ8qbZ
         ttC3eTBHgtMRhiNyzmusJiMYhOkQgyxjWs0rUiTTdbs0c+DVLgVOuSNvHRPfWN+AHVn3
         e/tjj0YI8iVKo5yfZIYD7pfRFOEB2l/qewbvZLR+9uwMQDNi0tzcRsyf3zGKkaxSyTnq
         wqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TLD8Jbo8UIYeGocg7FuQzap+U6xM4x3R3ICS0R5hStU=;
        b=ApGPJG13mi+GxTHOH9pHBVSyTgscY/wTFoDpD5FijjtxuJn9rMMoQBQOaRIpk6TDGR
         1zjoKFAaXADJadOQ7g3eaeOrSzKNYiciSMCHObyH/DRO7Jz98y02nHaFYxTzjRIPhqIn
         X76NP0cVbMsIloO7JeiGdoxlHzFJVZ9l0J1Htr3grSR/poVper5VNLnsQELliMUUoCkU
         4WahghGqXzkcNhiLr3R7aqMpqjiKzkhT6v6JIYV+a8axhg1k3XHTgOjT3U01nHMxVUcV
         rNuJS+br4nswT5DalzR+CdQ6dQ/FWvycbm8puuj1B9k5wPd6k9rPwTiEysqI7w3UjVqQ
         Jhwg==
X-Gm-Message-State: AHQUAuacU5wXyfY3Z0dkYQ5B927x/4pFEN63agO5t4r3O7qcQZyeVDEH
        dDF1+ym9ExDAX/HEh4GDTIg=
X-Google-Smtp-Source: AHgI3IaYERLi4jYJNOAk2znreCyUJa/9uSks7CmUavBYwGeuolPJku8bIX4FO0/e2EH22yyhpEJNXQ==
X-Received: by 2002:a5d:68c9:: with SMTP id p9mr2998220wrw.172.1550842625651;
        Fri, 22 Feb 2019 05:37:05 -0800 (PST)
Received: from ?IPv6:2a00:23c4:1c4c:e100:88de:abfa:71ef:1b73? ([2a00:23c4:1c4c:e100:88de:abfa:71ef:1b73])
        by smtp.googlemail.com with ESMTPSA id f126sm632618wmf.6.2019.02.22.05.37.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 05:37:04 -0800 (PST)
Subject: Re: [PATCH v2 16/30] v4l: subdev: Add [GS]_ROUTING subdev ioctls and
 operations
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo@jmondi.org>
Cc:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
 <20190221143940.k56z2vwovu3y5okh@uno.localdomain>
 <20190221223131.rago5jmpxhygtuep@kekkonen.localdomain>
 <20190222084019.62atdkk6qipnugvf@uno.localdomain>
 <20190222110429.ybmqdwba5rszntb7@paasikivi.fi.intel.com>
 <20190222111747.tlj2xdjhnjwrlqxx@uno.localdomain>
 <20190222112917.l7sgmdb56jmbnos2@paasikivi.fi.intel.com>
From:   Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <df4c7be8-a7da-ee0e-f2ba-ffa8a2da37d9@gmail.com>
Date:   Fri, 22 Feb 2019 13:37:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190222112917.l7sgmdb56jmbnos2@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On 22/02/2019 11:29, Sakari Ailus wrote:
> Hi Jacopo,
> 
> On Fri, Feb 22, 2019 at 12:17:47PM +0100, Jacopo Mondi wrote:
>> Hi Sakari,
>>      thanks for your suggestions.
>>
>> On Fri, Feb 22, 2019 at 01:04:29PM +0200, Sakari Ailus wrote:
>>> Hi Jacopo,
>>
>> [snip]
>>
>>>> On the previous example, I thought about GMSL-like devices, that can
>>>> output the video streams received from different remotes in a
>>>> separate virtual channel, at the same time.
>>>>
>>>> A possible routing table in that case would be like:
>>>>
>>>> Pads 0, 1, 2, 3 = SINKS
>>>> Pad 4 = SOURCE with 4 streams (1 for each VC)
>>>>
>>>> 0/0 -> 4/0
>>>> 0/0 -> 4/1
>>>> 0/0 -> 4/2
>>>> 0/0 -> 4/3
>>>> 1/0 -> 4/0
>>>> 1/0 -> 4/1
>>>> 1/0 -> 4/2
>>>> 1/0 -> 4/3
>>>> 2/0 -> 4/0
>>>> 2/0 -> 4/1
>>>> 2/0 -> 4/2
>>>> 2/0 -> 4/3
>>>> 3/0 -> 4/0
>>>> 3/0 -> 4/1
>>>> 3/0 -> 4/2
>>>> 3/0 -> 4/3
>>>
>>> If more than one pad can handle multiplexed streams, then you may end up in
>>> a situation like that. Indeed.
>>>
>>
>> Please note that in this case there is only one pad that can handle
>> multiplexed stream. The size of the routing table is the
>> multiplication of the total number of pads by the product of all
>> streams per pad. In this case (4 * (1 * 1 * 1 * 4))
> 
> Oh, good point, that's the case for G_ROUTING. I thought of S_ROUTING only.
> :-)
> 
>>
>>>>
>>>> With only one route per virtual channel active at a time.
>>
>> [snip]
>>
>>>>
>>>> Thanks, I had a look at the MEDIA_ ioctls yesterday, G_TOPOLOGY in
>>>> particular, which uses several pointers to arrays.
>>>>
>>>> Unfortunately, I didn't come up with anything better than using a
>>>> translation structure, from the IOCTL layer to the subdevice
>>>> operations layer:
>>>> https://paste.debian.net/hidden/b192969d/
>>>> (sharing a link for early comments, I can send v3 and you can comment
>>>> there directly if you prefer to :)
>>>
>>> Hmm. That is a downside indeed. It's still a lesser problem than the compat
>>> code in general --- which has been a source for bugs as well as nasty
>>> security problems over time.
>>>
>>
>> Good!
>>
>>> I think we need a naming scheme for such structs. How about just
>>> calling that struct e.g. v4l2_subdev_krouting instead? It's simple, easy to
>>> understand and it includes a suggestion which one is the kernel-only
>>> variant.
>>>
>>
>> I kind of like that! thanks!
>>
>>> You can btw. zero the struct memory by assigning { 0 } to it in
>>> declaration. memset() in general is much more trouble. In this case you
>>> could even do the assignments in delaration as well.
>>>
>>
>> Thanks, noted. I have been lazy and copied memset from other places in
>> the ioctl handling code. I should check on your suggestions because I
>> remember one of the many 0-initialization statement was a GCC specific one,
>> don't remember which...
> 
> {} is GCC specific whereas { 0 } is not. But there have been long-standing
> GCC bugs related to the use of { 0 } which is quite unfortunate --- they've
> produced warnings or errors from code that is valid C...
> 

Using = {} to intialise structs is all over the kernel and quite 
accepted. Eg. recent discussion with Mauro at [1].

[1] https://lore.kernel.org/linux-media/20181207105816.4c53aeaa@coco.lan/

Regards,
Ian
