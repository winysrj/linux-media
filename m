Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56030 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932568AbcKQREA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 12:04:00 -0500
Date: Thu, 17 Nov 2016 09:52:44 -0500
From: Theodore Ts'o <tytso@mit.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        ksummit-discuss@lists.linuxfoundation.org,
        Josh Triplett <josh@joshtriplett.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161117145244.sksssz6jvnntsw5u@thunk.org>
References: <20161107075524.49d83697@vento.lan>
 <11020459.EheIgy38UF@wuerfel>
 <20161116182633.74559ffd@vento.lan>
 <2923918.nyphv1Ma7d@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2923918.nyphv1Ma7d@wuerfel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 17, 2016 at 12:07:15PM +0100, Arnd Bergmann wrote:
> [adding Linus for clarification]
> 
> I understood the concern as being about binary files that you cannot
> modify with classic 'patch', which is a separate issue.

I think the other complaint is that the image files aren't "source" in
the proper term, since they are *not* the preferred form for
modification --- that's the svg files.  Beyond the license compliance
issues (which are satisified because the .svg files are included in
the git tree), there is the SCM cleaniless argument of not including
generated files in the distribution, since this increases the
opportunites for the "real" source file and the generated source file
to get out of sync.  (As just one example, if the patch can't
represent the change to binary file.)

I do check in generated files on occasion --- usually because I don't
trust autoconf to be a stable in terms of generating a correct
configure file from a configure.in across different versions of
autoconf and different macro libraries that might be installed on the
system.  So this isn't a hard and fast rule by any means (although
Linus may be more strict than I on that issue).

I don't understand why it's so terrible to have generate the image
file from the .svg file in a Makefile rule, and then copy it somewhere
else if Sphinx is too dumb to fetch it from the normal location?

     	       	      	      	       - Ted
