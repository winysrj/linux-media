Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:47509 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbcEDPzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 11:55:23 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Kernel docs: muddying the waters a bit
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160504134346.GY14148@phenom.ffwll.local>
Date: Wed, 4 May 2016 17:55:05 +0200
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
	Grant Likely <grant.likely@secretlab.ca>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <44110C0C-2E98-4470-9DB1-B72406E901A0@darmarit.de>
References: <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de> <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net> <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com> <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com> <54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de> <874maef8km.fsf@intel.com> <13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de> <20160504134346.GY14148@phenom.ffwll.local>
To: Daniel Vetter <daniel@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.05.2016 um 15:43 schrieb Daniel Vetter <daniel@ffwll.ch>:

> On Wed, May 04, 2016 at 02:40:29PM +0200, Markus Heiser wrote:
>>> On Wed, 04 May 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
>>> I'd be *very* hesitant about adding the kind of things you do in
>>> reformat_block_rst to kernel-doc. IMO the extraction from kernel-doc
>>> comments must be as simple as possible with basically pass-through of
>>> the comment blocks to sphinx.
>> 
>> Right, but you forgot, that the current markup in the source code comments
>> is based on the  kernel-doc-nano-HOWTO and I guess no one will migrate all
>> these source code comments to reST markup ;-)
>> 
>> So there is a need to differentiate between *vintage* kernel-doc markup 
>> and reST markup.
>> 
>> My suggestion is to add a tag to the comments, here a short example
>> what this might look like.
>> 
>> <vintage-comment-SNIP> --------------
>> /**
>> * drm_minor_release - Release DRM minor
>> * @minor: Pointer to DRM minor object
>> *
>> * Release a minor that was previously acquired via drm_minor_acquire().
>> */
>> <vintage-comment-SNAP> --------------
>> 
>> in short: the vintage style does not need any change and 
>> comments with reST markup has a tag ":reST:" in the first 
>> line(s) ...
>> 
>> <reST-comment-SNIP> --------------
>> /**
>> * :reST:
>> *
>> * .. c:function:: void drm_minor_release(struct drm_minor *minor)
>> *
>> *    Release DRM minor
>> *
>> *    :param struct drm_minor \*minor: Pointer to DRM minor object
>> *
>> */
>> <reST-comment-SNAP> --------------
>> 
>> Comments with the ":reST:" tag could be exported and pass-through
>> to sphinx.
>> 
>>> Specifically, do not attempt to detect and
>>> parse elements like lists in kernel-doc.
>> 
>> If your markup in the comments is plain reST, no need to parse, but there
>> are markups in the (vintage) comments which made use of individual 
>> text-markups, e.g. the markup of lists or ASCII-art. 
>> 
>> This individual text-markups has not been converted/rendered in the docbook
>> output, but I wanted to convert this individuals to reST, to render them in
>> Sphinx.
> 
> I think we need to unconfuse what's current standardize kerneldoc markup.
> There's three bits:
> - The header with the one-liner and parameters, i.e.

OK, forget my <reST-comment-SNAP> example, I don't really want to promote
this way ... I agree, it is better to stay with standardize kernel-doc markup
and provide a "pass through" for the section-content (even if it is mixing 
markups).

Am 04.05.2016 um 15:41 schrieb Jani Nikula <jani.nikula@intel.com>:

> Kernel-doc the tool should continue to parse kernel-doc comments at the
> high level like they currently are, according to the kernel-doc
> howto. 

The requirement was unclear for me, thanks to Daniel and 
Jani for clarifying this.


Am 04.05.2016 um 15:43 schrieb Daniel Vetter <daniel@ffwll.ch>:

> This is already used widely in kerneldoc included by gpu.tmpl, and
> currently it's asciidoc. Those lists and asciiarts though are _not_
> standard kerneldoc at all. But imo any doc toolchain improvement should
> integrate along those lines.
> 
> For reference, this is what it's supposed to look like with the asciidoc
> support enabled:
> 
> https://dri.freedesktop.org/docs/drm/API-struct-drm-display-mode.html
> 
> Fyi those hacked-up patches to make this happen are available in
> 
> https://cgit.freedesktop.org/drm-intel/log/?h=topic/kerneldoc
> 

Correct my, if I'am wrong. I'am a bit unfamiliar with DOCPROC in
particular with your "MARKDOWNREADY := gpu.xml" process.

As I understood, you convert markdown to docbook within the kernel-doc 
script using pandoc's executable? ... I don't face this topic. With my 
modification of kernel-doc I produced pure reST markup from standardize
kernel-doc markup, no intermediate steps or tools required.

Am 04.05.2016 um 15:41 schrieb Jani Nikula <jani.nikula@intel.com>:

> Overall I think we should promote fixing those in the kernel-doc
> comments. Trying to guesswork in kernel-doc tool will leave the source
> littered with bad examples that get proliferated all around. Instead of
> gradually fixing things, we'll end up gradually messing things up even
> more.

I agree with you, lets drop the reformat_block_rst from my kernel-doc script:

* https://github.com/return42/sphkerneldoc/blob/master/scripts/kernel-doc#L1736

and we should have a plain "pass through".

Am 04.05.2016 um 17:09 schrieb Jonathan Corbet <corbet@lwn.net>:

> I think all of this makes sense.  It would be really nice to have the
> directives in the native sphinx language like that.  I *don't* think we
> need to aim for that at the outset; the docproc approach works until we can
> properly get rid of it.  What would be *really* nice would be to get
> support for the kernel-doc directive into the sphinx upstream.

No need for kernel-doc directive in sphinx upstream, later it will be 
an extension which could be installed by a simple command like 
"pip install kernel-doc-extensions" or similar.

I develop these required extension (and more) within my proof of concept
on github ... this takes time ... if I finished all my tests and all is
well, I will build the *kernel-doc-extensions* package and deploy it
on https://pypi.python.org/pypi from where everyone could install this 
with "pip".

At this time I see only one change/merge to the linux upstream, this is my
modification of the kernel-doc script to get a proper reST output.

But my recommendation is not to merge anything in a hurry.

--Markus--


