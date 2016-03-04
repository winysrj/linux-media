Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:59291 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbcCDI71 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 03:59:27 -0500
Date: Fri, 4 Mar 2016 09:59:08 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Keith Packard <keithp@keithp.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160304085908.GA17381@linuxtv.org>
References: <20160213145317.247c63c7@lwn.net>
 <87y49zr74t.fsf@intel.com>
 <20160303071305.247e30b1@lwn.net>
 <20160303155037.705f33dd@recife.lan>
 <86egbrm9hw.fsf@hiro.keithp.com>
 <20160303221930.32558496@recife.lan>
 <87si06r6i3.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87si06r6i3.fsf@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 04, 2016 at 10:29:08AM +0200, Jani Nikula wrote:
> On Fri, 04 Mar 2016, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
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
> 
> I know none of this alleviates your concerns with table supports right
> now. I'll try to have a look at that a bit more.

FWIW, I think table formatting in Sphinx works via style sheets.
The mechanism is documented in the Python docutils docs that
Sphinx is built upon.
Basically you use the "class" or "role" directive and define
the corresponding CSS or LaTeX (or rst2pdf) style.

Here is one example (using a custom "cssclass" role):
https://pythonhosted.org/sphinxjp.themes.basicstrap/sample.html

Directives (especially role and class):
http://www.sphinx-doc.org/en/stable/rest.html#directives

LaTeX styling:
http://docutils.readthedocs.org/en/sphinx-docs/user/latex.html#custom-interpreted-text-roles


HTH,
Johannes
