Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36239 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753020AbcKSVJm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 16:09:42 -0500
MIME-Version: 1.0
In-Reply-To: <20161119185433.331a132b@vento.lan>
References: <20161107075524.49d83697@vento.lan> <11020459.EheIgy38UF@wuerfel>
 <20161116182633.74559ffd@vento.lan> <2923918.nyphv1Ma7d@wuerfel>
 <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
 <20161119101543.12b89563@lwn.net> <20161119185433.331a132b@vento.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 19 Nov 2016 13:09:40 -0800
Message-ID: <CA+55aFxabyppB3NgH_78J0jOFJDQ4rDe6sw3ijmoANSzXuKcDw@mail.gmail.com>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>,
        ksummit-discuss@lists.linuxfoundation.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 19, 2016 at 12:54 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
>
> I did some research on Friday trying to identify where those images
> came. It turns that, for the oldest images (before I took the media
> maintainership), PDF were actually their "source", as far as I could track,
> in the sense that the *.gif images were produced from the PDF.
>
> The images seem to be generated using some LaTeX tool. Their original
> format were probably EPS.

The original format was almost certainly xfig.

Converting fig files to eps and pdf to then encapsulate them into
LaTeX was a very common way to do documentation with simple figures.
Iirc, xfig natively supported "export as eps".

                Linus
