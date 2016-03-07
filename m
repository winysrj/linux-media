Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:51783 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbcCGDsR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Mar 2016 22:48:17 -0500
Date: Sun, 6 Mar 2016 20:48:14 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Jani Nikula <jani.nikula@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160306204814.608d902c@lwn.net>
In-Reply-To: <87y49zr74t.fsf@intel.com>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 03 Mar 2016 16:03:14 +0200
Jani Nikula <jani.nikula@intel.com> wrote:

> This stalled a bit, but the waters are still muddy...

So I've been messing with this a bit; wanted to do a proper patch posting
but I'm fried and mostly out of time for the moment.

The results I'm getting now can be seen at:

	http://static.lwn.net/kerneldoc/

I've pulled in a few templates (including gpu.tmpl), converted them, and
built them into some reasonable-looking HTML, modulo a fair number of
glitches. There's lots of details to deal with, but the broad shape of it
is there.  If you look, you'll see that things like cross-file
cross-references, a feature we've never had before, work nicely.

I can also get good EPUB and PDF output - except that rst2pdf is
currently crashing on me, which is a little discouraging.  Man page
output will take more work.

What I have so far can be pulled from:

	git://git.lwn.net/linux.git doc/sphinx

It's still based on using docproc because that was easiest (for me).  The
kernel-doc part is Jani's asciidoc stuff, hacked up and made uglier.  I'm
not sure that any of it is worth more than a demonstration of what can be
done; I'm not particularly proud of (or tied to) any of it.  But it's a
start.

I've not looked at the table situation at all; soon.

jon
