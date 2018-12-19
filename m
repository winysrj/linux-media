Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1D9C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 14:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C45021841
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 14:51:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DL1tGE9g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbeLSOv3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 09:51:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35206 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbeLSOv2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 09:51:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=o+bT8uJ7twTfSVANB3fgFwiG42Ku6gwOghEO7zhPR+Y=; b=DL1tGE9gY5Us8bdthVr84Pjjb
        dPvqVhcHImb34IatIEPkUmIjSmA8/eSN/gbdzeUJNcsF7JUYYrBmUcclEY0FTj8vK9VbmqxXEDXzw
        gi+GJUde46GItOYNiRPRlee+jHCsCICasKvPWhVEWclviIHKyUpGxPXPrdy/9CuPdjgm3hMfyimdi
        U914H6j0zz0cBIET2ccPMLH6xhFNHtF60G7uWzXN6QS9nf7Jg4lgjODB9sKM0D8+KM2nBjpKG+wK6
        hdLyV4qkaLJtfdB/vbLo5nUsIofpgZiMnGV8bUPBnFmh8WonC8NHPDXLqVSB0wBb9GBgWefsx3qxD
        k+08YnXUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gZdBy-0001LO-Pp; Wed, 19 Dec 2018 14:51:22 +0000
Date:   Wed, 19 Dec 2018 06:51:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>, hdegoede@redhat.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        rostedt@goodmis.org, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Subject: Re: [PATCH v5 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
Message-ID: <20181219145122.GA31947@infradead.org>
References: <20181212135440.GA6137@infradead.org>
 <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
 <20181213140329.GA25339@infradead.org>
 <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
 <20181214123624.GA5824@infradead.org>
 <CAAFQd5BnZHhNjOc6HKt=YVBVQFCcqN0RxAcfDp3S+gDKRvciqQ@mail.gmail.com>
 <20181218073847.GA4552@infradead.org>
 <CAAFQd5AT3ixnbZRm3TOjoWrk2UNH0bXqgR+Z8wyjMhr0xHtSOg@mail.gmail.com>
 <20181219075150.GA26656@infradead.org>
 <CAAFQd5DJPDpFDxU_m2r02bA59J8RCHW7iE8zYQUmkL4sFSz05Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5DJPDpFDxU_m2r02bA59J8RCHW7iE8zYQUmkL4sFSz05Q@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Dec 19, 2018 at 05:18:35PM +0900, Tomasz Figa wrote:
> The existing code that deals with dma_alloc_attrs() without
> DMA_ATTR_NON_CONSISTENT would just call dma_get_sgtable_attrs() like
> here:

I know.  And dma_get_sgtable_attrs is fundamentally flawed and we
need to kill this interface as it just can't worked with virtually
tagged cases.  It is a prime example for an interface that looks
nice and simple but is plain wrong.
