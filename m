Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5C5C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 04:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E598721900
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 04:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="Kp2YaAuE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbfCVEJB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 00:09:01 -0400
Received: from condef-08.nifty.com ([202.248.20.73]:41716 "EHLO
        condef-08.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbfCVEJA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 00:09:00 -0400
Received: from conssluserg-05.nifty.com ([10.126.8.84])by condef-08.nifty.com with ESMTP id x2M43VI2005197
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 13:03:31 +0900
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x2M43PIY030740;
        Fri, 22 Mar 2019 13:03:26 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x2M43PIY030740
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1553227406;
        bh=28+xPXmYPeN1HBmtz7B9dIBqNJifFl2mSkf3nvWDJZs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Kp2YaAuEwLikmvC4tE1wAYayjOtkYpDMHd/shAcuCxRM8AgHeXq/+23dofrv4dVSb
         8HVqnba7Yx3Ox5BtTYo0eetmpzNDc2uKvCm5wUPI0smYhOqbzK4uUIlMT/Ds5R6oET
         j9lpSv6OknJZolWGzA0YH34/WqrI5c4wK+mlDvDbZ81HwstX03Ckp57upG1+MzLkDY
         YLbHqO5PHnNcKgO/Y+RcPC/QCdXXk3uS+QNWZaekxLjwbYRQnlikhZ0Fn5KRzM3Llq
         WIXeVPNiDBSPR8tQR8ATdS44X4opekuejL9WJvab1hAQNsWFf63Ve5pHUh4w4szBLJ
         M/h/Tz9BsBsYg==
X-Nifty-SrcIP: [209.85.217.47]
Received: by mail-vs1-f47.google.com with SMTP id n14so587009vsp.12;
        Thu, 21 Mar 2019 21:03:26 -0700 (PDT)
X-Gm-Message-State: APjAAAXCjCme4oqE+5EffrQjbYMF+4fFjv7IrRi7nUNQQbgfdv3nAIes
        lA8iG2jZr0vXN5KW4b/nwG2pbG8/gcIWGDmi4Rw=
X-Google-Smtp-Source: APXvYqwHCEm0SC52OVyTV8OoSE7BfFl85FvHGE+Zip4cPyPTEvrYX2zS38nhxv3hXh8dKizOL2XZv8yCxd2Y9q+yrt8=
X-Received: by 2002:a67:7c04:: with SMTP id x4mr4634867vsc.155.1553227405005;
 Thu, 21 Mar 2019 21:03:25 -0700 (PDT)
MIME-Version: 1.0
References: <1548399259-17750-1-git-send-email-yamada.masahiro@socionext.com> <CAK7LNATPU9DJaOMP=8oOMjeGSuAqWSTh2rSesvvfhjXx4HfxRg@mail.gmail.com>
In-Reply-To: <CAK7LNATPU9DJaOMP=8oOMjeGSuAqWSTh2rSesvvfhjXx4HfxRg@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Fri, 22 Mar 2019 13:02:49 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQ5g6pFronkmaJrVTvOnep+f_z-LeemDC8_SJAnYz=ZzQ@mail.gmail.com>
Message-ID: <CAK7LNAQ5g6pFronkmaJrVTvOnep+f_z-LeemDC8_SJAnYz=ZzQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] media: clean-up header search paths and add
 $(srctree)/ prefix
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@iki.fi>,
        Patrice Chotard <patrice.chotard@st.com>,
        Akihiro Tsukada <tskd08@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Abylay Ospan <aospan@netup.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sergey Kozlov <serjk@netup.ru>, Mike Isely <isely@pobox.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,


On Mon, Feb 18, 2019 at 1:41 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> Hi Mauro,
>
> On Fri, Jan 25, 2019 at 4:00 PM Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > My main motivation is to get rid of crappy header search path manipulation
> > from Kbuild core.
> >
> > Before that, I want to do as many treewide cleanups as possible.
> >
> > If you are interested in the big picture of this work,
> > the full patch set is available at:
> > git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git build-test
>
>
> Could you take a look at this series, please?

Ping.




> >
> >
> >
> > Masahiro Yamada (3):
> >   media: coda: remove -I$(src) header search path
> >   media: remove unneeded header search paths
> >   media: prefix header search paths with $(srctree)/
> >
> >  drivers/media/common/b2c2/Makefile            | 4 ++--
> >  drivers/media/dvb-frontends/cxd2880/Makefile  | 2 --
> >  drivers/media/i2c/smiapp/Makefile             | 2 +-
> >  drivers/media/mmc/siano/Makefile              | 3 +--
> >  drivers/media/pci/b2c2/Makefile               | 2 +-
> >  drivers/media/pci/bt8xx/Makefile              | 5 ++---
> >  drivers/media/pci/cx18/Makefile               | 4 ++--
> >  drivers/media/pci/cx23885/Makefile            | 4 ++--
> >  drivers/media/pci/cx88/Makefile               | 4 ++--
> >  drivers/media/pci/ddbridge/Makefile           | 4 ++--
> >  drivers/media/pci/dm1105/Makefile             | 2 +-
> >  drivers/media/pci/mantis/Makefile             | 2 +-
> >  drivers/media/pci/netup_unidvb/Makefile       | 2 +-
> >  drivers/media/pci/ngene/Makefile              | 4 ++--
> >  drivers/media/pci/pluto2/Makefile             | 2 +-
> >  drivers/media/pci/pt1/Makefile                | 4 ++--
> >  drivers/media/pci/pt3/Makefile                | 4 ++--
> >  drivers/media/pci/smipcie/Makefile            | 5 ++---
> >  drivers/media/pci/ttpci/Makefile              | 4 ++--
> >  drivers/media/platform/coda/Makefile          | 2 --
> >  drivers/media/platform/coda/coda-h264.c       | 3 ++-
> >  drivers/media/platform/coda/trace.h           | 2 +-
> >  drivers/media/platform/sti/c8sectpfe/Makefile | 5 ++---
> >  drivers/media/radio/Makefile                  | 2 --
> >  drivers/media/spi/Makefile                    | 4 +---
> >  drivers/media/usb/as102/Makefile              | 2 +-
> >  drivers/media/usb/au0828/Makefile             | 4 ++--
> >  drivers/media/usb/b2c2/Makefile               | 2 +-
> >  drivers/media/usb/cx231xx/Makefile            | 5 ++---
> >  drivers/media/usb/em28xx/Makefile             | 4 ++--
> >  drivers/media/usb/go7007/Makefile             | 2 +-
> >  drivers/media/usb/pvrusb2/Makefile            | 4 ++--
> >  drivers/media/usb/siano/Makefile              | 2 +-
> >  drivers/media/usb/tm6000/Makefile             | 4 ++--
> >  drivers/media/usb/ttusb-budget/Makefile       | 2 +-
> >  drivers/media/usb/usbvision/Makefile          | 2 --
> >  36 files changed, 50 insertions(+), 64 deletions(-)
> >
> > --
> > 2.7.4
> >
>
>
> --
> Best Regards
> Masahiro Yamada



-- 
Best Regards
Masahiro Yamada
