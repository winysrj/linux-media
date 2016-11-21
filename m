Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37237
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753157AbcKUOHF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 09:07:05 -0500
Date: Mon, 21 Nov 2016 12:06:57 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        ksummit-discuss@lists.linuxfoundation.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161121120657.31eaeca4@vento.lan>
In-Reply-To: <1479724781.8662.18.camel@sipsolutions.net>
References: <20161107075524.49d83697@vento.lan>
        <11020459.EheIgy38UF@wuerfel>
        <20161116182633.74559ffd@vento.lan>
        <2923918.nyphv1Ma7d@wuerfel>
        <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
        <20161119101543.12b89563@lwn.net>
        <1479724781.8662.18.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Nov 2016 11:39:41 +0100
Johannes Berg <johannes@sipsolutions.net> escreveu:

> On Sat, 2016-11-19 at 10:15 -0700, Jonathan Corbet wrote:
> > 
> > I don't know what the ultimate source of these images is (Mauro,
> > perhaps you could shed some light there?).  
> 
> I'd argue that it probably no longer matters. Whether it's xfig, svg,
> graphviz originally etc. - the source is probably long lost. Recreating
> these images in any other format is probably not very difficult for
> most or almost all of them.

I did it already. I converted one image to Graphviz and the rest
to SVG.

> 
> > Rather than beating our heads against the wall trying to convert
> > between various image formats, maybe we need to take a step
> > back.  We're trying to build better documentation, and there is
> > certainly a place for diagrams and such in that
> > documentation.  Johannes was asking about it for the 802.11 docs, and
> > I know Paul has run into these issues with the RCU docs as
> > well.  Might there be a tool or an extension out there that would
> > allow us to express these diagrams in a text-friendly, editable
> > form?
> > 
> > With some effort, I bet we could get rid of a number of the images,
> > and perhaps end up with something that makes sense when read in the
> > .rst source files as an extra benefit.   
> 
> I tend to agree, and I think that having this readable in the text
> would be good.
> 
> You had pointed me to this plugin before
> https://pythonhosted.org/sphinxcontrib-aafig/
> 
> but I don't think it can actually represent any of the pictures.

No, but there are some ascii art images inside some txt/rst files
and inside some kernel-doc comments. We could either use the above
extension for them or to convert into some image. The ascii art
images I saw seem to be diagrams, so Graphviz would allow replacing
most of them, if not all.

> Some surely could be represented directly by having the graphviz source
> inside the rst file:
> http://www.sphinx-doc.org/en/1.4.8/ext/graphviz.html
> 
> (that's even an included plugin, no need to install anything extra)

Yes, but it seems that the existing plugin mis some things that
the .. figure:: tag does, like allowing to specify the alternate and
placing a caption to the figure (or tables) [1].

Also, as SVG is currently broken on Sphinx for PDF output, we'll
need to pre-process the image before calling Sphinx anyway. So,
IMHO, the best for now would be to use the same approach for both
cases.

On my patchsets, they're doing both SVG and Graphviz handling via
Makefile, before calling Sphinx.

When we have the needed features either at Sphinx upstream or as a
plugin, we could then switch to such solution.

[1] Another missing feature with regards to that is that Sphinx
doesn't seem to be able to produce a list of figures and tables.
Eventually, the image extension (or upstream improvements) that
would implement proper support for SVG and Graphviz could also
implement support for such indexes.

> graphviz is actually quite powerful, so I suspect things like
> dvbstb.png can be represented there, perhaps not pixel-identically, but
> at least semantically equivalently.

Yes, but we'll still need SVG for more complex things. I actually
converted (actually, I rewrote) dvbstb.png as SVG.

> However, I don't think we'll actually find a catch-all solution, so we
> need to continue this discussion here for a fallback anyway - as you
> stated (I snipped that quote, sorry), a picture describing the video
> formats will likely not be representable in text.
> 
> As far as my use-case for sequence diagrams is concerned, I'd really
> like to see this integrated with the toolchain since the source format
> for them is in fact a text format.

Yes, for sure having support for Graphviz will be very useful.

Thanks,
Mauro
