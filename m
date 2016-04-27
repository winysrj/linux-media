Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34328 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbcD0O3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 10:29:02 -0400
Received: by mail-io0-f169.google.com with SMTP id 190so42200332iow.1
        for <linux-media@vger.kernel.org>; Wed, 27 Apr 2016 07:29:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160412094620.4fbf05c0@lwn.net>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com>
 <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan>
 <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk>
 <CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com>
 <87a8m9qoy8.fsf@intel.com> <20160308082948.4e2e0f82@recife.lan>
 <CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com>
 <20160308103922.48d87d9d@recife.lan> <20160308123921.6f2248ab@recife.lan>
 <20160309182709.7ab1e5db@recife.lan> <87fuvypr2h.fsf@intel.com>
 <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de>
 <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 Apr 2016 15:28:41 +0100
Message-ID: <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com>
Subject: Re: Kernel docs: muddying the waters a bit
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 12, 2016 at 4:46 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Fri, 8 Apr 2016 17:12:27 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
>
>> motivated by this MT, I implemented a toolchain to migrate the kernel’s
>> DocBook XML documentation to reST markup.
>>
>> It converts 99% of the docs well ... to gain an impression how
>> kernel-docs could benefit from, visit my sphkerneldoc project page
>> on github:
>>
>>   http://return42.github.io/sphkerneldoc/
>
> So I've obviously been pretty quiet on this recently.  Apologies...I've
> been dealing with an extended death-in-the-family experience, and there is
> still a fair amount of cleanup to be done.
>
> Looking quickly at this work, it seems similar to the results I got.  But
> there's a lot of code there that came from somewhere?  I'd put together a
> fairly simple conversion using pandoc and a couple of short sed scripts;
> is there a reason for a more complex solution?
>
> Thanks for looking into this, anyway; I hope to be able to focus more on
> it shortly.

Hi Jon,

Thanks for digging into this. FWIW, here is my $0.02. I've been
working on restarting the devicetree specification, and after looking
at both reStructuredText and Asciidoc(tor) I thought I liked the
Asciidoc markup better, so chose that. I then proceeded to spend weeks
trying to get reasonable output from the toolchain. When I got fed up
and gave Sphinx a try, I was up and running with reasonable PDF and
HTML output in a day and a half.

Honestly, in the end I think we could make either tool do what is
needed of it. However, my impression after trying to do a document
that needs to have nice publishable output with both tools is that
Sphinx is easier to work with, simpler to extend, better supported. My
vote is firmly behind Sphinx/reStructuredText.

g.
