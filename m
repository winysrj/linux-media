Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43715 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbcEDNmh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 09:42:37 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jonathan Corbet <corbet@lwn.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media\@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
In-Reply-To: <13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de>
References: <20160213145317.247c63c7@lwn.net> <20160303155037.705f33dd@recife.lan> <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk> <CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com> <87a8m9qoy8.fsf@intel.com> <20160308082948.4e2e0f82@recife.lan> <CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com> <20160308103922.48d87d9d@recife.lan> <20160308123921.6f2248ab@recife.lan> <20160309182709.7ab1e5db@recife.lan> <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de> <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net> <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com> <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com> <54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de> <874maef8km.fsf@intel.com> <13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de>
Date: Wed, 04 May 2016 16:41:50 +0300
Message-ID: <87y47qlz35.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 May 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
>> What do you mean by ".tmpl workflow"?
>
> Sorry for bad naming, I addressed the DOCPROC build process which builds
> the .xml files from .tmpl files ...

Yeah, I know more about this part than I care. I was just wondering what
you refer to with that in the sphinx context.

> In reST the directive might look like:
>
> <reST-SNIP> -----
> Device Instance and Driver Handling
> ===================================
>
> .. kernel-doc::  drivers/gpu/drm/drm_drv.c
>    :doc:      driver instance overview
>    :exported:
>
> <reST-SNAP> -----

Yes, I think something like this, parsed by sphinx directly (via some
extension perhaps), should be the end goal. I am not sure if it should
be the immediate first goal though or whether we should reuse the
existing docproc for now.

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

Disagreed on most of the above.

Maybe I was unclear in my previous mail, and I've probably worked on
this so much previously that I thought it was clear how we should handle
lightweight markup in kernel-doc comments.

Kernel-doc the tool should continue to parse kernel-doc comments at the
high level like they currently are, according to the kernel-doc
howto. The first heading line, the parameter/member lines with @param:,
and references within the text with @param, function(), &struct
structures, etc. For those, kernel-doc should produce appropriate rst
elements.

Beyond that, kernel-doc should *not* try to make guesses about the
formatting of the documentation comments. It should just pass the rest
of the formatting through. If the ad-hoc lists etc. in the current
comments don't turn into proper rst lists, then so be it. If it bugs
people, the comments will gradually be converted to proper rst. The
worst we could do is promote a sloppy style that kernel-doc fixes for
you, possibly "fixing" things you'd want to pass through to sphinx.

What you have in <reST-comment-SNAP> example above will not fly. The
documentation comment style must remain as is defined in the kernel-doc
how, i.e. <vintage-comment-SNAP> example. It is imperative that the
kernel-doc comments remain as readable as they currently are in the
source code.

>> Specifically, do not attempt to detect and
>> parse elements like lists in kernel-doc.
>
> If your markup in the comments is plain reST, no need to parse, but there
> are markups in the (vintage) comments which made use of individual 
> text-markups, e.g. the markup of lists or ASCII-art. 
>
> This individual text-markups has not been converted/rendered in the docbook
> output, but I wanted to convert this individuals to reST, to render them in
> Sphinx.
>
> E.g. compare the member & description section of struct drm-display-mode ...
>
> DocBook: 
>
>   * https://www.kernel.org/doc/htmldocs/gpu/API-struct-drm-display-mode.html
>
> kernel-doc reST with the additional reformat_block_rst function:
>
>   * http://return42.github.io/sphkerneldoc/linux_src_doc/include/drm/drm_modes_h.html#struct-drm-display-mode

Overall I think we should promote fixing those in the kernel-doc
comments. Trying to guesswork in kernel-doc tool will leave the source
littered with bad examples that get proliferated all around. Instead of
gradually fixing things, we'll end up gradually messing things up even
more.

For those specific examples, IIRC the last time I played with that,
simply leaving the prefix whitespace in place went a long way (just eat
" * " from the lines). The asciiart just worked.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
