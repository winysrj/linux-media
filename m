Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:56937 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1425770AbcBRKwJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 05:52:09 -0500
Subject: Re: V4L docs and docbook
To: Jani Nikula <jani.nikula@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20160217145254.3085b333@lwn.net> <56C56A56.8010107@xs4all.nl>
 <87vb5me2wy.fsf@intel.com>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56C5A248.8080902@xs4all.nl>
Date: Thu, 18 Feb 2016 11:51:52 +0100
MIME-Version: 1.0
In-Reply-To: <87vb5me2wy.fsf@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/18/16 11:19, Jani Nikula wrote:
> On Thu, 18 Feb 2016, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> I looked at ReStructuredText and it looks like it will be a pain to convert
>> the media DocBook code to that, and the main reason is the poor table support.
>> The syntax for that looks very painful and the media DocBook is full of tables.
> 
> The table support seems to be one point in favor of asciidoc over
> reStructuredText [citation needed].
> 
>> BTW, my daily build scripts also rebuilds the media spec and it is available
>> here: https://hverkuil.home.xs4all.nl/spec/media.html
>>
>> Also missing in ReStructuredText seems to be support for formulas (see for
>> example the Colorspaces section in the spec), although to be fair standard
>> DocBook doesn't do a great job at that either.
> 
> This may be true for vanilla rst as supported by Python docutils, but
> the Sphinx tool we're considering does support a lot of things through
> extensions. The builtin extensions include support for rendering math
> via PNG or javascript [1]. There's also support for embedded graphviz
> [2] which may be of interest.
> 
>> Now, I hate DocBook so going to something easier would certainly be nice,
>> but I think it is going to be a difficult task.
>>
>> Someone would have to prove that going to another formatting tool will
>> produce good results for our documentation. We can certainly give a few
>> representative sections of our doc to someone to convert, and if that
>> looks OK, then the full conversion can be done.
> 
> It would be great to have you actively on board doing this yourself,
> seeking the solutions, as you're the ones doing your documentation in
> the end.
> 
> Speaking only for myself, I'd rather prove we can produce beautiful
> documentation from lightweight markup for ourselves, and let others make
> their own conclusions about switching over or sticking with DocBook.
> 
>> We have (and still are) put a lot of effort into our documentation and
>> we would like to keep the same level of quality.
> 
> We are doing this because we (at least in the graphics community) also
> put a lot of effort into documentation, and we would like to make it
> *better*!
> 
> I believe switching to some lightweight markup will be helpful in
> attracting more contributions to documentation.

Just to be clear: I really don't like DocBook at all, so something better and
easier would be very much appreciated.

But good table handling is a prerequisite for us since we rely heavily on that.

Regards,

	Hans
