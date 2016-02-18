Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:10378 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425770AbcBRJdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 04:33:11 -0500
From: Jani Nikula <jani.nikula@intel.com>
To: Russel Winder <russel@winder.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: V4L docs and docbook
In-Reply-To: <1455783420.10645.21.camel@winder.org.uk>
References: <20160217145254.3085b333@lwn.net> <20160217215138.15b6de82@recife.lan> <1455783420.10645.21.camel@winder.org.uk>
Date: Thu, 18 Feb 2016 11:33:05 +0200
Message-ID: <871t8afjn2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 18 Feb 2016, Russel Winder <russel@winder.org.uk> wrote:
> On Wed, 2016-02-17 at 21:51 -0200, Mauro Carvalho Chehab wrote:
>> […]
>> 
>> We have 2 types of documentation for the Kernel part of the
>> subsystem,
>> Both using DocBook:
>> - The uAPI documentation:
>> 	https://linuxtv.org/downloads/v4l-dvb-apis
>> - The kAPI documentation:
>> 	https://linuxtv.org/downloads/v4l-dvb-internals/device-drivers/
>> mediadev.html
> […]
>
> I may not be introducing new data here but…
>
> Whilst ReStructuredText and Markdown are fairly popular text markup
> languages, they are not related to the DocBook/XML toolchain.
>
> Many people, especially authors of books etc. are not really willing to
> write in DocBook/XML even though it is the re-purposable representation
> of choice for most of the major publishers. This led to ASCIIDoc.
>
> ASCIIDoc is a plain text markup language in the same way
> ReStructuredText and Markdown are, but it's intention was always to be
> a lightweight front end to DocBook/XML so as to allow authors to write
> in a nice markup language but work with the DocBook/XML toolchain.

We have been looking at asciidoc too, so much so that there are draft
patches by Jon and me to build some of the documentation from asciidoc
source. Both are in the thread starting at [1]. But we really need to
consider reStructuredText too [2].

I think this thread is about figuring out how much we really depend on
DocBook. There is a lot of pain in dealing with DocBook, especially as a
source format, but also as an intermediate format. If we can produce the
end results (html, pdf, man, ...) from the source markup directly, it's
a win.

> ASCIIDoc has gained quite a strong following. So much so that it now
> has a life of its own separate from the DocBook/XML tool chain. There
> is ASCIIDoctor which generates PDF, HTML,… from the source without
> using DocBook/XML, yet the source can quite happily go through a
> DocBook/XML toolchain as well.

See some of the other threads. Asciidoc seems to be in maintenance
mode. Asciidoctor depends on a ruby environment which is not met with
enthusiasm. The HTML output can only be chunked (split to several pages)
via the DocBook output. Sphinx is active, doesn't add a lot of new
dependencies, and seems to be able to natively output all the end
results people have so far said they care about.

> Many of the open source projects I am involved with are now using
> ASCIIDoctor as the documentation form. This has increased the number of
> non-main-contributor contributions via pull requests. It is so much
> easier to work with ASCIIDoc(tor) source than DocBook/XML source. 

I'm hopeful this holds for any of the lightweight markups.


BR,
Jani.


[1] http://lkml.kernel.org/r/1453764522-29030-1-git-send-email-corbet@lwn.net
[2] http://lkml.kernel.org/r/20160213145317.247c63c7@lwn.net

-- 
Jani Nikula, Intel Open Source Technology Center
