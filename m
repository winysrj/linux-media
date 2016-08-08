Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60521
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbcHHR0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2016 13:26:42 -0400
Date: Mon, 8 Aug 2016 14:26:35 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: parts of media docs sphinx re-building every time?
Message-ID: <20160808142635.4d766f8c@recife.lan>
In-Reply-To: <6D7865EB-9C40-4B8F-8D8F-3B28024624F3@darmarit.de>
References: <8760rbp8zh.fsf@intel.com>
	<6D7865EB-9C40-4B8F-8D8F-3B28024624F3@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jani,

Em Mon, 8 Aug 2016 18:07:10 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Hi Jani,
> 
> Am 08.08.2016 um 17:37 schrieb Jani Nikula <jani.nikula@intel.com>:
> 
> > 
> > Hi Mauro & co -
> > 
> > I just noticed running 'make htmldocs' rebuilds parts of media docs
> > every time on repeated runs. This shouldn't happen. Please investigate.

Perhaps there are some Makefile dependencies there that are not ok.
I'll look in to it.

> > 
> > I wonder if it's related to Documentation/media/Makefile... which I have
> > to say I am not impressed by. I was really hoping we could build all the
> > documentation by standalone sphinx-build invocation too, relying only on
> > the conf.py so that e.g. Read the Docs can build the docs. Part of that
> > motivation was to keep the build clean in makefiles, and handing the
> > dependency tracking completely to Sphinx.
> > 
> > I believe what's in Documentation/media/Makefile,
> > Documentation/sphinx/parse-headers.pl, and
> > Documentation/sphinx/kernel_include.py could be replaced by a Sphinx
> > extension looking at the sources directly.  
> 
> Yes, parse-headers.pl, kernel_include.py and media/Makefile are needed
> for one feature ... not very straight forward.
> 
> If it makes sense to migrate the perl scripts functionality to a
> Sphinx extension, may I can help ... depends on what Mauro thinks.
> 
> BTW: parse-headers.pl is not the only perl script I like to migrate to py ;)

As discussed before, we need to be able to auto-generate cross references
from the headers. Unfortunately, Sphinx acts like a 5-years-old-boy by
painting source files some random colors, but not doing anything
useful like creating cross references with the documentation.

So, we need an extra script for the media build to convert the API headers
into rst files. This work is somewhat complex, as there are symbols that
we explicitly want to ignore, including ifdef symbols like:

	#define _UAPI__LINUX_VIDEODEV2_H
	#ifdef _UAPI__LINUX_VIDEODEV2_H
		...
	#endif

We also want to do things like:

	replace symbol V4L2_TUNER_ANALOG_TV v4l2-tuner-type
	replace symbol V4L2_TUNER_RADIO v4l2-tuner-type
	replace symbol V4L2_TUNER_RF v4l2-tuner-type
	replace symbol V4L2_TUNER_SDR v4l2-tuner-type

in order to make all symbols to point to the same element at the rst file,
that are usually inside a table.

(I actually want to change this to point to an specific row at the
table, but there are almost 400 symbols to be fixed, and changing it
will take some time, and will likely require manual work).

The goal of Documentation/sphinx/parse-headers.pl script is to generate
such parsed headers, with the cross-references modified by an exceptions
file at Documentation/media/*.h.rst.exceptions.

This returns back a feature that we used to have with DocBook.

The Documentation/media/Makefile rules what should be converted,
and what exception file will be used to generate the rst file:

	$(BUILDDIR)/audio.h.rst: ${UAPI}/dvb/audio.h ${PARSER} $(SRC_DIR)/audio.h.rst.exceptions
		@$($(quiet)gen_rst)

We might move that to Documentation/Makefile.sphinx, if you don't
like having another makefile, but IMHO, this will be messy and will
cause conflicts during the merge window.

With regards to use python, well... I don't program on python, 
nor I'm interested on doing it ATM... I actually wrote one python script
a long time ago - that I had to fix to work on a newer python 2.x version,
as the unicode API was changed - and very likely it won't work on python 3
anymore, as lots of API got changed.

The thing is: perl is reliable enough for not needing to rewrite the script
every time someone comes with some crazy idea that would break the language
API and force changes at the scripts. So, I prefer to keep that script in a 
language that doesn't bite me on upgrades. As a plus, it doesn't forces
me to adopt random alien code style of 4 space indentations, and not use
tabs. But that's me.

So, I'm not against porting it. Yet, what would be the advantage of porting
it to Python? If there's no clear advantage, let's keep it in perl, as it
is easier to maintain.

Thanks,
Mauro
