Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:35045 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934905AbcKMTw5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Nov 2016 14:52:57 -0500
Date: Sun, 13 Nov 2016 12:52:50 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>, linux-doc@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org
Subject: Re: Including images on Sphinx documents
Message-ID: <20161113125250.779df4dd@lwn.net>
In-Reply-To: <20161107075524.49d83697@vento.lan>
References: <20161107075524.49d83697@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 7 Nov 2016 07:55:24 -0200
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> So, we have a few alternatives:
> 
> 1) copy (or symlink) all rst files to Documentation/output (or to the
>    build dir specified via O= directive) and generate the *.pdf there,
>    and produce those converted images via Makefile.;
> 
> 2) add an Sphinx extension that would internally call ImageMagick and/or
>    inkscape to convert the bitmap;
> 
> 3) if possible, add an extension to trick Sphinx for it to consider the 
>    output dir as a source dir too.

So, obviously, I've been letting this go by while dealing with other
stuff...

I really think that 2) is the one we want.  Copying all the stuff and
operating on the copies, beyond being a bit of a hack, just seems like a
recipe for weird build problems in the future.

We should figure out why PNG files don't work.  Maybe I'll give that a
try at some point soon, if I can find a moment.  Working around tools
bugs seems like the wrong approach.

Working from .svg seems optimial, but I don't like the --shell-escape
thing at all.

[Along those lines, we've picked up a lot of lines like this:

	 restricted \write18 enabled.

That, too, is shell execution stuff.  I've not been able to figure out
where it came from, but I would sure like to get rid of it...]

jon
