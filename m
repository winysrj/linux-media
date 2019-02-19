Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322F3C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C222177E
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550586445;
	bh=tpy8rrQJ3yiKTcszAT0FZ3TX6v7c+Aw8pDeNvs1+RqI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=ewAKpipfwecJ5jqSFSe8rDZ7HcUqV2qIxMs1aIYWoNgPdJbptDBy6fz1gjYHeZFsh
	 NM/u5wPxEVQ9aPGMOXU/GPViyccS+9OCnV0ItlGbpK9mPQ0n0pfhZXlyv8GPRSzFEF
	 zzTzQnLQBlfakrVZJgzSfdF5wv9ynmHyINAwBnH8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfBSO1Y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:27:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfBSO1Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 09:27:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CqOSlvNtv34bBqYDcz2M++Og6HIof6lh0zV1Id4i7YQ=; b=egAYBStAtrrVgBXbIhiqhJ3II
        QfYfkJvJHQjdxhVYvVmafhmGIIUKkLBAfYrYMABxX3pYnOIEMoWCSEDZLvEGVWshZhIjQ9p/Q0kF5
        zdp06ZJCqECQeUWd0D3GyrNx27rkTq+bxy9BCy1WNTh7LIWRAF/oIG2uxRmY4p3jZRmTodJEXnz8h
        KXSWDLR9Zug08aeG6whR2SLnl/mZodsrwS0F6ux0a1D/+oNYBKoQ9Lf0wMtVIGDnek/6Up6ECP0gF
        QQUdKa6Qd+aHgaJl1KYR64Tjp29v2Cpf7ooxK5/ANfXckuJe+6j6TDBIHEU02eDX5FE1WwHnbFfhd
        QNyPJG1zQ==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gw6Mk-0002El-TM; Tue, 19 Feb 2019 14:27:23 +0000
Date:   Tue, 19 Feb 2019 11:27:19 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] media: ipu3: shut up warnings produced with W=1
Message-ID: <20190219112719.6275a8ce@coco.lan>
In-Reply-To: <20190219140317.hmsyybhbe7lan2ek@kekkonen.localdomain>
References: <0bdfc56c13c0ffe003f28395fcde2cd9b5ea0622.1550584828.git.mchehab+samsung@kernel.org>
        <20190219140317.hmsyybhbe7lan2ek@kekkonen.localdomain>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 19 Feb 2019 16:03:17 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
> 
> On Tue, Feb 19, 2019 at 09:00:29AM -0500, Mauro Carvalho Chehab wrote:
> > There are lots of warnings produced by this driver. It is not
> > as much as atomisp, but it is still a lot.
> > 
> > So, use the same solution to hide most of them.
> > Those need to be fixed before promoting it out of staging,
> > so add it at the TODO list.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >  drivers/staging/media/ipu3/Makefile | 6 ++++++
> >  drivers/staging/media/ipu3/TODO     | 2 ++
> >  2 files changed, 8 insertions(+)
> > 
> > diff --git a/drivers/staging/media/ipu3/Makefile b/drivers/staging/media/ipu3/Makefile
> > index fb146d178bd4..fa7fa3372bcb 100644
> > --- a/drivers/staging/media/ipu3/Makefile
> > +++ b/drivers/staging/media/ipu3/Makefile
> > @@ -9,3 +9,9 @@ ipu3-imgu-objs += \
> >  		ipu3-css.o ipu3-v4l2.o ipu3.o
> >  
> >  obj-$(CONFIG_VIDEO_IPU3_IMGU) += ipu3-imgu.o
> > +
> > +# HACK! While this driver is in bad shape, don't enable several warnings
> > +#       that would be otherwise enabled with W=1
> > +ccflags-y += $(call cc-disable-warning, packed-not-aligned)
> > +ccflags-y += $(call cc-disable-warning, type-limits)
> > +ccflags-y += $(call cc-disable-warning, unused-const-variable)  
> 
> I'm preparing patches to address these. Could you wait a little bit more,
> please?

Those warnings are there for a while...

It has been really painful for my workflow all those ipu3
warnings, as they're preventing seeing troubles on other places.

Anyway, as soon as you address the issues, we can (partially
or fully) revert those changes.

Thanks,
Mauro
