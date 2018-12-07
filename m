Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E6BC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A532E20892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544187507;
	bh=yyGdR4yUgNCKRQ/34auW9Kl2NtfIfI39Fh4jBzwXimQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=V1K43KWXDzz1SwUhcZksLZPlKH6z+1WZGsGMqbDnEdxmhAt7c9oCGc5h/xESFFxrV
	 JmuF8p3DbK025bdTieeUChZjIrWERVVe6OicXABOunfwPCXVZ7oj7xe//TEjocHy7x
	 wxXcJhm83Ygc1YWZAC25Y48XPfWIQDsFEDxPL6vk=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A532E20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbeLGM61 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:58:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:54542 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbeLGM61 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 07:58:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=13NHRxnoLyb4VxDc3oC1vjb27mrBra/tYVqaEF9agAY=; b=nj6CqMtmvHiLiiI1AyhhzkTuhV
        rvi1DI8BstMYwUXphiHMEsUrMffMcHjHqa1XCHeBddKvO5POUR10cTJk88+TMqrJpN7iCt5IT8p8v
        RYHdOftLwoDNdZ0c4u8tVQUkV0nGiok41Yl3QhF4e4/R/VaX8/PpbrYnRXmjGKcTyS1CPOnQ4vC3w
        uujJhl7m0jmtNMBGniyLF/tYMR4c9o4fw7FiRsrL6XjqqJuFjC5uPpAMt6seBqIRIaAvKgDP8y2QX
        fcYLmwyiUTkCc7gRodGzqdceKWvzGo5Vms9l5i40f4yRVZIFQYJiwCTNOHQucCxfyuQ4uQJSasE++
        0XhBvrYw==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVFi1-0000n3-VQ; Fri, 07 Dec 2018 12:58:22 +0000
Date:   Fri, 7 Dec 2018 10:58:16 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Ian Arkver <ian.arkver.dev@gmail.com>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] media: cedrus: don't initialize pointers with zero
Message-ID: <20181207105816.4c53aeaa@coco.lan>
In-Reply-To: <948a841b-efde-b43c-9532-abf72c7a6a97@gmail.com>
References: <dd25052db89ccf292f2a5e45b7e94e8e6d000c40.1544180158.git.mchehab+samsung@kernel.org>
        <ff5fe553-fee4-bc5c-d1e9-9dc4cc1319ba@xs4all.nl>
        <20181207093106.4f112d0b@coco.lan>
        <4a2f5566-c021-ed9c-a9f0-03d6bcd894d0@xs4all.nl>
        <948a841b-efde-b43c-9532-abf72c7a6a97@gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 7 Dec 2018 12:27:09 +0000
Ian Arkver <ian.arkver.dev@gmail.com> escreveu:

> On 07/12/2018 11:37, Hans Verkuil wrote:
> > On 12/07/2018 12:31 PM, Mauro Carvalho Chehab wrote:  
> >> Em Fri, 7 Dec 2018 12:14:50 +0100
> >> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>  
> >>> On 12/07/2018 11:56 AM, Mauro Carvalho Chehab wrote:  
> >>>> A common mistake is to assume that initializing a var with:
> >>>> 	struct foo f = { 0 };
> >>>>
> >>>> Would initialize a zeroed struct. Actually, what this does is
> >>>> to initialize the first element of the struct to zero.
> >>>>
> >>>> According to C99 Standard 6.7.8.21:
> >>>>
> >>>>      "If there are fewer initializers in a brace-enclosed
> >>>>       list than there are elements or members of an aggregate,
> >>>>       or fewer characters in a string literal used to initialize
> >>>>       an array of known size than there are elements in the array,
> >>>>       the remainder of the aggregate shall be initialized implicitly
> >>>>       the same as objects that have static storage duration."
> >>>>
> >>>> So, in practice, it could zero the entire struct, but, if the
> >>>> first element is not an integer, it will produce warnings:
> >>>>
> >>>> 	drivers/staging/media/sunxi/cedrus/cedrus.c:drivers/staging/media/sunxi/cedrus/cedrus.c:78:49:  warning: Using plain integer as NULL pointer
> >>>> 	drivers/staging/media/sunxi/cedrus/cedrus_dec.c:drivers/staging/media/sunxi/cedrus/cedrus_dec.c:29:35:  warning: Using plain integer as NULL pointer
> >>>>
> >>>> A proper way to initialize it with gcc is to use:
> >>>>
> >>>> 	struct foo f = { };
> >>>>
> >>>> But that seems to be a gcc extension. So, I decided to check upstream  
> >>>
> >>> No, this is not a gcc extension. It's part of the latest C standard.  
> >>
> >> Sure? Where the C standard spec states that? I've been seeking for
> >> such info for a while, as '= {}' is also my personal preference.  
> > 
> > I believe it was added in C11, but I've loaned the book that stated
> > that to someone else, so I can't check.  
> 
> Sadly I don't see mention of empty initializer lists in section 6.7.9 of
> ISO/IEC 9899:2011, though I've only got a draft version.

