Return-path: <linux-media-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54748 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754061AbcKUPlt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 10:41:49 -0500
Message-ID: <1479742905.2309.16.camel@HansenPartnership.com>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: ksummit-discuss@lists.linuxfoundation.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 21 Nov 2016 07:41:45 -0800
In-Reply-To: <20161121120657.31eaeca4@vento.lan>
References: <20161107075524.49d83697@vento.lan>
         <11020459.EheIgy38UF@wuerfel> <20161116182633.74559ffd@vento.lan>
         <2923918.nyphv1Ma7d@wuerfel>
         <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
         <20161119101543.12b89563@lwn.net>
         <1479724781.8662.18.camel@sipsolutions.net>
         <20161121120657.31eaeca4@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-11-21 at 12:06 -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 21 Nov 2016 11:39:41 +0100
> Johannes Berg <johannes@sipsolutions.net> escreveu:
> > On Sat, 2016-11-19 at 10:15 -0700, Jonathan Corbet wrote:
> > 
> > > Rather than beating our heads against the wall trying to convert
> > > between various image formats, maybe we need to take a step
> > > back.  We're trying to build better documentation, and there is
> > > certainly a place for diagrams and such in that
> > > documentation.  Johannes was asking about it for the 802.11 docs, 
> > > and I know Paul has run into these issues with the RCU docs as
> > > well.  Might there be a tool or an extension out there that would
> > > allow us to express these diagrams in a text-friendly, editable
> > > form?
> > > 
> > > With some effort, I bet we could get rid of a number of the 
> > > images, and perhaps end up with something that makes sense when 
> > > read in the .rst source files as an extra benefit.   
> > 
> > I tend to agree, and I think that having this readable in the text
> > would be good.
> > 
> > You had pointed me to this plugin before
> > https://pythonhosted.org/sphinxcontrib-aafig/
> > 
> > but I don't think it can actually represent any of the pictures.
> 
> No, but there are some ascii art images inside some txt/rst files
> and inside some kernel-doc comments. We could either use the above
> extension for them or to convert into some image. The ascii art
> images I saw seem to be diagrams, so Graphviz would allow replacing
> most of them, if not all.

Please don't replace ASCII art that effectively conveys conceptual
diagrams.  If you do, we'll wind up in situations where someone hasn't
built the docs and doesn't possess the tools to see a diagram that was
previously shown by every text editor (or can't be bothered to dig out
the now separate file).  In the name of creating "prettier" diagrams
(and final doc), we'll have damaged capacity to understand stuff by
just reading the source if this diagram is in kernel doc comments.  I
think this is a good application of "if it ain't broke, don't fix it".

James

