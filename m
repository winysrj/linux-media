Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33947 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752855AbcKRKXR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 05:23:17 -0500
Received: by mail-wm0-f68.google.com with SMTP id g23so4653918wme.1
        for <linux-media@vger.kernel.org>; Fri, 18 Nov 2016 02:23:17 -0800 (PST)
Date: Fri, 18 Nov 2016 11:23:12 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ksummit-discuss@lists.linuxfoundation.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161118102312.45boaus2eobz5gs6@phenom.ffwll.local>
References: <20161107075524.49d83697@vento.lan>
 <11020459.EheIgy38UF@wuerfel>
 <20161116182633.74559ffd@vento.lan>
 <2923918.nyphv1Ma7d@wuerfel>
 <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
 <87y40hxi76.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y40hxi76.fsf@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 18, 2016 at 11:15:09AM +0200, Jani Nikula wrote:
> On Thu, 17 Nov 2016, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > We have makefiles, but more importantly, few enough people actually
> > *generate* the documentation, that I think if it's an option to just
> > fix sphinx, we should do that instead. If it means that you have to
> > have some development version of sphinx, so be it. Most people read
> > the documentation either directly in the unprocessed text-files
> > ("source code") or on the web (by searching for pre-formatted docs)
> > that I really don't think we need to worry too much about the
> > toolchain.
> 
> My secret plan was to make building documentation easy, and then trick
> more people into actually doing that on a regular basis, to ensure we
> keep the build working and the output sensible in a variety of
> environments. Sure we have a bunch of people doing this, and we have
> 0day doing this, but I'd hate it if it became laborous and fiddly to set
> up the toolchain to generate documentation.
> 
> So I'm not necessarily disagreeing with anything you say, but I think
> there's value in having a low bar for entry (from the toolchain POV) for
> people interested in working with documentation, whether they're
> seasoned kernel developers or newcomers purely interested in
> documentation.

Yeah, I want a low bar for doc building too. The initial hack fest we had
to add cross-linking and other dearly needed stuff increased the build
time so much that everyone stopped creating docs. It's of course not as
extreme, but stating that "no one runs the doc toolchain" is imo akin to
"no one runs gcc, developers just read the source and users install rpms".
It's totally true, until you try to change stuff, then you have to be able
to build that pile fast and with an easily-obtained toolchain.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
