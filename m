Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:63188 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757720AbcEFPHk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 11:07:40 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Grant Likely <grant.likely@secretlab.ca>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
In-Reply-To: <3EA89E0D-9951-437C-A2E0-E6866A43A459@darmarit.de>
References: <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de> <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net> <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com> <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com> <54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de> <874maef8km.fsf@intel.com> <13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de> <20160504134346.GY14148@phenom.ffwll.local> <44110C0C-2E98-4470-9DB1-B72406E901A0@darmarit.de> <87inytn6n2.fsf@intel.com> <6BDB8BFB-6AEA-46A8-B535-C69FBC6FF3BD@darmarit.de> <20160506083529.31ad2fa0@recife.lan> <BAE3C147-6C21-4242-BD3C-8989C1626E10@darmarit.de> <20160506104210.12197832@recife.lan> <3EA89E0D-9951-437C-A2E0-E6866A43A459@darmarit.de>
Date: Fri, 06 May 2016 18:06:49 +0300
Message-ID: <87poszgr92.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 06 May 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> @Jonathan: what do you think? Should I prepare a patch
> with a basic reST (sphinx) build infrastructure, including
>
> * a folder for sphinx docs:
>
>   ./Documentation/sphinx/

I'm already working on a patch series taking a different approach. I
don't think we should hide the documentation under an extra folder named
after a tool. Actually, I'm strongly opposed to that.

Instead, we should place the Sphinx stuff directly under Documentation,
and have Sphinx recursively pick up all the *.rst files. We should
promote gradually switching to lightweight markup and integration of the
documents into one system. This process should be as little disruptive
as possible.

If someone wants to convert a .txt document to .rst and get it processed
by Sphinx, it should be as simple as renaming the file, doing the
necessary edits, and adding it to a toctree. Imagine gradually
converting the files under, say, Documentation/kbuild. Why should the
.rst files be moved under another directory? They should stay alongside
the .txt files under the same directory. There's bound to be a lot of
people who'll never use Sphinx, and will expect to find the good old
plain text files (albeit with some markup) where they always were.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