Yeah, as far as I checked, this is not really part of the standard.

Depending on how you read:

      "If there are fewer initializers in a brace-enclosed
       list than there are elements or members of an aggregate,
       or fewer characters in a string literal used to initialize
       an array of known size than there are elements in the array,
       the remainder of the aggregate shall be initialized implicitly
       the same as objects that have static storage duration."

One may infere that a brace-enclosed list with zero elements
would fit, and "the remainder of the aggregate shall be
initialized implicitly".

I suspect that this is how gcc people interpreted it.

> I had a play with Compiler Explorer[1] and it seems like clang is OK
> with the {} form though just out of interest msvc isn't.

Yeah, I'm aware that msvc won't support it. Good to know that clang
does the right thing cleaning the struct.

To be realistic, we only really care with gcc at the Kernel side, as
clang upstream versions still can't build upstream Kernels, and
nobody uses any other compiler for the Kernel anymore. Yet, with
regards to clang, there's a push to let it to build the Kernel.
So, it seems wise to add something that would work for both.

Anyway, I'll post a version 2 of this patch using ={} and placing
some rationale on it.

> I didn't try
> exploring other command line options.
> 
> [1] https://gcc.godbolt.org/z/XIDC7W
> 
> Regards,
> Ian
> > 
> > In any case, it's used everywhere:
> > 
> > git grep '= *{ *}' drivers/
> > 
> > So it is really pointless to *not* use it.
> > 
> > Regards,
> > 
> > 	Hans
> >   
> >> I tried to build the Kernel with clang, just to be sure that this
> >> won't cause issues with the clang support, but, unfortunately, the
> >> clang compiler (not even the upstream version) is able to build
> >> the upstream Kernel yet, as it lacks asm-goto support (there is an
> >> OOT patch for llvm solving it - but it sounds too much effort for
> >> my time to have to build llvm from their sources just for a simple
> >> check like this).
> >>  
> >>> It's used all over in the kernel, so please use {} instead of { NULL }.
> >>>
> >>> Personally I think {} is a fantastic invention and I wish C++ had it as
> >>> well.  
> >>
> >> Fully agreed on that.
> >>  
> >>>
> >>> Regards,
> >>>
> >>> 	Hans
> >>>  
> >>>> what's the most commonly pattern. The gcc pattern has about 2000 entries:
> >>>>
> >>>> 	$ git grep -E "=\s*\{\s*\}"|wc -l
> >>>> 	1951
> >>>>
> >>>> The standard-C compliant pattern has about 2500 entries:
> >>>>
> >>>> 	$ git grep -E "=\s*\{\s*NULL\s*\}"|wc -l
> >>>> 	137
> >>>> 	$ git grep -E "=\s*\{\s*0\s*\}"|wc -l
> >>>> 	2323
> >>>>
> >>>> So, let's initialize those structs with:
> >>>> 	 = { NULL }
> >>>>
> >>>> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> >>>> ---
> >>>>   drivers/staging/media/sunxi/cedrus/cedrus.c     | 2 +-
> >>>>   drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 2 +-
> >>>>   2 files changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
> >>>> index b538eb0321d8..44c45c687503 100644
> >>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
> >>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
> >>>> @@ -75,7 +75,7 @@ static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
> >>>>   	memset(ctx->ctrls, 0, ctrl_size);
> >>>>   
> >>>>   	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
> >>>> -		struct v4l2_ctrl_config cfg = { 0 };
> >>>> +		struct v4l2_ctrl_config cfg = { NULL };
> >>>>   
> >>>>   		cfg.elem_size = cedrus_controls[i].elem_size;
> >>>>   		cfg.id = cedrus_controls[i].id;
> >>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> >>>> index e40180a33951..4099a42dba2d 100644
> >>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> >>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> >>>> @@ -26,7 +26,7 @@ void cedrus_device_run(void *priv)
> >>>>   {
> >>>>   	struct cedrus_ctx *ctx = priv;
> >>>>   	struct cedrus_dev *dev = ctx->dev;
> >>>> -	struct cedrus_run run = { 0 };
> >>>> +	struct cedrus_run run = { NULL };
> >>>>   	struct media_request *src_req;
> >>>>   	unsigned long flags;
> >>>>   
> >>>>      
> >>>  
> >>
> >>
> >>
> >> Thanks,
> >> Mauro
> >>  
> >   



Thanks,
Mauro
