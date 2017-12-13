Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:39092 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdLMJD6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 04:03:58 -0500
MIME-Version: 1.0
In-Reply-To: <20171211091223.2ba10fb1@vento.lan>
References: <20171208135650.3f385c45@vento.lan> <CA+55aFwBvXVQavgwDKVV3epFhd4MTaQvDktpDahkPhxweXnMmQ@mail.gmail.com>
 <20171211091223.2ba10fb1@vento.lan>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 13 Dec 2017 10:03:56 +0100
Message-ID: <CAMuHMdUkHda_=7oUrPvOLG9Tt8ZdosQJa2mFkMeoLMjhrVV3PA@mail.gmail.com>
Subject: Re: [GIT PULL for v4.15-rc3] media fixes
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Dec 11, 2017 at 12:12 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Without this series, I was getting 809 lines of bogus warnings (see below),
> with was preventing me to see new warnings on my incremental builds
> while applying new patches at the media tree.

$ linux-log-diff build.log{.old,}

(from https://github.com/geertu/linux-scripts)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
