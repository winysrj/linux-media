Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E684C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 18:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5283E20869
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548871223;
	bh=R5keSWwrulEJaveG++Z13MW3eqL8sbbflBH57FQA294=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=0AiDRD2sLDLY3tIGbliVXtPd64jeqL/LA36XTF7VI26xj0xJxzC0c5Ged0OU1LZu8
	 d6wIffDYY1l9XnM3HW1afsK3nENT1hB2q6u2f/NmkCTfzFhqk/wEyAzeS8soKXyj9d
	 h2VIBQ/t2Gs5PuyWc3YKPJXowCW4YDx9yTDNuyW8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbfA3SAW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 13:00:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38918 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfA3SAW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 13:00:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+fp22wRjDuvf0HjSO8AgYUAG6uPqCbeEVitFBjX0C00=; b=SFk7vWy09CX3ERJQyWQqc4poY
        AgneMhFfymavz1bqszn150tZRQeQL37nxWmXaXqIb0SV1HjcF4wypK47zqj/rsuZ6V4qQFWrtHWPW
        adBK3RK61k7hVO8nWlsQAht7/X57StGhq3Tw9hwAa+kEbAjtnb2lv0ZGbtRM+C/nqiB4fYc/LLwVu
        X5TUMJMooQKHJ0Z8WJOjX7i0c29TUXN64H7Rsb4ainH4FxNhcN/Ii87h6YLybsjEO3bwEJrXhFMcT
        chFn8CLo4pvTIbclPiZvNBCPC0SCqunwVKe/Yr0BT9tA0bu0yhJb4wX2uS6IpPzw5PYUSvZYC11FB
        Vw+CeDHWQ==;
Received: from [177.43.31.175] (helo=silica.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gou9r-0007z4-Pk; Wed, 30 Jan 2019 18:00:20 +0000
Date:   Wed, 30 Jan 2019 16:00:04 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Anton Leontiev <scileont@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 2/3] media: vim2m: use per-file handler work queue
Message-ID: <20190130160004.4433b922@silica.lan>
In-Reply-To: <755a24c6fd7ccc34f3d3ccda8caa1dda715241ea.camel@collabora.com>
References: <cover.1548776693.git.mchehab+samsung@kernel.org>
        <7ff2d5c791473c746ae07c012d1890c6bdd08f6d.1548776693.git.mchehab+samsung@kernel.org>
        <0f25ab2f936e3fcb8cd68b55682838027e46eec5.camel@collabora.com>
        <20190130111933.313ed5a0@silica.lan>
        <755a24c6fd7ccc34f3d3ccda8caa1dda715241ea.camel@collabora.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 30 Jan 2019 11:56:58 -0300
Ezequiel Garcia <ezequiel@collabora.com> escreveu:

> Hey Mauro,
> 
> On Wed, 2019-01-30 at 11:19 -0200, Mauro Carvalho Chehab wrote:
> > Em Wed, 30 Jan 2019 09:41:44 -0300
> > Ezequiel Garcia <ezequiel@collabora.com> escreveu:
> >   
> > > On Tue, 2019-01-29 at 14:00 -0200, Mauro Carvalho Chehab wrote:  
> > > > It doesn't make sense to have a per-device work queue, as the
> > > > scheduler should be called per file handler. Having a single
> > > > one causes failures if multiple streams are filtered by vim2m.
> > > >     
> > > 
> > > Having a per-device workqueue should emulate a real device more closely.  
> > 
> > Yes.
> >   
> > > But more importantly, why would having a single workqeueue fail if multiple
> > > streams are run? The m2m should take care of the proper serialization
> > > between multiple contexts, unless I am missing something here.  
> > 
> > Yes, the m2m core serializes the access to m2m src/dest buffer per device.
> > 
> > So, two instances can't access the buffer at the same time. That makes
> > sense for a real physical hardware, although specifically for the virtual
> > one, it doesn't (any may not make sense for some stateless codec, if
> > the codec would internally be able to handle multiple requests at the same
> > time).
> > 
> > Without this patch, when multiple instances are used, sometimes it ends 
> > into a dead lock preventing to stop all of them.
> > 
> > I didn't have time to debug where exactly it happens, but I suspect that
> > the issue is related to using the same mutex for both VB and open/release
> > instances.
> > 
> > Yet, I ended by opting to move all queue-specific mutex/semaphore to be
> > instance-based, as this makes a lot more sense, IMHO. Also, if some day
> > we end by allowing support for some hardware that would have support to
> > run multiple m2m instances in parallel, vim2m would already be ready.
> >   
> 
> I don't oppose to the idea of having a per-context workqueue.
> 
> However, I'm not too comfortable with having a bug somewhere (and not knowing
> whert) and instead of fixing it, working around it. I'd rather
> fix the bug instead, then decide about the workqueue.

I suspect that just using a separate mutex for open/release could
be enough to make the upstream version stable, when multiple instances
are running.


However, it has been a challenge for me to debug it here, as I'm traveling
with limited resources. I'm using the same machine for both desktop, to run
a VM to access some corp resources and to do Kernel devel.

That's usually a very bad idea. Yet, I'm pretty sure that after this patch,
things are stable, as I've been able to test it without any issues and
without needing to reboot my machine.

If you have enough time, feel free to test. Otherwise, I intend to just
apply this patch series, as it fixes a few bugs and make vim2m to
actually display what it would be expected, instead of plotting just some
weird image that the current version shows.

Cheers,
Mauro
