Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53728 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425898AbcBRK1E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 05:27:04 -0500
Date: Thu, 18 Feb 2016 08:26:57 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160218082657.5a1a5b0f@recife.lan>
In-Reply-To: <CAKMK7uE72wFEFCyw1dHbt+f3-ex3fr_9MbjoGfnKFZkd5+9S2Q@mail.gmail.com>
References: <20160213145317.247c63c7@lwn.net>
	<86fuwwcdmd.fsf@hiro.keithp.com>
	<CAKMK7uGeU_grgC7pRCdqw+iDGWQfXhHwvX+tkSgRmdimxMrthA@mail.gmail.com>
	<20160217151401.3cb82f65@lwn.net>
	<CAKMK7uEqbSrhc2nh0LjC1fztciM4eTjtKE9T_wMVCqAkkTnzkA@mail.gmail.com>
	<874md6fkna.fsf@intel.com>
	<CAKMK7uE72wFEFCyw1dHbt+f3-ex3fr_9MbjoGfnKFZkd5+9S2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 18 Feb 2016 10:24:04 +0100
Daniel Vetter <daniel.vetter@ffwll.ch> escreveu:

> On Thu, Feb 18, 2016 at 10:11 AM, Jani Nikula <jani.nikula@intel.com> wrote:
> > On Thu, 18 Feb 2016, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:  
> >> On Wed, Feb 17, 2016 at 11:14 PM, Jonathan Corbet <corbet@lwn.net> wrote:  
> >>> On Sun, 14 Feb 2016 13:27:04 +0100
> >>> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >>>  
> >>>> One concern/open I have for pro/cons are the hyperlinks from kerneldoc
> >>>> comments. Currently we have the postproc hack, iirc Jani's patches
> >>>> generated links native when extracting the kerneldoc. What's the
> >>>> solution with spinx?  
> >>>
> >>> So I've been trying to figure out what this refers to.  Is this the
> >>> cross-reference links within the document?  When I did my sphinx hack it
> >>> used a technique that, shall we say, strongly resembles what Jani's
> >>> patches did.  One difference is that Sphinx has the concept of
> >>> "functions" built into it, so I use function references for those.  
> >>
> >> That's what I meant. As long as I can type in stuff like func(),
> >> &struct and similar and get a link for it automatically (plus anywhere
> >> else in the templated stuff for function headers) I'm really happy.  
> >
> > I think that could be made to work in rst just as well as
> > asciidoc. Which is to say, kernel-doc may generate broken refs in both,
> > since it doesn't know if the link target exists outside of the
> > file. Also, in theory, it's possible to generate non-unique targets in
> > the end result if there are same named enums, structs, static functions
> > etc. but I think that's less of a problem. Asciidoc just ignores these
> > issues, I don't know what sphinx does.
> >
> > I think some of that could be alleviated by making the kernel-doc
> > inclusion a directive through a sphinx extension. It could at the very
> > least provide informative error messages. But that's distant future.
> >
> > Worth noting is that, AFAICT, in all of the proposals, including the
> > original where kernel-doc produces docbook, this autoreferencing only
> > works within parts processed by kernel-doc. Not in the template
> > documents themselves. (You can still use the markup's more verbose cross
> > referencing keywords.)  
> 
> It works everywhere, even in the docbook template, as long as you mark
> it up correctly. Which in docbook means <function>func</function>.
> That's because it's a post-proc path over the entire doc. But then the
> entire point here is to move the overview sections all into kerneldoc,
> so making the links in the templates more verbose shouldn't be a big
> deal.

For simple documents like the one produced by kernel-doc, I guess
all markup languages would work equally.

The problem is for complex documents like the media kAPI one, where
the document was written to produce a book. So, it uses some complex
features found at DocBook. One of such features we use extensively
is the capability of having a table with per-line columns. This way,
we can produce things like:

V4L2_CID_COLOR_KILLER	boolean	Enable the color killer (i. e. force a black & white image in case of a weak video signal).
V4L2_CID_COLORFX	enum	Selects a color effect. The following values are defined:
				V4L2_COLORFX_NONE 		Color effect is disabled.
				V4L2_COLORFX_ANTIQUE 		An aging (old photo) effect.
				V4L2_COLORFX_ART_FREEZE 	Frost color effect.

In the above example, we have a main 3 columns table, and we embed
a 2 columns table at the third field of V4L2_CID_COLORFX to represent
possible values for this menu control.

See https://linuxtv.org/downloads/v4l-dvb-apis/control.html for the
complete output of it.

This is used extensively inside the media DocBook, and properly
supporting it is one of our major concerns.

Are there any way to represent those things with the markup
languages currently being analyzed?

Converting those tables will likely require manual work, as I don't
think automatic tools will properly handle it, specially since we
use some DocBook macros to help creating such tables.

-- 
Thanks,
Mauro
