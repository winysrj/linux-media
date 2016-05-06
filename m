Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33213 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758302AbcEFPOb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 11:14:31 -0400
Date: Fri, 6 May 2016 12:14:23 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Jani Nikula <jani.nikula@intel.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Grant Likely <grant.likely@secretlab.ca>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>,
	"@mx4.goneo.de>"@mx6.goneo.de
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160506121423.1b61d0f8@recife.lan>
In-Reply-To: <3EA89E0D-9951-437C-A2E0-E6866A43A459@darmarit.de>
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
	<6BDB8BFB-6AEA-46A8-B535-C69FBC6FF3BD@darmarit.de>
	<20160506083529.31ad2fa0@recife.lan>
	<BAE3C147-6C21-4242-BD3C-8989C1626E10@darmarit.de>
	<20160506104210.12197832@recife.lan>
	<3EA89E0D-9951-437C-A2E0-E6866A43A459@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 6 May 2016 16:27:21 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Hi all, hi Jonathan,
> 
> Am 06.05.2016 um 15:42 schrieb Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> 
> > Em Fri, 6 May 2016 15:32:35 +0200
> > Markus Heiser <markus.heiser@darmarit.de> escreveu:
> >   
> >> Hi Mauro,
> >> 
> >> Am 06.05.2016 um 13:35 schrieb Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> >>   
> >>> Markus,
> >>> 
> >>> Em Fri, 6 May 2016 13:23:06 +0200
> >>> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> >>>   
> >>>> 
> >>>> In this conf.py you have to *register* your folder with the extensions.
> >>>> A few words about the flat-table extension and a (future) kernel-doc one:    
> >>> 
> >>> ...
> >>>   
> >>>> The flat-table is a pure docutils (the layer below sphinx) extension which
> >>>> is not application specific, so I will ask for moving it to the docutils 
> >>>> upstream.     
> >>> 
> >>> So, if I understood well, your proposal is to have a conf.py and the
> >>> flat-table (plus other extensions) at the Kernel tree.    
> >> 
> >> Each book (better call it root-node) is a Sphinx-project, each 
> >> Sphinx-project need a conf.py file (the build configuration file)
> >> in its reST-source tree.
> >> 
> >> * http://www.sphinx-doc.org/en/stable/config.html
> >>   
> >>> Assuming that docutils upstream receives the flat-table extension
> >>> (and eventually modifies it), while the new version doesn't arrive
> >>> all distros, we'll end by having some developers using the newer
> >>> docutils with the extension, plus others using the in-tree one.
> >>> 
> >>> Is there a way to specify at the conf.py what extension variant
> >>> should it use, in case of both the in-tree or the docutils have
> >>> the same?    
> >> 
> >> The build configuration file is a regular python file, you can 
> >> implement conditions whatever you want/need.
> >>   
> >>> This could be trickier if they end by modifying the extension,
> >>> but we can always backport the latest version, if they change the
> >>> API.    
> >> 
> >> As far as i know, the docutils API is stable since 2002. In the
> >> meantime there has been so many application build on it that
> >> it is not realistic, you will see a not backward compatibly 
> >> change.
> >> 
> >> The docutils project is conservative, very conservative, IMO to
> >> conservative.
> >> 
> >> Today I'am doubtful if it isn't better I would merge it sphinx
> >> upstream. I have to discuss this with some maintainers, but 
> >> before I have to persuade myself, that all aspects are covered
> >> and the implementations are robust. We are at the beginning and
> >> we should not fear about every bit which could happen in the future.
> >> 
> >> The sphinx / docutils bottom plate gives us a number of degrees 
> >> of freedom to find answers to question we have not yet asked. ;-)  
> > 
> > Ok. So, from what I understand, once Sphinx support is added at
> > Kernel upstream, we could convert the media docbook to
> > reST+flat-table extension, adding such extension either on a shared
> > place or only for the media DocBook build, together with its
> > conf.py.
> >   
> 
> Yes, in your media-conf you could decide to use a extension.
> 
> > Once it reaches upstream (either sphinx or docutils), we can
> > work to make it integrate better with upstream as needed.
> > 
> > Right?  
> 
> yes, right :-)
> 
> > If so, I'm ok with merging it as soon as possible.  
> 
> If we advice a merge of the flat-table directive we should 
> bundle this with the (to implement) "kernel-doc" directive ...
> 
> > In reST the directive might look like:
> > 
> > <reST-SNIP> -----
> > Device Instance and Driver Handling
> > ===================================
> > 
> > .. kernel-doc::  drivers/gpu/drm/drm_drv.c
> >   :doc:      driver instance overview
> >   :exported:
> > 
> > <reST-SNAP> -----  
> 
> and the patches from my kernel-doc perl script to produce
> reST from source code comments.
> 
> With this bundle within the kernel tree we have a good starting
> point to compose reST documents from scratch and to migrate book
> by book from DocBook to reST.
> 
> I insist to migrate book by book, because there are some
> broken books. Broken by that, that some sources have changed
> but not the corresponding documentation which use the comments
> of these sources ... grap "Ooops" in the builded (xml or rst) docs.
> 
> E.g. I greped the .rst file and found the following Oops in the migrated books:
> 
> ./books/mtdnand/pubfunctions-000-012.rst:13:Oops
> ./books/scsi/mid_layer-000-001-016-003.rst:13:Oops
> ./books/s390-drivers/ccw-000-004-003.rst:13:Oops
> ./books/device-drivers/devdrivers-000-003-048.rst:13:Oops
> ./books/device-drivers/devdrivers-000-003-050.rst:13:Oops
> ./books/device-drivers/Basics-000-001-002.rst:13:Oops
> ./books/device-drivers/devdrivers-000-003-031.rst:13:Oops
> ./books/device-drivers/Basics-000-009-032.rst:13:Oops
> ./books/kernel-api/kernel-lib-000-004-008.rst:13:Oops
> ./books/gadget/api-000-011-005.rst:13:Oops
> ./books/gadget/api-000-011-009.rst:13:Oops
> ./books/gadget/api-000-011-007.rst:13:Oops
> ./books/gadget/api-000-011-003.rst:13:Oops
> ./books/gadget/api-000-011-011.rst:13:Oops
> ./books/genericirq/intfunctions-000-009.rst:13:Oops
> 
> ----- Summarize ----
> 
> @Jonathan: what do you think? Should I prepare a patch
> with a basic reST (sphinx) build infrastructure, including
> 
> * a folder for sphinx docs:
> 
>   ./Documentation/sphinx/
> 
> * flat-table & kernel-doc extension at
> 
>   ./Documentation/sphinx/extensions
> 
> * a patch with rst-Output for the kernel-doc perl script at
> 
>   ./scripts/kernel-doc

Maybe the best here is to add a kernel-doc-rest script, avoiding
the risk of regressions while we don't migrate all the books.

> * An example document "HowTo document with reST" at
> 
>   ./Documentation/sphinx/kernel-doc-rst-howto
> 
>   which at minimum describes the "flat-table" and "kernel-doc" 
>   directive and the requirements for a building docs.
> 
> * a make file which fit into the kernel Makefile infrastructure (not 
>   the one created by sphinx-quickstart).

Works for me. Btw, if we're following the above, as the sphinx
build will be independent and won't affect the current documentation
build, then perhaps we could merge it on 4.7 merge window.

While Documentation for things like device-drivers.tmpl should of be
handled via the documentation tree, if we apply the needed
infrastructure, each subsystem maintainer would be freed to work
on the docs that are specific to their own subsystem. So, in my case,
I can handle the needed patches for the media subsystem DocBook via the
media development tree (as I currently do for
Documentation/DocBook/media).

Regards,
Mauro
