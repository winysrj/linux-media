Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:34009 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbcCHJtl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2016 04:49:41 -0500
From: Jani Nikula <jani.nikula@intel.com>
To: Dan Allen <dan@opendevise.io>, Russel Winder <russel@winder.org.uk>
Cc: Keith Packard <keithp@keithp.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
In-Reply-To: <CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com> <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan> <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk> <CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com>
Date: Tue, 08 Mar 2016 11:49:35 +0200
Message-ID: <87a8m9qoy8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 08 Mar 2016, Dan Allen <dan@opendevise.io> wrote:
> One of the key goals of the Asciidoctor project is to be able to directly
> produce a wide variety of outputs from the same source (without DocBook).
> We've added flexibility and best practices into the syntax and matured the
> converter mechanism to bridge this (sometimes very wide) gap.

I think our conclusion so far was that the native AsciiDoc (and
Asciidoctor) outputs fell short of our needs, forcing us to use the
DocBook pipeline. I, for one, was hoping we could eventually simplify
the toolchain. For example, there was no support for chunked, or split
to chapters, HTML, and the single page result was simply way too big.

> Asciidoctor is the future of AsciiDoc. Even the AsciiDoc Python maintainers
> acknowledge that (including the original creator).

Thanks for the input. We've touched the topic of AsciiDoc
vs. Asciidoctor before [1]. So we should be using Asciidoctor instead of
AsciiDoc. That actually makes choosing asciidoc harder, because
requiring another language environment complicates, not simplifies, the
toolchain. I'd really like to lower the bar for building the
documentation, for everyone, so much so that it becomes part of the
normal checks for patch inclusion.


BR,
Jani.


[1] http://mid.gmane.org/86pow31ddj.fsf@hiro.keithp.com


-- 
Jani Nikula, Intel Open Source Technology Center
