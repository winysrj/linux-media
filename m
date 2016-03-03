Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34023 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbcCCPRL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 10:17:11 -0500
Date: Thu, 3 Mar 2016 08:17:09 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jani Nikula <jani.nikula@intel.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160303081709.5907bcd8@lwn.net>
In-Reply-To: <20160303143425.2361dea2@lxorguk.ukuu.org.uk>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303143425.2361dea2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 3 Mar 2016 14:34:25 +0000
One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:

> We only have docbook because it was the tool of choice rather a lot of
> years ago to then get useful output formats. It was just inherited when
> borrowed the original scripts from Gnome/Gtk. It's still the most
> effective way IMHO of building big structured documents out of the kernel.

...except that we haven't used it that way.  Instead, we make a whole
bunch of smaller, partially structured document silos.

> The Gtk people long ago rewrote the original document script into a real
> tool so they have some different and maintained tools that are close to
> equivalent and already have some markdown support. Before we go off and
> re-invent the wheel it might be worth just borrowing their wheel and
> tweaking it as needed ? In particular they can generate help indexes so
> that the entire output becomes nicely browsable with an HTML based help
> browser.

Well, not inventing the wheel was kind of the motivation behind much of
this effort; I got kind of worried watching us trying to cobble more
functionality into our existing house-of-cards documentation system.

Sphinx is a well-established, heavily used, and well supported system;
using it would not be an exercise in wheel reinvention.  As far as I can
tell, it does everything we need (with some open questions about table
support), lets us drop the whole DocBook toolchain dependency, and move to
a much better-supported setup than we have now.  Plus we get much nicer
output, index generation, cross-references between documents, and the
ability to write documents in a lightweight markup language.  Seems like a
win.

I assume you're referring to gtk-doc?  It's web page
(http://www.gtk.org/gtk-doc/) starts by noting that it's "a bit awkward to
setup and use"; they recommend looking at Doxygen instead.  So I guess I'm
not really sure what it offers that merits throwing another option into
the mix now?  What am I missing?

Thanks,

jon
