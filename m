Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:17260 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbcEDPpK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 11:45:10 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
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
In-Reply-To: <20160504085713.3b81856d@lwn.net>
References: <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de> <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net> <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com> <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com> <54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de> <874maef8km.fsf@intel.com> <13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de> <20160504134346.GY14148@phenom.ffwll.local> <CAKMK7uG9hNkG6KxFLQeaCbtPFY7qLiz6s5+qDy9-DcdywkDqrA@mail.gmail.com> <20160504085713.3b81856d@lwn.net>
Date: Wed, 04 May 2016 18:44:22 +0300
Message-ID: <87pot1n7zd.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 May 2016, Jonathan Corbet <corbet@lwn.net> wrote:
> The sphinx/rst approach does seem, to me, to be the right one, with the
> existing DocBook structure remaining in place for those who want/need
> it.  I'm inclined toward my stuff as a base to work with, obviously :) But
> it's hackish at best and needs a lot of cleaning up.  It's a proof of
> concept, but it's hardly finished (one might say it's barely begun...)

Thanks. I'll start looking at how to make it less hackish and more
upstreamable.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
