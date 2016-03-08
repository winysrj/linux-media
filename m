Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37006 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbcCHNaK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2016 08:30:10 -0500
Date: Tue, 8 Mar 2016 10:30:03 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Dan Allen <dan@opendevise.io>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160308103003.5747c76e@recife.lan>
In-Reply-To: <CAKeHnO7_7k8Qc5Jmu_x2OzAVT4YXxW8PSe_m6QUP-8V7XxbTVw@mail.gmail.com>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<1457076530.13171.13.camel@winder.org.uk>
	<CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com>
	<87a8m9qoy8.fsf@intel.com>
	<CAKeHnO7_7k8Qc5Jmu_x2OzAVT4YXxW8PSe_m6QUP-8V7XxbTVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 08 Mar 2016 05:09:40 -0700
Dan Allen <dan@opendevise.io> escreveu:

> Jani wrote:
> 
> > there was no support for chunked, or split
> > to chapters, HTML, and the single page result was simply way too big.
> >  
> 
> That's not entirely true. First, you can pre-split at the source level
> using includes and generate output for each of the masters. That's what I
> tend to do and it works really well since these are logical split points.

The problem on pre-splitting the documents and process them in separate
is that this will break cross-references. At the media uAPI Docbook,
we use a lot of cross references.

Btw, we use a lot of includes. Currently, it has 187 separate files.

We even parse the header files looking for typedefs, structs, enums,
#defines and functions, in order to produce a document that will
cross-reference the documentation.

> Second, there is a custom converter in the works to split post-generate
> (which is really what we're talking about when we compare it to the DocBook
> toolchain).
> 
> https://github.com/asciidoctor/asciidoctor-extensions-lab/blob/master/lib/multipage-html5-converter.rb
> 
> It's just a prototype, but proves it is possible by design.

I didn't test it, but I saw some comments at the web that the part
that would handle cross-references between files is not ready.

> Personally, I don't like most chunked HTML approaches because they split
> arbitrarily. We are trying to find the right balance so that the output is
> actually sensible. There's still work to do, but there are options in the
> meantime.

Well, if it is capable of creating one chunk per include file, and do
cross-references between chunks, this would work for media UAPI book.

Yet, it would be good to have the multi-chunk extension packaged
on major distros, as I don't like the idea of installing it without
using my distro's package manager.

-- 
Thanks,
Mauro
