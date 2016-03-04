Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:41807 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbcCDOJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 09:09:27 -0500
Date: Fri, 4 Mar 2016 15:09:09 +0100
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
Message-ID: <20160304140909.GA15636@linuxtv.org>
References: <20160213145317.247c63c7@lwn.net>
 <87y49zr74t.fsf@intel.com>
 <20160303071305.247e30b1@lwn.net>
 <20160303155037.705f33dd@recife.lan>
 <86egbrm9hw.fsf@hiro.keithp.com>
 <20160303221930.32558496@recife.lan>
 <87si06r6i3.fsf@intel.com>
 <20160304095950.3358a2cb@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160304095950.3358a2cb@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 04, 2016 at 09:59:50AM -0300, Mauro Carvalho Chehab wrote:
> 
> 3) I tried to use a .. cssclass, as Johannes suggested, but
> I was not able to include the CSS file. I suspect that this is
> easy to fix, but I want to see if the cssclass will also work for
> the pdf output as well.

"cssclass" was (I think) a custom role defined in the example,
unless you also have defined a custom role you can use plain "class".
I have not looked deeper into the theming and template stuff.

> 4) It seems that it can't produce nested tables in pdf:
> 
> Markup is unsupported in LaTeX:
> v4l-table-within-table:: nested tables are not yet implemented.
> Makefile:115: recipe for target 'latexpdf' failed

This:
http://www.sphinx-doc.org/en/stable/markup/misc.html#tables

suggests you need to add the tabularcolumns directive
for complex tables.

BTW, as an alternative to the ASCII-art input
there is also support for CSV and list tables:
http://docutils.sourceforge.net/docs/ref/rst/directives.html#table


Johannes
