Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:45888 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbcHHQHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2016 12:07:51 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: parts of media docs sphinx re-building every time?
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <8760rbp8zh.fsf@intel.com>
Date: Mon, 8 Aug 2016 18:07:10 +0200
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Transfer-Encoding: 8BIT
Message-Id: <6D7865EB-9C40-4B8F-8D8F-3B28024624F3@darmarit.de>
References: <8760rbp8zh.fsf@intel.com>
To: Jani Nikula <jani.nikula@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jani,

Am 08.08.2016 um 17:37 schrieb Jani Nikula <jani.nikula@intel.com>:

> 
> Hi Mauro & co -
> 
> I just noticed running 'make htmldocs' rebuilds parts of media docs
> every time on repeated runs. This shouldn't happen. Please investigate.
> 
> I wonder if it's related to Documentation/media/Makefile... which I have
> to say I am not impressed by. I was really hoping we could build all the
> documentation by standalone sphinx-build invocation too, relying only on
> the conf.py so that e.g. Read the Docs can build the docs. Part of that
> motivation was to keep the build clean in makefiles, and handing the
> dependency tracking completely to Sphinx.
> 
> I believe what's in Documentation/media/Makefile,
> Documentation/sphinx/parse-headers.pl, and
> Documentation/sphinx/kernel_include.py could be replaced by a Sphinx
> extension looking at the sources directly.

Yes, parse-headers.pl, kernel_include.py and media/Makefile are needed
for one feature ... not very straight forward.

If it makes sense to migrate the perl scripts functionality to a
Sphinx extension, may I can help ... depends on what Mauro thinks.

BTW: parse-headers.pl is not the only perl script I like to migrate to py ;)

> (I presume kernel_include.py
> is mostly a workaround to keep out-of-tree builds working?)

Yes, e.g. with "make O=/tmp/kernel htmldocs" the parse-headers.pl output goes 
to /tmp/kernel and is included by ".. kernel-include: $BUILDDIR/xxx"

-- Markus --
 
> Anyway, the rebuild part is most important. This must be fixed.
> 
> 
> BR,
> Jani.
> 
> -- 
> Jani Nikula, Intel Open Source Technology Center

