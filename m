Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934845AbcHJS61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:58:27 -0400
Date: Wed, 10 Aug 2016 06:22:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: parts of media docs sphinx re-building every time?
Message-ID: <20160810062202.56d72818@vela.lan>
In-Reply-To: <87mvklvvbd.fsf@intel.com>
References: <8760rbp8zh.fsf@intel.com>
	<6D7865EB-9C40-4B8F-8D8F-3B28024624F3@darmarit.de>
	<87mvklvvbd.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 10 Aug 2016 12:15:34 +0300
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Mon, 08 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> > Hi Jani,
> >
> > Am 08.08.2016 um 17:37 schrieb Jani Nikula <jani.nikula@intel.com>:
> >  
> >> 
> >> Hi Mauro & co -
> >> 
> >> I just noticed running 'make htmldocs' rebuilds parts of media docs
> >> every time on repeated runs. This shouldn't happen. Please investigate.
> >> 
> >> I wonder if it's related to Documentation/media/Makefile... which I have
> >> to say I am not impressed by. I was really hoping we could build all the
> >> documentation by standalone sphinx-build invocation too, relying only on
> >> the conf.py so that e.g. Read the Docs can build the docs. Part of that
> >> motivation was to keep the build clean in makefiles, and handing the
> >> dependency tracking completely to Sphinx.
> >> 
> >> I believe what's in Documentation/media/Makefile,
> >> Documentation/sphinx/parse-headers.pl, and
> >> Documentation/sphinx/kernel_include.py could be replaced by a Sphinx
> >> extension looking at the sources directly.  
> >
> > Yes, parse-headers.pl, kernel_include.py and media/Makefile are needed
> > for one feature ... not very straight forward.
> >
> > If it makes sense to migrate the perl scripts functionality to a
> > Sphinx extension, may I can help ... depends on what Mauro thinks.
> >
> > BTW: parse-headers.pl is not the only perl script I like to migrate to py ;)  
> 
> If I understand the need of all of this right, I think the cleanest and
> fastest short term measure would be to make the kernel-include directive
> extension do the same thing as the kernel-doc directive does: call the
> perl script from the directive.
> 
> This lets you get rid of Documentation/media/Makefile and you don't have
> to copy-paste all of Include.run method into kernel_include.py. You can
> also get rid of specifying environment variables in rst files and
> parsing them in the extension. We can get rid of the problematic
> intermediate rst files. This design has been proven with the kernel-doc
> extension and script already. It's much simpler.

Works for me. If someone comes with such patch, I'll happily ack it.

Cheers,
Mauro
