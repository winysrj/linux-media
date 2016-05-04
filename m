Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:50002 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbcEDPJJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 11:09:09 -0400
Date: Wed, 4 May 2016 09:09:01 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
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
Message-ID: <20160504090901.334c2ae7@lwn.net>
In-Reply-To: <87y47qlz35.fsf@intel.com>
References: <20160213145317.247c63c7@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<1457076530.13171.13.camel@winder.org.uk>
	<CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com>
	<87a8m9qoy8.fsf@intel.com>
	<20160308082948.4e2e0f82@recife.lan>
	<CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com>
	<20160308103922.48d87d9d@recife.lan>
	<20160308123921.6f2248ab@recife.lan>
	<20160309182709.7ab1e5db@recife.lan>
	<87fuvypr2h.fsf@intel.com>
	<20160310122101.2fca3d79@recife.lan>
	<AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de>
	<8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de>
	<20160412094620.4fbf05c0@lwn.net>
	<CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com>
	<CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com>
	<54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de>
	<874maef8km.fsf@intel.com>
	<13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de>
	<87y47qlz35.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 May 2016 16:41:50 +0300
Jani Nikula <jani.nikula@intel.com> wrote:

> On Wed, 04 May 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> > In reST the directive might look like:
> >
> > <reST-SNIP> -----
> > Device Instance and Driver Handling
> > ===================================
> >
> > .. kernel-doc::  drivers/gpu/drm/drm_drv.c
> >    :doc:      driver instance overview
> >    :exported:
> >
> > <reST-SNAP> -----  
> 
> Yes, I think something like this, parsed by sphinx directly (via some
> extension perhaps), should be the end goal. I am not sure if it should
> be the immediate first goal though or whether we should reuse the
> existing docproc for now.

I think all of this makes sense.  It would be really nice to have the
directives in the native sphinx language like that.  I *don't* think we
need to aim for that at the outset; the docproc approach works until we can
properly get rid of it.  What would be *really* nice would be to get
support for the kernel-doc directive into the sphinx upstream.

> > <reST-comment-SNAP> --------------
> >
> > Comments with the ":reST:" tag could be exported and pass-through
> > to sphinx.  
> 
> Disagreed on most of the above.

Agreed with the disagreement here.  We can't be adding ":reST:" tags to
comments; I anticipate a wee bit of pushback if we try.  It needs to work
with the comments as they are now.  It seems that should be possible.

Thanks,

jon
