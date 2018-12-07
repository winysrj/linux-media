Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D515BC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 874BC208E7
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:27:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vCnwZFSl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 874BC208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbeLGM1M (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:27:12 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35362 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbeLGM1M (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 07:27:12 -0500
Received: by mail-wr1-f68.google.com with SMTP id 96so3658098wrb.2
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 04:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fa7ZUaeNisB6MwzfrlCnNE/INyEusiuXNzIhSKPzn/U=;
        b=vCnwZFSllKnIZfEyGG8RpqLKKpETyvbE5nwWtNcyS70b7sXGAWuY40+jh9WbLjlppf
         SjyhvGf7QUi2+g5vPFN9swCHpnSpYKlb22g72rkF3rVC/q77rwQBUDBCD1GpH7Gf/Xfq
         m/66nQKtASVxsaO0n9Wl8sZpZpNSOxU6Z1C0mN80UfJE02HCgeWldrOEj83sjmisaG/4
         OukBioA7nxU68WFmd4IkWkntkR1Le92acd08B2qzmonW1s3tz8VKhPqF4QafGXXE/bGU
         UcZdTscDNzzFyMTt3sSBW+VOZmb+Vq/AUkyrumBKUUfwYYIPAlHnHIFQCuoDknKtb1hn
         xSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fa7ZUaeNisB6MwzfrlCnNE/INyEusiuXNzIhSKPzn/U=;
        b=akQWA472EyMkAgP8pMe45vBmw+x8ADTilXWbpYGg2BXXo1kOm+uyAyPcxWLNJIFzZY
         Aae0j96l/NVoISvQGuaAVKzI7GwSpAJ9HhdN5oAU6TtJ2FTS+161GglbLiSZ1Ko2mniz
         3b//is4+60CxcN+H3M7zlDERlzsNwmYxKuGonTruZ6GdWr+gWC1kel2L293o7pQfADp8
         eAzrPQHTlPS6+xQTQ9d6fnYUBXfde47MThKR0/vSfz22oesr+k4zL5NX8gK1bhA2iRj7
         zFiPSpk+vhSW8VrybzzAYZHpscrWYoa9e1t3MrfSyfV90MTPNUdKcXae6Og4gDRVrlNb
         lbmA==
X-Gm-Message-State: AA+aEWbTuTBLy7ZtfjZ/ZBEoMdFSaqGaghs8EmIC/wfZontkEhm/oFer
        K8RaLGxOI583xzLhd/74ST4=
X-Google-Smtp-Source: AFSGD/WfsrMI/6wlplfnyOGpqeMpXomm6KQvdBQNtLYOEabsWsTH5qtiaPNz/Qh+kj6GoHjDqkqxZw==
X-Received: by 2002:adf:9323:: with SMTP id 32mr1597994wro.213.1544185630250;
        Fri, 07 Dec 2018 04:27:10 -0800 (PST)
Received: from ?IPv6:2a00:23c4:1c29:2800:6205:b922:c1e4:51a8? ([2a00:23c4:1c29:2800:6205:b922:c1e4:51a8])
        by smtp.googlemail.com with ESMTPSA id r69sm6509282wmd.4.2018.12.07.04.27.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 04:27:09 -0800 (PST)
Subject: Re: [PATCH] media: cedrus: don't initialize pointers with zero
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
References: <dd25052db89ccf292f2a5e45b7e94e8e6d000c40.1544180158.git.mchehab+samsung@kernel.org>
 <ff5fe553-fee4-bc5c-d1e9-9dc4cc1319ba@xs4all.nl>
 <20181207093106.4f112d0b@coco.lan>
 <4a2f5566-c021-ed9c-a9f0-03d6bcd894d0@xs4all.nl>
From:   Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <948a841b-efde-b43c-9532-abf72c7a6a97@gmail.com>
Date:   Fri, 7 Dec 2018 12:27:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <4a2f5566-c021-ed9c-a9f0-03d6bcd894d0@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 07/12/2018 11:37, Hans Verkuil wrote:
> On 12/07/2018 12:31 PM, Mauro Carvalho Chehab wrote:
>> Em Fri, 7 Dec 2018 12:14:50 +0100
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>> On 12/07/2018 11:56 AM, Mauro Carvalho Chehab wrote:
>>>> A common mistake is to assume that initializing a var with:
>>>> 	struct foo f = { 0 };
>>>>
>>>> Would initialize a zeroed struct. Actually, what this does is
>>>> to initialize the first element of the struct to zero.
>>>>
>>>> According to C99 Standard 6.7.8.21:
>>>>
>>>>      "If there are fewer initializers in a brace-enclosed
>>>>       list than there are elements or members of an aggregate,
>>>>       or fewer characters in a string literal used to initialize
>>>>       an array of known size than there are elements in the array,
>>>>       the remainder of the aggregate shall be initialized implicitly
>>>>       the same as objects that have static storage duration."
>>>>
>>>> So, in practice, it could zero the entire struct, but, if the
>>>> first element is not an integer, it will produce warnings:
>>>>
>>>> 	drivers/staging/media/sunxi/cedrus/cedrus.c:drivers/staging/media/sunxi/cedrus/cedrus.c:78:49:  warning: Using plain integer as NULL pointer
>>>> 	drivers/staging/media/sunxi/cedrus/cedrus_dec.c:drivers/staging/media/sunxi/cedrus/cedrus_dec.c:29:35:  warning: Using plain integer as NULL pointer
>>>>
>>>> A proper way to initialize it with gcc is to use:
>>>>
>>>> 	struct foo f = { };
>>>>
>>>> But that seems to be a gcc extension. So, I decided to check upstream
>>>
>>> No, this is not a gcc extension. It's part of the latest C standard.
>>
>> Sure? Where the C standard spec states that? I've been seeking for
>> such info for a while, as '= {}' is also my personal preference.
> 
> I believe it was added in C11, but I've loaned the book that stated
> that to someone else, so I can't check.

Sadly I don't see mention of empty initializer lists in section 6.7.9 of
ISO/IEC 9899:2011, though I've only got a draft version.

I had a play with Compiler Explorer[1] and it seems like clang is OK
with the {} form though just out of interest msvc isn't. I didn't try
exploring other command line options.

[1] https://gcc.godbolt.org/z/XIDC7W

Regards,
Ian
> 
> In any case, it's used everywhere:
> 
> git grep '= *{ *}' drivers/
> 
> So it is really pointless to *not* use it.
> 
> Regards,
> 
> 	Hans
> 
>> I tried to build the Kernel with clang, just to be sure that this
>> won't cause issues with the clang support, but, unfortunately, the
>> clang compiler (not even the upstream version) is able to build
>> the upstream Kernel yet, as it lacks asm-goto support (there is an
>> OOT patch for llvm solving it - but it sounds too much effort for
>> my time to have to build llvm from their sources just for a simple
>> check like this).
>>
>>> It's used all over in the kernel, so please use {} instead of { NULL }.
>>>
>>> Personally I think {} is a fantastic invention and I wish C++ had it as
>>> well.
>>
>> Fully agreed on that.
>>
>>>
>>> Regards,
>>>
>>> 	Hans
>>>
>>>> what's the most commonly pattern. The gcc pattern has about 2000 entries:
>>>>
>>>> 	$ git grep -E "=\s*\{\s*\}"|wc -l
>>>> 	1951
>>>>
>>>> The standard-C compliant pattern has about 2500 entries:
>>>>
>>>> 	$ git grep -E "=\s*\{\s*NULL\s*\}"|wc -l
>>>> 	137
>>>> 	$ git grep -E "=\s*\{\s*0\s*\}"|wc -l
>>>> 	2323
>>>>
>>>> So, let's initialize those structs with:
>>>> 	 = { NULL }
>>>>
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>>>> ---
>>>>   drivers/staging/media/sunxi/cedrus/cedrus.c     | 2 +-
>>>>   drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 2 +-
>>>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
>>>> index b538eb0321d8..44c45c687503 100644
>>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
>>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
>>>> @@ -75,7 +75,7 @@ static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
>>>>   	memset(ctx->ctrls, 0, ctrl_size);
>>>>   
>>>>   	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
>>>> -		struct v4l2_ctrl_config cfg = { 0 };
>>>> +		struct v4l2_ctrl_config cfg = { NULL };
>>>>   
>>>>   		cfg.elem_size = cedrus_controls[i].elem_size;
>>>>   		cfg.id = cedrus_controls[i].id;
>>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
>>>> index e40180a33951..4099a42dba2d 100644
>>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
>>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
>>>> @@ -26,7 +26,7 @@ void cedrus_device_run(void *priv)
>>>>   {
>>>>   	struct cedrus_ctx *ctx = priv;
>>>>   	struct cedrus_dev *dev = ctx->dev;
>>>> -	struct cedrus_run run = { 0 };
>>>> +	struct cedrus_run run = { NULL };
>>>>   	struct media_request *src_req;
>>>>   	unsigned long flags;
>>>>   
>>>>    
>>>
>>
>>
>>
>> Thanks,
>> Mauro
>>
> 
