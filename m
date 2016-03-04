Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35835 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbcCDM75 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 07:59:57 -0500
Date: Fri, 4 Mar 2016 09:59:50 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Keith Packard <keithp@keithp.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>,
	Johannes Stezenbach <js@linuxtv.org>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160304095950.3358a2cb@recife.lan>
In-Reply-To: <87si06r6i3.fsf@intel.com>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<20160303221930.32558496@recife.lan>
	<87si06r6i3.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Mar 2016 10:29:08 +0200
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Fri, 04 Mar 2016, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> > Em Thu, 03 Mar 2016 15:23:23 -0800
> > Keith Packard <keithp@keithp.com> escreveu:
> >  
> >> Mauro Carvalho Chehab <mchehab@osg.samsung.com> writes:
> >>   
> >> > On my tests, Sphinix seemed too limited to format tables. Asciidoc
> >> > produced an output that worked better.    
> >> 
> >> Yes, asciidoc has much more flexibility in table formatting, including
> >> the ability to control text layout within cells and full control over
> >> borders.
> >> 
> >> However, I think asciidoc has two serious problems:
> >> 
> >>   1) the python version (asciidoc) appears to have been abandoned in
> >>      favor of the ruby version. 
> >> 
> >>   2) It really is just a docbook pre-processor. Native html/latex output
> >>      is poorly supported at best, and exposes only a small subset of the
> >>      full capabilities of the input language.
> >> 
> >> As such, we would have to commit to using the ruby version and either
> >> committing to fixing the native html output backend or continuing to use
> >> the rest of the docbook toolchain.
> >> 
> >> We could insist on using the python version, of course. I spent a bit of
> >> time hacking that up to add 'real' support for a table-of-contents in
> >> the native HTML backend and it looks like getting those changes
> >> upstreamed would be reasonably straightforward. However, we'd end up
> >> 'owning' the code, and I'm not sure we want to.  
> >
> > I'm a way more concerned about using a tool that fulfill our needs
> > than to look for something that won't use the docbook toolchain or
> > require to install ruby.  
> 
> I think you meant that to be the other way round, or I fail at parsing
> you. ;)

I mean: I'm a way more concerned about using a tool that fulfill our
needs than on toolchain it uses.

> 
> > In the case of Docbook, we know it works and we know already its
> > issues. Please correct me if I'm wrong, but the big problem we
> > have is not due to the DocBook toolchain, but due to the lack of
> > features at the kernel-doc script. Also, xmlto is already installed
> > by the ones that build the kernel docs. So, keeping use it won't
> > require to install a weird toolchain by hand.  
> 
> I think kernel-doc is just a small part of the puzzle. It's a problem,
> but a small one at that, and we've already made it output asciidoc, rst
> and docbook as part of this exercise. For real, as in code, not as in
> talk.
> 
> The reasons I'm involved in this is that I want to make writing
> documentation and rich kernel-doc comments easier (using lightweight
> markup) and I want to make building the documentation easier (using a
> straightforward toolchain with not too many dependencies). I'm hoping
> the former makes writing documentation more attractive and the latter
> keeps the documentation and the toolchain in a better shape through
> having more people actually build the documentation.

I don't think the toolchain is a problem. We don't attract too many
people because developers don't like writing documentation.

Ok, using a markup language can be easier than writing DocBook
tags directly, but people usually don't even add C comments on
the code they submit.

> IMHO docbook is problematic because the toolchain gets too long and
> fragile. You need plenty of tools installed to build the documentation,
> it's fussy to get working, and people just won't. Like code,
> documentation bitrots too when it's not used. 

On most distros, a single command installs all that it is needed.

> The documentation build is broken too often. 

This is indeed a problem, but the way I solved this at the media
subsystem is that I rebuild the documentation every time a media
file either at Documentation/Docbook or included at device-drivers.tmpl
is touched.

If the script produces error, I nack the patch.

So, IMHO, this is not a toolchain fault, but the lack of a process.

The kernel build robot is now producing e-mails when the documentation
has new troubles, so I guess this will help a lot to avoid adding
new documentation breakages.

> Debugging formatting issues through the entire
> pipeline gets hard; I already faced some of this when playing with the
> kernel-doc->asciidoc->docbook->html chain.
> 
> In short, I don't think the docbook toolchain fills all of our needs
> either.
> 
> > So, to be frank, it doesn't scary me to use either pyhton or
> > ruby script + docbook.
> >
> > Of course, having to own the code has a cost that should be evaluated.
> >
> > If, on the other hand, we decide to use RST, we'll very likely need to
> > patch it to fulfill our needs in order to add proper table support.
> > I've no idea how easy/difficult would be to do that, nor if Sphinx
> > upstream would accept such changes.
> >
> > So, at the end of the day, we may end by having to carry on our own
> > version of Sphinx inside our tree, with doesn't sound good, specially
> > since it is not just a script, but a package with hundreds of
> > files.  
> 
> If we end up having to modify Sphinx, it has a powerful extension
> mechanism for this. We wouldn't have to worry about getting it merged to
> Sphinx upstream, and we wouldn't have to carry a local version of all of
> Sphinx. (In fact, the extension mechanism provides a future path for
> doing kernel-doc within Sphinx instead of as a preprocessing step.)

That's indeed a good news.

> 
> I know none of this alleviates your concerns with table supports right
> now. I'll try to have a look at that a bit more.

I created a PoC tree with a few usecases taken from the V4L2 uAPI
documentation:
	https://git.linuxtv.org/mchehab/v4l2-docs-poc.git/

Perhaps you could help to fix the issues there:

1) We want borderless tables, on both PDF and HTML outputs, for
the table at:
	https://git.linuxtv.org/mchehab/v4l2-docs-poc.git/tree/v4l-table-within-table.rst

2) The tables at packed-rgb.rst are not created:
	https://git.linuxtv.org/mchehab/v4l2-docs-poc.git/diff/packed-rgb.rst

It complains that the table there is malformed:                                                                                                   
	packed-rgb.rst:12: ERROR: Malformed table.

3) I tried to use a .. cssclass, as Johannes suggested, but
I was not able to include the CSS file. I suspect that this is
easy to fix, but I want to see if the cssclass will also work for
the pdf output as well.

4) It seems that it can't produce nested tables in pdf:

Markup is unsupported in LaTeX:
v4l-table-within-table:: nested tables are not yet implemented.
Makefile:115: recipe for target 'latexpdf' failed

Can you help solving those issues?

Thanks,
Mauro
