Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D70EC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20DC920892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:37:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20DC920892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbeLGLha (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 06:37:30 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:59593 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbeLGLha (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 06:37:30 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VERgg67NpgJOKVERkgYaor; Fri, 07 Dec 2018 12:37:28 +0100
Subject: Re: [PATCH] media: cedrus: don't initialize pointers with zero
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
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
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4a2f5566-c021-ed9c-a9f0-03d6bcd894d0@xs4all.nl>
Date:   Fri, 7 Dec 2018 12:37:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181207093106.4f112d0b@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfArV9RumTkhV/FgkPMJwmznHSeceNc7RT87Bcouykbh4+FyCr8WoQ1xEJwAbG3bDEhrDM6eELbYNQkCJki3p/J98QtxIM0Nurl9pk8bUzXuu4fx4y4UX
 zPYr2X0NZEH+7p6rQtlNW6vtk7wabbkuP+xFSMtdYkPmMiSqCIfNAhOM31Urg7LXh7mfFt5BBYwCdGzniTarXLR/DLvzRLg7vVvWUGjx36zAyc6OCxlo0MgM
 K3hfu6pzD0PTYzPAsQPC38qZACVMd+2ZrCFA3Vmy/Ylr6ywCycWlpEpa0lz2GARoawcNxKrKy1ko9HnXb2HT9c3YUyEptx02hsOiRc4V+Vzf8tuB8SuIY7a9
 4hdNGWB+aOzjmoR6iu559yEaGtoZK6tHLAFg5K9f4QpvGoqaqTvVOxxKlPbjMiU81T/0SIIKZlOymu76rEuQtm+Aq8l+XbYLGZylC9D8wI6Fbq0uNE/pnvBH
 6LdzXu3rU9srsdoH
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/07/2018 12:31 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 7 Dec 2018 12:14:50 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 12/07/2018 11:56 AM, Mauro Carvalho Chehab wrote:
>>> A common mistake is to assume that initializing a var with:
>>> 	struct foo f = { 0 };
>>>
>>> Would initialize a zeroed struct. Actually, what this does is
>>> to initialize the first element of the struct to zero.
>>>
>>> According to C99 Standard 6.7.8.21:
>>>
>>>     "If there are fewer initializers in a brace-enclosed
>>>      list than there are elements or members of an aggregate,
>>>      or fewer characters in a string literal used to initialize
>>>      an array of known size than there are elements in the array,
>>>      the remainder of the aggregate shall be initialized implicitly
>>>      the same as objects that have static storage duration."
>>>
>>> So, in practice, it could zero the entire struct, but, if the
>>> first element is not an integer, it will produce warnings:
>>>
>>> 	drivers/staging/media/sunxi/cedrus/cedrus.c:drivers/staging/media/sunxi/cedrus/cedrus.c:78:49:  warning: Using plain integer as NULL pointer
>>> 	drivers/staging/media/sunxi/cedrus/cedrus_dec.c:drivers/staging/media/sunxi/cedrus/cedrus_dec.c:29:35:  warning: Using plain integer as NULL pointer
>>>
>>> A proper way to initialize it with gcc is to use:
>>>
>>> 	struct foo f = { };
>>>
>>> But that seems to be a gcc extension. So, I decided to check upstream  
>>
>> No, this is not a gcc extension. It's part of the latest C standard.
> 
> Sure? Where the C standard spec states that? I've been seeking for
> such info for a while, as '= {}' is also my personal preference.

I believe it was added in C11, but I've loaned the book that stated
that to someone else, so I can't check.

In any case, it's used everywhere:

git grep '= *{ *}' drivers/

So it is really pointless to *not* use it.

Regards,

	Hans

> I tried to build the Kernel with clang, just to be sure that this
> won't cause issues with the clang support, but, unfortunately, the
> clang compiler (not even the upstream version) is able to build
> the upstream Kernel yet, as it lacks asm-goto support (there is an
> OOT patch for llvm solving it - but it sounds too much effort for
> my time to have to build llvm from their sources just for a simple
> check like this).
> 
>> It's used all over in the kernel, so please use {} instead of { NULL }.
>>
>> Personally I think {} is a fantastic invention and I wish C++ had it as
>> well.
> 
> Fully agreed on that.
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>> what's the most commonly pattern. The gcc pattern has about 2000 entries:
>>>
>>> 	$ git grep -E "=\s*\{\s*\}"|wc -l
>>> 	1951
>>>
>>> The standard-C compliant pattern has about 2500 entries:
>>>
>>> 	$ git grep -E "=\s*\{\s*NULL\s*\}"|wc -l
>>> 	137
>>> 	$ git grep -E "=\s*\{\s*0\s*\}"|wc -l
>>> 	2323
>>>
>>> So, let's initialize those structs with:
>>> 	 = { NULL }
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>>> ---
>>>  drivers/staging/media/sunxi/cedrus/cedrus.c     | 2 +-
>>>  drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 2 +-
>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
>>> index b538eb0321d8..44c45c687503 100644
>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
>>> @@ -75,7 +75,7 @@ static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
>>>  	memset(ctx->ctrls, 0, ctrl_size);
>>>  
>>>  	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
>>> -		struct v4l2_ctrl_config cfg = { 0 };
>>> +		struct v4l2_ctrl_config cfg = { NULL };
>>>  
>>>  		cfg.elem_size = cedrus_controls[i].elem_size;
>>>  		cfg.id = cedrus_controls[i].id;
>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
>>> index e40180a33951..4099a42dba2d 100644
>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
>>> @@ -26,7 +26,7 @@ void cedrus_device_run(void *priv)
>>>  {
>>>  	struct cedrus_ctx *ctx = priv;
>>>  	struct cedrus_dev *dev = ctx->dev;
>>> -	struct cedrus_run run = { 0 };
>>> +	struct cedrus_run run = { NULL };
>>>  	struct media_request *src_req;
>>>  	unsigned long flags;
>>>  
>>>   
>>
> 
> 
> 
> Thanks,
> Mauro
> 

