Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36652 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbcCGMPp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2016 07:15:45 -0500
Date: Mon, 7 Mar 2016 09:15:37 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160307091537.28548511@recife.lan>
In-Reply-To: <20160307084826.GA6381@linuxtv.org>
References: <87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<20160303221930.32558496@recife.lan>
	<87si06r6i3.fsf@intel.com>
	<20160304095950.3358a2cb@recife.lan>
	<20160304140909.GA15636@linuxtv.org>
	<20160305232937.74678dd0@recife.lan>
	<20160306232908.GA3732@linuxtv.org>
	<20160307084826.GA6381@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 7 Mar 2016 09:48:26 +0100
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Mon, Mar 07, 2016 at 12:29:08AM +0100, Johannes Stezenbach wrote:
> > On Sat, Mar 05, 2016 at 11:29:37PM -0300, Mauro Carvalho Chehab wrote:  
> > > 
> > > I converted one of the big tables to CSV. At least now it recognized
> > > it as a table. Yet, the table was very badly formated:
> > > 	https://mchehab.fedorapeople.org/media-kabi-docs-test/rst_tests/packed-rgb.html
> > > 
> > > This is how this table should look like:
> > > 	https://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html
> > > 
> > > Also, as this table has merged cells at the legend. I've no idea how
> > > to tell sphinx to do that on csv format.
> > > 
> > > The RST files are on this git tree:
> > > 	https://git.linuxtv.org/mchehab/v4l2-docs-poc.git/  
> > 
> > Yeah, seems it can't do merged cells in csv.  Attached patch converts it
> > back to grid table format and fixes the table definition.
> > The html output looks usable, but clearly it is no fun to
> > work with tables in Sphinx.
> > 
> > Sphinx' latex writer can't handle nested tables, though.
> > Python's docutils rst2latex can, but that doesn't help here.
> > rst2pdf also supports it.  But I have doubts such a large
> > table would render OK in pdf without using landscape orientation.
> > I have not tried because I used python3-sphinx but rst2pdf
> > is only availble for Python2 in Debian so it does not integrate
> > with Sphinx.  
> 
> Just a quick idea:
> Perhaps one alternative would be to use Graphviz to render
> the problematic tables, it supports a HTML-like syntax
> and can be embedded in Spinx documents:
> 
> http://www.sphinx-doc.org/en/stable/ext/graphviz.html
> http://www.graphviz.org/content/node-shapes#html
> http://stackoverflow.com/questions/13890568/graphviz-html-nested-tables

That could work, but it is scary... Graphviz is great to generate
diagrams, but it really sucks when one wants to put a graph element
on a specific place, as it loves to reorder elements putting them on
unexpected places.

Btw, 

I converted all docs from our uAPI docbook to rst using pandoc.
It was a brainless conversion, except for a few fixes.

The output is at:
	https://mchehab.fedorapeople.org/media-kabi-docs-test/rst_tests/

I added it on the top of my PoC tree at:
	https://git.linuxtv.org/mchehab/v4l2-docs-poc.git/  

Besides tables, I noticed some other bad things that needs to be
corrected somehow:

1) Document divisions are not numbered. We need that. It should be
broken into:
	- Document divisions - one per documented API:
		- V4L2
		- Remote Controllers
		- DVB
		- Media Controller

	- Chapters
	- Sessions

Everything should be numbered, as, when discussing API improvements,
it is usual the need of pinpoint to an specific chapter and section.

Tables and images should also be numbered, and we need a way to
use references for table/image numbers.

2) Images

Most images didn't popup. We have images on different file formats:
	- SVG
	- GIF
	- PDF
	- PNG

3) References

It could be a conversion issue, but there are lots of missing 
references at the documentation.

4) We need to have some way to tell sphinx to not put some things
at the lateral ToC bar. For example, at the V4L2 "Changes" section,
we don't want to have one entry per version at the ToC bar.

Giving that, I suspect that we'll have huge headaches to address
if we use sphinx, as it seems too limited to handle complex
documents. We should try to use some other tool that would give
us better results.


Regards,
Mauro
