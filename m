Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:42250 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeEELiL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 07:38:11 -0400
Received: by mail-qk0-f177.google.com with SMTP id j10so18610267qke.9
        for <linux-media@vger.kernel.org>; Sat, 05 May 2018 04:38:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5ebaf32866b649cc4e384725ce2742d705c064e6.1525520023.git.mchehab+samsung@kernel.org>
References: <5ebaf32866b649cc4e384725ce2742d705c064e6.1525520023.git.mchehab+samsung@kernel.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 5 May 2018 14:38:09 +0300
Message-ID: <CAHp75Vdu6972ORzVyd345wQDJ6OvKZwhE68yLi1a3m5Y4gpY0Q@mail.gmail.com>
Subject: Re: [PATCH] media: pt1: fix strncmp() size warning
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Akihiro Tsukada <tskd08@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 5, 2018 at 2:33 PM, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> As warned by smatch:
>         drivers/media/pci/pt1/pt1.c:213 config_demod() error: strncmp() '"tc90522sat"' too small (11 vs 20)
>
> Use the same strncmp() syntax as pt1_init_frontends() does.

> +       is_sat = !strncmp(cl->name, TC90522_I2C_DEV_SAT,
> +                         strlen(TC90522_I2C_DEV_SAT));

In this case I don't see a point to use strNcmp(). Plain strcmp() would work.


-- 
With Best Regards,
Andy Shevchenko
