Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53889 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425268AbcBRMol (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 07:44:41 -0500
Date: Thu, 18 Feb 2016 10:44:34 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jonathan Corbet <corbet@lwn.net>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160218104434.25d11e33@recife.lan>
In-Reply-To: <56C5B3E7.6030509@xs4all.nl>
References: <20160213145317.247c63c7@lwn.net>
	<86fuwwcdmd.fsf@hiro.keithp.com>
	<CAKMK7uGeU_grgC7pRCdqw+iDGWQfXhHwvX+tkSgRmdimxMrthA@mail.gmail.com>
	<20160217151401.3cb82f65@lwn.net>
	<CAKMK7uEqbSrhc2nh0LjC1fztciM4eTjtKE9T_wMVCqAkkTnzkA@mail.gmail.com>
	<874md6fkna.fsf@intel.com>
	<CAKMK7uE72wFEFCyw1dHbt+f3-ex3fr_9MbjoGfnKFZkd5+9S2Q@mail.gmail.com>
	<20160218082657.5a1a5b0f@recife.lan>
	<87r3gadzye.fsf@intel.com>
	<20160218100427.6471cb22@recife.lan>
	<56C5B3E7.6030509@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 18 Feb 2016 13:07:03 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/18/16 13:04, Mauro Carvalho Chehab wrote:
> > Em Thu, 18 Feb 2016 13:23:37 +0200
> > Jani Nikula <jani.nikula@intel.com> escreveu:
> >   
> >> On Thu, 18 Feb 2016, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:  
> >>> For simple documents like the one produced by kernel-doc, I guess
> >>> all markup languages would work equally.
> >>>
> >>> The problem is for complex documents like the media kAPI one, where
> >>> the document was written to produce a book. So, it uses some complex
> >>> features found at DocBook. One of such features we use extensively
> >>> is the capability of having a table with per-line columns. This way,
> >>> we can produce things like:
> >>>
> >>> V4L2_CID_COLOR_KILLER	boolean	Enable the color killer (i. e. force a black & white image in case of a weak video signal).
> >>> V4L2_CID_COLORFX	enum	Selects a color effect. The following values are defined:
> >>> 				V4L2_COLORFX_NONE 		Color effect is disabled.
> >>> 				V4L2_COLORFX_ANTIQUE 		An aging (old photo) effect.
> >>> 				V4L2_COLORFX_ART_FREEZE 	Frost color effect.
> >>>
> >>> In the above example, we have a main 3 columns table, and we embed
> >>> a 2 columns table at the third field of V4L2_CID_COLORFX to represent
> >>> possible values for this menu control.
> >>>
> >>> See https://linuxtv.org/downloads/v4l-dvb-apis/control.html for the
> >>> complete output of it.
> >>>
> >>> This is used extensively inside the media DocBook, and properly
> >>> supporting it is one of our major concerns.
> >>>
> >>> Are there any way to represent those things with the markup
> >>> languages currently being analyzed?
> >>>
> >>> Converting those tables will likely require manual work, as I don't
> >>> think automatic tools will properly handle it, specially since we
> >>> use some DocBook macros to help creating such tables.    
> >>
> >> Since I've let myself be told that asciidoc handles tables better than
> >> reStructuredText, I tested this a bit with the presumably inferior one.
> >>
> >> rst has two table types, simple tables and grid tables [1]. It seems
> >> like grid tables can do pretty much anything, but they can be cumbersome
> >> to work with. So I tried to check what can be done with simple tables.
> >>
> >> Here's a sample, converted using rst2html (Sphinx will be prettier, but
> >> rst2html works for simple things like this):
> >>
> >> https://people.freedesktop.org/~jani/v4l-table-within-table.rst
> >> https://people.freedesktop.org/~jani/v4l-table-within-table.html  
> > 
> > Yes, this would work. Can we remove the border from the main table?
> > I guess it would be nicer.
> >   
> >>
> >> Rather than using nested tables, you might want to consider using
> >> definition lists within tables:
> >>
> >> https://people.freedesktop.org/~jani/v4l-definition-list-within-table.rst
> >> https://people.freedesktop.org/~jani/v4l-definition-list-within-table.html
> >>
> >> You be the judge, but I think this is workable.  
> > 
> > It is workable, but I guess nested tables produced a better result.
> > 
> > I did myself a test with nested tables with asciidoc too:
> > 
> > https://mchehab.fedorapeople.org/media-kabi-docs-test/pandoc_asciidoc/table.html
> > https://mchehab.fedorapeople.org/media-kabi-docs-test/pandoc_asciidoc/table.ascii
> > 
> > With looks very decent to me.  
> 
> It does, except for the vertical alignment of the third column (at least when viewed
> with google chrome).

Not sure what you mean. Here, it looks fine on both Firefox and Chrome,
except that the second colum size could be smaller. If this is what
you're meaning this can be fixed by changing the second line from:

	[width="100%",cols="2,1,10a",options="header",frame="none", grid="none"]

to:

	[width="100%",cols="3,1,30a",options="header",frame="none", grid="none"]

With regards to ReStructured Text, I've no idea how to control the
format of a table in order to do things like hiding the borders and
changing the column spacing.

So, at least on a first glance, asciidoc seems to fit better.

Thanks,
Mauro
