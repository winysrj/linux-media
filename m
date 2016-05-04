Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:34137 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbcEDMkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 08:40:46 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Kernel docs: muddying the waters a bit
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <874maef8km.fsf@intel.com>
Date: Wed, 4 May 2016 14:40:29 +0200
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
Content-Transfer-Encoding: 8BIT
Message-Id: <13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com> <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan> <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk> <CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com> <87a8m9qoy8.fsf@intel.com> <20160308082948.4e2e0f82@recife.lan> <CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com> <20160308103922.48d87d9d@recife.lan> <20160308123921.6f2248ab@recife.lan> <20160309182709.7ab1e5db@recife.lan> <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de> <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net> <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com> <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com> <54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de> <874maef8km.fsf@intel.com>
To: Jani Nikula <jani.nikula@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jani,

Am 04.05.2016 um 11:58 schrieb Jani Nikula <jani.nikula@intel.com>:

> On Wed, 04 May 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
>> but I think this will not by very helpful, as long as you miss 
>> a similar ".tmpl" workflow for reST documents.
>> 
>> I'am working on a reST directive (named: "kernel-doc") to provide a
>> similar ".tmpl" workflow within plain reST. The first step towards
>> is done with (my) modified kernel-doc script ...
>> 
>> * https://github.com/return42/sphkerneldoc/blob/master/scripts/kernel-doc#L1736
>> 
>> which produce reST from source code comments. E.g. this content is 
>> generated with it.
> 
> What do you mean by ".tmpl workflow"?

Sorry for bad naming, I addressed the DOCPROC build process which builds
the .xml files from .tmpl files ...

<SNIP> ----
###
# The build process is as follows (targets):
#              (xmldocs) [by docproc]
# file.tmpl --> file.xml +--> file.ps   (psdocs)   [by db2ps or xmlto]
#                        +--> file.pdf  (pdfdocs)  [by db2pdf or xmlto]
#                        +--> DIR=file  (htmldocs) [by xmlto]
#                        +--> man/      (mandocs)  [by xmlto]
....
###
# DOCPROC is used for two purposes:
# 1) To generate a dependency list for a .tmpl file
# 2) To preprocess a .tmpl file and call kernel-doc with
#     appropriate parameters.
# The following rules are used to generate the .xml documentation
# required to generate the final targets. (ps, pdf, html).
<SNAP> -----


The DOCPROC markup directives are described in the kernel-doc-nano-HOWTO:

https://github.com/torvalds/linux/blob/master/Documentation/kernel-doc-nano-HOWTO.txt#L332

My aim is to implement a reST-directive which is similar. E.g: 
 
<XML-SNIP> -----
    <sect2>
      <title>Device Instance and Driver Handling</title>
!Pdrivers/gpu/drm/drm_drv.c driver instance overview
!Edrivers/gpu/drm/drm_drv.c
    </sect2>
    <sect2>
<XML-SNAP> -----

In reST the directive might look like:

<reST-SNIP> -----
Device Instance and Driver Handling
===================================

.. kernel-doc::  drivers/gpu/drm/drm_drv.c
   :doc:      driver instance overview
   :exported:

<reST-SNAP> -----


> I'd be *very* hesitant about adding the kind of things you do in
> reformat_block_rst to kernel-doc. IMO the extraction from kernel-doc
> comments must be as simple as possible with basically pass-through of
> the comment blocks to sphinx.

Right, but you forgot, that the current markup in the source code comments
is based on the  kernel-doc-nano-HOWTO and I guess no one will migrate all
these source code comments to reST markup ;-)

So there is a need to differentiate between *vintage* kernel-doc markup 
and reST markup.

My suggestion is to add a tag to the comments, here a short example
what this might look like.

<vintage-comment-SNIP> --------------
/**
 * drm_minor_release - Release DRM minor
 * @minor: Pointer to DRM minor object
 *
 * Release a minor that was previously acquired via drm_minor_acquire().
 */
<vintage-comment-SNAP> --------------

in short: the vintage style does not need any change and 
comments with reST markup has a tag ":reST:" in the first 
line(s) ...

<reST-comment-SNIP> --------------
/**
 * :reST:
 *
 * .. c:function:: void drm_minor_release(struct drm_minor *minor)
 *
 *    Release DRM minor
 *
 *    :param struct drm_minor \*minor: Pointer to DRM minor object
 *
 */
<reST-comment-SNAP> --------------

Comments with the ":reST:" tag could be exported and pass-through
to sphinx.

> Specifically, do not attempt to detect and
> parse elements like lists in kernel-doc.

If your markup in the comments is plain reST, no need to parse, but there
are markups in the (vintage) comments which made use of individual 
text-markups, e.g. the markup of lists or ASCII-art. 

This individual text-markups has not been converted/rendered in the docbook
output, but I wanted to convert this individuals to reST, to render them in
Sphinx.

E.g. compare the member & description section of struct drm-display-mode ...

DocBook: 

  * https://www.kernel.org/doc/htmldocs/gpu/API-struct-drm-display-mode.html

kernel-doc reST with the additional reformat_block_rst function:

  * http://return42.github.io/sphkerneldoc/linux_src_doc/include/drm/drm_modes_h.html#struct-drm-display-mode


-- Markus--

> -- 
> Jani Nikula, Intel Open Source Technology Center
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

