Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE3CC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 04:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4274D218DE
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 04:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="P7PzVX51"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfBREpy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 23:45:54 -0500
Received: from condef-05.nifty.com ([202.248.20.70]:45930 "EHLO
        condef-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfBREpy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 23:45:54 -0500
Received: from conssluserg-06.nifty.com ([10.126.8.85])by condef-05.nifty.com with ESMTP id x1I4gDnm027747
        for <linux-media@vger.kernel.org>; Mon, 18 Feb 2019 13:42:13 +0900
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id x1I4frEc004906;
        Mon, 18 Feb 2019 13:41:54 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com x1I4frEc004906
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1550464914;
        bh=ztgmX9sUlu2nCI1xh+b3f1xiPfCJOBT6fDt3BnwveqQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=P7PzVX51KZrab9ZW5oqrIT8J9Ju9pNbYmQPWl8I6DAq46mu+FA3czUDWoB7WdsK/u
         X79Ht0QijuBBSrGktArNitimGyuQajVsVVRuJ0R0KuRAy/Oe/8nA0Qa6Rgj/4nc4hF
         VP+5O4peyXNM6rnOwkbzcIWbXY5HKC8KVk97dABHZJgxqDD58FaAzrCXWLKwhElRuq
         r/pc89JXEpH6G2yYVcQiN4lM0Wdy+26umFJ0Quc0WI5A+3ABJIiwAHwRi4BaGRlPDF
         Dsz4qgRGrI7WpF2vdIjugdj22qHEUNvtvd5AZtVKuCD7+mCJReMkNaAspioJUkyt9j
         KbTanO5DajEOw==
X-Nifty-SrcIP: [209.85.222.51]
Received: by mail-ua1-f51.google.com with SMTP id q17so5419174uam.0;
        Sun, 17 Feb 2019 20:41:54 -0800 (PST)
X-Gm-Message-State: AHQUAubQheTv9JHmjvZC0Pt/O4Mo8LF/r+S5eOaTTulfRV+cfMqfAwsW
        Kj665Xc7IJFSz3HpKea+nO7xh+avnnekDOy5U0Q=
X-Google-Smtp-Source: AHgI3IbyDkHjiQeJ0+9MBKEkpsesEfJvKrQFdgUzRewMFLa/BtvuEl7ZmkGxg3+pBwxrNuanj1WRJZbecRcwpSL6DI8=
X-Received: by 2002:ab0:c07:: with SMTP id a7mr12558uak.55.1550464913003; Sun,
 17 Feb 2019 20:41:53 -0800 (PST)
MIME-Version: 1.0
References: <1548399259-17750-1-git-send-email-yamada.masahiro@socionext.com>
In-Reply-To: <1548399259-17750-1-git-send-email-yamada.masahiro@socionext.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Mon, 18 Feb 2019 13:41:17 +0900
X-Gmail-Original-Message-ID: <CAK7LNATPU9DJaOMP=8oOMjeGSuAqWSTh2rSesvvfhjXx4HfxRg@mail.gmail.com>
Message-ID: <CAK7LNATPU9DJaOMP=8oOMjeGSuAqWSTh2rSesvvfhjXx4HfxRg@mail.gmail.com>
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

On Fri, Jan 25, 2019 at 4:00 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> My main motivation is to get rid of crappy header search path manipulation
> from Kbuild core.
>
> Before that, I want to do as many treewide cleanups as possible.
>
> If you are interested in the big picture of this work,
> the full patch set is available at:
> git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git build-test


Could you take a look at this series, please?


>
>
>
> Masahiro Yamada (3):
>   media: coda: remove -I$(src) header search path
>   media: remove unneeded header search paths
>   media: prefix header search paths with $(srctree)/
>
>  drivers/media/common/b2c2/Makefile            | 4 ++--
>  drivers/media/dvb-frontends/cxd2880/Makefile  | 2 --
>  drivers/media/i2c/smiapp/Makefile             | 2 +-
>  drivers/media/mmc/siano/Makefile              | 3 +--
>  drivers/media/pci/b2c2/Makefile               | 2 +-
>  drivers/media/pci/bt8xx/Makefile              | 5 ++---
>  drivers/media/pci/cx18/Makefile               | 4 ++--
>  drivers/media/pci/cx23885/Makefile            | 4 ++--
>  drivers/media/pci/cx88/Makefile               | 4 ++--
>  drivers/media/pci/ddbridge/Makefile           | 4 ++--
>  drivers/media/pci/dm1105/Makefile             | 2 +-
>  drivers/media/pci/mantis/Makefile             | 2 +-
>  drivers/media/pci/netup_unidvb/Makefile       | 2 +-
>  drivers/media/pci/ngene/Makefile              | 4 ++--
>  drivers/media/pci/pluto2/Makefile             | 2 +-
>  drivers/media/pci/pt1/Makefile                | 4 ++--
>  drivers/media/pci/pt3/Makefile                | 4 ++--
>  drivers/media/pci/smipcie/Makefile            | 5 ++---
>  drivers/media/pci/ttpci/Makefile              | 4 ++--
>  drivers/media/platform/coda/Makefile          | 2 --
>  drivers/media/platform/coda/coda-h264.c       | 3 ++-
>  drivers/media/platform/coda/trace.h           | 2 +-
>  drivers/media/platform/sti/c8sectpfe/Makefile | 5 ++---
>  drivers/media/radio/Makefile                  | 2 --
>  drivers/media/spi/Makefile                    | 4 +---
>  drivers/media/usb/as102/Makefile              | 2 +-
>  drivers/media/usb/au0828/Makefile             | 4 ++--
>  drivers/media/usb/b2c2/Makefile               | 2 +-
>  drivers/media/usb/cx231xx/Makefile            | 5 ++---
>  drivers/media/usb/em28xx/Makefile             | 4 ++--
>  drivers/media/usb/go7007/Makefile             | 2 +-
>  drivers/media/usb/pvrusb2/Makefile            | 4 ++--
>  drivers/media/usb/siano/Makefile              | 2 +-
>  drivers/media/usb/tm6000/Makefile             | 4 ++--
>  drivers/media/usb/ttusb-budget/Makefile       | 2 +-
>  drivers/media/usb/usbvision/Makefile          | 2 --
>  36 files changed, 50 insertions(+), 64 deletions(-)
>
> --
> 2.7.4
>


-- 
Best Regards
Masahiro Yamada
