Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7090BC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1FF520684
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfCEJac (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 04:30:32 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46992 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfCEJac (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 04:30:32 -0500
Received: by mail-qk1-f194.google.com with SMTP id i5so4409465qkd.13;
        Tue, 05 Mar 2019 01:30:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jexVvyA3iEsprtYPEf6Tq7zXfxjDn59k/qoQOcbtQKs=;
        b=LfD5HPPCrzHgy/VrMSNjo55JhnIO+7EQcMbu62plunm3QOE9cvK2Hv5cyO74ERtVl1
         AYvYm82VsuL1vPubasUJ+9IXpwOVCek6Glp/oBQwVnfnarM508b0SXvB0nTMMzh4woVX
         Vh2xKNuknZOh77+2z77GEb0QGGqxwpZHT6CUaVdyyKGeb0rcS7vOjqc1pnp8f8kz2hZ7
         D1+zN4Yo+QKfGJ/vXyd1xRKyc7GlqFbEPzEVGJdoeNnVpTe4p5F1dxk5/sKjpkdnbhqd
         0WHdYzLtRqKQC+EGNAWqSi1nb32mr8cildX9BpV6jU3etHFhKlVN/414sIcVWTBJDkYU
         o04w==
X-Gm-Message-State: APjAAAVq3xY2SGjvB76sZQ/wR2nPwfk2/b0tRhPAfQ3iG+/CzExcPttj
        057tHl7hVjokYnjFzLnp5WxGvPVw4h8jXWE6q1nK4Q==
X-Google-Smtp-Source: APXvYqwOpNaIpNXZokwKfAXBynD4oDunOEqjfwf9wYhv6HwmLb/C0BpSwYs/Sr+FFTupE5HzH3zSWetJMKI+urHLrRM=
X-Received: by 2002:a05:620a:1478:: with SMTP id j24mr933719qkl.343.1551778230956;
 Tue, 05 Mar 2019 01:30:30 -0800 (PST)
MIME-Version: 1.0
References: <20190304202758.1802417-1-arnd@arndb.de> <EE45BB6704246A4E914B70E8B61FB42A15C131D5@SHSMSX104.ccr.corp.intel.com>
 <20190305075317.4t32uyyhzftuoebp@kekkonen.localdomain> <CAK8P3a17qNvFvEVpjd5W0gwDn-HocW_ChDyeukiqHBbJbyAedQ@mail.gmail.com>
 <20190305084720.jlgwd5ifouq3vvra@kekkonen.localdomain>
In-Reply-To: <20190305084720.jlgwd5ifouq3vvra@kekkonen.localdomain>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 5 Mar 2019 10:30:12 +0100
Message-ID: <CAK8P3a0zUqLWO8HgsTOhZdUmRCCLs--U1Z9xm6VuSCYqWA8AXA@mail.gmail.com>
Subject: Re: [PATCH] media: staging/intel-ipu3: reduce kernel stack usage
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     "Cao, Bingbu" <bingbu.cao@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 5, 2019 at 9:47 AM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> On Tue, Mar 05, 2019 at 09:40:24AM +0100, Arnd Bergmann wrote:
> > On Tue, Mar 5, 2019 at 8:53 AM Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
> > > On Tue, Mar 05, 2019 at 12:25:18AM +0000, Cao, Bingbu wrote:
> >
> > > > >     struct v4l2_pix_format_mplane *const in =
> > > > >                                     &q[IPU3_CSS_QUEUE_IN].fmt.mpix;
> > > > >     struct v4l2_pix_format_mplane *const out = @@ -1753,6 +1754,11 @@
> > > > > int imgu_css_fmt_try(struct imgu_css *css,
> > > > >                                     &q[IPU3_CSS_QUEUE_VF].fmt.mpix;
> > > > >     int i, s, ret;
> > > > >
> > > > > +   if (!q) {
> > > > > +           ret = -ENOMEM;
> > > > > +           goto out;
> > > > > +   }
> > > > [Cao, Bingbu]
> > > > The goto here is wrong, you can just report an error, and I prefer it is next to the alloc.
> > >
> > > I agree, the goto is just not needed.
> >
> > Should I remove all the gotos then and do an explicit kfree() in each
> > error path?
> >
> > I'd prefer not to mix the two styles, as that can lead to subtle mistakes
> > when the code is refactored again.
>
> In this case there's no need for kfree as q is NULL. Goto is often useful
> if you need to do things to undo stuff that was done earlier in the
> function but it's not the case here. I prefer keeping the rest gotos.

Ok, I'll send an updated patch the way you suggested then.

     Arnd
