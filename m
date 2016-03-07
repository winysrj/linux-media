Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36663 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbcCGMTR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2016 07:19:17 -0500
Date: Mon, 7 Mar 2016 09:19:10 -0300
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
Message-ID: <20160307091910.09c90f31@recife.lan>
In-Reply-To: <20160306232908.GA3732@linuxtv.org>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<20160303221930.32558496@recife.lan>
	<87si06r6i3.fsf@intel.com>
	<20160304095950.3358a2cb@recife.lan>
	<20160304140909.GA15636@linuxtv.org>
	<20160305232937.74678dd0@recife.lan>
	<20160306232908.GA3732@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 7 Mar 2016 00:29:08 +0100
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Sat, Mar 05, 2016 at 11:29:37PM -0300, Mauro Carvalho Chehab wrote:
> > 
> > I converted one of the big tables to CSV. At least now it recognized
> > it as a table. Yet, the table was very badly formated:
> > 	https://mchehab.fedorapeople.org/media-kabi-docs-test/rst_tests/packed-rgb.html
> > 
> > This is how this table should look like:
> > 	https://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html
> > 
> > Also, as this table has merged cells at the legend. I've no idea how
> > to tell sphinx to do that on csv format.
> > 
> > The RST files are on this git tree:
> > 	https://git.linuxtv.org/mchehab/v4l2-docs-poc.git/  
> 
> Yeah, seems it can't do merged cells in csv.  Attached patch converts it
> back to grid table format and fixes the table definition.
> The html output looks usable, but clearly it is no fun to
> work with tables in Sphinx.

Yes, the output is OK, but, as you said, working with tables in
Sphinx is hard, and using asciiart for the kind of tables we have
is not nice.

> 
> Sphinx' latex writer can't handle nested tables, though.

Yeah, this is a big trouble that need to be solved if you're
willing to use Sphinx.

Btw, it crashes when trying to generate man pages:

	Exception occurred:
	  File "/usr/lib/python2.7/site-packages/docutils/writers/manpage.py", line 627, in depart_entry
	    self._active_table.append_cell(self.body[start:])
	AttributeError: 'NoneType' object has no attribute 'append_cell'
	The full traceback has been saved in /tmp/sphinx-err-04qRMz.log, if you want to report the issue to the developers.

So, if we're willing to use sphinx, someone should either fix
it to produce latex nexted table and fix it to generate manpages,
or we'll need to stick with just html output.

> Python's docutils rst2latex can, but that doesn't help here.
> rst2pdf also supports it.

At least here, rst2* scripts were unable to identify that the
index.rst had links to other rst documents. 

In the specific case of rst2latex, I got several errors like:

	index.rst:21: (ERROR/3) Unknown interpreted text role "ref".


> But I have doubts such a large
> table would render OK in pdf without using landscape orientation.

Yeah, in the past, when we had pdf enabled for DocBook (e. g. when
media development was using a separate mercurial tree), I guess
we had tags changing the text orientation on a few tables that
would otherwise won't diplay fine, but I can't remember the dirty
details anymore.

> I have not tried because I used python3-sphinx but rst2pdf
> is only availble for Python2 in Debian so it does not integrate
> with Sphinx.
> 
> 
> Johannes


-- 
Thanks,
Mauro
