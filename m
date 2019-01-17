Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23873C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 15:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E052920851
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 15:54:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="I7MydC1P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfAQPyU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:54:20 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44167 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbfAQPyU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 10:54:20 -0500
Received: by mail-pf1-f195.google.com with SMTP id u6so5006953pfh.11
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 07:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XoyTkci7Xp8nMCsWzbFM4wtrRh6DnJmyxh+OjoiL0IM=;
        b=I7MydC1P7i1ju7q1CMrbpHev2RNE0RTiJhi4H1jlVNeEOCHKMoZEWSb0urKeWSLRZc
         10Bcp9jbY+u0n5lqq/lzgXhSUpoWLtU6VzLpYpCauoJH+M6Em7HE454XQ9ST9eifWoHz
         JXE8afWHg9h7szhHiOxdNsYnuLE58AhoOmnYTp5yYE7ZnniEYPrw4SSEoK0kACVQSKtC
         ywp7tV18XrsvUJtubKtgz7FplJgrZraxgPfv9R7OozrIGFPsmob+p0WHbYxsWYcHl6P3
         K2rrYisDx216Ii5AcbhkkupWq23bb446jIBaKaxskuYsFHQ674O2FTRdQpztvVgLz8XC
         Op2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XoyTkci7Xp8nMCsWzbFM4wtrRh6DnJmyxh+OjoiL0IM=;
        b=pGSIZ8txlzfn0PVfxbuEor1JtclcTqXs8S+Ve2rjjv0/zl/eRiV7zEGgdF2qNdmV+S
         gS6VIekzYHaZTmCslp4hP0WDtzvArCqp6U76FhZ8gjtCit+EwCZ9AMdV9liNS95ULK8v
         O1ItF9jHj3CStjPmcU7TYgPMuqbdLJPEX+Re/k+yZ3tmWLDEW+MVUS6J0YqcD1aJI/Cf
         g5pvAp7oiY1csZWMEmGsK3XaezJ5iBnCSGX3n4aFrW/FJ7nbpT0cp6Jwrm8p8LKiezAL
         WyEJL5tkb2sFUC7VQf6mtfU8fGQLBCC3QToe0u2KpCcD5Moo+0xZiAjQ58docsgeN1Mz
         tKHA==
X-Gm-Message-State: AJcUuketABkdVwGylFKWPeEM1Hj/jpkuXT8qme0jvowRRbFrtyhvJMqx
        gA8gAOGdE9659z/nmrCtD6BahQ==
X-Google-Smtp-Source: ALg8bN7i4AEcXrvgf2w5lkLDM59sbNtHu1LAnlsxU5Ir5bbeI1rNtUTupfIyXf5Xa76CZvPDMT+8ug==
X-Received: by 2002:a62:8c11:: with SMTP id m17mr15472054pfd.224.1547740459205;
        Thu, 17 Jan 2019 07:54:19 -0800 (PST)
Received: from ziepe.ca (S010614cc2056d97f.ed.shawcable.net. [174.3.196.123])
        by smtp.gmail.com with ESMTPSA id u6sm1926006pgr.79.2019.01.17.07.54.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Jan 2019 07:54:18 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1gk9zl-0002uC-9u; Thu, 17 Jan 2019 08:54:17 -0700
Date:   Thu, 17 Jan 2019 08:54:17 -0700
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "hch@lst.de" <hch@lst.de>
Cc:     Thomas Hellstrom <thellstrom@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yong.zhi@intel.com" <yong.zhi@intel.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "syeh@vmware.com" <syeh@vmware.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "imre.deak@intel.com" <imre.deak@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Message-ID: <20190117155417.GA9629@ziepe.ca>
References: <20190104223531.GA1705@ziepe.ca>
 <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <20190115212501.GE22045@ziepe.ca>
 <20190116161134.GA29041@lst.de>
 <20190116172436.GM22045@ziepe.ca>
 <20190117093001.GB31303@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117093001.GB31303@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 17, 2019 at 10:30:01AM +0100, hch@lst.de wrote:
> On Wed, Jan 16, 2019 at 10:24:36AM -0700, Jason Gunthorpe wrote:
> > The fact is there is 0 industry interest in using RDMA on platforms
> > that can't do HW DMA cache coherency - the kernel syscalls required to
> > do the cache flushing on the IO path would just destroy performance to
> > the point of making RDMA pointless. Better to use netdev on those
> > platforms.
> 
> In general there is no syscall required for doing cache flushing, you
> just issue the proper instructions directly from userspace. 

At least on the ARM/MIPS systems I've worked with like this the cache
manipulation instructions are privileged and cannot be executed by
userspace. So the general case requires a syscall.

> In that case we just need to block userspace DMA access entirely.
> Which given the amount of problems it creates sounds like a pretty
> good idea anyway.

I doubt there is any support for that idea...

Jason
