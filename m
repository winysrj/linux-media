Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2F3C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3122E208E7
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544190120;
	bh=OdV6Mox6x1Zrs+2AO7gMKp0TjuOZMzLKEqBr7wePiJ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=l9QK19kOoEWIybqPN7GkdQgAEqb4rBFG8SW11tL+dLIZAvv9h+JnhFaKjW2f5j2hB
	 Qi3DMWrLmQvQ0mXFIBg6PCssfvrsBgKQ/iPzh9BLtRURqhFwE8UUt6CLuR5YXLpCd1
	 dC08Hr22yq7gOTymXRQ2jzeUi2LwNHL1U3h9lOi4=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3122E208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbeLGNl7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:41:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:57982 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbeLGNl6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:41:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4tMBBj+0C+iJd2F6ACxvnEgAwII0WaYiOyCUwY8ub5U=; b=TNNk0N6H80YctNJDGeaUH+Qyk/
        j3Yj6H5Tnpldcy1Ck6KtIHE2i9jdN5RTYFFD7xKYLKFB3o7H/M+VP6UhBc5fofoTFNImGhQNPToj6
        WfBYdUfjjrb5xSRvIYYWw+S+yCExBLxsvaBakXPYEkSMQ4UWfJwF5bU6YDUGqYglFdysNgz64uyXo
        /8GDIyw87mhdkW2YSrQRTVpCpf3krYJbKRWH8F9LterzHL+EDJduS1ujU5hYN66djZOXlapE8rCbj
        ief8Dd22vHwE0+tVdQu8IuYwlQHULsdJFARmusS+icwNs4uCvszP8yTI01Fo/jXpeTZnFAlpShm5K
        Bvl3areQ==;
Received: from [179.95.33.236] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVGOC-0002Oy-2z; Fri, 07 Dec 2018 13:41:56 +0000
Date:   Fri, 7 Dec 2018 11:41:50 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] media: cedrus: don't initialize pointers with zero
Message-ID: <20181207114150.2dc93fb6@coco.lan>
In-Reply-To: <c426c7ea8159349f3cc23bf7d65d2c24f2ade00e.camel@bootlin.com>
References: <9db60f061d1c577f14136f81af641f58bccbead3.1544187795.git.mchehab+samsung@kernel.org>
        <c426c7ea8159349f3cc23bf7d65d2c24f2ade00e.camel@bootlin.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 07 Dec 2018 14:21:44 +0100
Paul Kocialkowski <paul.kocialkowski@bootlin.com> escreveu:

> Hi,
> 
> On Fri, 2018-12-07 at 08:03 -0500, Mauro Carvalho Chehab wrote:
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
> > As the right initialization would be, instead:
> > 
> > 	struct foo f = { NULL };  
> 
> Thanks for sharing these details, it's definitely interesting and good
> to know :)

Yeah, that's something that was bothering for quite a while, as I've
seen patches using either one of the ways. It took me a while to
do some research, and having it documented at the patch helps, as
we should now handle it the same way for similar stuff :-)

> 
> > Another way to initialize it with gcc is to use:
> > 
> > 	struct foo f = {};
> > 
> > That seems to be a gcc extension, but clang also does the right thing,
> > and that's a clean way for doing it.
> > 
> > Anyway, I decided to check upstream what's the most commonly pattern.
> > The "= {}" pattern has about 2000 entries:
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
> > Meaning that developers have split options on that.
> > 
> > So, let's opt to the simpler form.  
> 
> Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Applied, thanks!

> 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >  drivers/staging/media/sunxi/cedrus/cedrus.c     | 2 +-
> >  drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
> > index b538eb0321d8..b7c918fa5fd1 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
> > @@ -75,7 +75,7 @@ static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
> >  	memset(ctx->ctrls, 0, ctrl_size);
> >  
> >  	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
> > -		struct v4l2_ctrl_config cfg = { 0 };
> > +		struct v4l2_ctrl_config cfg = {};
> >  
> >  		cfg.elem_size = cedrus_controls[i].elem_size;
> >  		cfg.id = cedrus_controls[i].id;
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> > index e40180a33951..f10c25f5460e 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> > @@ -26,7 +26,7 @@ void cedrus_device_run(void *priv)
> >  {
> >  	struct cedrus_ctx *ctx = priv;
> >  	struct cedrus_dev *dev = ctx->dev;
> > -	struct cedrus_run run = { 0 };
> > +	struct cedrus_run run = {};
> >  	struct media_request *src_req;
> >  	unsigned long flags;
> >    



Thanks,
Mauro
