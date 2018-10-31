Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43754 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbeKADEg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 23:04:36 -0400
Received: by mail-lj1-f195.google.com with SMTP id g26-v6so14423180lja.10
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2018 11:05:29 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id l13-v6sm3389103lji.7.2018.10.31.11.05.27
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Oct 2018 11:05:27 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id g26-v6so14423080lja.10
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2018 11:05:27 -0700 (PDT)
MIME-Version: 1.0
References: <20181030105328.0667ec68@coco.lan>
In-Reply-To: <20181030105328.0667ec68@coco.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 31 Oct 2018 11:05:09 -0700
Message-ID: <CAHk-=whQKCA18MEi7FT=10c0HVa=kxSyYBJeAQH-C2mA5gBhbg@mail.gmail.com>
Subject: Re: [GIT PULL for v4.20-rc1] new experimental media request API
To: mchehab+samsung@kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 30, 2018 at 6:53 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> For a new media API: the request API

Ugh. I don't know how much being in staging matters - if people start
using it, they start using it.

"Staging" does not mean "regressions don't matter".

But pulled,

                Linus
