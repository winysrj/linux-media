Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37612 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725755AbeKAHc0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 03:32:26 -0400
Received: by mail-lj1-f194.google.com with SMTP id c4-v6so16350161lja.4
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2018 15:32:22 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id p63-v6sm4432044lfg.46.2018.10.31.15.32.19
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Oct 2018 15:32:20 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id m18-v6so12869020lfl.11
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2018 15:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20181030105328.0667ec68@coco.lan> <CAHk-=whQKCA18MEi7FT=10c0HVa=kxSyYBJeAQH-C2mA5gBhbg@mail.gmail.com>
In-Reply-To: <CAHk-=whQKCA18MEi7FT=10c0HVa=kxSyYBJeAQH-C2mA5gBhbg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 31 Oct 2018 15:32:03 -0700
Message-ID: <CAHk-=wi5wkZtwZQfjVudLtS-Ej9pvaqu6=xM1msoBF8sMuTc_A@mail.gmail.com>
Subject: Re: [GIT PULL for v4.20-rc1] new experimental media request API
To: mchehab+samsung@kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 31, 2018 at 11:05 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But pulled,

I have no idea how I missed this during the actual test compile after
the pull (and yes, I'm sure I did one), but after doing a couple of
more pulls I finally did notice.

After the media pull I get this warning:

  ./usr/include/linux/v4l2-controls.h:1105: found __[us]{8,16,32,64}
type without #include <linux/types.h>

and sure enough, the recent changes to

  include/uapi/linux/v4l2-controls.h

add those new structures use the "__uXY" types without including the
header to define them.

It's harmless in the short term and the kernel build itself obviously
doesn't care apart from the warning, but please fix it.

                     Linus
