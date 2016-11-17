Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49050 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934152AbcKQRGG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 12:06:06 -0500
Date: Thu, 17 Nov 2016 13:16:51 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>,
        ksummit-discuss@lists.linuxfoundation.org,
        Josh Triplett <josh@joshtriplett.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161117131651.467943e0@vento.lan>
In-Reply-To: <20161117145244.sksssz6jvnntsw5u@thunk.org>
References: <20161107075524.49d83697@vento.lan>
        <11020459.EheIgy38UF@wuerfel>
        <20161116182633.74559ffd@vento.lan>
        <2923918.nyphv1Ma7d@wuerfel>
        <20161117145244.sksssz6jvnntsw5u@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ted,

Em Thu, 17 Nov 2016 09:52:44 -0500
Theodore Ts'o <tytso@mit.edu> escreveu:

> On Thu, Nov 17, 2016 at 12:07:15PM +0100, Arnd Bergmann wrote:
> > [adding Linus for clarification]
> > 
> > I understood the concern as being about binary files that you cannot
> > modify with classic 'patch', which is a separate issue.  
> 
> I think the other complaint is that the image files aren't "source" in
> the proper term, since they are *not* the preferred form for
> modification --- that's the svg files.  Beyond the license compliance
> issues (which are satisified because the .svg files are included in
> the git tree), there is the SCM cleaniless argument of not including
> generated files in the distribution, since this increases the
> opportunites for the "real" source file and the generated source file
> to get out of sync.  (As just one example, if the patch can't
> represent the change to binary file.)
> 
> I do check in generated files on occasion --- usually because I don't
> trust autoconf to be a stable in terms of generating a correct
> configure file from a configure.in across different versions of
> autoconf and different macro libraries that might be installed on the
> system.  So this isn't a hard and fast rule by any means (although
> Linus may be more strict than I on that issue).
> 
> I don't understand why it's so terrible to have generate the image
> file from the .svg file in a Makefile rule, and then copy it somewhere
> else if Sphinx is too dumb to fetch it from the normal location?

The images whose source are in .svg are now generated via Makefile
for the PDF output (after my patches, already applied to the docs-next
tree).

So, the problem that remains is for those images whose source
is a bitmap. If we want to stick with the Sphinx supported formats,
we have only two options for bitmaps: jpg or png. We could eventually
use uuencode or base64 to make sure that the patches won't use
git binary diff extension, or, as Arnd proposed, use a portable
bitmap format, in ascii, converting via Makefile, but losing
the alpha channel with makes the background transparent.

Thanks,
Mauro
