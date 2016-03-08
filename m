Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52708 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbcCHN6M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2016 08:58:12 -0500
From: Jani Nikula <jani.nikula@intel.com>
To: Dan Allen <dan@opendevise.io>
Cc: Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
In-Reply-To: <CAKeHnO7_7k8Qc5Jmu_x2OzAVT4YXxW8PSe_m6QUP-8V7XxbTVw@mail.gmail.com>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com> <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan> <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk> <CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com> <87a8m9qoy8.fsf@intel.com> <CAKeHnO7_7k8Qc5Jmu_x2OzAVT4YXxW8PSe_m6QUP-8V7XxbTVw@mail.gmail.com>
Date: Tue, 08 Mar 2016 15:58:08 +0200
Message-ID: <8737s1qdfz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 08 Mar 2016, Dan Allen <dan@opendevise.io> wrote:
> That's not entirely true. First, you can pre-split at the source level
> using includes and generate output for each of the masters. That's what I
> tend to do and it works really well since these are logical split points.

I need to look into this again. Is there a specific option or directive
to produce split output for includes? When I tried this, the result was
just one big output file. (And indeed we'd need both. Some includes we
want embedded, some includes should produce separate outputs.)

>> That actually makes choosing asciidoc harder, because
>> requiring another language environment complicates, not simplifies, the
>> toolchain. I'd really like to lower the bar for building the
>> documentation, for everyone, so much so that it becomes part of the
>> normal checks for patch inclusion.
>
> Pardon my bluntness here, but I don't buy that argument. This is Linux.
> Installing software couldn't be simpler, and we're talking about an
> extremely well supported language (Ruby).

Granted, that part works for me. I'm not so sensitive to the
dependencies; others may disagree.

> I think it's a huge exaggeration to say that Asciidoctor is any harder to
> install than AsciiDoc Python. It's also a heck of a lot smaller in size
> since AsciiDoc Python pulls in hundreds of MB of LaTeX packages.

For me, the comparison is really between Sphinx and Asciidoctor, not so
much doc vs. doctor. The native output format and extension support in
Sphinx is appealing; I am not yet convinced we could manage with
Asciidoctor but without DocBook. The extension offering seems better in
Sphinx.

> Whatever you decide, I wish you all the best with your documentation
> efforts!

Thanks!

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
