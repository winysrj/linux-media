Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61827 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426064AbcBRKTr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 05:19:47 -0500
From: Jani Nikula <jani.nikula@intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: V4L docs and docbook
In-Reply-To: <56C56A56.8010107@xs4all.nl>
References: <20160217145254.3085b333@lwn.net> <56C56A56.8010107@xs4all.nl>
Date: Thu, 18 Feb 2016 12:19:41 +0200
Message-ID: <87vb5me2wy.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 18 Feb 2016, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> I looked at ReStructuredText and it looks like it will be a pain to convert
> the media DocBook code to that, and the main reason is the poor table support.
> The syntax for that looks very painful and the media DocBook is full of tables.

The table support seems to be one point in favor of asciidoc over
reStructuredText [citation needed].

> BTW, my daily build scripts also rebuilds the media spec and it is available
> here: https://hverkuil.home.xs4all.nl/spec/media.html
>
> Also missing in ReStructuredText seems to be support for formulas (see for
> example the Colorspaces section in the spec), although to be fair standard
> DocBook doesn't do a great job at that either.

This may be true for vanilla rst as supported by Python docutils, but
the Sphinx tool we're considering does support a lot of things through
extensions. The builtin extensions include support for rendering math
via PNG or javascript [1]. There's also support for embedded graphviz
[2] which may be of interest.

> Now, I hate DocBook so going to something easier would certainly be nice,
> but I think it is going to be a difficult task.
>
> Someone would have to prove that going to another formatting tool will
> produce good results for our documentation. We can certainly give a few
> representative sections of our doc to someone to convert, and if that
> looks OK, then the full conversion can be done.

It would be great to have you actively on board doing this yourself,
seeking the solutions, as you're the ones doing your documentation in
the end.

Speaking only for myself, I'd rather prove we can produce beautiful
documentation from lightweight markup for ourselves, and let others make
their own conclusions about switching over or sticking with DocBook.

> We have (and still are) put a lot of effort into our documentation and
> we would like to keep the same level of quality.

We are doing this because we (at least in the graphics community) also
put a lot of effort into documentation, and we would like to make it
*better*!

I believe switching to some lightweight markup will be helpful in
attracting more contributions to documentation.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
