Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33706 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbcEDNnt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 09:43:49 -0400
Received: by mail-wm0-f67.google.com with SMTP id r12so10393488wme.0
        for <linux-media@vger.kernel.org>; Wed, 04 May 2016 06:43:49 -0700 (PDT)
Date: Wed, 4 May 2016 15:43:46 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160504134346.GY14148@phenom.ffwll.local>
References: <87fuvypr2h.fsf@intel.com>
 <20160310122101.2fca3d79@recife.lan>
 <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de>
 <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de>
 <20160412094620.4fbf05c0@lwn.net>
 <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com>
 <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com>
 <54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de>
 <874maef8km.fsf@intel.com>
 <13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 04, 2016 at 02:40:29PM +0200, Markus Heiser wrote:
> > On Wed, 04 May 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> > I'd be *very* hesitant about adding the kind of things you do in
> > reformat_block_rst to kernel-doc. IMO the extraction from kernel-doc
> > comments must be as simple as possible with basically pass-through of
> > the comment blocks to sphinx.
> 
> Right, but you forgot, that the current markup in the source code comments
> is based on the  kernel-doc-nano-HOWTO and I guess no one will migrate all
> these source code comments to reST markup ;-)
> 
> So there is a need to differentiate between *vintage* kernel-doc markup 
> and reST markup.
> 
> My suggestion is to add a tag to the comments, here a short example
> what this might look like.
> 
> <vintage-comment-SNIP> --------------
> /**
>  * drm_minor_release - Release DRM minor
>  * @minor: Pointer to DRM minor object
>  *
>  * Release a minor that was previously acquired via drm_minor_acquire().
>  */
> <vintage-comment-SNAP> --------------
> 
> in short: the vintage style does not need any change and 
> comments with reST markup has a tag ":reST:" in the first 
> line(s) ...
> 
> <reST-comment-SNIP> --------------
> /**
>  * :reST:
>  *
>  * .. c:function:: void drm_minor_release(struct drm_minor *minor)
>  *
>  *    Release DRM minor
>  *
>  *    :param struct drm_minor \*minor: Pointer to DRM minor object
>  *
>  */
> <reST-comment-SNAP> --------------
> 
> Comments with the ":reST:" tag could be exported and pass-through
> to sphinx.
> 
> > Specifically, do not attempt to detect and
> > parse elements like lists in kernel-doc.
> 
> If your markup in the comments is plain reST, no need to parse, but there
> are markups in the (vintage) comments which made use of individual 
> text-markups, e.g. the markup of lists or ASCII-art. 
> 
> This individual text-markups has not been converted/rendered in the docbook
> output, but I wanted to convert this individuals to reST, to render them in
> Sphinx.

I think we need to unconfuse what's current standardize kerneldoc markup.
There's three bits:
- The header with the one-liner and parameters, i.e.

/**
 * drm_minor_release - Release DRM minor
 * @minor: Pointer to DRM minor object

  There's thousands of those, and we cant realistically change them. This
  means we need to teach kernel-doc to parse those and convert them to
  rest/shpinx layout. Any approach that expects a conversion of all the
  existing comments over to sphinx/rst is imo unworkable.

- References for function(), &structures, #constants and @parameters.
  Again for the same reasons of being here already, we can't change those
  at all. On top of that these markers are also used to generate
  hyperlinks in the final docs. The kernel-doc script therefor not only
  needs to generate the right markup, but also correct links. Without
  generating links to functions/structures outside of a given document.

- kernel-doc also does paragraph splitting and minimalistic headers like

 * Returns:
 * 
 * This will be under a separate Returns: heading in the text.

  afaict at least the paragraph splitting would be identical between all
  proposed markup languages.

Now what all current proposals have done is simply allow pass-through of
asciidoc or rst markup in those paragraphs, so that the final processor
could make stuff pretty.

This is already used widely in kerneldoc included by gpu.tmpl, and
currently it's asciidoc. Those lists and asciiarts though are _not_
standard kerneldoc at all. But imo any doc toolchain improvement should
integrate along those lines.
 
For reference, this is what it's supposed to look like with the asciidoc
support enabled:

https://dri.freedesktop.org/docs/drm/API-struct-drm-display-mode.html

Fyi those hacked-up patches to make this happen are available in

https://cgit.freedesktop.org/drm-intel/log/?h=topic/kerneldoc

Note that this isn't upstream, but we did start using this support all
over in gpu documentation simply because we really, really need it. And
I'm willing to throw all the comments into a converter to end up with
whatever markup we decide upon.

But what will not work is to throw the existing kernel-doc standard into
the shredder. So all the stuff with @, (), & and # must keep working.

> E.g. compare the member & description section of struct drm-display-mode ...
> 
> DocBook: 
> 
>   * https://www.kernel.org/doc/htmldocs/gpu/API-struct-drm-display-mode.html
> 
> kernel-doc reST with the additional reformat_block_rst function:
> 
>   * http://return42.github.io/sphkerneldoc/linux_src_doc/include/drm/drm_modes_h.html#struct-drm-display-mode

So we have this already. The two things I thought this entire discussion
was about:

- also throw out the docbook .xml and replace it with something else. That
  was jani's prototype on top of asciidoc, and it sounds like we could do
  something similar with rst/sphinx. Everyone pretty much agrees that
  this would be a second step, and the first step would be to simply
  integrate more advanced markup into the existing toolchain.

- which flavour of markup has the best support for more advanced use-cases
  like those in the media docbook. It sounds like sphinx won that
  competition.

I'd really like to converge on the markup question, so that we can start
using all the cool stuff with impunity in gpu documentations.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
