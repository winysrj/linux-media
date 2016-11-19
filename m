Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34368 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752652AbcKSSp2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 13:45:28 -0500
MIME-Version: 1.0
In-Reply-To: <1479578112.4382.15.camel@infradead.org>
References: <20161107075524.49d83697@vento.lan> <11020459.EheIgy38UF@wuerfel>
 <20161116182633.74559ffd@vento.lan> <2923918.nyphv1Ma7d@wuerfel>
 <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
 <20161119101543.12b89563@lwn.net> <1479578112.4382.15.camel@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 19 Nov 2016 10:45:26 -0800
Message-ID: <CA+55aFy1r1ZDZjADvpKULC2sgAnSq4qM4W+_PP4Q2R5RG92LoQ@mail.gmail.com>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        ksummit-discuss@lists.linuxfoundation.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 19, 2016 at 9:55 AM, David Woodhouse <dwmw2@infradead.org> wrote:
>
> I know it's unfashionable these days, but TeX always used to be bloody
> good at that kind of thing.

You must have used a different TeX than I did.

TeX is a horrible example. The moment you needed to insert anything
that TeX didn't know about, you were screwed.

I think my go-to for TeX was LaTeX, the "epsfig" thing, and then xfig
and eps files (using fig2dev). Christ, I get flashbacks just thinking
about it.

I thought one of the points of Sphinx was to not have to play those games.

I think that graphviz and svg are the reasonable modern formats. Let's
try to avoid bitmaps in today's world, except perhaps as intermediate
generated things for what we can't avoid.

                    Linus
