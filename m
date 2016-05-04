Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38785 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbcEDQib (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 12:38:31 -0400
Date: Wed, 4 May 2016 13:38:23 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
	Markus Heiser <markus.heiser@darmarit.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	"Hans Verkuil" <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160504133823.2a25bff9@recife.lan>
In-Reply-To: <20160504085713.3b81856d@lwn.net>
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
	<CAKMK7uG9hNkG6KxFLQeaCbtPFY7qLiz6s5+qDy9-DcdywkDqrA@mail.gmail.com>
	<20160504085713.3b81856d@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 4 May 2016 08:57:13 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Wed, 4 May 2016 16:18:27 +0200
> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> 
> > > I'd really like to converge on the markup question, so that we can start
> > > using all the cool stuff with impunity in gpu documentations.    
> > 
> > Aside: If we decide this now I could send in a pull request for the
> > rst/sphinx kernel-doc support still for 4.7 (based upon the minimal
> > markdown/asciidoc code I still have). That would be really awesome ...  
> 
> Sorry for my relative absence...I'm still busy dealing with bureaucracy
> an ocean away from home.  I hope to begin emerging from this mess in the
> near future.
> 
> So ... there's the code you have, the work I (+Jani) did, and the work
> Markus has done.  Which would you have me push into 4.7?

IMHO, Markus approach is the one that is providing a better result,
as it added support for missing features that we require for the
media DocBook.

Still, it seems premature to merge it for 4.7.

Markus is getting real progress on converting the media docs to work
with Sphynx, but there are still troubles when the table is big, as,
currently, it is truncating everything that passes the right margin
on some tables.

So, IMHO, the next action item would be to be sure that big tables 
will not be truncated. Assuming that he can fix that in time, we
can merge it for 4.8, and then start porting the documentation to
use it.

Btw, converting the DocBook/media Makefile will require an extra
step, as part of the documentation is generated via scripts (some
C file examples, and include/uapi headers). Those scripts also
warrant that (almost) every API at include/uapi is synchronized
with the DocBook. I use this on my patch review process, in order
to reject patches that don't add the proper documentation updates.

Thanks,
Mauro
