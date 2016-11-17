Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:33237 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754341AbcKQRCL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 12:02:11 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
References: <20161107075524.49d83697@vento.lan> <11020459.EheIgy38UF@wuerfel>
 <20161116182633.74559ffd@vento.lan> <2923918.nyphv1Ma7d@wuerfel> <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Nov 2016 08:04:37 -0800
Message-ID: <CA+55aFw6s_1iGjNqf+t1XJ-d0RKNzacLery+JoQk-9_dmnosew@mail.gmail.com>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        ksummit-discuss@lists.linuxfoundation.org,
        Josh Triplett <josh@joshtriplett.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 17, 2016 at 8:02 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> No. That is how I *noticed* the issue. Those stupid pdf binary files
> have been around forever, I just didn't notice until the Fedora people
> started complaining about the patches.

Side note: my release patches these days enable both "--binary" and
"-M", so they require "git apply" now. So we handle the binaries fine
in patches now, but as mentioned, that was just what made me notice,
it wasn't a fix for the deeper ("source") problem.

                   Linus
