Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36535 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbcCFC3q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2016 21:29:46 -0500
Date: Sat, 5 Mar 2016 23:29:37 -0300
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
Message-ID: <20160305232937.74678dd0@recife.lan>
In-Reply-To: <20160304140909.GA15636@linuxtv.org>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<20160303221930.32558496@recife.lan>
	<87si06r6i3.fsf@intel.com>
	<20160304095950.3358a2cb@recife.lan>
	<20160304140909.GA15636@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Mar 2016 15:09:09 +0100
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Fri, Mar 04, 2016 at 09:59:50AM -0300, Mauro Carvalho Chehab wrote:
> > 
> > 3) I tried to use a .. cssclass, as Johannes suggested, but
> > I was not able to include the CSS file. I suspect that this is
> > easy to fix, but I want to see if the cssclass will also work for
> > the pdf output as well.  
> 
> "cssclass" was (I think) a custom role defined in the example,
> unless you also have defined a custom role you can use plain "class".
> I have not looked deeper into the theming and template stuff.

Well, it accepted cssclass for html (well, it didn't find the
templates - so I guess it is just me failing to understand how to tell
sphinx to get the stylesheet), but it rejects it for latexPDF.

> 
> > 4) It seems that it can't produce nested tables in pdf:
> > 
> > Markup is unsupported in LaTeX:
> > v4l-table-within-table:: nested tables are not yet implemented.
> > Makefile:115: recipe for target 'latexpdf' failed  
> 
> This:
> http://www.sphinx-doc.org/en/stable/markup/misc.html#tables
> 
> suggests you need to add the tabularcolumns directive
> for complex tables.
> 
> BTW, as an alternative to the ASCII-art input
> there is also support for CSV and list tables:
> http://docutils.sourceforge.net/docs/ref/rst/directives.html#table

I converted one of the big tables to CSV. At least now it recognized
it as a table. Yet, the table was very badly formated:
	https://mchehab.fedorapeople.org/media-kabi-docs-test/rst_tests/packed-rgb.html

This is how this table should look like:
	https://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html

Also, as this table has merged cells at the legend. I've no idea how
to tell sphinx to do that on csv format.

The RST files are on this git tree:
	https://git.linuxtv.org/mchehab/v4l2-docs-poc.git/

Regards,
Mauro
