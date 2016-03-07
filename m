Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:60443 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbcCGIst (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2016 03:48:49 -0500
Date: Mon, 7 Mar 2016 09:48:26 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160307084826.GA6381@linuxtv.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160306232908.GA3732@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 07, 2016 at 12:29:08AM +0100, Johannes Stezenbach wrote:
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
> 
> Sphinx' latex writer can't handle nested tables, though.
> Python's docutils rst2latex can, but that doesn't help here.
> rst2pdf also supports it.  But I have doubts such a large
> table would render OK in pdf without using landscape orientation.
> I have not tried because I used python3-sphinx but rst2pdf
> is only availble for Python2 in Debian so it does not integrate
> with Sphinx.

Just a quick idea:
Perhaps one alternative would be to use Graphviz to render
the problematic tables, it supports a HTML-like syntax
and can be embedded in Spinx documents:

http://www.sphinx-doc.org/en/stable/ext/graphviz.html
http://www.graphviz.org/content/node-shapes#html
http://stackoverflow.com/questions/13890568/graphviz-html-nested-tables


Johannes
