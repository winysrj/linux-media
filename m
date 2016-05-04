Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:47678 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbcEDJe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 05:34:27 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Kernel docs: muddying the waters a bit
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com>
Date: Wed, 4 May 2016 11:34:08 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com> <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan> <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk> <CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com> <87a8m9qoy8.fsf@intel.com> <20160308082948.4e2e0f82@recife.lan> <CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com> <20160308103922.48d87d9d@recife.lan> <20160308123921.6f2248ab@recife.lan> <20160309182709.7ab1e5db@recife.lan> <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de> <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net> <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com> <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all, (hi Jonathan, please take note of my offer below)

Am 03.05.2016 um 16:31 schrieb Daniel Vetter <daniel.vetter@ffwll.ch>:

> Hi all,
> 
> So sounds like moving ahead with rst/sphinx is the option that should
> allow us to address everyone's concerns eventually? Of course the
> first one won't have it all (media seems really tricky), ...

BTW: Mauro mentioned that ASCII-art tables are not diff-friendly ... 

Am 18.04.2016 um 13:16 schrieb Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> With that sense, the "List tables" format is also not good, as
> one row addition would generate several hunks (one for each column
> of the table), making harder to review the patch by just looking at
> the diff.

For this, I wrote the "flat-table" reST-directive, which adds 
missing cells automatically:

doc:    http://return42.github.io/sphkerneldoc/articles/table_concerns.html#flat-table
source: https://github.com/return42/sphkerneldoc/blob/master/doc/extensions/rstFlatTable.py

I used "flat-table" to migrate all DocBook-XML documents to reST. With this
directive, I also managed to migrate the complete media book (no more TODOs)
incl. the large tables like them from subdev-formats:

https://return42.github.io/sphkerneldoc/books/linux_tv/media/v4l/subdev-formats.html

(Rendering large tables is a general discussion which should not take place in this MT)

>  but I'd like
> to get something awesome in this area closer to mainline. I'm stalling
> on typing more fancyful gpu docs right now (with tables, pictures and
> stuff) since that would require a pile of needless work to redo when
> we switch a few times more ;-)

Are your "fancyful gpu" written from scratch, or will it be an rewrite
of the Documentation/DocBook/gpu.tmpl?

If it is the last; as starting point you can use a copy of:

https://github.com/return42/sphkerneldoc/tree/master/doc/books/gpu

but I think this will not by very helpful, as long as you miss 
a similar ".tmpl" workflow for reST documents.

I'am working on a reST directive (named: "kernel-doc") to provide a
similar ".tmpl" workflow within plain reST. The first step towards
is done with (my) modified kernel-doc script ...

* https://github.com/return42/sphkerneldoc/blob/master/scripts/kernel-doc#L1736

which produce reST from source code comments. E.g. this content is 
generated with it.

* http://return42.github.io/sphkerneldoc/linux_src_doc/index.html

> And Jani also wants to get this in, but he doesn't really want to
> spend more effort on a system that can't be merged.
> 
> So sphinx/rst y/n? Jon, is that ok with you from the doc maintainer pov?

My recommendation is to start with reST-markup if you are 
writing new docs from scratch. Workflows like the .tmpl one
can be added to the kernel build process step by step and
there is no need to drop the DocBook-XML process. Every author
should be free to decide by himself, when it is time to
migrate his DocBook sources into a reST building process.

I'am new to the kernel, my aim is to support the doc maintainer
(contact me), e.g. to migrate existing DocBooks to reST,
elaborate (build) procedures for improved reST support
within the kernel sources and to give recommendation to 
infrastructures.

@Jonathan: I know, you have no time right now. If it is OK
for you, I elaborate all these reST stuff within my POC
at github (this will take some time). Later, if you have
time, we can merge the made experience and tools to the
kernel build process .. is that okay for you?

-- Markus --


> 
> Cheers, Daniel
> 
> On Wed, Apr 27, 2016 at 4:28 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Tue, Apr 12, 2016 at 4:46 PM, Jonathan Corbet <corbet@lwn.net> wrote:
>>> On Fri, 8 Apr 2016 17:12:27 +0200
>>> Markus Heiser <markus.heiser@darmarit.de> wrote:
>>> 
>>>> motivated by this MT, I implemented a toolchain to migrate the kernel’s
>>>> DocBook XML documentation to reST markup.
>>>> 
>>>> It converts 99% of the docs well ... to gain an impression how
>>>> kernel-docs could benefit from, visit my sphkerneldoc project page
>>>> on github:
>>>> 
>>>>  http://return42.github.io/sphkerneldoc/
>>> 
>>> So I've obviously been pretty quiet on this recently.  Apologies...I've
>>> been dealing with an extended death-in-the-family experience, and there is
>>> still a fair amount of cleanup to be done.
>>> 
>>> Looking quickly at this work, it seems similar to the results I got.  But
>>> there's a lot of code there that came from somewhere?  I'd put together a
>>> fairly simple conversion using pandoc and a couple of short sed scripts;
>>> is there a reason for a more complex solution?
>>> 
>>> Thanks for looking into this, anyway; I hope to be able to focus more on
>>> it shortly.
>> 
>> Hi Jon,
>> 
>> Thanks for digging into this. FWIW, here is my $0.02. I've been
>> working on restarting the devicetree specification, and after looking
>> at both reStructuredText and Asciidoc(tor) I thought I liked the
>> Asciidoc markup better, so chose that. I then proceeded to spend weeks
>> trying to get reasonable output from the toolchain. When I got fed up
>> and gave Sphinx a try, I was up and running with reasonable PDF and
>> HTML output in a day and a half.
>> 
>> Honestly, in the end I think we could make either tool do what is
>> needed of it. However, my impression after trying to do a document
>> that needs to have nice publishable output with both tools is that
>> Sphinx is easier to work with, simpler to extend, better supported. My
>> vote is firmly behind Sphinx/reStructuredText.
>> 
>> g.
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

