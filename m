Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:50498 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbcEDQ7u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 12:59:50 -0400
Date: Wed, 4 May 2016 10:59:36 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Markus Heiser <markus.heiser@darmarit.de>,
	Daniel Vetter <daniel@ffwll.ch>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Grant Likely <grant.likely@secretlab.ca>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160504105936.34c2697f@lwn.net>
In-Reply-To: <20160504135035.1f055fa7@recife.lan>
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
	<20160504134346.GY14148@phenom.ffwll.local>
	<44110C0C-2E98-4470-9DB1-B72406E901A0@darmarit.de>
	<87inytn6n2.fsf@intel.com>
	<20160504135035.1f055fa7@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 May 2016 13:50:35 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> Em Wed, 4 May 2016 19:13:21 +0300
> Jani Nikula <jani.nikula@intel.com> escreveu:
> > I think we should go for vanilla sphinx at first, to make the setup step
> > as easy as possible for everyone.  
> 
> Vanilla Sphinx doesn't work, as reST markup language is too limited
> to support the docs we have. So, we should either push the needed
> extensions to Sphinx reST or find a way to put it at Kernel tree
> without causing too much pain for the developers, e. g. as something
> that just doing "make htmldoc" would automatically use such extensions
> without needing to actually install the extensions.

It works for everything except the extended media book, right?  Or is there
something I'm missing here?  I am very much interested in having one system
for *all* our docs, but we wouldn't attempt to convert a document can't be
expressed in sphinx.

> > Even if it means still doing that ugly
> > docproc step to call kernel-doc. We can improve from there, and I
> > definitely appreciate your work on making this work with sphinx
> > extensions.  
> 
> I disagree: We should not cause documentation regressions by
> producing incomplete documentation and losing tables because of
> such conversion.

> The quality of the documentation after the change should be *at least*
> equal to the one we current produce, never worse.

Agreed; that's why I think the existing DocBook mechanism should stay in
place until that document will be improved by the change.  But I'd rather
not hold up the entire process for one book, especially since pushing that
process forward can only help in dealing with those final problems.

> > That said, how would it work to include the kernel-doc extension in the
> > kernel source tree? Having things just work if sphinx is installed is
> > preferred over requiring installation of something extra from pypi. (I
> > know this may sound backwards for a lot of projects, but for kernel I'm
> > pretty sure this is how it should be done.)  
> 
> Yeah, using pypi seems an additional undesired step. Aren't there
> any way to make python to use an additional extension at the
> Kernel tree without needing to install it?

Well, sphinx has to come from somewhere too.  But yes, we should be able to
carry extensions in the kernel tree.  But I would still rather upstream it
(to sphinx) if possible, so we're not stuck trying to maintain it across
several sphinx releases.  I don't know how volatile their interfaces are,
but it would be, in any case, the analog of an out-of-tree module...

jon
