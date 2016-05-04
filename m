Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:49914 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbcEDO6d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 10:58:33 -0400
Date: Wed, 4 May 2016 08:57:13 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Jani Nikula <jani.nikula@intel.com>,
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
Message-ID: <20160504085713.3b81856d@lwn.net>
In-Reply-To: <CAKMK7uG9hNkG6KxFLQeaCbtPFY7qLiz6s5+qDy9-DcdywkDqrA@mail.gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 May 2016 16:18:27 +0200
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> > I'd really like to converge on the markup question, so that we can start
> > using all the cool stuff with impunity in gpu documentations.  
> 
> Aside: If we decide this now I could send in a pull request for the
> rst/sphinx kernel-doc support still for 4.7 (based upon the minimal
> markdown/asciidoc code I still have). That would be really awesome ...

Sorry for my relative absence...I'm still busy dealing with bureaucracy
an ocean away from home.  I hope to begin emerging from this mess in the
near future.

So ... there's the code you have, the work I (+Jani) did, and the work
Markus has done.  Which would you have me push into 4.7?

The sphinx/rst approach does seem, to me, to be the right one, with the
existing DocBook structure remaining in place for those who want/need
it.  I'm inclined toward my stuff as a base to work with, obviously :) But
it's hackish at best and needs a lot of cleaning up.  It's a proof of
concept, but it's hardly finished (one might say it's barely begun...)

In the end, I guess, I feel that anything we might try to push for 4.7 is
going to look rushed and not ready, and Linus might react accordingly.
I'd be more comfortable aiming for 4.8.  I *will* have more time to focus
on things in that time frame...  I suspect you're pretty well fed up with
this stuff being pushed back, and rightly so.  All I can do is apologize.

That said, if you do think there's something out there that is good
enough to consider pushing in a week or two, do tell and we can all take
a look.

Thanks,

jon
