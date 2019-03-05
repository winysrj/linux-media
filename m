Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2C0C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 08:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37D8220848
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 08:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfCEIkm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 03:40:42 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42770 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbfCEIkm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 03:40:42 -0500
Received: by mail-qt1-f193.google.com with SMTP id u7so8164997qtg.9;
        Tue, 05 Mar 2019 00:40:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yenxM1KHEOaUzkNWsEW3RfBPXAcIH6jtrNaR/UemryI=;
        b=oghEYFCQzu+MiKuIjGm0V/Rx0I9IcLiIGpHBhdKVDcgwCZsL9pXInRgjVCWHT65ahp
         CczjBfuo//NJtwq3Q7GbNYtc7ndtBhiu3SUT2fIL8w5CUOPBaDdmgIaet4vpbl1FcTC3
         W+w5adSCDuMBeik0dHImGzv74ikuKeCzIIx/7kATcHStlVNUutPcLuralPF8tzLK/mSu
         Eb6c43F1208smwMZ03t+MsOmg2NBlkCaokKoCpAPHoOHoRPMHbOl8wY3Po7knFNmfTrF
         loP+w1YzCw83edArpWSEXR/NeUxpVSINJ7hiU0wePwpUa11qBGShc2CyXOLE0l5kbR/a
         hO9g==
X-Gm-Message-State: APjAAAVQtPhrRGcsHgCSguGPZeelwhcfHZ4Eb2TYyTWR9k6AnCxBVoHH
        1pr89EaWKvZLLV84ErgVs0FahEIx8XyeeUAYWlo=
X-Google-Smtp-Source: APXvYqxnWSN4EGPZ5sWLBus61NtbajBTOh4nZsNJ/Zv6nQx/twi+DcY3cBt/o7fDVtdqMbwWVagwUgABhDrLefT8uoQ=
X-Received: by 2002:ac8:3251:: with SMTP id y17mr584822qta.152.1551775241213;
 Tue, 05 Mar 2019 00:40:41 -0800 (PST)
MIME-Version: 1.0
References: <20190304202758.1802417-1-arnd@arndb.de> <EE45BB6704246A4E914B70E8B61FB42A15C131D5@SHSMSX104.ccr.corp.intel.com>
 <20190305075317.4t32uyyhzftuoebp@kekkonen.localdomain>
In-Reply-To: <20190305075317.4t32uyyhzftuoebp@kekkonen.localdomain>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 5 Mar 2019 09:40:24 +0100
Message-ID: <CAK8P3a17qNvFvEVpjd5W0gwDn-HocW_ChDyeukiqHBbJbyAedQ@mail.gmail.com>
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

On Tue, Mar 5, 2019 at 8:53 AM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> On Tue, Mar 05, 2019 at 12:25:18AM +0000, Cao, Bingbu wrote:

> > >     struct v4l2_pix_format_mplane *const in =
> > >                                     &q[IPU3_CSS_QUEUE_IN].fmt.mpix;
> > >     struct v4l2_pix_format_mplane *const out = @@ -1753,6 +1754,11 @@
> > > int imgu_css_fmt_try(struct imgu_css *css,
> > >                                     &q[IPU3_CSS_QUEUE_VF].fmt.mpix;
> > >     int i, s, ret;
> > >
> > > +   if (!q) {
> > > +           ret = -ENOMEM;
> > > +           goto out;
> > > +   }
> > [Cao, Bingbu]
> > The goto here is wrong, you can just report an error, and I prefer it is next to the alloc.
>
> I agree, the goto is just not needed.

Should I remove all the gotos then and do an explicit kfree() in each
error path?

I'd prefer not to mix the two styles, as that can lead to subtle mistakes
when the code is refactored again.

      Arnd
