Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47079 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbcEENYE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2016 09:24:04 -0400
Date: Thu, 5 May 2016 10:23:55 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Markus Heiser <markus.heiser@darmarit.de>,
	Daniel Vetter <daniel@ffwll.ch>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Grant Likely <grant.likely@secretlab.ca>,
	"Dan Allen" <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	"Keith Packard" <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160505102355.740f66ed@recife.lan>
In-Reply-To: <20160505070210.477a568c@lwn.net>
References: <87fuvypr2h.fsf@intel.com>
	<20160310122101.2fca3d79@recife.lan>
	<AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de>
	<8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de>
	<20160412094620.4fbf05c0@lwn.net>
	<CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com>
	<CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com>
	<54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de>
	<874maef8km.fsf@intel.com>
	<13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de>
	<20160504134346.GY14148@phenom.ffwll.local>
	<44110C0C-2E98-4470-9DB1-B72406E901A0@darmarit.de>
	<87inytn6n2.fsf@intel.com>
	<20160504135035.1f055fa7@recife.lan>
	<20160504105936.34c2697f@lwn.net>
	<20160504145738.34e6bf5a@recife.lan>
	<20160505070210.477a568c@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 5 May 2016 07:02:10 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Wed, 4 May 2016 14:57:38 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
> > Also, media documentation is not just one more documentation. It is
> > the biggest one we have, and that has more changes than any other
> > documentation under Documentation/DocBook:
> > 
> > $ git lg --since 01/01/2015 ` ls *.tmpl|grep -v media`|wc -l
> > 116
> > $ git lg --since 01/01/2015 ` ls *.tmpl|grep media` `find media/ -type f`|wc -l
> > 179
> > 
> > It also is more than twice the size of the other DocBook docs:
> > 
> > $ wc -l $(ls *.tmpl|grep  media) `find media/ -type f`|tail -1
> >   82275 total
> > $ wc -l $(ls *.tmpl|grep -v media)|tail -1
> >   29568 total
> > 
> > E. g. media corresponds to 60% of the number of patches and 73% of
> > the DocBook stuff.  
> 
> These numbers are not entirely representative, I have to say.  You're
> ignoring the kerneldoc comments - which is what much of the "DocBook"
> documents are made of, and which is the focus of much of this activity.  If
> you could find a way to count those, you'd get a different picture.

Yeah, if we take the big picture, I'm pretty sure that there are more
stuff written using kerneldoc. However, what is written at the 
kerneldoc comments don't use DocBook markup, but its own markup
language.

Assuming that we'll keep using kerneldoc script to convert from the
Kerneldoc NANO markup, it means that any changes at the kerneldoc
backend to use DocBook/Markdown/asciidoc/reST/... won't change anything
for the developers nor will require them to actually use the new markups.
So, they can gradually start using new markups as they wish/learn, if
they want to improve the documentation. Lazy developers could just ignore
reST if they want, as everything will work as before.

However, for the files written directly in DocBook, there's no option:
at the moment the doc is converted, the developer will need to submit
patches using the new markup language. So, we need to be sure that
such transition will happen in a way that won't cause more harm than
needed.  I would prefer to convert all of them at one, on a single Kernel
release (or two), in order to minimize the impact for the developers.

> 
> But I don't think that really matters; there doesn't seem to be *that* much
> disagreement here.
> 
> The media book is important; we want it to be a part of the overall kernel
> documentation suite and not stuck in some DocBook ghetto.  I agree that we
> should have an idea for a plausible path for *all* of our documentation.
> But I'm also concerned about delaying this work yet again; we have
> developers trying to push forward with improved documentation, and they've
> had to wait a year for this stuff - so far.

Yeah, I understand.

Regards,
Mauro
