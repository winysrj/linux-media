Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55985 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938612AbcHJS6i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:58:38 -0400
Date: Wed, 10 Aug 2016 06:04:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Markus Heiser <markus.heiser@darmarit.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: parts of media docs sphinx re-building every time?
Message-ID: <20160810060408.1598f2e1@vela.lan>
In-Reply-To: <87twetvzff.fsf@intel.com>
References: <8760rbp8zh.fsf@intel.com>
	<6D7865EB-9C40-4B8F-8D8F-3B28024624F3@darmarit.de>
	<20160808142635.4d766f8c@recife.lan>
	<87twetvzff.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 10 Aug 2016 10:46:44 +0300
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Mon, 08 Aug 2016, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> > The goal of Documentation/sphinx/parse-headers.pl script is to generate
> > such parsed headers, with the cross-references modified by an exceptions
> > file at Documentation/media/*.h.rst.exceptions.  
> 
> Would you be so kind as to state in a few lines what you want to
> achieve? I can guess based on the current solution, but I'd like to hear
> it from you. Please leave out rants about tools and languages etc. so we
> can focus on the problem statement, and try to figure out the best
> overall solution.

It is basically what's written above: to produce a cross-referenced output
document from a source, were, clicking on the API symbols will navigate to
the place where the symbol was documented.

It should allow to add exceptions, as we don't want to add cross-references
for legacy symbols or helper macros, for example. 

This is a good example on what we want:
	https://linuxtv.org/downloads/v4l-dvb-apis-new/media/uapi/rc/lirc-header.html#lirc-h

The only parts of the header file that will have a different color will be
the symbols defined at the API.

This way, it is easy for us to visually discover what stuff is not yet
documented (like LIRC_MODE2_SPACE - that should be documented - and
_LINUX_LIRC_H macro - that should not be documented).
When something is not cross-referenced there, there's a single place to
look that will explain why this was not documented (at the exceptions file).

The main goal for documentation writers is to use the header
file to identify the documentation gaps. For code developers, the header
file works like an index to the document, where all the API can be seen
altogether, and more details can easily be obtained by clicking at the links.

Regard


Cheers,
Mauro
