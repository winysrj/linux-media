Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33061 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753884AbeGEMfg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 08:35:36 -0400
Received: by mail-qt0-f193.google.com with SMTP id l10-v6so6912352qtj.0
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 05:35:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1530740760.git.mchehab+samsung@kernel.org> <2a369e8faf3b277baff4026371f298e95c84fbb2.1530740760.git.mchehab+samsung@kernel.org>
In-Reply-To: <2a369e8faf3b277baff4026371f298e95c84fbb2.1530740760.git.mchehab+samsung@kernel.org>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Thu, 5 Jul 2018 08:35:24 -0400
Message-ID: <CAOcJUbzxccYDYoB4ZBPNzVKcidUde56M-=G_PO4vC+Q2N-KqUQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: dvb: convert tuner_info frequencies to Hz
To: mchehab+samsung@kernel.org
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        suzuki.katsuhiro@socionext.com, Antti Palosaari <crope@iki.fi>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        d.scheller.oss@gmail.com, Michael Buesch <m@bues.ch>,
        Olli Salonen <olli.salonen@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 4, 2018 at 10:47 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Right now, satellite tuner drivers specify frequencies in kHz,
> while terrestrial/cable ones specify in Hz. That's confusing
> for developers.
>
> However, the main problem is that universal tuners capable
> of handling both satellite and non-satelite delivery systems
> are appearing. We end by needing to hack the drivers in
> order to support such hybrid tuners.
>
> So, convert everything to specify tuner frequencies in Hz.
>
> Plese notice that a similar patch is also needed for frontends.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

I'm okay with the idea behind this, but I'm not sure I'm behind the
way it's being done.  What if, rather than changing every tuner range
to HZ, instead, to add a new field to indicate the magnitude. This can
be Hz, KHz, MHz, etc

This way, the ranges would remain unaltered, and userspace can remain
unchanged.  Although the patch as-is may solve a problem, it might be
better to solve it with less impact.

-Mike Krufky
