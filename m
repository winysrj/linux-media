Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:46396 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752181AbcKSRVP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 12:21:15 -0500
Date: Sat, 19 Nov 2016 10:15:43 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        ksummit-discuss@lists.linuxfoundation.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161119101543.12b89563@lwn.net>
In-Reply-To: <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
References: <20161107075524.49d83697@vento.lan>
        <11020459.EheIgy38UF@wuerfel>
        <20161116182633.74559ffd@vento.lan>
        <2923918.nyphv1Ma7d@wuerfel>
        <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 17 Nov 2016 08:02:50 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> We have makefiles, but more importantly, few enough people actually
> *generate* the documentation, that I think if it's an option to just
> fix sphinx, we should do that instead. If it means that you have to
> have some development version of sphinx, so be it. Most people read
> the documentation either directly in the unprocessed text-files
> ("source code") or on the web (by searching for pre-formatted docs)
> that I really don't think we need to worry too much about the
> toolchain.
> 
> But what we *should* worry about is having the kernel source tree
> contain source.

I would be happy to take a shot at fixing sphinx; we clearly need to
engage more with sphinx upstream in general.  But I guess I still haven't
figured out what "fixing sphinx" means in this case.

I don't know what the ultimate source of these images is (Mauro, perhaps
you could shed some light there?).  Perhaps its SVG for some of the
diagrams, but for the raster images, probably not; it's probably some
weird-ass diagram-editor format.  We could put those in the tree, but
they are likely to be harder to convert to a useful format and will raise
all of the same obnoxious binary patch issues.

Rather than beating our heads against the wall trying to convert between
various image formats, maybe we need to take a step back.  We're trying
to build better documentation, and there is certainly a place for
diagrams and such in that documentation.  Johannes was asking about it
for the 802.11 docs, and I know Paul has run into these issues with the
RCU docs as well.  Might there be a tool or an extension out there that
would allow us to express these diagrams in a text-friendly, editable
form?

With some effort, I bet we could get rid of a number of the images, and
perhaps end up with something that makes sense when read in the .rst
source files as an extra benefit.  But I'm not convinced that we can,
say, sensibly express the differences between different video interlacing
schemes that way.

jon
