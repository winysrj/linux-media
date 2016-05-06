Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:36910 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037AbcEFPgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2016 11:36:07 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Kernel docs: muddying the waters a bit
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <87poszgr92.fsf@intel.com>
Date: Fri, 6 May 2016 17:35:50 +0200
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Daniel Vetter <daniel@ffwll.ch>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Grant Likely <grant.likely@secretlab.ca>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <FE0A9B16-D835-4C4A-8149-320D74F36715@darmarit.de>
References: <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de> <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net> <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com> <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com> <54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de> <874maef8km.fsf@intel.com> <13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de> <20160504134346.GY14148@phenom.ffwll.local> <44110C0C-2E98-4470-9DB1-B72406E901A0@darmarit.de> <87inytn6n2.fsf@intel.com> <6BDB8BFB-6AEA-46A8-B535-C69FBC6FF3BD@darmarit.de> <20160506083529.31ad2fa0@recife.lan> <BAE3C147-6C21-4242-BD3C-8989C1626E10@darmarit.de> <20160506104210.12197832@recife.lan> <3EA89E0D-9951-437C-A2E0-E6866A43A459@darmarit.de> <87poszgr92.fsf@intel.com>
To: Jani Nikula <jani.nikula@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 06.05.2016 um 17:06 schrieb Jani Nikula <jani.nikula@intel.com>:

> On Fri, 06 May 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
>> @Jonathan: what do you think? Should I prepare a patch
>> with a basic reST (sphinx) build infrastructure, including
>> 
>> * a folder for sphinx docs:
>> 
>>  ./Documentation/sphinx/
> 
> I'm already working on a patch series taking a different approach. I
> don't think we should hide the documentation under an extra folder named
> after a tool. Actually, I'm strongly opposed to that.

Could you post a link to a repo? / thanks 

There is no need for concurrency, let's work together on your repo. 
Within my POC I realized similar building processes we will need in the
kernel sources ... where you have cascading configuration. A base 
configuration which fits for all common cases and (if needed) a 
*per-book* configuration.

At the end, when it comes to generate pdf books/articles, man pages 
and e.g. texinfo files out of a sphinx-project you will need a build
infrastructure like this.

> Instead, we should place the Sphinx stuff directly under Documentation,
> and have Sphinx recursively pick up all the *.rst files. We should
> promote gradually switching to lightweight markup and integration of the
> documents into one system. This process should be as little disruptive
> as possible.
> 
> If someone wants to convert a .txt document to .rst and get it processed
> by Sphinx, it should be as simple as renaming the file, doing the
> necessary edits, and adding it to a toctree. Imagine gradually
> converting the files under, say, Documentation/kbuild. Why should the
> .rst files be moved under another directory? They should stay alongside
> the .txt files under the same directory. There's bound to be a lot of
> people who'll never use Sphinx, and will expect to find the good old
> plain text files (albeit with some markup) where they always were.
> 

Ok, I agree with you in the fact that a additional "sphinx" folder
is unrewarding.

This means (e.g.) a migrated Documentation/DocBook/gpu book should placed
in Documentation/gpu ... but don' try to merge all (Doc-)Books and .txt-files
into one sphinx project!

You will need on sphinx-project for each DocBook and one single 
sphinx-project where you collect the .txt to .rst migrated files.

Am 06.05.2016 um 17:23 schrieb Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> We won't avoid the need of moving things among directories, as we
> have lots of stuff under DocBook/ dir (btw, named after the toolchain).

Yes, it is named by the toolchain, but no one reads xml-files. Reading
text files is common.

> Ok, if we put the .rst files at Documentation, we very likely reduce
> the number of renames, but we'll increase the Makefile complexity,
> and the risk of breakages.

I don't see a great potential of breakages ...  if we place every book
in a separated folder and have one project which collects the .txt files
(see above).


--Markus--

