Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35459 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbcEDOS2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 10:18:28 -0400
Received: by mail-ob0-f175.google.com with SMTP id n10so21328686obb.2
        for <linux-media@vger.kernel.org>; Wed, 04 May 2016 07:18:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160504134346.GY14148@phenom.ffwll.local>
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
Date: Wed, 4 May 2016 16:18:27 +0200
Message-ID: <CAKMK7uG9hNkG6KxFLQeaCbtPFY7qLiz6s5+qDy9-DcdywkDqrA@mail.gmail.com>
Subject: Re: Kernel docs: muddying the waters a bit
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Markus Heiser <markus.heiser@darmarit.de>,
	Jani Nikula <jani.nikula@intel.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 4, 2016 at 3:43 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> I'd really like to converge on the markup question, so that we can start
> using all the cool stuff with impunity in gpu documentations.

Aside: If we decide this now I could send in a pull request for the
rst/sphinx kernel-doc support still for 4.7 (based upon the minimal
markdown/asciidoc code I still have). That would be really awesome ...

Jon?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
