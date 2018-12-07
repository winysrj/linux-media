Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0C5C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C46D20892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544182276;
	bh=yK5kZRbepyvDZrOhuHj0N+nENicmtjeL8lZlN8qXgP0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=wwNMjjMUS3jJpFeZeZ8hDiX+KSgJ8PQzIl0BXYG2nKM8G96JPjBfNuH0Mkbm3o8zx
	 OaPJHPqA3JETNVQhdX82wQd6wB59OOSNA0P0Cw31Cqn500dhzc7kWovjVdcPtSTfT9
	 FWK1wDOW2zr3A3Te2BbHkkr29c0Vl9OmSMkbzKLU=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C46D20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbeLGLbP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 06:31:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:47926 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbeLGLbP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 06:31:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RACk3WKIxfiFb3nPJEon9vOh9OydMlebHN0495ebvEc=; b=UkIYXibW/ftXaH/s3+VbMQTOB9
        +BQNOAAfX7vC9o+52+K/2D7/MUANu3N/i0Da7iUqLcapsc23w9trrOZJBmrjFz6TDTVTsc2RzKxBe
        vZa9+NTN0Qywa0hzkON8//Q7zimS87q/jgggZy0xeYYrN3ruiCW4xQ+Rv/S7q4+p1LC0mSX4vO5Dq
        c2OGaBaXlZWxOijTUFTjyn3BsuoVDifvw7Rtln9+tNVomDXDtQ+0j0bJ2Cgey3xQxy5Y3qxsz9nfO
        ys4wkj1h3BXGega7sxnoMRYiRwJnYGSzXDimMbLaCgofCUT5OjdWn4QPNqqcpu7aMx2n3L3Xdlops
        mYeCQbqA==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVELg-0006KA-54; Fri, 07 Dec 2018 11:31:12 +0000
Date:   Fri, 7 Dec 2018 09:31:06 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] media: cedrus: don't initialize pointers with zero
Message-ID: <20181207093106.4f112d0b@coco.lan>
In-Reply-To: <ff5fe553-fee4-bc5c-d1e9-9dc4cc1319ba@xs4all.nl>
References: <dd25052db89ccf292f2a5e45b7e94e8e6d000c40.1544180158.git.mchehab+samsung@kernel.org>
        <ff5fe553-fee4-bc5c-d1e9-9dc4cc1319ba@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 7 Dec 2018 12:14:50 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 12/07/2018 11:56 AM, Mauro Carvalho Chehab wrote:
> > A common mistake is to assume that initializing a var with:
> > 	struct foo f = { 0 };
> > 
> > Would initialize a zeroed struct. Actually, what this does is
> > to initialize the first element of the struct to zero.
> > 
> > According to C99 Standard 6.7.8.21:
> > 
> >     "If there are fewer initializers in a brace-enclosed
> >      list than there are elements or members of an aggregate,
> >      or fewer characters in a string literal used to initialize
> >      an array of known size than there are elements in the array,
> >      the remainder of the aggregate shall be initialized implicitly
> >      the same as objects that have static storage duration."
> > 
> > So, in practice, it could zero the entire struct, but, if the
> > first element is not an integer, it will produce warnings:
> > 
> > 	drivers/staging/media/sunxi/cedrus/cedrus.c:drivers/staging/media/sunxi/cedrus/cedrus.c:78:49:  warning: Using plain integer as NULL pointer
> > 	drivers/staging/media/sunxi/cedrus/cedrus_dec.c:drivers/staging/media/sunxi/cedrus/cedrus_dec.c:29:35:  warning: Using plain integer as NULL pointer
> > 
> > A proper way to initialize it with gcc is to use:
> > 
> > 	struct foo f = { };
> > 
> > But that seems to be a gcc extension. So, I decided to check upstream  
> 
> No, this is not a gcc extension. It's part of the latest C standard.

Sure? Where the C standard spec states that? I've been seeking for
such info for a while, as '= {}' is also my personal preference.

I tried to build the Kernel with clang, just to be sure that this
won't cause issues with the clang support, but, unfortunately, the
clang compiler (not even the upstream version) is able to build
the upstream Kernel yet, as it lacks asm-goto support (there is an
OOT patch for llvm solving it - but it sounds too much effort for
my time to have to build llvm from their sources just for a simple
check like this).

> It's used all over in the kernel, so please use {} instead of { NULL }.
> 
> Personally I think {} is a fantastic invention and I wish C++ had it as
> well.

Fully agreed on that.

> 
> Regards,
> 
> 	Hans
> 
> > what's the most commonly pattern. The gcc pattern has about 2000 entries:
> > 
> > 	$ git grep -E "=\s*\{\s*\}"|wc -l
> > 	1951
> > 
> > The standard-C compliant pattern has about 2500 entries:
> > 
> > 	$ git grep -E "=\s*\{\s*NULL\s*\}"|wc -l
> > 	137
> > 	$ git grep -E "=\s*\{\s*0\s*\}"|wc -l
> > 	2323
> > 
> > So, let's initialize those structs with:
> > 	 = { NULL }
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >  drivers/staging/media/sunxi/cedrus/cedrus.c     | 2 +-
> >  drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
> > index b538eb0321d8..44c45c687503 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
> > @@ -75,7 +75,7 @@ static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
> >  	memset(ctx->ctrls, 0, ctrl_size);
> >  
> >  	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
> > -		struct v4l2_ctrl_config cfg = { 0 };
> > +		struct v4l2_ctrl_config cfg = { NULL };
> >  
> >  		cfg.elem_size = cedrus_controls[i].elem_size;
> >  		cfg.id = cedrus_controls[i].id;
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> > index e40180a33951..4099a42dba2d 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> > @@ -26,7 +26,7 @@ void cedrus_device_run(void *priv)
> >  {
> >  	struct cedrus_ctx *ctx = priv;
> >  	struct cedrus_dev *dev = ctx->dev;
> > -	struct cedrus_run run = { 0 };
> > +	struct cedrus_run run = { NULL };
> >  	struct media_request *src_req;
> >  	unsigned long flags;
> >  
> >   
> 



Thanks,
Mauro
