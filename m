Return-path: <linux-media-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36292 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753250AbcKUPof (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 10:44:35 -0500
Message-ID: <1479743068.4391.4.camel@sipsolutions.net>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
From: Johannes Berg <johannes@sipsolutions.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: ksummit-discuss@lists.linuxfoundation.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 21 Nov 2016 16:44:28 +0100
In-Reply-To: <1479742905.2309.16.camel@HansenPartnership.com>
References: <20161107075524.49d83697@vento.lan>
         <11020459.EheIgy38UF@wuerfel> <20161116182633.74559ffd@vento.lan>
         <2923918.nyphv1Ma7d@wuerfel>
         <CA+55aFyFrhRefTuRvE2rjrp6d4+wuBmKfT_+a65i0-4tpxa46w@mail.gmail.com>
         <20161119101543.12b89563@lwn.net>
         <1479724781.8662.18.camel@sipsolutions.net>
         <20161121120657.31eaeca4@vento.lan>
         <1479742905.2309.16.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> > > You had pointed me to this plugin before
> > > https://pythonhosted.org/sphinxcontrib-aafig/
> > > 
> > > but I don't think it can actually represent any of the pictures.
> > 
> > No, but there are some ascii art images inside some txt/rst files
> > and inside some kernel-doc comments. We could either use the above
> > extension for them or to convert into some image. The ascii art
> > images I saw seem to be diagrams, so Graphviz would allow replacing
> > most of them, if not all.
> 
> Please don't replace ASCII art that effectively conveys conceptual
> diagrams.  If you do, we'll wind up in situations where someone
> hasn't built the docs and doesn't possess the tools to see a diagram
> that was previously shown by every text editor (or can't be bothered
> to dig out the now separate file).  In the name of creating
> "prettier" diagrams (and final doc), we'll have damaged capacity to
> understand stuff by just reading the source if this diagram is in
> kernel doc comments.  I think this is a good application of "if it
> ain't broke, don't fix it".

Right, I agree completely!

That's the selling point of aafig though, it translates to pretty
diagrams, but looks fine when viewed in a normal text editor (with
fixed-width font)

I had a hack elsewhere that would embed the fixed-width text if the
plugin isn't present, which seemed like a decent compromise, but nobody
is willing to let plugins be used in general to start with, it seems :)

johannes
