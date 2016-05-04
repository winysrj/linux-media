Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22008 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbcEDQOW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 12:14:22 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>,
	Daniel Vetter <daniel@ffwll.ch>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
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
In-Reply-To: <44110C0C-2E98-4470-9DB1-B72406E901A0@darmarit.de>
References: <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de> <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net> <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com> <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com> <54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de> <874maef8km.fsf@intel.com> <13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de> <20160504134346.GY14148@phenom.ffwll.local> <44110C0C-2E98-4470-9DB1-B72406E901A0@darmarit.de>
Date: Wed, 04 May 2016 19:13:21 +0300
Message-ID: <87inytn6n2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 May 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> Correct my, if I'am wrong. I'am a bit unfamiliar with DOCPROC in
> particular with your "MARKDOWNREADY := gpu.xml" process.
>
> As I understood, you convert markdown to docbook within the kernel-doc 
> script using pandoc's executable? ... I don't face this topic. With my 
> modification of kernel-doc I produced pure reST markup from standardize
> kernel-doc markup, no intermediate steps or tools required.

That pandoc thing is a dead end. Forget about it. I think we've all
pretty much agreed we should have kernel-doc produce the lightweight
markup directly since [1].

[1] http://mid.gmane.org/1453106477-21359-1-git-send-email-jani.nikula@intel.com

> Am 04.05.2016 um 17:09 schrieb Jonathan Corbet <corbet@lwn.net>:
>
>> I think all of this makes sense.  It would be really nice to have the
>> directives in the native sphinx language like that.  I *don't* think we
>> need to aim for that at the outset; the docproc approach works until we can
>> properly get rid of it.  What would be *really* nice would be to get
>> support for the kernel-doc directive into the sphinx upstream.
>
> No need for kernel-doc directive in sphinx upstream, later it will be 
> an extension which could be installed by a simple command like 
> "pip install kernel-doc-extensions" or similar.
>
> I develop these required extension (and more) within my proof of concept
> on github ... this takes time ... if I finished all my tests and all is
> well, I will build the *kernel-doc-extensions* package and deploy it
> on https://pypi.python.org/pypi from where everyone could install this 
> with "pip".

I think we should go for vanilla sphinx at first, to make the setup step
as easy as possible for everyone. Even if it means still doing that ugly
docproc step to call kernel-doc. We can improve from there, and I
definitely appreciate your work on making this work with sphinx
extensions.

That said, how would it work to include the kernel-doc extension in the
kernel source tree? Having things just work if sphinx is installed is
preferred over requiring installation of something extra from pypi. (I
know this may sound backwards for a lot of projects, but for kernel I'm
pretty sure this is how it should be done.)

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
