Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45349 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425515AbcBRLXn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 06:23:43 -0500
From: Jani Nikula <jani.nikula@intel.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Kernel docs: muddying the waters a bit
In-Reply-To: <20160218082657.5a1a5b0f@recife.lan>
References: <20160213145317.247c63c7@lwn.net> <86fuwwcdmd.fsf@hiro.keithp.com> <CAKMK7uGeU_grgC7pRCdqw+iDGWQfXhHwvX+tkSgRmdimxMrthA@mail.gmail.com> <20160217151401.3cb82f65@lwn.net> <CAKMK7uEqbSrhc2nh0LjC1fztciM4eTjtKE9T_wMVCqAkkTnzkA@mail.gmail.com> <874md6fkna.fsf@intel.com> <CAKMK7uE72wFEFCyw1dHbt+f3-ex3fr_9MbjoGfnKFZkd5+9S2Q@mail.gmail.com> <20160218082657.5a1a5b0f@recife.lan>
Date: Thu, 18 Feb 2016 13:23:37 +0200
Message-ID: <87r3gadzye.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 18 Feb 2016, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> For simple documents like the one produced by kernel-doc, I guess
> all markup languages would work equally.
>
> The problem is for complex documents like the media kAPI one, where
> the document was written to produce a book. So, it uses some complex
> features found at DocBook. One of such features we use extensively
> is the capability of having a table with per-line columns. This way,
> we can produce things like:
>
> V4L2_CID_COLOR_KILLER	boolean	Enable the color killer (i. e. force a black & white image in case of a weak video signal).
> V4L2_CID_COLORFX	enum	Selects a color effect. The following values are defined:
> 				V4L2_COLORFX_NONE 		Color effect is disabled.
> 				V4L2_COLORFX_ANTIQUE 		An aging (old photo) effect.
> 				V4L2_COLORFX_ART_FREEZE 	Frost color effect.
>
> In the above example, we have a main 3 columns table, and we embed
> a 2 columns table at the third field of V4L2_CID_COLORFX to represent
> possible values for this menu control.
>
> See https://linuxtv.org/downloads/v4l-dvb-apis/control.html for the
> complete output of it.
>
> This is used extensively inside the media DocBook, and properly
> supporting it is one of our major concerns.
>
> Are there any way to represent those things with the markup
> languages currently being analyzed?
>
> Converting those tables will likely require manual work, as I don't
> think automatic tools will properly handle it, specially since we
> use some DocBook macros to help creating such tables.

Since I've let myself be told that asciidoc handles tables better than
reStructuredText, I tested this a bit with the presumably inferior one.

rst has two table types, simple tables and grid tables [1]. It seems
like grid tables can do pretty much anything, but they can be cumbersome
to work with. So I tried to check what can be done with simple tables.

Here's a sample, converted using rst2html (Sphinx will be prettier, but
rst2html works for simple things like this):

https://people.freedesktop.org/~jani/v4l-table-within-table.rst
https://people.freedesktop.org/~jani/v4l-table-within-table.html

Rather than using nested tables, you might want to consider using
definition lists within tables:

https://people.freedesktop.org/~jani/v4l-definition-list-within-table.rst
https://people.freedesktop.org/~jani/v4l-definition-list-within-table.html

You be the judge, but I think this is workable.

BR,
Jani.


[1] http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#tables


-- 
Jani Nikula, Intel Open Source Technology Center
